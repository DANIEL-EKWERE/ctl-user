// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/your_orders_history_model.dart';
import '../models/your_tab_model.dart';

/// A controller class for the YourOrdersHistoryScreen.
///
/// This class manages the state of the YourOrdersHistoryScreen, including the
/// current yourOrdersHistoryModelObj
class YourOrdersHistoryController extends GetxController
    with GetSingleTickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();

  Rx<YourOrdersHistoryModel> yourOrdersHistoryModelObj =
      YourOrdersHistoryModel().obs;

  late TabController tabviewController = Get.put(
    TabController(vsync: this, length: 2),
  );

  Rx<YourTabModel> yourTabModelObj = YourTabModel().obs;

  @override
  void onClose() {
    super.onClose();
    searchController.dispose();
  }
}
