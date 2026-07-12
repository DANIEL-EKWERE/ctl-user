import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_utils.dart';
import '../../../data/models/models.dart';
import '../../../data/services/api_client.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/app_widgets.dart';
import '../../auth/auth_controller.dart';
import '../home/customer_home_controller.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthController.to;
    final ctrl = CustomerHomeController.to;
    final u    = auth.customerUser;
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            color: AppColors.orange,
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 16, left: 20, right: 20, bottom: 24),
            child: Column(children: [
              CircleAvatar(radius: 36, backgroundColor: AppColors.navy,
                child: Text(u?.initials ?? 'NK',
                    style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700))),
              const SizedBox(height: 10),
              Text(u?.name ?? '', style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800)),
              Text(u?.email ?? '', style: const TextStyle(color: Colors.white70, fontSize: 12)),
              if (u?.referralCode != null) ...[
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => Get.snackbar('', 'Code: ${u!.referralCode}'),
                  child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                    decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(14)),
                    child: Text('Referral: ${u!.referralCode}',
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700))),
                ),
              ],
            ]),
          ),
          const SizedBox(height: 10),
          _group([
            _tile('👤', 'Edit Profile',    () => Get.toNamed(AppRoutes.editProfile)),
            _tile('🔒', 'Change Password', () => Get.toNamed(AppRoutes.changePass)),
            _tile('🔑', 'Transaction PIN', () => Get.toNamed(AppRoutes.setPin), last: true),
          ]),
          const SizedBox(height: 10),
          _group([
            _tile('📍', 'Saved Addresses', () { ctrl.loadAddresses(); Get.toNamed(AppRoutes.addresses); }),
            _tile('🔔', 'Notifications',   () { ctrl.loadNotifications(); Get.toNamed(AppRoutes.notifications); }),
            _tile('💬', 'Support',         () => Get.toNamed(AppRoutes.support), last: true),
          ]),
          const SizedBox(height: 10),
          _group([_tile('🚪', 'Logout', () => _logout(context, auth), color: AppColors.red, last: true)]),
          const SizedBox(height: 30),
        ]),
      ),
    );
  }

  Widget _group(List<Widget> children) => Container(color: Colors.white, child: Column(children: children));

  Widget _tile(String icon, String label, VoidCallback onTap, {bool last = false, Color? color}) =>
    InkWell(onTap: onTap, child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(border: last ? null : const Border(bottom: BorderSide(color: AppColors.border))),
      child: Row(children: [
        Container(width: 36, height: 36,
          decoration: BoxDecoration(color: color != null ? const Color(0xFFFEF2F2) : AppColors.chipBg, borderRadius: BorderRadius.circular(10)),
          child: Center(child: Text(icon, style: const TextStyle(fontSize: 16)))),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: color ?? AppColors.navy))),
        Icon(Icons.chevron_right, size: 20, color: color ?? AppColors.textLight),
      ]),
    ));

  void _logout(BuildContext ctx, AuthController auth) => showDialog(
    context: ctx,
    builder: (_) => AlertDialog(
      title: const Text('Sign out?', style: TextStyle(fontWeight: FontWeight.w700)),
      content: const Text('Are you sure you want to sign out?'),
      actions: [
        TextButton(onPressed: Get.back, child: const Text('Cancel')),
        ElevatedButton(onPressed: auth.logout,
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.red), child: const Text('Sign out')),
      ],
    ));
}

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override State<EditProfileScreen> createState() => _EditProfileState();
}
class _EditProfileState extends State<EditProfileScreen> {
  final auth = AuthController.to;
  late final _nameCtrl  = TextEditingController(text: auth.customerUser?.name ?? '');
  late final _phoneCtrl = TextEditingController(text: auth.customerUser?.phone ?? '');
  bool loading = false; String? error;
  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty) { setState(() => error = 'Name is required'); return; }
    setState(() { loading = true; error = null; });
    final res = await ApiClient.instance.updateProfile({'name': _nameCtrl.text.trim(), 'phone': _phoneCtrl.text.trim()}, auth.customerToken!);
    setState(() => loading = false);
    if (res['success'] == true) { Get.back(); Get.snackbar('', 'Profile updated ✓'); }
    else setState(() => error = res['message']);
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.white,
    appBar: OrangeTopBar(title: 'Edit Profile'),
    body: SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(children: [
      CircleAvatar(radius: 40, backgroundColor: AppColors.navy,
        child: Text(auth.customerUser?.initials ?? 'NK', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700))),
      const SizedBox(height: 24),
      AppInput(label: 'Full name', hint: 'Your full name', controller: _nameCtrl),
      const SizedBox(height: 14),
      AppInput(label: 'Email', hint: '', controller: TextEditingController(text: auth.customerUser?.email ?? ''), readOnly: true),
      const SizedBox(height: 14),
      AppInput(label: 'Phone', hint: '08012345678', controller: _phoneCtrl, keyboardType: TextInputType.phone),
      if (error != null) ...[const SizedBox(height: 12), Text(error!, style: const TextStyle(color: AppColors.red, fontSize: 13))],
      const SizedBox(height: 24),
      AppButton(label: 'Save Changes', loading: loading, onTap: _save),
    ])),
  );
}

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});
  @override State<ChangePasswordScreen> createState() => _ChangePwState();
}
class _ChangePwState extends State<ChangePasswordScreen> {
  final auth = AuthController.to;
  final _oldCtrl = TextEditingController(); final _newCtrl = TextEditingController(); final _confCtrl = TextEditingController();
  bool loading = false; String? error;
  Future<void> _submit() async {
    if (_oldCtrl.text.isEmpty || _newCtrl.text.isEmpty || _confCtrl.text.isEmpty) { setState(() => error = 'Fill all fields'); return; }
    if (_newCtrl.text != _confCtrl.text) { setState(() => error = 'Passwords do not match'); return; }
    if (_newCtrl.text.length < 8) { setState(() => error = 'Minimum 8 characters'); return; }
    setState(() { loading = true; error = null; });
    final res = await ApiClient.instance.changePassword({'current_password': _oldCtrl.text, 'password': _newCtrl.text, 'password_confirmation': _confCtrl.text}, auth.customerToken!);
    setState(() => loading = false);
    if (res['success'] == true) { Get.back(); Get.snackbar('', 'Password updated ✓'); }
    else setState(() => error = res['message']);
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.white, appBar: OrangeTopBar(title: 'Change Password'),
    body: Padding(padding: const EdgeInsets.all(24), child: Column(children: [
      AppInput(label: 'Current password', hint: '••••••••', controller: _oldCtrl, obscure: true),
      const SizedBox(height: 14),
      AppInput(label: 'New password', hint: 'Min 8 characters', controller: _newCtrl, obscure: true),
      const SizedBox(height: 14),
      AppInput(label: 'Confirm new password', hint: 'Repeat', controller: _confCtrl, obscure: true),
      if (error != null) ...[const SizedBox(height: 12), Text(error!, style: const TextStyle(color: AppColors.red, fontSize: 13))],
      const SizedBox(height: 24), AppButton(label: 'Update Password', loading: loading, onTap: _submit),
    ])),
  );
}

