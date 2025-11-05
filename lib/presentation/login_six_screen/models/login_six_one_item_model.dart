// TODO Implement this library.
import '../../../core/app_export.dart';

/// This class is used in the [login_six_one_item_widget] screen.

// ignore_for_file: must_be_immutable
class LoginSixOneItemModel {
  LoginSixOneItemModel({this.frame, this.id}) {
    frame = frame ?? Rx("lbl_s".tr);
    id = id ?? Rx("");
  }

  Rx<String>? frame;

  Rx<String>? id;
}
