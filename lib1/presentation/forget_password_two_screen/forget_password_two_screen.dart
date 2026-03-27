// Redesigned: Chewdeck-style New Password Screen
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'controller/forget_password_two_controller.dart';

// ignore_for_file: must_be_immutable
class ForgetPasswordTwoScreen extends GetWidget<ForgetPasswordTwoController> {
  ForgetPasswordTwoScreen({Key? key}) : super(key: key);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                GestureDetector(onTap: () => Get.back(), child: const Icon(Icons.arrow_back, color: Color(0xFF1B1B1B))),
                const SizedBox(height: 32),
                Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(14)),
                  child: const Icon(Icons.lock_outline, color: Color(0xFF1B5E20), size: 28),
                ),
                const SizedBox(height: 20),
                const Text("Set New Password", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Color(0xFF1B1B1B))),
                const SizedBox(height: 8),
                Text("Your new password must be different from previously used passwords.", style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.5)),
                const SizedBox(height: 32),
                _buildLabel("New Password"),
                const SizedBox(height: 8),
                _buildPasswordField(controller.newPasswordController, "Create new password"),
                const SizedBox(height: 20),
                _buildLabel("Confirm Password"),
                const SizedBox(height: 8),
                _buildPasswordField(controller.confirmPasswordController, "Confirm new password"),
                const SizedBox(height: 28),
                GestureDetector(
                  onTap: () { if (_formKey.currentState!.validate()) controller.onTapReset(); },
                  child: Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(color: const Color(0xFF1B5E20), borderRadius: BorderRadius.circular(12)),
                    child: const Center(child: Text("Reset Password", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String t) => Text(t, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF333333)));

  Widget _buildPasswordField(TextEditingController ctrl, String hint) {
    return TextField(
      controller: ctrl, obscureText: true,
      style: const TextStyle(fontSize: 14, color: Color(0xFF1B1B1B)),
      decoration: InputDecoration(
        hintText: hint, hintStyle: TextStyle(fontSize: 14, color: Colors.grey[400]),
        filled: true, fillColor: const Color(0xFFF8F8F8),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        suffixIcon: const Icon(Icons.visibility_off_outlined, color: Color(0xFF888888), size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFEEEEEE))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFEEEEEE))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF1B5E20), width: 1.5)),
      ),
    );
  }
}
