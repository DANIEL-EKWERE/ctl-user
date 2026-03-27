// TODO Implement this library.
import '../../../core/app_export.dart';
import 'listtoday16fort_item_model.dart';

/// This class defines the variables used in the [detail_restaurants_review_vone_screen],
/// and is typically used to hold data that is passed between different parts of the application.

// ignore_for_file: must_be_immutable
class DetailRestaurantsReviewVoneModel {
  Rx<List<Listtoday16fortItemModel>> listtoday16fortItemList = Rx([
    Listtoday16fortItemModel(
      today16forty: ImageConstant.imgImage.obs,
      name: "lbl_eleanor_summers".tr.obs,
      duration: "lbl_today_16_40".tr.obs,
      whatcanisayitsf: "msg_what_can_i_say_it_s".tr.obs,
      likesCounter: "lbl_68_likes".tr.obs,
    ),
    Listtoday16fortItemModel(
      today16forty: ImageConstant.imgImage.obs,
      name: "lbl_laura_smith".tr.obs,
      duration: "msg_yesterday_16_40".tr.obs,
      whatcanisayitsf: "msg_amazing_food_lots".tr.obs,
      likesCounter: "lbl_32_likes".tr.obs,
    ),
    Listtoday16fortItemModel(
      name: "lbl_dora_perry".tr.obs,
      duration: "msg_yesterday_16_40".tr.obs,
      whatcanisayitsf: "msg_i_popped_in_for".tr.obs,
      likesCounter: "lbl_99_likes".tr.obs,
    ),
    Listtoday16fortItemModel(),
  ]);
}
