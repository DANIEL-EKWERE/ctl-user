import '../../../core/app_export.dart';
import 'items_one_item_model.dart';

/// This class is used in the [twenty_tab_page] screen.

// ignore_for_file: must_be_immutable
class TwentyTabModel {
  Rx<List<ItemsOneItemModel>> itemsOneItemList = Rx([
    ItemsOneItemModel(
      sandwichOne: ImageConstant.imgGroup5.obs,
      namecategory: "lbl_sandwich".tr.obs,
    ),
    ItemsOneItemModel(
      sandwichOne: ImageConstant.imgGroup5Primary.obs,
      namecategory: "lbl_burgers".tr.obs,
    ),
    ItemsOneItemModel(namecategory: "lbl_pizza".tr.obs),
  ]);
}
