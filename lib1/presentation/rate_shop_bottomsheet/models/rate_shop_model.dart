// TODO Implement this library.
import '../../../core/app_export.dart';
import 'chipviewlabel_item_model.dart';

/// This class defines the variables used in the [rate_shop_bottomsheet],
/// and is typically used to hold data that is passed between different parts of the application.

// ignore_for_file: must_be_immutable
class RateShopModel {
  Rx<List<ChipviewlabelItemModel>> chipviewlabelItemList = Rx([
    ChipviewlabelItemModel(labelFour: "lbl_clean".tr.obs),
    ChipviewlabelItemModel(labelFour: "lbl_good_package".tr.obs),
    ChipviewlabelItemModel(labelFour: "lbl_pair_price".tr.obs),
    ChipviewlabelItemModel(labelFour: "lbl_good_food".tr.obs),
  ]);
}
