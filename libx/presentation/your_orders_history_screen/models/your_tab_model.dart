// TODO Implement this library.
import '../../../core/app_export.dart';
import 'listinfoone_item_model.dart';

/// This class is used in the [your_tab_page] screen.

// ignore_for_file: must_be_immutable
class YourTabModel {
  Rx<List<ListinfooneItemModel>> listinfooneItemList = Rx([
    ListinfooneItemModel(
      infoone: "lbl_drink".tr.obs,
      infothree: "lbl_completed".tr.obs,
      duration: "msg_tuesday_03_march".tr.obs,
      drinkOne: ImageConstant.imgImportImage8.obs,
      namemarket: "lbl_starbucks".tr.obs,
      infooneOne: "msg_8700_beverly_ca".tr.obs,
      price: "lbl_40".tr.obs,
      itemsCounter: "lbl_2_items".tr.obs,
    ),
    ListinfooneItemModel(
      infoone: "lbl_food".tr.obs,
      infothree: "lbl_completed".tr.obs,
      duration: "msg_tuesday_03_march".tr.obs,
      drinkOne: ImageConstant.imgImportImage9.obs,
      namemarket: "lbl_burger_king".tr.obs,
      infooneOne: "msg_8700_beverly_ca".tr.obs,
      price: "lbl_40".tr.obs,
      itemsCounter: "lbl_2_items".tr.obs,
    ),
    ListinfooneItemModel(),
  ]);
}
