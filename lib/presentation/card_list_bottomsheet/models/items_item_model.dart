// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';

/// This class is used in the [items_item_widget] screen.

// ignore_for_file: must_be_immutable
class ItemsItemModel {
  ItemsItemModel({
    this.visaOne,
    this.placeholder,
    this.placeholderoneController,
    this.id,
  }) {
    visaOne = visaOne ?? Rx(ImageConstant.imgLogoPayment);
    placeholder = placeholder ?? Rx("lbl_visa".tr);
    placeholderoneController =
        placeholderoneController ?? TextEditingController();
    id = id ?? Rx("");
  }

  Rx<String>? visaOne;

  Rx<String>? placeholder;

  TextEditingController? placeholderoneController;

  Rx<String>? id;
}
