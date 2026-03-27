// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/login_one_model.dart';

/// A controller class for the LoginOneScreen.
///
/// This class manages the state of the LoginOneScreen, including the
/// current loginOneModelObj
class LoginOneController extends GetxController {
  TextEditingController emailController = TextEditingController();

  TextEditingController visibleoneController = TextEditingController();

  Rx<LoginOneModel> loginOneModelObj = LoginOneModel().obs;

  Rx<bool> isShowPassword = true.obs;

  Rx<bool> keepmeloginone = false.obs;

  @override
  void onClose() {
    super.onClose();
    emailController.dispose();
    visibleoneController.dispose();
  }
}
