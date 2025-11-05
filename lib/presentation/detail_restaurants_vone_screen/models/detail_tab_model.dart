// TODO Implement this library.
import '../../../core/app_export.dart';
import 'listnamemarket_item_model.dart';

/// This class is used in the [detail_tab_page] screen.

// ignore_for_file: must_be_immutable
class DetailTabModel {
  Rx<List<ListnamemarketItemModel>> listnamemarketItemList = Rx([
    ListnamemarketItemModel(
      image: ImageConstant.imgImportImage146x144.obs,
      namemarket: "msg_extreme_cheese_whopper".tr.obs,
      price: "lbl_5_99".tr.obs,
      infoone: "lbl_burger".tr.obs,
    ),
    ListnamemarketItemModel(
      image: ImageConstant.imgImportImage3.obs,
      namemarket: "msg_singles_bbq_bacon".tr.obs,
      price: "lbl_7_99".tr.obs,
      infoone: "lbl_burger".tr.obs,
    ),
    ListnamemarketItemModel(
      image: ImageConstant.imgImportImage4.obs,
      namemarket: "msg_potato_chip_burrger".tr.obs,
      price: "lbl_3_99".tr.obs,
      infoone: "lbl_coffee".tr.obs,
    ),
  ]);

  Rx<String>? hotcoffeesOne = Rx("msg_hot_burger_combo".tr);
}
