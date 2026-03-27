import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'controller/login_two_controller.dart';
// ignore_for_file: must_be_immutable
class LoginTwoScreen extends GetWidget<LoginTwoController> {
  LoginTwoScreen({Key? key}) : super(key: key);
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
          const Text("Phone Verification", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Color(0xFF1B1B1B))),
          const SizedBox(height: 8),
          Text("Enter your phone number to continue.", style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.5)),
          const SizedBox(height: 32),
          const Text("Phone Number", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF333333))),
          const SizedBox(height: 8),
          TextField(controller: controller.phoneController, keyboardType: TextInputType.phone,
            decoration: InputDecoration(hintText: "+234 800 000 0000", hintStyle: TextStyle(color: Colors.grey[400]), filled: true, fillColor: const Color(0xFFF8F8F8), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFEEEEEE))), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFEEEEEE))), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF1B5E20), width: 1.5)))),
          const Spacer(),
          GestureDetector(
            onTap: () => controller.onTapSend(),
            child: Container(width: double.maxFinite, padding: const EdgeInsets.symmetric(vertical: 16), decoration: BoxDecoration(color: const Color(0xFF1B5E20), borderRadius: BorderRadius.circular(12)),
              child: const Center(child: Text("Send Code", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)))),
          ),
          const SizedBox(height: 24),
        ]),
      )),
    );
  }
}
