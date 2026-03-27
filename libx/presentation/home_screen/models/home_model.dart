// TODO Implement this library.
import '../../../core/app_export.dart';
import 'home_screen_one_item_model.dart';

/// This class defines the variables used in the [home_screen],
/// and is typically used to hold data that is passed between different parts of the application.

// ignore_for_file: must_be_immutable
class HomeModel {
  Rx<List<HomeScreenOneItemModel>> homeScreenOneItemList = Rx([
    HomeScreenOneItemModel(
      image: ImageConstant.imgGroup35601.obs,
      prismar: "msg_prismar_international".tr.obs,
      afahaoffot: "msg_afaha_offot_abak".tr.obs,
    ),
    HomeScreenOneItemModel(
      image: ImageConstant.imgAirplane.obs,
      prismar: "msg_akwa_ibom_international".tr.obs,
      afahaoffot: "lbl_uruan".tr.obs,
    ),
    HomeScreenOneItemModel(
      image: ImageConstant.imgAirplane.obs,
      prismar: "lbl_tropicana_mall".tr.obs,
      afahaoffot: "msg_sir_udo_udoma_avenue".tr.obs,
    ),
    HomeScreenOneItemModel(
      image: ImageConstant.imgGroup35601.obs,
      prismar: "msg_prismar_international".tr.obs,
      afahaoffot: "msg_afaha_offot_abak".tr.obs,
    ),
  ]);
}
