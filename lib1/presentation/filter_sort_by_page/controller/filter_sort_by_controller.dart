// Filter Sort By Controller
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/filter_sort_by_model.dart';

/// A controller class for the FilterSortByPage.
///
/// This class manages the state of the FilterSortByPage, including the
/// current filterSortByModelObj
class FilterSortByController extends GetxController {
  FilterSortByController(this.filterSortByModelObj);

  Rx<FilterSortByModel> filterSortByModelObj;
  Rx<String> selectedSort = "Price: Low to High".obs;

  // Available sort options
  final List<String> sortOptions = [
    "Price: Low to High",
    "Price: High to Low",
    "Rating: High to Low",
    "Distance: Near to Far",
    "Newest First",
    "Most Popular",
  ];

  void onSortSelected(String sortOption) {
    selectedSort.value = sortOption;
  }

  void applySort() {
    // TODO: Apply sort and navigate back
    Get.back(result: {
      'sortBy': selectedSort.value,
    });
  }

  void clearSort() {
    selectedSort.value = "Price: Low to High";
  }
}
