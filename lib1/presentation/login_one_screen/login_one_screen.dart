import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'controller/login_one_controller.dart';
// ignore_for_file: must_be_immutable
class LoginOneScreen extends GetWidget<LoginOneController> {
  LoginOneScreen({Key? key}) : super(key: key);
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
          const Text("Sign In", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Color(0xFF1B1B1B))),
          const SizedBox(height: 8),
          Text("Welcome back!", style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          const SizedBox(height: 32),
          const Text("Email", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF333333))),
          const SizedBox(height: 8),
          TextField(controller: controller.emailController, keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(hintText: "Enter your email", hintStyle: TextStyle(color: Colors.grey[400]), filled: true, fillColor: const Color(0xFFF8F8F8), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFEEEEEE))), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFEEEEEE))), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF1B5E20), width: 1.5)))),
          const SizedBox(height: 16),
          const Text("Password", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF333333))),
          const SizedBox(height: 8),
          TextField(controller: controller.passwordController, obscureText: true,
            decoration: InputDecoration(hintText: "Enter password", hintStyle: TextStyle(color: Colors.grey[400]), filled: true, fillColor: const Color(0xFFF8F8F8), suffixIcon: const Icon(Icons.visibility_off_outlined, color: Color(0xFF888888), size: 20), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFEEEEEE))), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFEEEEEE))), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF1B5E20), width: 1.5)))),
          const SizedBox(height: 28),
          GestureDetector(
            onTap: () => controller.onTapLogIn(),
            child: Container(width: double.maxFinite, padding: const EdgeInsets.symmetric(vertical: 16), decoration: BoxDecoration(color: const Color(0xFF1B5E20), borderRadius: BorderRadius.circular(12)),
              child: const Center(child: Text("Sign In", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)))),
          ),
          const SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text("Don't have an account? ", style: TextStyle(fontSize: 14, color: Colors.grey[600])),
            GestureDetector(onTap: () => Get.toNamed(AppRoutes.signupScreen), child: const Text("Sign Up", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1B5E20)))),
          ]),
        ]),
      )),
    );
  }
}
