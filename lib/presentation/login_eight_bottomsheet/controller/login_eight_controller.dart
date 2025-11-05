// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/login_eight_model.dart';

/// A controller class for the LoginEightBottomsheet.
///
/// This class manages the state of the LoginEightBottomsheet, including the
/// current loginEightModelObj
class LoginEightController extends GetxController {
  TextEditingController creditcardoneController = TextEditingController();

  TextEditingController mmyyoneController = TextEditingController();

  TextEditingController cvconeController = TextEditingController();

  Rx<LoginEightModel> loginEightModelObj = LoginEightModel().obs;

  @override
  void onClose() {
    super.onClose();
    creditcardoneController.dispose();
    mmyyoneController.dispose();
    cvconeController.dispose();
  }
}