class SetPinScreen extends StatefulWidget {
  const SetPinScreen({super.key});
  @override State<SetPinScreen> createState() => _SetPinState();
}
class _SetPinState extends State<SetPinScreen> {
  final auth = AuthController.to;
  final _pinCtrl = TextEditingController(); final _confCtrl = TextEditingController();
  bool loading = false; String? error;
  Future<void> _save() async {
    if (_pinCtrl.text.length != 4 || _confCtrl.text.length != 4) { setState(() => error = 'PIN must be 4 digits'); return; }
    if (_pinCtrl.text != _confCtrl.text) { setState(() => error = 'PINs do not match'); return; }
    setState(() { loading = true; error = null; });
    final res = await ApiClient.instance.setPin(_pinCtrl.text, _confCtrl.text, auth.customerToken!);
    setState(() => loading = false);
    if (res['success'] == true) { Get.back(); Get.snackbar('', 'PIN set ✓'); }
    else setState(() => error = res['message']);
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.white, appBar: OrangeTopBar(title: 'Transaction PIN'),
    body: Padding(padding: const EdgeInsets.all(24), child: Column(children: [
      const Icon(Icons.lock_outline, size: 52, color: AppColors.orange), const SizedBox(height: 12),
      const Text('Set your 4-digit PIN', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.navy)),
      const SizedBox(height: 24),
      AppInput(label: 'New PIN', hint: '••••', controller: _pinCtrl, obscure: true, keyboardType: TextInputType.number),
      const SizedBox(height: 14),
      AppInput(label: 'Confirm PIN', hint: '••••', controller: _confCtrl, obscure: true, keyboardType: TextInputType.number),
      if (error != null) ...[const SizedBox(height: 12), Text(error!, style: const TextStyle(color: AppColors.red, fontSize: 13))],
      const SizedBox(height: 24), AppButton(label: 'Set PIN', loading: loading, onTap: _save),
    ])),
  );
}

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});
  @override State<SupportScreen> createState() => _SupportState();
}
class _SupportState extends State<SupportScreen> {
  final auth = AuthController.to;
  final _subCtrl = TextEditingController(); final _msgCtrl = TextEditingController();
  String cat = 'general'; bool loading = false;
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.white, appBar: OrangeTopBar(title: 'Support'),
    body: SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.inputBg, borderRadius: BorderRadius.circular(16)),
        child: const Column(children: [
          Text('💬', style: TextStyle(fontSize: 32)), SizedBox(height: 8),
          Text('How can we help?', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.navy), textAlign: TextAlign.center),
        ])),
      const SizedBox(height: 20),
      const Text('Category', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
      const SizedBox(height: 8),
      DropdownButtonFormField<String>(
        value: cat,
        decoration: InputDecoration(filled: true, fillColor: AppColors.inputBg,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border))),
        items: const [
          DropdownMenuItem(value: 'general',   child: Text('General')),
          DropdownMenuItem(value: 'order',     child: Text('Order Issue')),
          DropdownMenuItem(value: 'payment',   child: Text('Payment')),
          DropdownMenuItem(value: 'account',   child: Text('Account')),
          DropdownMenuItem(value: 'technical', child: Text('Technical')),
        ],
        onChanged: (v) => setState(() => cat = v!),
      ),
      const SizedBox(height: 14),
      AppInput(label: 'Subject', hint: 'Brief description', controller: _subCtrl),
      const SizedBox(height: 14),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Message', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
        const SizedBox(height: 5),
        TextFormField(controller: _msgCtrl, maxLines: 5, decoration: const InputDecoration(hintText: 'Describe your issue...')),
      ]),
      const SizedBox(height: 24),
      AppButton(label: 'Send Message', loading: loading, onTap: () async {
        if (_subCtrl.text.isEmpty || _msgCtrl.text.isEmpty) { Get.snackbar('', 'Fill all fields', snackPosition: SnackPosition.BOTTOM); return; }
        setState(() => loading = true);
        final res = await ApiClient.instance.sendSupport({'category': cat, 'subject': _subCtrl.text, 'message': _msgCtrl.text}, auth.customerToken!);
        setState(() => loading = false);
        if (res['success'] == true) { Get.back(); Get.snackbar('', '✅ Message sent!'); }
        else Get.snackbar('Error', res['message'] ?? 'Failed', snackPosition: SnackPosition.BOTTOM);
      }),
    ])),
  );
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final ctrl = CustomerHomeController.to;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: OrangeTopBar(title: 'Notifications'),
      body: Obx(() {
        final list = ctrl.notifications;
        if (list.isEmpty) return const EmptyState(icon: Icons.notifications_none_outlined, title: 'No notifications yet');
        return ListView.builder(itemCount: list.length, itemBuilder: (_, i) {
          final n = list[i];
          return Container(
            decoration: BoxDecoration(color: n.isRead ? Colors.white : const Color(0xFFFFF5E6),
                border: const Border(bottom: BorderSide(color: AppColors.border))),
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(width: 10, height: 10, margin: const EdgeInsets.only(top: 4, right: 10),
                decoration: BoxDecoration(shape: BoxShape.circle, color: n.isRead ? Colors.transparent : AppColors.orange)),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(n.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.navy)),
                if (n.body != null) ...[const SizedBox(height: 4), Text(n.body!, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary))],
                if (n.createdAt != null) ...[const SizedBox(height: 4), Text(AppUtils.timeAgo(n.createdAt), style: const TextStyle(fontSize: 11, color: AppColors.textLight))],
              ])),
            ]),
          );
        });
      }),
    );
  }
}

