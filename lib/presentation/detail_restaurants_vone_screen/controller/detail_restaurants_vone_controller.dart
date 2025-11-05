// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/detail_restaurants_vone_model.dart';
import '../models/detail_tab_model.dart';

/// A controller class for the DetailRestaurantsVoneScreen.
///
/// This class manages the state of the DetailRestaurantsVoneScreen, including the
/// current detailRestaurantsVoneModelObj
class DetailRestaurantsVoneController extends GetxController
    with GetSingleTickerProviderStateMixin {
  Rx<DetailRestaurantsVoneModel> detailRestaurantsVoneModelObj =
      DetailRestaurantsVoneModel().obs;

  late TabController tabviewController = Get.put(
    TabController(vsync: this, length: 2),
  );

  Rx<DetailTabModel> detailTabModelObj = DetailTabModel().obs;
}
