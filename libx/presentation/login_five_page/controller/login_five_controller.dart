import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/login_five_model.dart';

/// A controller class for the LoginFivePage.
///
/// This class manages the state of the LoginFivePage, including the
/// current loginFiveModelObj
class LoginFiveController extends GetxController {
  LoginFiveController(this.loginFiveModelObj);

  Rx<LoginFiveModel> loginFiveModelObj;
}
