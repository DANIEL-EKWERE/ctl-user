// Change Password Controller
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../data/apiClient/apiClient.dart';
import '../models/change_password_model.dart';

/// A controller class for the ChangePasswordBottomsheet.
///
/// This class manages the state of the ChangePasswordBottomsheet, including the
/// current changePasswordModelObj
class ChangePasswordController extends GetxController {
  TextEditingController passwordController = TextEditingController();
  TextEditingController newpasswordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();

  Rx<ChangePasswordModel> changePasswordModelObj = ChangePasswordModel().obs;

  Rx<bool> isShowPassword = true.obs;
  Rx<bool> isShowPassword1 = true.obs;
  Rx<bool> isShowPassword2 = true.obs;

  Rx<bool> isLoading = false.obs;

  final ApiClient apiClient = ApiClient(Duration(seconds: 30));

  @override
  void onClose() {
    super.onClose();
    passwordController.dispose();
    newpasswordController.dispose();
    confirmpasswordController.dispose();
  }

  void onTapSave() async {
    if (_validateInputs()) {
      isLoading.value = true;
      try {
        // TODO: Implement API call to change password
        // For now, just simulate success
        await Future.delayed(const Duration(seconds: 2));

        Get.back(); // Close bottomsheet
        Get.snackbar(
          "Success",
          "Password changed successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Clear fields
        passwordController.clear();
        newpasswordController.clear();
        confirmpasswordController.clear();

      } catch (e) {
        Get.snackbar(
          "Error",
          "Failed to change password: ${e.toString()}",
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
    if (passwordController.text.isEmpty) {
      Get.snackbar("Error", "Please enter current password",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    if (newpasswordController.text.isEmpty) {
      Get.snackbar("Error", "Please enter new password",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    if (newpasswordController.text.length < 6) {
      Get.snackbar("Error", "New password must be at least 6 characters",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    if (confirmpasswordController.text.isEmpty) {
      Get.snackbar("Error", "Please confirm new password",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    if (newpasswordController.text != confirmpasswordController.text) {
      Get.snackbar("Error", "New passwords do not match",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    return true;
  }
}
