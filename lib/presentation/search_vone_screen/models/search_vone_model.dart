// TODO Implement this library.
import '../../../core/app_export.dart';
import 'listburger_king_item_model.dart';

/// This class defines the variables used in the [search_vone_screen],
/// and is typically used to hold data that is passed between different parts of the application.

// ignore_for_file: must_be_immutable
class SearchVoneModel {
  Rx<List<ListburgerKingItemModel>> listburgerKingItemList = Rx([
    ListburgerKingItemModel(
      burgerKingOne: ImageConstant.imgImportImage10.obs,
      name: "lbl_burger_king".tr.obs,
      usdCounter: "lbl_2_5_usd".tr.obs,
      food: "lbl_food".tr.obs,
    ),
    ListburgerKingItemModel(
      burgerKingOne: ImageConstant.imgImportImage11.obs,
      name: "lbl_burger_king".tr.obs,
      usdCounter: "lbl_2_5_usd".tr.obs,
      food: "lbl_food".tr.obs,
    ),
    ListburgerKingItemModel(
      burgerKingOne: ImageConstant.imgImportImage12.obs,
      name: "lbl_burger_king".tr.obs,
      usdCounter: "lbl_2_5_usd".tr.obs,
      food: "lbl_food".tr.obs,
    ),
    ListburgerKingItemModel(
      burgerKingOne: ImageConstant.imgImportImage13.obs,
      name: "lbl_burger_king".tr.obs,
      usdCounter: "lbl_2_5_usd".tr.obs,
      food: "lbl_food".tr.obs,
    ),
    ListburgerKingItemModel(
      burgerKingOne: ImageConstant.imgImportImage14.obs,
      name: "lbl_burger_king".tr.obs,
      usdCounter: "lbl_2_5_usd".tr.obs,
      food: "lbl_food".tr.obs,
    ),
    ListburgerKingItemModel(
      burgerKingOne: ImageConstant.imgImportImage15.obs,
      name: "lbl_burger_king".tr.obs,
      usdCounter: "lbl_2_5_usd".tr.obs,
      food: "lbl_food".tr.obs,
    ),
  ]);
}
