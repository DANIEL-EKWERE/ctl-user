// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/new_password_one_model.dart';

/// A controller class for the NewPasswordOneScreen.
///
/// This class manages the state of the NewPasswordOneScreen, including the
/// current newPasswordOneModelObj
class NewPasswordOneController extends GetxController {
  TextEditingController newpasswordController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  Rx<NewPasswordOneModel> newPasswordOneModelObj = NewPasswordOneModel().obs;

  Rx<bool> isShowPassword = true.obs;

  Rx<bool> isShowPassword1 = true.obs;

  @override
  void onClose() {
    super.onClose();
    newpasswordController.dispose();
    passwordController.dispose();
  }
}
