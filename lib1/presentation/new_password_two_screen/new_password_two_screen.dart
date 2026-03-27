import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'controller/new_password_two_controller.dart';
// ignore_for_file: must_be_immutable
class NewPasswordTwoScreen extends GetWidget<NewPasswordTwoController> {
  const NewPasswordTwoScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 24),
          GestureDetector(onTap: () => Get.back(), child: const Icon(Icons.arrow_back, color: Color(0xFF1B1B1B))),
          const SizedBox(height: 32),
          const Text("Set New Password", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Color(0xFF1B1B1B))),
          const SizedBox(height: 8),
          Text("Choose a strong password for your account.", style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.5)),
          const SizedBox(height: 32),
          const Text("New Password", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF333333))),
          const SizedBox(height: 8),
          TextField(controller: controller.newPasswordController, obscureText: true,
            decoration: InputDecoration(hintText: "Enter new password", hintStyle: TextStyle(color: Colors.grey[400]), filled: true, fillColor: const Color(0xFFF8F8F8), suffixIcon: const Icon(Icons.visibility_off_outlined, color: Color(0xFF888888), size: 20), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFEEEEEE))), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFEEEEEE))), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF1B5E20), width: 1.5)))),
          const SizedBox(height: 16),
          const Text("Confirm Password", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF333333))),
          const SizedBox(height: 8),
          TextField(controller: controller.confirmPasswordController, obscureText: true,
            decoration: InputDecoration(hintText: "Confirm new password", hintStyle: TextStyle(color: Colors.grey[400]), filled: true, fillColor: const Color(0xFFF8F8F8), suffixIcon: const Icon(Icons.visibility_off_outlined, color: Color(0xFF888888), size: 20), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFEEEEEE))), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFEEEEEE))), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF1B5E20), width: 1.5)))),
          const Spacer(),
          GestureDetector(
            onTap: () => controller.onTapSave(),
            child: Container(width: double.maxFinite, padding: const EdgeInsets.symmetric(vertical: 16), decoration: BoxDecoration(color: const Color(0xFF1B5E20), borderRadius: BorderRadius.circular(12)),
              child: const Center(child: Text("Update Password", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)))),
          ),
          const SizedBox(height: 24),
        ]),
      )),
    );
  }
}
