// Forget Password One Controller
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../data/apiClient/apiClient.dart';
import '../models/forget_password_one_model.dart';

/// A controller class for the ForgetPasswordOneScreen.
///
/// This class manages the state of the ForgetPasswordOneScreen, including the
/// current forgetPasswordOneModelObj
class ForgetPasswordOneController extends GetxController {
  TextEditingController emailController = TextEditingController();

  Rx<ForgetPasswordOneModel> forgetPasswordOneModelObj =
      ForgetPasswordOneModel().obs;

  Rx<bool> isLoading = false.obs;

  final ApiClient apiClient = ApiClient(Duration(seconds: 30));

  @override
  void onClose() {
    super.onClose();
    emailController.dispose();
  }

  void onTapSend() async {
    if (_validateEmail()) {
      isLoading.value = true;
      try {
        // TODO: Implement API call to send reset password email
        // For now, just simulate success
        await Future.delayed(const Duration(seconds: 2));

        Get.snackbar(
          "Reset Code Sent",
          "Please check your email for the reset code",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Navigate to OTP screen
        Get.toNamed('/forgot-password-otp', arguments: {'email': emailController.text});

      } catch (e) {
        Get.snackbar(
          "Error",
          "Failed to send reset code: ${e.toString()}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  bool _validateEmail() {
    if (emailController.text.isEmpty) {
      Get.snackbar("Error", "Please enter your email",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    // Basic email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(emailController.text)) {
      Get.snackbar("Error", "Please enter a valid email address",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    return true;
  }
}
