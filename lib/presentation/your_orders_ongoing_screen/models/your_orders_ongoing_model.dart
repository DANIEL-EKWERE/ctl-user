// TODO Implement this library.
import '../../../core/app_export.dart';
import 'timelineclose_item_model.dart';

/// This class defines the variables used in the [your_orders_ongoing_screen],
/// and is typically used to hold data that is passed between different parts of the application.

// ignore_for_file: must_be_immutable
class YourOrdersOngoingModel {
  Rx<List<TimelinecloseItemModel>> timelinecloseItemList = Rx([
    TimelinecloseItemModel(
      closeOne: ImageConstant.imgClosePrimary.obs,
      nameOne: "msg_burger_king_1453".tr.obs,
      infooneTwo: "lbl_restaurant".tr.obs,
      time: "lbl_13_00_pm".tr.obs,
    ),
    TimelinecloseItemModel(
      closeOne: ImageConstant.imgLinkedinPrimary.obs,
      nameOne: "msg_you_49th_st_los".tr.obs,
      infooneTwo: "lbl_home".tr.obs,
      time: "lbl_13_30_pm".tr.obs,
    ),
  ]);
}
