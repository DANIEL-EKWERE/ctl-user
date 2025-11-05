// TODO Implement this library.
import '../../../core/app_export.dart';

/// This class is used in the [items_item_widget] screen.

// ignore_for_file: must_be_immutable
class ItemsItemModel {
  ItemsItemModel({
    this.imageOne,
    this.name,
    this.price,
    this.lblQuantity,
    this.id,
  }) {
    imageOne = imageOne ?? Rx(ImageConstant.imgPngwing1);
    name = name ?? Rx("msg_prime_beef_pizza".tr);
    price = price ?? Rx("lbl_20_99".tr);
    lblQuantity = lblQuantity ?? Rx(1);
    id = id ?? Rx("");
  }

  Rx<String>? imageOne;

  Rx<String>? name;

  Rx<String>? price;

  Rx<int>? lblQuantity;

  Rx<String>? id;
}
