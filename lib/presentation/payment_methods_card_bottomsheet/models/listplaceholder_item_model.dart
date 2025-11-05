// TODO Implement this library.
import '../../../core/app_export.dart';

/// This class is used in the [listplaceholder_item_widget] screen.

// ignore_for_file: must_be_immutable
class ListplaceholderItemModel {
  ListplaceholderItemModel({
    this.image,
    this.placeholder,
    this.placeholderOne,
    this.id,
  }) {
    image = image ?? Rx(ImageConstant.imgLogoPayment);
    placeholder = placeholder ?? Rx("msg_4086148238059709".tr);
    placeholderOne = placeholderOne ?? Rx("lbl_default_payment".tr);
    id = id ?? Rx("");
  }

  Rx<String>? image;

  Rx<String>? placeholder;

  Rx<String>? placeholderOne;

  Rx<String>? id;
}
