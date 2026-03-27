// Filter Price Controller
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

  Rx<double> minPrice = 0.0.obs;
  Rx<double> maxPrice = 1000.0.obs;

  // Price range options
  final List<Map<String, dynamic>> priceRanges = [
    {'label': 'Under ₦500', 'min': 0.0, 'max': 500.0},
    {'label': '₦500 - ₦1000', 'min': 500.0, 'max': 1000.0},
    {'label': '₦1000 - ₦2000', 'min': 1000.0, 'max': 2000.0},
    {'label': '₦2000 - ₦5000', 'min': 2000.0, 'max': 5000.0},
    {'label': 'Above ₦5000', 'min': 5000.0, 'max': double.infinity},
  ];

  Rx<String> selectedRange = 'All'.obs;

  void onRangeSelected(String range) {
    selectedRange.value = range;

    if (range == 'All') {
      minPrice.value = 0.0;
      maxPrice.value = double.infinity;
    } else {
      final selectedRangeData = priceRanges.firstWhere(
        (r) => r['label'] == range,
        orElse: () => {'min': 0.0, 'max': double.infinity},
      );
      minPrice.value = selectedRangeData['min'];
      maxPrice.value = selectedRangeData['max'];
    }
  }

  void onCustomRangeChanged(double min, double max) {
    minPrice.value = min;
    maxPrice.value = max;
    selectedRange.value = 'Custom';
  }

  void applyPriceFilter() {
    // TODO: Apply price filter and navigate back
    Get.back(result: {
      'minPrice': minPrice.value,
      'maxPrice': maxPrice.value,
      'selectedRange': selectedRange.value,
    });
  }

  void clearPriceFilter() {
    minPrice.value = 0.0;
    maxPrice.value = double.infinity;
    selectedRange.value = 'All';
  }
}
