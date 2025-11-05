import '../../../core/app_export.dart';

/// This class is used in the [listburger_king_item_widget] screen.

// ignore_for_file: must_be_immutable
class ListburgerKingItemModel {
  ListburgerKingItemModel({
    this.burgerKingOne,
    this.name,
    this.usdCounter,
    this.food,
    this.id,
  }) {
    burgerKingOne = burgerKingOne ?? Rx(ImageConstant.imgImportImage10);
    name = name ?? Rx("lbl_burger_king".tr);
    usdCounter = usdCounter ?? Rx("lbl_2_5_usd".tr);
    food = food ?? Rx("lbl_food".tr);
    id = id ?? Rx("");
  }

  Rx<String>? burgerKingOne;

  Rx<String>? name;

  Rx<String>? usdCounter;

  Rx<String>? food;

  Rx<String>? id;
}
