// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/account_information_model.dart';

/// A controller class for the AccountInformationBottomsheet.
///
/// This class manages the state of the AccountInformationBottomsheet, including the
/// current accountInformationModelObj
class AccountInformationController extends GetxController {
  TextEditingController fullNameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController phoneNumberController = TextEditingController();

  Rx<AccountInformationModel> accountInformationModelObj =
      AccountInformationModel().obs;

  @override
  void onClose() {
    super.onClose();
    fullNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
  }
}
