// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/rate_shop1_model.dart';

/// A controller class for the RateShop1Dialog.
///
/// This class manages the state of the RateShop1Dialog, including the
/// current rateShop1ModelObj
class RateShop1Controller extends GetxController {
  Rx<RateShop1Model> rateShop1ModelObj = RateShop1Model().obs;
}
