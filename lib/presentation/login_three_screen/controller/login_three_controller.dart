// TODO Implement this library.
import 'package:ctluser/data/model/selectionPopupModel/selection_popup_model.dart';
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/login_three_initial_model.dart';
import '../models/login_three_model.dart';

/// A controller class for the LoginThreeScreen.
///
/// This class manages the state of the LoginThreeScreen, including the
/// current loginThreeModelObj
class LoginThreeController extends GetxController {
  Rx<LoginThreeModel> loginThreeModelObj = LoginThreeModel().obs;

  Rx<LoginThreeInitialModel> loginThreeInitialModelObj =
      LoginThreeInitialModel().obs;

  SelectionPopupModel? selectedDropDownValue;

  onSelected(dynamic value) {
    for (var element
        in loginThreeInitialModelObj.value.dropdownItemList.value) {
      element.isSelected = false;
      if (element.id == value.id) {
        element.isSelected = true;
      }
    }
    loginThreeInitialModelObj.value.dropdownItemList.refresh();
  }
}
