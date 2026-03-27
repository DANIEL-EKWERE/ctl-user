// Redesigned: Chewdeck-style Login Screen
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../core/utils/validation_functions.dart';
import '../../domain/facebookauth/facebook_auth_helper.dart';
import '../../domain/googleauth/google_auth_helper.dart';
import '../../widgets/custom_text_form_field.dart';
import 'controller/login_controller.dart';

// ignore_for_file: must_be_immutable
class LoginScreen extends GetWidget<LoginController> {
  LoginScreen({Key? key}) : super(key: key);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                // Logo / Brand
                Row(
                  children: [
                    Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(color: const Color(0xFF1B5E20), borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.fastfood, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 10),
                    const Text("ChewDeck", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF1B1B1B))),
                  ],
                ),
                const SizedBox(height: 40),
                const Text("Welcome back!", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Color(0xFF1B1B1B))),
                const SizedBox(height: 6),
                Text("Sign in to continue", style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                const SizedBox(height: 32),
                // Email
                _buildLabel("Email address"),
                const SizedBox(height: 8),
                _buildField(controller: controller.emailController, hint: "Enter your email", keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 20),
                // Password
                _buildLabel("Password"),
                const SizedBox(height: 8),
                _buildField(controller: controller.passwordController, hint: "Enter your password", obscure: true),
                const SizedBox(height: 12),
                // Forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.forgetPasswordOneScreen),
                    child: const Text("Forgot Password?", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1B5E20))),
                  ),
                ),
                const SizedBox(height: 28),
                // Login button
                GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) controller.onTapLogIn();
                  },
                  child: Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(color: const Color(0xFF1B5E20), borderRadius: BorderRadius.circular(12)),
                    child: const Center(child: Text("Sign In", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700))),
                  ),
                ),
                const SizedBox(height: 24),
                // Divider
                Row(children: [
                  Expanded(child: Divider(color: Colors.grey[300])),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text("or continue with", style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                  ),
                  Expanded(child: Divider(color: Colors.grey[300])),
                ]),
                const SizedBox(height: 24),
                // Social buttons
                Row(
                  children: [
                    Expanded(child: _buildSocialBtn("Google", Icons.g_mobiledata, () async {
                      final user = await GoogleAuthHelper().googleSignInProcess();
                      if (user != null) controller.googleSignIn(user);
                    })),
                    const SizedBox(width: 16),
                    Expanded(child: _buildSocialBtn("Facebook", Icons.facebook, () async {
                      final user = await FacebookAuthHelper().facebookSignInProcess();
                      if (user != null) controller.facebookSignIn(user);
                    })),
                  ],
                ),
                const SizedBox(height: 40),
                // Sign up
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? ", style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                    GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.signupScreen),
                      child: const Text("Sign Up", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1B5E20))),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF333333)));
  }

  Widget _buildField({required TextEditingController controller, required String hint, bool obscure = false, TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 14, color: Color(0xFF1B1B1B)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 14, color: Colors.grey[400]),
        filled: true,
        fillColor: const Color(0xFFF8F8F8),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFEEEEEE))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFEEEEEE))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF1B5E20), width: 1.5)),
        suffixIcon: obscure ? const Icon(Icons.visibility_off_outlined, color: Color(0xFF888888), size: 20) : null,
      ),
    );
  }

  Widget _buildSocialBtn(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFDDDDDD)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: const Color(0xFF333333)),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF333333))),
          ],
        ),
      ),
    );
  }
}
