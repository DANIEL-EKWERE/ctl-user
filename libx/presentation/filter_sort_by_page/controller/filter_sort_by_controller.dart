// TODO Implement this library.
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
}
