import 'package:ctluser/presentation/otp_screen/controller/otp_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/state_manager.dart';

import 'dart:async';

OtpController controller = Get.put(OtpController());

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  var email = Get.arguments['email'];

  @override
  void initState() {
    super.initState();
    controller.resendOtp({'email': email});
    controller.startResendTimer();

    // Set up focus node listeners
    for (int i = 0; i < 4; i++) {
      _controllers[i].addListener(() {
        if (_controllers[i].text.length == 1 && i < 3) {
          _focusNodes[i + 1].requestFocus();
        }
      });
    }
  }

  String get _formattedTime {
    int minutes = controller.resendSeconds.value ~/ 60;
    int seconds = controller.resendSeconds.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    controller.timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const StatusBar(),
              const SizedBox(height: 24),
              Row(
                //  spacing: 10,
                children: [
                  IconButton(
                    icon: Icon(Icons.chevron_left),
                    onPressed: () => Get.back(),
                  ),
                  const Text(
                    'Email Verification',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'We have sent a confirmation code to your mail at $email',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  4,
                  (index) => SizedBox(
                    width: 60,
                    height: 60,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFF004DBF),
                            width: 2,
                          ),
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 3) {
                          _focusNodes[index + 1].requestFocus();
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: Obx(() {
                  return TextButton(
                    onPressed:
                        controller.resendSeconds.value == 0
                            ? () {
                              setState(() {
                                controller.resendOtp({"email": email});
                                //controller.resendSeconds.value = 240;
                                //controller.startResendTimer();
                              });
                            }
                            : null,
                    child: Text(
                      'Didn\'t Receive Email, Send A New Email',
                      style: TextStyle(
                        color:
                            controller.resendSeconds.value == 0
                                ? const Color(0xFF004DBF)
                                : Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }),
              ),
              Obx(() {
                return (controller.resendSeconds.value > 0)
                    ? Center(
                      child: Text(
                        'Send new code in $_formattedTime',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    )
                    : SizedBox.shrink();
              }),
              const Spacer(),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    print(_controllers.length);
                    // print(_controllers.toString());
                    String otp =
                        _controllers
                            .map((controller) => controller.text)
                            .join();
                    print('OTP:$otp');
                    controller.verifyEmail({"email": email, "otp": otp});
                    //Navigator.pushNamed(context, '/profile-setup');
                    // Navigator.of(context).push(CupertinoPageRoute(builder: (context)=> const ProfileSetupScreen()));
                  },
                  child: const Text(
                    'Verify',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF004DBF),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
