import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/controllers/auth_controller.dart';
import '../../../theme/app_theme.dart';
import '../../widgets/common/app_widgets.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(AuthController());
    final emailCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Form(key: formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          GestureDetector(onTap: Get.back, child: const Icon(Icons.arrow_back_ios_new, size: 20)),
          const SizedBox(height: 32),
          const Text('Forgot password?', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          const Text("Enter your email and we'll send a reset code.", style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
          const SizedBox(height: 36),
          AppTextField(
            label: 'Email', hint: 'your@email.com', controller: emailCtrl,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(Icons.email_outlined, size: 20, color: AppColors.grey400),
            validator: (v) => (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
          ),
          const SizedBox(height: 32),
          Obx(() => AppButton(
            label: 'Send Reset Code', isLoading: ctrl.isLoading.value,
            onTap: () {
              if (formKey.currentState!.validate()) ctrl.forgotPassword(email: emailCtrl.text.trim());
            },
          )),
        ])),
      )),
    );
  }
}
