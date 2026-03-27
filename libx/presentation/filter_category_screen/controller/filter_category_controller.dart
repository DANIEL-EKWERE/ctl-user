// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/filter_category_model.dart';
import '../models/twenty_tab_model.dart';

/// A controller class for the FilterCategoryScreen.
///
/// This class manages the state of the FilterCategoryScreen, including the
/// current filterCategoryModelObj
class FilterCategoryController extends GetxController
    with GetSingleTickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();

  TextEditingController searchoneController = TextEditingController();

  Rx<FilterCategoryModel> filterCategoryModelObj = FilterCategoryModel().obs;

  late TabController tabviewController = Get.put(
    TabController(vsync: this, length: 3),
  );

  Rx<TwentyTabModel> twentyTabModelObj = TwentyTabModel().obs;

  @override
  void onClose() {
    super.onClose();
    searchController.dispose();
    searchoneController.dispose();
  }
}