class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final ctrl = CustomerHomeController.to;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: OrangeTopBar(title: 'Saved Addresses', actions: [
        IconButton(icon: const Icon(Icons.add, color: Colors.white), onPressed: () => Get.toNamed(AppRoutes.addAddress)),
      ]),
      body: Obx(() {
        final list = ctrl.addresses;
        if (list.isEmpty) return EmptyState(icon: Icons.location_on_outlined, title: 'No addresses',
            buttonLabel: 'Add Address', onButton: () => Get.toNamed(AppRoutes.addAddress));
        return ListView.builder(
          padding: const EdgeInsets.all(14), itemCount: list.length,
          itemBuilder: (_, i) {
            final a = list[i];
            return Container(
              margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: a.isDefault ? AppColors.orange : AppColors.border)),
              child: Row(children: [
                Icon(Icons.location_on_outlined, color: a.isDefault ? AppColors.orange : AppColors.textSecondary),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Text(a.label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.navy)),
                    if (a.isDefault) ...[const SizedBox(width: 6),
                      Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: AppColors.orange, borderRadius: BorderRadius.circular(10)),
                        child: const Text('Default', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700)))],
                  ]),
                  Text(a.address, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ])),
              ]),
            );
          },
        );
      }),
    );
  }
}

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});
  @override State<AddAddressScreen> createState() => _AddAddressState();
}
class _AddAddressState extends State<AddAddressScreen> {
  final ctrl = CustomerHomeController.to; final auth = AuthController.to;
  final _addrCtrl = TextEditingController(); final _cityCtrl = TextEditingController(); final _stateCtrl = TextEditingController();
  String label = 'Home'; bool loading = false;
  Future<void> _save() async {
    if (_addrCtrl.text.isEmpty) { Get.snackbar('', 'Enter an address', snackPosition: SnackPosition.BOTTOM); return; }
    setState(() => loading = true);
    final res = await ApiClient.instance.saveAddress({'label': label, 'address': _addrCtrl.text.trim(), 'city': _cityCtrl.text.trim(), 'state': _stateCtrl.text.trim()}, auth.customerToken!);
    setState(() => loading = false);
    if (res['success'] == true) { await ctrl.loadAddresses(); Get.back(); Get.snackbar('', 'Address saved ✓', snackPosition: SnackPosition.BOTTOM); }
    else Get.snackbar('Error', res['message'] ?? 'Failed', snackPosition: SnackPosition.BOTTOM);
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.white, appBar: OrangeTopBar(title: 'Add Address'),
    body: SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Label', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
      const SizedBox(height: 8),
      Wrap(spacing: 8, children: ['Home', 'Work', 'Other'].map((l) => GestureDetector(
        onTap: () => setState(() => label = l),
        child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(color: label == l ? AppColors.orange : Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: label == l ? AppColors.orange : AppColors.border)),
          child: Text(l, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: label == l ? Colors.white : AppColors.textSecondary))),
      )).toList()),
      const SizedBox(height: 16),
      AppInput(label: 'Street Address', hint: 'Enter your street address', controller: _addrCtrl),
      const SizedBox(height: 14),
      AppInput(label: 'City', hint: 'e.g. Lagos', controller: _cityCtrl),
      const SizedBox(height: 14),
      AppInput(label: 'State', hint: 'e.g. Lagos State', controller: _stateCtrl),
      const SizedBox(height: 24),
      AppButton(label: 'Save Address', loading: loading, onTap: _save),
    ])),
  );
}