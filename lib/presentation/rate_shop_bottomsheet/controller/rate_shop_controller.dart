// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/rate_shop_model.dart';

/// A controller class for the RateShopBottomsheet.
///
/// This class manages the state of the RateShopBottomsheet, including the
/// current rateShopModelObj
class RateShopController extends GetxController {
  TextEditingController commentController = TextEditingController();

  Rx<RateShopModel> rateShopModelObj = RateShopModel().obs;

  @override
  void onClose() {
    super.onClose();
    commentController.dispose();
  }
}
