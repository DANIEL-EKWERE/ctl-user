import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'controller/false_forgot_password_otp_controller.dart';
// ignore_for_file: must_be_immutable
class FalseForgotPasswordOtpScreen extends GetWidget<FalseForgotPasswordOtpController> {
  const FalseForgotPasswordOtpScreen({Key? key}) : super(key: key);
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
          Container(width: 56, height: 56, decoration: BoxDecoration(color: const Color(0xFFFFEBEE), borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.error_outline, color: Color(0xFFD32F2F), size: 28)),
          const SizedBox(height: 20),
          const Text("Invalid Code", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Color(0xFF1B1B1B))),
          const SizedBox(height: 8),
          Text("The code you entered is incorrect or has expired. Please try again.", style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.5)),
          const Spacer(),
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: double.maxFinite, padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(color: const Color(0xFF1B5E20), borderRadius: BorderRadius.circular(12)),
              child: const Center(child: Text("Try Again", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700))),
            ),
          ),
          const SizedBox(height: 24),
        ]),
      )),
    );
  }
}
