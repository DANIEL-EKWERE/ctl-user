// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/filter_price_model.dart';

/// A controller class for the FilterPricePage.
///
/// This class manages the state of the FilterPricePage, including the
/// current filterPriceModelObj
class FilterPriceController extends GetxController {
  FilterPriceController(this.filterPriceModelObj);

  Rx<FilterPriceModel> filterPriceModelObj;
}
