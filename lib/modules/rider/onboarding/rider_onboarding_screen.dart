import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/utils/toast.dart';
import '../../../data/services/api_client.dart';
import '../../../widgets/app_widgets.dart';
import '../../auth/auth_controller.dart';
import 'rider_gate.dart';

// ─── Rider Onboarding ─────────────────────────────────────────────────────────
// Three steps, each with its own endpoint:
//   1. rider/onboarding/step-1  vehicle + guarantor details (JSON)
//   2. rider/onboarding/step-2  profile_photo, means_of_id, driver_licence
//   3. rider/onboarding/step-3  guarantor_id
// After step 3 the rider is routed (via routeRider) to "awaiting approval".
class RiderOnboardingScreen extends StatefulWidget {
  /// 1-based step to open on (onboarding_step + 1).
  final int startStep;
  const RiderOnboardingScreen({super.key, this.startStep = 1});

  @override
  State<RiderOnboardingScreen> createState() => _RiderOnboardingState();
}

class _RiderOnboardingState extends State<RiderOnboardingScreen> {
  final _api = ApiClient.instance;
  final _picker = ImagePicker();
  String get _token => AuthController.to.riderToken!;

  static const _vehicleTypes = {
    'bike': 'Motorbike',
    'tricycle': 'Tricycle (Keke)',
    'car': 'Car',
  };

  static const _step2Docs = {
    'profile_photo': 'Profile photo',
    'means_of_id': 'Means of ID (NIN, passport, voter’s card)',
    'driver_licence': "Driver's licence",
  };
  static const _step3Docs = {'guarantor_id': "Guarantor's ID"};

  late int _step = widget.startStep.clamp(1, 3);

  // Step 1
  String? _vehicleType;
  final _plateCtrl = TextEditingController();
  final _licenseCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _gNameCtrl = TextEditingController();
  final _gPhoneCtrl = TextEditingController();

