// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/login_six_model.dart';

/// A controller class for the LoginSixScreen.
///
/// This class manages the state of the LoginSixScreen, including the
/// current loginSixModelObj
class LoginSixController extends GetxController {
  TextEditingController lblQuantity = TextEditingController();

  Rx<LoginSixModel> loginSixModelObj = LoginSixModel().obs;

  @override
  void onClose() {
    super.onClose();
    lblQuantity.dispose();
  }

  void incrementQuantity() {
    int quantity = int.tryParse(lblQuantity.text ?? '1') ?? 1;
    quantity++;
    lblQuantity.text = quantity.toString();
  }

  void decrementQuantity() {
    int quantity = int.tryParse(lblQuantity.text ?? '1') ?? 1;
    if (quantity > 1) {
      quantity--;
      lblQuantity.text = quantity.toString();
    }
  }
}
