// Redesigned: Chewdeck-style Forgot Password Screen
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../core/utils/validation_functions.dart';
import 'controller/forget_password_one_controller.dart';

// ignore_for_file: must_be_immutable
class ForgetPasswordOneScreen extends GetWidget<ForgetPasswordOneController> {
  ForgetPasswordOneScreen({Key? key}) : super(key: key);
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
                  child: const Icon(Icons.lock_reset_outlined, color: Color(0xFF1B5E20), size: 28),
                ),
                const SizedBox(height: 20),
                const Text("Forgot Password?", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Color(0xFF1B1B1B))),
                const SizedBox(height: 8),
                Text("Enter your registered email and we'll send you a reset link.", style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.5)),
                const SizedBox(height: 32),
                const Text("Email address", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF333333))),
                const SizedBox(height: 8),
                TextFormField(
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF1B1B1B)),
                  validator: (v) => (v == null || !isValidEmail(v, isRequired: true)) ? "Please enter a valid email" : null,
                  decoration: InputDecoration(
                    hintText: "Enter your email address",
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey[400]),
                    filled: true, fillColor: const Color(0xFFF8F8F8),
                    prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF888888), size: 20),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFEEEEEE))),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFEEEEEE))),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF1B5E20), width: 1.5)),
                  ),
                ),
                const SizedBox(height: 28),
                GestureDetector(
                  onTap: () { if (_formKey.currentState!.validate()) controller.onTapSend(); },
                  child: Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(color: const Color(0xFF1B5E20), borderRadius: BorderRadius.circular(12)),
                    child: const Center(child: Text("Send Reset Link", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
