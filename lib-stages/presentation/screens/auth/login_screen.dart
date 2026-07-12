import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/controllers/auth_controller.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/app_theme.dart';
import '../../widgets/common/app_widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(AuthController());
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Logo
                Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(16)),
                  child: const Center(child: Text('NK', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.white))),
                ),
                const SizedBox(height: 28),
                const Text('Welcome back 👋', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                const SizedBox(height: 6),
                const Text('Sign in to continue', style: TextStyle(fontSize: 15, color: AppColors.textSecondary)),
                const SizedBox(height: 36),
                AppTextField(
                  label: 'Email',
                  hint: 'Enter your email',
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.email_outlined, size: 20, color: AppColors.grey400),
                  validator: (v) => (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
                ),
                const SizedBox(height: 20),
                AppTextField(
                  label: 'Password',
                  hint: 'Enter your password',
                  controller: passCtrl,
                  obscure: true,
                  textInputAction: TextInputAction.done,
                  prefixIcon: const Icon(Icons.lock_outlined, size: 20, color: AppColors.grey400),
                  validator: (v) => (v == null || v.length < 6) ? 'Password too short' : null,
                  onSubmitted: (_) {
                    if (formKey.currentState!.validate()) {
                      ctrl.login(email: emailCtrl.text.trim(), password: passCtrl.text);
                    }
                  },
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.forgotPassword),
                    child: const Text('Forgot password?', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary)),
                  ),
                ),
                const SizedBox(height: 28),
                Obx(() => AppButton(
                  label: 'Sign In',
                  isLoading: ctrl.isLoading.value,
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      ctrl.login(email: emailCtrl.text.trim(), password: passCtrl.text);
                    }
                  },
                )),
                const SizedBox(height: 32),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text("Don't have an account? ", style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                  GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.register),
                    child: const Text('Sign up', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary)),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
