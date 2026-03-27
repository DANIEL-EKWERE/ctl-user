// TODO Implement this library.
import '../../../core/app_export.dart';

/// This class is used in the [timelineclose_item_widget] screen.

// ignore_for_file: must_be_immutable
class TimelinecloseItemModel {
  TimelinecloseItemModel({
    this.closeOne,
    this.nameOne,
    this.infooneTwo,
    this.time,
    this.id,
  }) {
    closeOne = closeOne ?? Rx(ImageConstant.imgClosePrimary);
    nameOne = nameOne ?? Rx("msg_burger_king_1453".tr);
    infooneTwo = infooneTwo ?? Rx("lbl_restaurant".tr);
    time = time ?? Rx("lbl_13_00_pm".tr);
    id = id ?? Rx("");
  }

  Rx<String>? closeOne;

  Rx<String>? nameOne;

  Rx<String>? infooneTwo;

  Rx<String>? time;

  Rx<String>? id;
}