  // Steps 2 & 3: field name -> local file path
  final Map<String, String> _files = {};

  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _prefill();
  }

  @override
  void dispose() {
    for (final c in [
      _plateCtrl,
      _licenseCtrl,
      _addressCtrl,
      _gNameCtrl,
      _gPhoneCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  /// Fills step 1 from the existing rider record, if any (e.g. resubmitting
  /// after a rejection). Riders without a record simply start empty.
  Future<void> _prefill() async {
    final res = await _api.getRiderInfo(_token);
    if (!mounted || res['success'] != true) return;
    String v(String k) => AppUtils.findKey(res['data'], k)?.toString() ?? '';
    final vt = v('vehicle_type').toLowerCase();
    setState(() {
      _vehicleType ??= _vehicleTypes.containsKey(vt) ? vt : null;
      if (_plateCtrl.text.isEmpty) _plateCtrl.text = v('plate_number');
      if (_licenseCtrl.text.isEmpty) _licenseCtrl.text = v('license_number');
      if (_addressCtrl.text.isEmpty) _addressCtrl.text = v('home_address');
      if (_gNameCtrl.text.isEmpty) _gNameCtrl.text = v('guarantor_name');
      if (_gPhoneCtrl.text.isEmpty) _gPhoneCtrl.text = v('guarantor_phone');
    });
  }

  // ── Submission ──────────────────────────────────────────────────────────
  Future<void> _continue() async {
    final missing = _missingForStep();
    if (missing.isNotEmpty) {
      setState(() => _error = 'Please provide: ${missing.join(', ')}.');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });

    final Map<String, dynamic> res;
    switch (_step) {
      case 1:
        res = await _api.riderOnboardingStep1({
          'vehicle_type': _vehicleType,
          'plate_number': _plateCtrl.text.trim(),
          'license_number': _licenseCtrl.text.trim(),
          'guarantor_name': _gNameCtrl.text.trim(),
          'guarantor_phone': _gPhoneCtrl.text.trim(),
          'home_address': _addressCtrl.text.trim(),
        }, _token);
      case 2:
        res = await _api.riderOnboardingStep2({
          for (final k in _step2Docs.keys) k: _files[k]!,
        }, _token);
      default:
        res = await _api.riderOnboardingStep3({
          for (final k in _step3Docs.keys) k: _files[k]!,
        }, _token);
    }
    if (!mounted) return;
    setState(() => _saving = false);

    if (res['success'] != true) {
      setState(() => _error = _errorText(res));
      return;
    }

    await AuthController.to.applyRiderStatus(res['data']);
    if (_step < 3) {
      setState(() => _step++);
    } else {
      showToast('Application submitted! We will review it shortly.');
      await routeRider(); // → awaiting approval
    }
  }

  List<String> _missingForStep() => switch (_step) {
    1 => [
      if (_vehicleType == null) 'vehicle type',
      if (_plateCtrl.text.trim().isEmpty) 'plate number',
      if (_licenseCtrl.text.trim().isEmpty) 'license number',
      if (_addressCtrl.text.trim().isEmpty) 'home address',
      if (_gNameCtrl.text.trim().isEmpty) 'guarantor name',
      if (_gPhoneCtrl.text.trim().isEmpty) 'guarantor phone',
    ],
    2 => [
      for (final e in _step2Docs.entries)
        if (!_files.containsKey(e.key)) e.value.split(' (').first,
    ],
    _ => [
      for (final e in _step3Docs.entries)
        if (!_files.containsKey(e.key)) e.value,
    ],
  };

  /// Shows Laravel validation errors line by line when available.
  String _errorText(Map<String, dynamic> res) {
    final errors = res['errors'];
    if (errors is Map && errors.isNotEmpty) {
      return errors.values
          .expand((v) => v is List ? v : [v])
          .map((e) => e.toString())
          .join('\n');
    }
    return res['message']?.toString() ?? 'Something went wrong. Try again.';
  }

  Future<void> _pick(String field) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Take a photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;
    try {
      final file = await _picker.pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 1600,
      );
      if (file != null) {
        setState(() {
          _files[field] = file.path;
          _error = null;
        });
      }
    } catch (e) {
      showToast('Could not open ${source.name}: $e', isError: true);
    }
  }

  // ── UI ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) => PopScope(
    // System back steps backwards through the flow before leaving it.
    canPop: _step <= widget.startStep,
    onPopInvokedWithResult: (didPop, _) {
      if (!didPop) setState(() => _step--);
    },
    child: Scaffold(
      backgroundColor: AppColors.bg,
      appBar: OrangeTopBar(
        title: 'Become a Rider',
        showBack: Navigator.of(context).canPop(),
        actions: [
          TextButton(
            onPressed: AuthController.to.logout,
            child: const Text(
              'Log out',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _progress(),
          const SizedBox(height: 16),
          ...switch (_step) {
            1 => _step1(),
            2 => _docsStep(
              'Your documents',
              'Upload clear photos. Make sure all text is readable.',
              _step2Docs,
            ),
            _ => _docsStep(
              "Guarantor's ID",
              'Upload a valid ID belonging to your guarantor.',
              _step3Docs,
            ),
          },
          if (_error != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFECACA)),
              ),
              child: Text(
                _error!,
                style: const TextStyle(color: AppColors.red, fontSize: 13),
              ),
            ),
          ],
          const SizedBox(height: 20),
          AppButton(
            label: _step < 3 ? 'Save & Continue' : 'Submit Application',
            loading: _saving,
            onTap: _continue,
          ),
          if (_step > 1 && !_saving)
            TextButton(
              onPressed: () => setState(() {
                _step--;
                _error = null;
              }),
              child: const Text('Back'),
            ),
          const SizedBox(height: 24),
        ],
      ),
    ),
  );

  Widget _progress() {
    const labels = ['Details', 'Documents', 'Guarantor ID'];
    return Row(
      children: [
        for (var i = 1; i <= 3; i++) ...[
          Expanded(
            child: Column(
              children: [
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: i <= _step ? AppColors.orange : AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Step $i · ${labels[i - 1]}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: i == _step ? FontWeight.w700 : FontWeight.w500,
                    color: i == _step ? AppColors.navy : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (i < 3) const SizedBox(width: 8),
        ],
      ],
    );
  }

  List<Widget> _step1() => [
    _section('Vehicle', [
      DropdownButtonFormField<String>(
        initialValue: _vehicleType,
        decoration: const InputDecoration(labelText: 'Vehicle type'),
        items: _vehicleTypes.entries
            .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
            .toList(),
        onChanged: (v) => setState(() => _vehicleType = v),
      ),
      const SizedBox(height: 12),
      AppInput(
        label: 'Plate number',
        hint: 'e.g. ABC-123-XY',
        controller: _plateCtrl,
      ),
      const SizedBox(height: 12),
      AppInput(
        label: "Driver's licence number",
        hint: 'Licence number',
        controller: _licenseCtrl,
      ),
      const SizedBox(height: 12),
      AppInput(
        label: 'Home address',
        hint: 'Street, area, city',
        controller: _addressCtrl,
      ),
    ]),
    const SizedBox(height: 14),
    _section('Guarantor', [
      AppInput(
        label: 'Guarantor full name',
        hint: 'Full name',
        controller: _gNameCtrl,
      ),
      const SizedBox(height: 12),
      AppInput(
        label: 'Guarantor phone',
        hint: '08012345678',
        controller: _gPhoneCtrl,
        keyboardType: TextInputType.phone,
      ),
    ]),
  ];

  List<Widget> _docsStep(
    String title,
    String subtitle,
    Map<String, String> docs,
  ) => [
    _section(title, [
      Text(
        subtitle,
        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
      ),
      const SizedBox(height: 8),
      for (final e in docs.entries) _docTile(e.key, e.value),
    ]),
  ];

  Widget _section(String title, List<Widget> children) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    ),
  );

  Widget _docTile(String field, String label) {
    final picked = _files.containsKey(field);
    final color = picked ? AppColors.green : AppColors.textSecondary;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        picked ? Icons.check_circle_outline : Icons.upload_file_outlined,
        color: color,
      ),
      title: Text(label, style: const TextStyle(fontSize: 13)),
      subtitle: Text(
        picked ? 'Photo selected' : 'Required',
        style: TextStyle(fontSize: 11, color: picked ? color : AppColors.red),
      ),
      trailing: TextButton(
        onPressed: () => _pick(field),
        child: Text(
          picked ? 'Change' : 'Upload',
          style: const TextStyle(
            color: AppColors.orange,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
