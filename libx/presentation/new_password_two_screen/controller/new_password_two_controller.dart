// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/new_password_two_model.dart';

/// A controller class for the NewPasswordTwoScreen.
///
/// This class manages the state of the NewPasswordTwoScreen, including the
/// current newPasswordTwoModelObj
class NewPasswordTwoController extends GetxController {
  TextEditingController newpasswordController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  Rx<NewPasswordTwoModel> newPasswordTwoModelObj = NewPasswordTwoModel().obs;

  Rx<bool> isShowPassword = true.obs;

  Rx<bool> isShowPassword1 = true.obs;

  @override
  void onClose() {
    super.onClose();
    newpasswordController.dispose();
    passwordController.dispose();
  }
}
