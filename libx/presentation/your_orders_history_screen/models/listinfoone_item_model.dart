// TODO Implement this library.
import '../../../core/app_export.dart';

/// This class is used in the [listinfoone_item_widget] screen.

// ignore_for_file: must_be_immutable
class ListinfooneItemModel {
  ListinfooneItemModel({
    this.infoone,
    this.infothree,
    this.duration,
    this.drinkOne,
    this.namemarket,
    this.infooneOne,
    this.price,
    this.itemsCounter,
    this.id,
  }) {
    infoone = infoone ?? Rx("lbl_drink".tr);
    infothree = infothree ?? Rx("lbl_completed".tr);
    duration = duration ?? Rx("msg_tuesday_03_march".tr);
    drinkOne = drinkOne ?? Rx(ImageConstant.imgImportImage8);
    namemarket = namemarket ?? Rx("lbl_starbucks".tr);
    infooneOne = infooneOne ?? Rx("msg_8700_beverly_ca".tr);
    price = price ?? Rx("lbl_40".tr);
    itemsCounter = itemsCounter ?? Rx("lbl_2_items".tr);
    id = id ?? Rx("");
  }

  Rx<String>? infoone;

  Rx<String>? infothree;

  Rx<String>? duration;

  Rx<String>? drinkOne;

  Rx<String>? namemarket;

  Rx<String>? infooneOne;

  Rx<String>? price;

  Rx<String>? itemsCounter;

  Rx<String>? id;
}
