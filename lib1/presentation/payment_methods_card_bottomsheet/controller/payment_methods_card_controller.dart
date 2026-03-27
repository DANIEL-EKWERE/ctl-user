// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/payment_methods_card_model.dart';

/// A controller class for the PaymentMethodsCardBottomsheet.
///
/// This class manages the state of the PaymentMethodsCardBottomsheet, including the
/// current paymentMethodsCardModelObj
class PaymentMethodsCardController extends GetxController {
  Rx<PaymentMethodsCardModel> paymentMethodsCardModelObj =
      PaymentMethodsCardModel().obs;
}
