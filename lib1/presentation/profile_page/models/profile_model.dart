// TODO Implement this library.
import '../../../core/app_export.dart';
import 'listaccount_item_model.dart';

/// This class defines the variables used in the [profile_page],
/// and is typically used to hold data that is passed between different parts of the application.

// ignore_for_file: must_be_immutable
class ProfileModel {
  Rx<List<ListaccountItemModel>> listaccountItemList = Rx([
    ListaccountItemModel(
      account: ImageConstant.imgLockGray400.obs,
      placeholder: "msg_account_information".tr.obs,
      placeholderOne: "msg_change_your_account".tr.obs,
    ),
    ListaccountItemModel(
      account: ImageConstant.imgLocation.obs,
      placeholder: "lbl_password".tr.obs,
      placeholderOne: "msg_change_your_password".tr.obs,
    ),
    ListaccountItemModel(
      account: ImageConstant.imgIconFinance.obs,
      placeholder: "lbl_payment_methods".tr.obs,
      placeholderOne: "msg_add_your_credit".tr.obs,
    ),
    ListaccountItemModel(
      account: ImageConstant.imgLinkedin.obs,
      placeholder: "msg_delivery_locations".tr.obs,
      placeholderOne: "msg_change_your_delivery".tr.obs,
    ),
    ListaccountItemModel(
      account: ImageConstant.imgIconSocialC.obs,
      placeholder: "msg_invite_your_friends".tr.obs,
      placeholderOne: "msg_get_59_for_each".tr.obs,
    ),
  ]);
}
