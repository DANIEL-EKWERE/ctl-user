// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/login_six_model.dart';

/// A controller class for the LoginSixScreen.
///
/// This class manages the state of the LoginSixScreen, including the
/// current loginSixModelObj
class LoginSixController extends GetxController {
  Rx<TextEditingController> lblQuantity = TextEditingController(text: '1').obs;

  Rx<LoginSixModel> loginSixModelObj = LoginSixModel().obs;

  var quantity = 1.obs;

  @override
  void onClose() {
    super.onClose();
    //lblQuantity.dispose();
  }

  void incrementQuantity() {
    int quantity = int.tryParse(lblQuantity.value.text ?? '1') ?? 1;
    quantity++;
    lblQuantity.value = TextEditingController(text: quantity.toString());
  }

  void decrementQuantity() {
    int quantity = int.tryParse(lblQuantity.value.text ?? '1') ?? 1;
    if (quantity > 1) {
      quantity--;
      lblQuantity.value = TextEditingController(text: quantity.toString());
    }
  }
}
