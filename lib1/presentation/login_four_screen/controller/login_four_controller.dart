// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/login_four_model.dart';

/// A controller class for the LoginFourScreen.
///
/// This class manages the state of the LoginFourScreen, including the
/// current loginFourModelObj
class LoginFourController extends GetxController {
  Rx<LoginFourModel> loginFourModelObj = LoginFourModel().obs;
}
