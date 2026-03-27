// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../../core/app_export.dart';
import '../models/false_forgot_password_otp_model.dart';

/// A controller class for the FalseForgotPasswordOtpScreen.
///
/// This class manages the state of the FalseForgotPasswordOtpScreen, including the
/// current falseForgotPasswordOtpModelObj
class FalseForgotPasswordOtpController extends GetxController
    with CodeAutoFill {
  Rx<TextEditingController> otpController = TextEditingController().obs;

  Rx<FalseForgotPasswordOtpModel> falseForgotPasswordOtpModelObj =
      FalseForgotPasswordOtpModel().obs;

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
