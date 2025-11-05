// TODO Implement this library.
import '../../../core/app_export.dart';

/// This class is used in the [home_screen_one_item_widget] screen.

// ignore_for_file: must_be_immutable
class HomeScreenOneItemModel {
  HomeScreenOneItemModel({this.image, this.prismar, this.afahaoffot, this.id}) {
    image = image ?? Rx(ImageConstant.imgGroup35601);
    prismar = prismar ?? Rx("msg_prismar_international".tr);
    afahaoffot = afahaoffot ?? Rx("msg_afaha_offot_abak".tr);
    id = id ?? Rx("");
  }

  Rx<String>? image;

  Rx<String>? prismar;

  Rx<String>? afahaoffot;

  Rx<String>? id;
}
