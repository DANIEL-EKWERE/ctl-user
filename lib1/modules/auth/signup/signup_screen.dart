import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../widgets/app_widgets.dart';
import '../auth_controller.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _ctrl = AuthController.to;
  final _nameCtrl  = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  final _passConfCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    for (final c in [_nameCtrl, _emailCtrl, _phoneCtrl, _passCtrl, _passConfCtrl]) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.white,
    appBar: OrangeTopBar(title: 'Create Account'),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Obx(() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Role selector
        const Text('I am a...', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(color: AppColors.chipBg, borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.all(4),
          child: Row(children: [
            _roleBtn('customer', '🛍️ Customer'),
            _roleBtn('rider', '🏍️ Rider'),
          ]),
        ),
        const SizedBox(height: 20),
        AppInput(label: 'Full name', hint: 'Your full name', controller: _nameCtrl,
          onChanged: (v) => _ctrl.signupName.value = v),
        const SizedBox(height: 14),
        AppInput(label: 'Email address', hint: 'you@example.com', controller: _emailCtrl,
          keyboardType: TextInputType.emailAddress, onChanged: (v) => _ctrl.signupEmail.value = v),
        const SizedBox(height: 14),
        AppInput(label: 'Phone number', hint: '08012345678', controller: _phoneCtrl,
          keyboardType: TextInputType.phone, onChanged: (v) => _ctrl.signupPhone.value = v),
        const SizedBox(height: 14),
        AppInput(label: 'Password', hint: 'Minimum 8 characters', controller: _passCtrl,
          obscure: _obscure, onChanged: (v) => _ctrl.signupPass.value = v,
          suffix: IconButton(icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, size: 20),
            onPressed: () => setState(() => _obscure = !_obscure))),
        const SizedBox(height: 14),
        AppInput(label: 'Confirm password', hint: 'Repeat password', controller: _passConfCtrl,
          obscure: _obscure, onChanged: (v) => _ctrl.signupPassConf.value = v),
        if (_ctrl.error.value != null) ...[
          const SizedBox(height: 12),
          Container(padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFFEF2F2), borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFECACA))),
            child: Text(_ctrl.error.value!, style: const TextStyle(color: Color(0xFFB91C1C), fontSize: 13))),
        ],
        const SizedBox(height: 24),
        AppButton(label: 'Create Account', loading: _ctrl.isLoading.value, onTap: _ctrl.register),
        const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('Already have an account? ', style: TextStyle(color: AppColors.textSecondary)),
          GestureDetector(onTap: Get.back,
            child: const Text('Sign in', style: TextStyle(color: AppColors.orange, fontWeight: FontWeight.w700))),
        ]),
      ])),
    ),
  );

  Widget _roleBtn(String value, String label) => Expanded(
    child: GestureDetector(
      onTap: () => _ctrl.signupRole.value = value,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color: _ctrl.signupRole.value == value ? AppColors.navy : Colors.transparent,
          borderRadius: BorderRadius.circular(11),
          boxShadow: _ctrl.signupRole.value == value
              ? [const BoxShadow(color: Color(0x33000000), blurRadius: 8, offset: Offset(0, 3))]
              : null,
        ),
        child: Text(label, textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
            color: _ctrl.signupRole.value == value ? Colors.white : AppColors.textSecondary)),
      ),
    ),
  );
}