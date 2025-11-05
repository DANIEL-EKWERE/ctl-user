// TODO Implement this library.
import '../../../core/app_export.dart';

/// This class is used in the [listnamemarket_item_widget] screen.

// ignore_for_file: must_be_immutable
class ListnamemarketItemModel {
  ListnamemarketItemModel({
    this.image,
    this.namemarket,
    this.price,
    this.infoone,
    this.id,
  }) {
    image = image ?? Rx(ImageConstant.imgImportImage146x144);
    namemarket = namemarket ?? Rx("msg_extreme_cheese_whopper".tr);
    price = price ?? Rx("lbl_5_99".tr);
    infoone = infoone ?? Rx("lbl_burger".tr);
    id = id ?? Rx("");
  }

  Rx<String>? image;

  Rx<String>? namemarket;

  Rx<String>? price;

  Rx<String>? infoone;

  Rx<String>? id;
}
