// TODO Implement this library.
import 'package:ctluser/data/model/selectionPopupModel/selection_popup_model.dart';

import '../../../core/app_export.dart';

import 'login_three_one_item_model.dart';

/// This class is used in the [login_three_initial_page] screen.

// ignore_for_file: must_be_immutable
class LoginThreeInitialModel {
  Rx<List<SelectionPopupModel>> dropdownItemList = Rx([
    SelectionPopupModel(id: 1, title: "Item One", isSelected: true),
    SelectionPopupModel(id: 2, title: "Item Two"),
    SelectionPopupModel(id: 3, title: "Item Three"),
  ]);

  Rx<List<LoginThreeOneItemModel>> loginThreeOneItemList = Rx([
    LoginThreeOneItemModel(
      restaurantsOne: ImageConstant.imgFlashlight.obs,
      hanoivietnam: "lbl_restaurants".tr.obs,
    ),
    LoginThreeOneItemModel(
      restaurantsOne: ImageConstant.imgTrophy.obs,
      hanoivietnam: "lbl_shops".tr.obs,
    ),
    LoginThreeOneItemModel(
      restaurantsOne: ImageConstant.imgGroup36052.obs,
      hanoivietnam: "lbl_pharmacies".tr.obs,
    ),
  ]);
}
