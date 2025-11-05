// TODO Implement this library.
import '../../../core/app_export.dart';
import 'items_item_model.dart';

/// This class defines the variables used in the [card_list_bottomsheet],
/// and is typically used to hold data that is passed between different parts of the application.

// ignore_for_file: must_be_immutable
class CardListModel {
  Rx<List<ItemsItemModel>> itemsItemList = Rx([
    ItemsItemModel(
      visaOne: ImageConstant.imgLogoPayment.obs,
      placeholder: "lbl_visa".tr.obs,
    ),
    ItemsItemModel(
      visaOne: ImageConstant.imgLogoPayment32x32.obs,
      placeholder: "lbl_mastercard".tr.obs,
    ),
    ItemsItemModel(
      visaOne: ImageConstant.imgLogoPayment1.obs,
      placeholder: "lbl_paypal".tr.obs,
    ),
  ]);
}
