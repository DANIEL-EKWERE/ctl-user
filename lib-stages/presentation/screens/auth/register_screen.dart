import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/controllers/auth_controller.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/app_theme.dart';
import '../../widgets/common/app_widgets.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(AuthController());
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final roleObs = 'customer'.obs;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: Get.back,
                  child: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 24),
                const Text('Create account', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                const SizedBox(height: 6),
                const Text('Join NKsereke today', style: TextStyle(fontSize: 15, color: AppColors.textSecondary)),
                const SizedBox(height: 28),

                // Role selector
                Obx(() => Row(children: [
                  _roleChip('Customer', 'customer', roleObs),
                  const SizedBox(width: 12),
                  _roleChip('Rider', 'rider', roleObs),
                ])),
                const SizedBox(height: 24),

                AppTextField(
                  label: 'Full Name',
                  hint: 'Emeka Okafor',
                  controller: nameCtrl,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.person_outlined, size: 20, color: AppColors.grey400),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Name is required' : null,
                ),
                const SizedBox(height: 20),
                AppTextField(
                  label: 'Email',
                  hint: 'emeka@example.com',
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.email_outlined, size: 20, color: AppColors.grey400),
                  validator: (v) => (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
                ),
                const SizedBox(height: 20),
                AppTextField(
                  label: 'Phone',
                  hint: '08012345678',
                  controller: phoneCtrl,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.phone_outlined, size: 20, color: AppColors.grey400),
                  validator: (v) => (v == null || v.length < 10) ? 'Enter a valid phone number' : null,
                ),
                const SizedBox(height: 20),
                AppTextField(
                  label: 'Password',
                  hint: 'Min 8 characters',
                  controller: passCtrl,
                  obscure: true,
                  textInputAction: TextInputAction.done,
                  prefixIcon: const Icon(Icons.lock_outlined, size: 20, color: AppColors.grey400),
                  validator: (v) => (v == null || v.length < 6) ? 'Password too short' : null,
                ),
                const SizedBox(height: 32),
                Obx(() => AppButton(
                  label: 'Create Account',
                  isLoading: ctrl.isLoading.value,
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      ctrl.register(
                        name: nameCtrl.text.trim(),
                        email: emailCtrl.text.trim(),
                        phone: phoneCtrl.text.trim(),
                        password: passCtrl.text,
                        role: roleObs.value,
                      );
                    }
                  },
                )),
                const SizedBox(height: 24),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text('Already have an account? ', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                  GestureDetector(
                    onTap: () => Get.offNamed(AppRoutes.login),
                    child: const Text('Sign in', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary)),
                  ),
                ]),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _roleChip(String label, String value, RxString selected) {
    return Obx(() {
      final isSelected = selected.value == value;
      return GestureDetector(
        onTap: () => selected.value = value,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.grey100,
            borderRadius: BorderRadius.circular(24),
            border: isSelected ? null : Border.all(color: AppColors.border),
          ),
          child: Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isSelected ? AppColors.white : AppColors.textSecondary)),
        ),
      );
    });
  }
}
