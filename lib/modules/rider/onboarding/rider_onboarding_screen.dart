import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/toast.dart';
import '../../../data/services/api_client.dart';
import '../../../widgets/app_widgets.dart';
import '../../auth/auth_controller.dart';
import '../dashboard/rider_controller.dart';

// ─── Rider Onboarding ─────────────────────────────────────────────────────────
// Lets a newly registered rider submit vehicle details, guarantor info,
// address and the documents required for approval (POST rider/profile).
class RiderOnboardingScreen extends StatefulWidget {
  const RiderOnboardingScreen({super.key});
  @override
  State<RiderOnboardingScreen> createState() => _RiderOnboardingState();
}

class _RiderOnboardingState extends State<RiderOnboardingScreen> {
  final ctrl = RiderController.to;
  final _picker = ImagePicker();

  static const _vehicleTypes = {
    'motorcycle': 'Motorcycle',
    'bicycle': 'Bicycle',
    'tricycle': 'Tricycle (Keke)',
    'car': 'Car',
    'van': 'Van',
  };

  String? _vehicleType;
  final _plateCtrl = TextEditingController();
  final _licenseCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _stateCtrl = TextEditingController();
  final _gNameCtrl = TextEditingController();
  final _gPhoneCtrl = TextEditingController();

  /// Newly picked document files: field name -> local path.
  final Map<String, String> _pickedDocs = {};

  bool _loading = true;
  bool _saving = false;
  String? _error;

  Map<String, dynamic> get _info => ctrl.riderInfo.value ?? const {};
  Map get _uploadedDocs =>
      _info['documents'] is Map ? _info['documents'] as Map : const {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    for (final c in [
      _plateCtrl,
      _licenseCtrl,
      _addressCtrl,
      _cityCtrl,
      _stateCtrl,
      _gNameCtrl,
      _gPhoneCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    await ctrl.loadRiderInfo();
    if (!mounted) return;
    final i = _info;
    final vt = i['vehicle_type']?.toString().toLowerCase();
    setState(() {
      _vehicleType = _vehicleTypes.containsKey(vt) ? vt : null;
      _plateCtrl.text = i['plate_number']?.toString() ?? '';
      _licenseCtrl.text = i['license_number']?.toString() ?? '';
      _addressCtrl.text = i['home_address']?.toString() ?? '';
      _cityCtrl.text = i['current_city']?.toString() ?? '';
      _stateCtrl.text = i['current_state']?.toString() ?? '';
      _gNameCtrl.text = i['guarantor_name']?.toString() ?? '';
      _gPhoneCtrl.text = i['guarantor_phone']?.toString() ?? '';
      _loading = false;
    });
  }

  Future<void> _pickDoc(String field) async {
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
      if (file != null) setState(() => _pickedDocs[field] = file.path);
    } catch (e) {
      showToast('Could not open ${source.name}: $e', isError: true);
    }
  }

  Future<void> _submit() async {
    final missing = <String>[
      if (_vehicleType == null) 'vehicle type',
      if (_plateCtrl.text.trim().isEmpty) 'plate number',
      if (_licenseCtrl.text.trim().isEmpty) 'license number',
      if (_addressCtrl.text.trim().isEmpty) 'home address',
      if (_gNameCtrl.text.trim().isEmpty) 'guarantor name',
      if (_gPhoneCtrl.text.trim().isEmpty) 'guarantor phone',
      for (final e in RiderController.requiredDocuments.entries)
        if (_uploadedDocs[e.key] == null && !_pickedDocs.containsKey(e.key))
          e.value.toLowerCase(),
    ];
    if (missing.isNotEmpty) {
      setState(() => _error = 'Please provide: ${missing.join(', ')}.');
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });
    final res = await ApiClient.instance.submitRiderProfile(
      {
        'vehicle_type': _vehicleType!,
        'plate_number': _plateCtrl.text.trim(),
        'license_number': _licenseCtrl.text.trim(),
        'home_address': _addressCtrl.text.trim(),
        'current_city': _cityCtrl.text.trim(),
        'current_state': _stateCtrl.text.trim(),
        'guarantor_name': _gNameCtrl.text.trim(),
        'guarantor_phone': _gPhoneCtrl.text.trim(),
      },
      _pickedDocs,
      AuthController.to.riderToken!,
    );
    if (!mounted) return;
    setState(() => _saving = false);

    if (res['success'] == true) {
      await ctrl.loadDashboard();
      Get.back(result: true);
      showToast('Details submitted. We will review your account shortly.');
    } else if (res['statusCode'] == 404 ||
        (res['message']?.toString().toLowerCase().contains('not found') ??
            false)) {
      // The backend only updates an existing rider record; accounts whose
      // record was never created at signup can't be completed from the app.
      setState(
        () => _error =
            "Your rider account hasn't been fully set up on our side yet, so "
            'your details could not be saved. Please contact support and we '
            'will activate it.',
      );
    } else {
      final errors = res['errors'];
      final detail = errors is Map
          ? errors.values
                .expand((v) => v is List ? v : [v])
                .map((e) => e.toString())
                .join('\n')
          : null;
      setState(
        () => _error = detail?.isNotEmpty == true
            ? detail
            : (res['message'] ?? 'Could not submit your details.'),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.bg,
    appBar: OrangeTopBar(title: 'Rider Profile'),
    body: _loading
        ? const Center(
            child: CircularProgressIndicator(color: AppColors.orange),
          )
        : ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Complete these details so we can verify and activate your '
                'account. You can go online once your account is approved.',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 14),
              _section('Vehicle', [
                DropdownButtonFormField<String>(
                  initialValue: _vehicleType,
                  decoration: const InputDecoration(labelText: 'Vehicle type'),
                  items: _vehicleTypes.entries
                      .map(
                        (e) => DropdownMenuItem(
                          value: e.key,
                          child: Text(e.value),
                        ),
                      )
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
                  label: "Driver's license number",
                  hint: 'License number',
                  controller: _licenseCtrl,
                ),
              ]),
              const SizedBox(height: 14),
              _section('Address', [
                AppInput(
                  label: 'Home address',
                  hint: 'Street and house number',
                  controller: _addressCtrl,
                ),
                const SizedBox(height: 12),
                AppInput(label: 'City', hint: 'e.g. Uyo', controller: _cityCtrl),
                const SizedBox(height: 12),
                AppInput(
                  label: 'State',
                  hint: 'e.g. Akwa Ibom',
                  controller: _stateCtrl,
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
              const SizedBox(height: 14),
              _section('Documents', [
                for (final e in RiderController.requiredDocuments.entries)
                  _docTile(e.key, e.value),
              ]),
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
                label: 'Submit for Approval',
                loading: _saving,
                onTap: _submit,
              ),
              const SizedBox(height: 30),
            ],
          ),
  );

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
    final picked = _pickedDocs.containsKey(field);
    final uploaded = _uploadedDocs[field] != null;
    final status = picked
        ? 'Selected — will upload'
        : uploaded
        ? 'Uploaded'
        : 'Required';
    final color = picked || uploaded ? AppColors.green : AppColors.red;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        picked || uploaded
            ? Icons.check_circle_outline
            : Icons.upload_file_outlined,
        color: color,
      ),
      title: Text(label, style: const TextStyle(fontSize: 13)),
      subtitle: Text(status, style: TextStyle(fontSize: 11, color: color)),
      trailing: TextButton(
        onPressed: () => _pickDoc(field),
        child: Text(
          uploaded || picked ? 'Replace' : 'Upload',
          style: const TextStyle(
            color: AppColors.orange,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
