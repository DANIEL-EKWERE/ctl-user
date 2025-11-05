import '../../../core/app_export.dart';
import 'listplaceholder_item_model.dart';

/// This class defines the variables used in the [payment_methods_card_bottomsheet],
/// and is typically used to hold data that is passed between different parts of the application.

// ignore_for_file: must_be_immutable
class PaymentMethodsCardModel {
  Rx<List<ListplaceholderItemModel>> listplaceholderItemList = Rx([
    ListplaceholderItemModel(
      image: ImageConstant.imgLogoPayment.obs,
      placeholder: "msg_4086148238059709".tr.obs,
      placeholderOne: "lbl_default_payment".tr.obs,
    ),
    ListplaceholderItemModel(
      image: ImageConstant.imgLogoPayment32x32.obs,
      placeholder: "msg_5314098616607150".tr.obs,
      placeholderOne: "lbl_not_default".tr.obs,
    ),
  ]);
}
