import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/items_item_model.dart';
import '../models/login_seven_model.dart';

/// A controller class for the LoginSevenScreen.
///
/// This class manages the state of the LoginSevenScreen, including the
/// current loginSevenModelObj
class LoginSevenController extends GetxController {
  Rx<LoginSevenModel> loginSevenModelObj = LoginSevenModel().obs;

  void decrementQuantity(ItemsItemModel itemsItemModelObj) {
    if (itemsItemModelObj.lblQuantity!.value != null) {
      if (itemsItemModelObj.lblQuantity!.value > 1) {
        itemsItemModelObj.lblQuantity!.value--;
      }
    }
  }

  void incrementQuantity(ItemsItemModel itemsItemModelObj) {
    if (itemsItemModelObj.lblQuantity!.value != null) {
      itemsItemModelObj.lblQuantity!.value++;
    }
  }
}
