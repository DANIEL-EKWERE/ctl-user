// Redesigned: Chewdeck-style OTP Screen
import 'package:ctluser/presentation/otp_screen/controller/otp_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

OtpController controller = Get.put(OtpController());

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  var email = Get.arguments['email'];

  @override
  void initState() {
    super.initState();
    controller.resendOtp({'email': email});
    controller.startResendTimer();
    for (int i = 0; i < 4; i++) {
      _controllers[i].addListener(() {
        if (_controllers[i].text.length == 1 && i < 3) _focusNodes[i + 1].requestFocus();
      });
    }
  }

  String get _formattedTime {
    int m = controller.resendSeconds.value ~/ 60;
    int s = controller.resendSeconds.value % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    controller.timer?.cancel();
    for (var c in _controllers) c.dispose();
    for (var n in _focusNodes) n.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () => Get.back(),
                child: const Icon(Icons.arrow_back, color: Color(0xFF1B1B1B)),
              ),
              const SizedBox(height: 32),
              const Text("Enter OTP", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Color(0xFF1B1B1B))),
              const SizedBox(height: 8),
              Text.rich(
                TextSpan(
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  children: [
                    const TextSpan(text: "We sent a 4-digit code to "),
                    TextSpan(text: email ?? "your email", style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1B1B1B))),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // OTP boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(4, (i) => _buildOtpBox(i)),
              ),
              const SizedBox(height: 32),
              // Resend timer
              Obx(() => Center(
                child: controller.resendSeconds.value > 0
                    ? Text.rich(
                        TextSpan(
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                          children: [
                            const TextSpan(text: "Resend code in "),
                            TextSpan(text: _formattedTime, style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF1B5E20))),
                          ],
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          controller.resendOtp({'email': email});
                          controller.startResendTimer();
                        },
                        child: const Text("Resend OTP", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1B5E20))),
                      ),
              )),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  final otp = _controllers.map((c) => c.text).join();
                  controller.verifyOtp({'email': email, 'otp': otp});
                },
                child: Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(color: const Color(0xFF1B5E20), borderRadius: BorderRadius.circular(12)),
                  child: const Center(child: Text("Verify OTP", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700))),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpBox(int index) {
    return SizedBox(
      width: 68,
      height: 68,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        maxLength: 1,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF1B1B1B)),
        onChanged: (val) {
          if (val.isEmpty && index > 0) _focusNodes[index - 1].requestFocus();
        },
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: const Color(0xFFF8F8F8),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFEEEEEE))),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFEEEEEE))),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF1B5E20), width: 2)),
        ),
      ),
    );
  }
}
