import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'controller/signup_one_controller.dart';
// ignore_for_file: must_be_immutable
class SignupOneScreen extends GetWidget<SignupOneController> {
  SignupOneScreen({Key? key}) : super(key: key);
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
          const Text("Verify your account", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Color(0xFF1B1B1B))),
          const SizedBox(height: 8),
          Text("Enter the verification code sent to you.", style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.5)),
          const SizedBox(height: 40),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: List.generate(4, (i) => SizedBox(
            width: 68, height: 68,
            child: TextField(
              keyboardType: TextInputType.number, maxLength: 1, textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              decoration: InputDecoration(counterText: "", filled: true, fillColor: const Color(0xFFF8F8F8),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFEEEEEE))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFEEEEEE))),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF1B5E20), width: 2))),
            ),
          ))),
          const Spacer(),
          GestureDetector(
            onTap: () => controller.onTapVerify(),
            child: Container(width: double.maxFinite, padding: const EdgeInsets.symmetric(vertical: 16), decoration: BoxDecoration(color: const Color(0xFF1B5E20), borderRadius: BorderRadius.circular(12)),
              child: const Center(child: Text("Verify Account", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)))),
          ),
          const SizedBox(height: 24),
        ]),
      )),
    );
  }
}
