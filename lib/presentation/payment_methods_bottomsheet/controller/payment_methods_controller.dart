// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/payment_methods_model.dart';

/// A controller class for the PaymentMethodsBottomsheet.
///
/// This class manages the state of the PaymentMethodsBottomsheet, including the
/// current paymentMethodsModelObj
class PaymentMethodsController extends GetxController {
  Rx<PaymentMethodsModel> paymentMethodsModelObj = PaymentMethodsModel().obs;
}
