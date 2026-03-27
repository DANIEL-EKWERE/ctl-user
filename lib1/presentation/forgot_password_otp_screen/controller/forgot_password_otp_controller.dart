// Forgot Password OTP Controller
import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../../core/app_export.dart';
import '../../../data/apiClient/apiClient.dart';
import '../models/forgot_password_otp_model.dart';

/// A controller class for the ForgotPasswordOtpScreen.
///
/// This class manages the state of the ForgotPasswordOtpScreen, including the
/// current forgotPasswordOtpModelObj
class ForgotPasswordOtpController extends GetxController with CodeAutoFill {
  Rx<TextEditingController> otpController = TextEditingController().obs;

  Rx<ForgotPasswordOtpModel> forgotPasswordOtpModelObj =
      ForgotPasswordOtpModel().obs;

  Rx<bool> isLoading = false.obs;
  Rx<int> countdown = 30.obs;

  final ApiClient apiClient = ApiClient(Duration(seconds: 30));

  @override
  void codeUpdated() {
    otpController.value.text = code ?? '';
  }

  @override
  void onInit() {
    super.onInit();
    listenForCode();
    startCountdown();
  }

  @override
  void onClose() {
    super.onClose();
    cancel();
    otpController.value.dispose();
  }

  void startCountdown() {
    countdown.value = 30;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      countdown.value--;
      return countdown.value > 0;
    });
  }

  void onTapConfirm() async {
    if (_validateOtp()) {
      isLoading.value = true;
      try {
        // TODO: Implement API call to verify OTP
        // For now, just simulate success
        await Future.delayed(const Duration(seconds: 2));

        Get.snackbar(
          "OTP Verified",
          "Please set your new password",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Navigate to reset password screen
        Get.toNamed('/new-password-one', arguments: {
          'email': Get.arguments?['email'],
          'otp': otpController.value.text
        });

      } catch (e) {
        Get.snackbar(
          "Error",
          "Failed to verify OTP: ${e.toString()}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  void onTapResend() async {
    if (countdown.value > 0) return;

    try {
      // TODO: Implement API call to resend OTP
      // For now, just restart countdown
      startCountdown();

      Get.snackbar(
        "OTP Sent",
        "A new verification code has been sent to your email",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to resend OTP: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  bool _validateOtp() {
    if (otpController.value.text.isEmpty) {
      Get.snackbar("Error", "Please enter the verification code",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    if (otpController.value.text.length != 6) {
      Get.snackbar("Error", "Please enter a valid 6-digit code",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    return true;
  }
}
