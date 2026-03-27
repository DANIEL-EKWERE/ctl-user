// TODO Implement this library.
import '../../../core/app_export.dart';

/// This class is used in the [listaccount_item_widget] screen.

// ignore_for_file: must_be_immutable
class ListaccountItemModel {
  ListaccountItemModel({
    this.account,
    this.placeholder,
    this.placeholderOne,
    this.id,
  }) {
    account = account ?? Rx(ImageConstant.imgLockGray400);
    placeholder = placeholder ?? Rx("msg_account_information".tr);
    placeholderOne = placeholderOne ?? Rx("msg_change_your_account".tr);
    id = id ?? Rx("");
  }

  Rx<String>? account;

  Rx<String>? placeholder;

  Rx<String>? placeholderOne;

  Rx<String>? id;
}
