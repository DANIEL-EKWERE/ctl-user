// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/login_nine_model.dart';

/// A controller class for the LoginNineDialog.
///
/// This class manages the state of the LoginNineDialog, including the
/// current loginNineModelObj
class LoginNineController extends GetxController {
  Rx<LoginNineModel> loginNineModelObj = LoginNineModel().obs;
}
