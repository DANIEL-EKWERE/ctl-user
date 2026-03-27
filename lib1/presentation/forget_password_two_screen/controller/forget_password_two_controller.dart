// Forget Password Two Controller
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../data/apiClient/apiClient.dart';
import '../models/forget_password_two_model.dart';

/// A controller class for the ForgetPasswordTwoScreen.
///
/// This class manages the state of the ForgetPasswordTwoScreen, including the
/// current forgetPasswordTwoModelObj
class ForgetPasswordTwoController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Rx<ForgetPasswordTwoModel> forgetPasswordTwoModelObj =
      ForgetPasswordTwoModel().obs;

  Rx<bool> isLoading = false.obs;
  Rx<bool> isShowPassword = true.obs;
  Rx<bool> isShowConfirmPassword = true.obs;

  final ApiClient apiClient = ApiClient(Duration(seconds: 30));

  @override
  void onClose() {
    super.onClose();
    emailController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
  }

  void onTapReset() async {
    if (_validateInputs()) {
      isLoading.value = true;
      try {
        // TODO: Implement API call to reset password
        // For now, just simulate success
        await Future.delayed(const Duration(seconds: 2));

        Get.offAllNamed('/login'); // Navigate to login screen

        Get.snackbar(
          "Password Reset",
          "Your password has been reset successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

      } catch (e) {
        Get.snackbar(
          "Error",
          "Failed to reset password: ${e.toString()}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  bool _validateInputs() {
    if (newPasswordController.text.isEmpty) {
      Get.snackbar("Error", "Please enter new password",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    if (newPasswordController.text.length < 6) {
      Get.snackbar("Error", "Password must be at least 6 characters",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    if (confirmPasswordController.text.isEmpty) {
      Get.snackbar("Error", "Please confirm your password",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      Get.snackbar("Error", "Passwords do not match",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    return true;
  }
}
