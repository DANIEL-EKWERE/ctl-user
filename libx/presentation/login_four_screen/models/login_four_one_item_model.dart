// TODO Implement this library.
import '../../../core/app_export.dart';

/// This class is used in the [login_four_one_item_widget] screen.

// ignore_for_file: must_be_immutable
class LoginFourOneItemModel {
  LoginFourOneItemModel({this.namemarket, this.id}) {
    namemarket = namemarket ?? Rx("msg_extreme_cheese_whopper".tr);
    id = id ?? Rx("");
  }

  Rx<String>? namemarket;

  Rx<String>? id;
}
