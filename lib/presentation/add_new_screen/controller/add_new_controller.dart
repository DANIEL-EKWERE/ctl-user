// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/add_new_model.dart';
import '../models/items_item_model.dart';

/// A controller class for the AddNewScreen.
///
/// This class manages the state of the AddNewScreen, including the
/// current addNewModelObj
class AddNewController extends GetxController {
  Rx<AddNewModel> addNewModelObj = AddNewModel().obs;

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
