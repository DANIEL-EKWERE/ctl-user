// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../../core/app_export.dart';
import '../models/forgot_password_otp_model.dart';

/// A controller class for the ForgotPasswordOtpScreen.
///
/// This class manages the state of the ForgotPasswordOtpScreen, including the
/// current forgotPasswordOtpModelObj
class ForgotPasswordOtpController extends GetxController with CodeAutoFill {
  Rx<TextEditingController> otpController = TextEditingController().obs;

  Rx<ForgotPasswordOtpModel> forgotPasswordOtpModelObj =
      ForgotPasswordOtpModel().obs;

  @override
  void codeUpdated() {
    otpController.value.text = code ?? '';
  }

  @override
  void onInit() {
    super.onInit();
    listenForCode();
  }
}
