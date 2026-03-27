// TODO Implement this library.
import 'package:ctluser/data/model/selectionPopupModel/selection_popup_model.dart';
import '../../../core/app_export.dart';
import '../models/login_two_model.dart';

/// A controller class for the LoginTwoScreen.
///
/// This class manages the state of the LoginTwoScreen, including the
/// current loginTwoModelObj
class LoginTwoController extends GetxController {
  Rx<LoginTwoModel> loginTwoModelObj = LoginTwoModel().obs;

  SelectionPopupModel? selectedDropDownValue;

  onSelected(dynamic value) {
    for (var element in loginTwoModelObj.value.dropdownItemList.value) {
      element.isSelected = false;
      if (element.id == value.id) {
        element.isSelected = true;
      }
    }
    loginTwoModelObj.value.dropdownItemList.refresh();
  }
}
