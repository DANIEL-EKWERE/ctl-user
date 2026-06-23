import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/controllers/auth_controller.dart';
import '../../../theme/app_theme.dart';
import '../../widgets/common/app_widgets.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(AuthController());
    final otpCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Form(key: formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          GestureDetector(onTap: Get.back, child: const Icon(Icons.arrow_back_ios_new, size: 20)),
          const SizedBox(height: 32),
          const Text('Reset password', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          const Text('Enter the code from your email and your new password.', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
          const SizedBox(height: 36),
          AppTextField(
            label: 'OTP Code', hint: '6-digit code', controller: otpCtrl,
            keyboardType: TextInputType.number,
            validator: (v) => (v == null || v.length < 6) ? 'Enter valid OTP' : null,
          ),
          const SizedBox(height: 20),
          AppTextField(
            label: 'New Password', hint: 'Min 8 characters', controller: passCtrl,
            obscure: true,
            validator: (v) => (v == null || v.length < 6) ? 'Password too short' : null,
          ),
          const SizedBox(height: 32),
          Obx(() => AppButton(
            label: 'Reset Password', isLoading: ctrl.isLoading.value,
            onTap: () {
              if (formKey.currentState!.validate()) ctrl.resetPassword(otp: otpCtrl.text, password: passCtrl.text);
            },
          )),
        ])),
      )),
    );
  }
}
