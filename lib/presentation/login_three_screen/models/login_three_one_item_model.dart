// TODO Implement this library.
import '../../../core/app_export.dart';

/// This class is used in the [login_three_one_item_widget] screen.

// ignore_for_file: must_be_immutable
class LoginThreeOneItemModel {
  LoginThreeOneItemModel({this.restaurantsOne, this.hanoivietnam, this.id}) {
    restaurantsOne = restaurantsOne ?? Rx(ImageConstant.imgFlashlight);
    hanoivietnam = hanoivietnam ?? Rx("lbl_restaurants".tr);
    id = id ?? Rx("");
  }

  Rx<String>? restaurantsOne;

  Rx<String>? hanoivietnam;

  Rx<String>? id;
}
