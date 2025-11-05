// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/forget_password_two_model.dart';

/// A controller class for the ForgetPasswordTwoScreen.
///
/// This class manages the state of the ForgetPasswordTwoScreen, including the
/// current forgetPasswordTwoModelObj
class ForgetPasswordTwoController extends GetxController {
  TextEditingController emailController = TextEditingController();

  Rx<ForgetPasswordTwoModel> forgetPasswordTwoModelObj =
      ForgetPasswordTwoModel().obs;

  @override
  void onClose() {
    super.onClose();
    emailController.dispose();
  }
}
