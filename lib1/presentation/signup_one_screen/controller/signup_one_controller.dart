// TODO Implement this library.
import 'package:ctluser/data/model/selectionPopupModel/selection_popup_model.dart';
import 'package:flutter/material.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/utils/utils.dart';
import '../../../core/app_export.dart';
import '../models/signup_one_model.dart';

/// A controller class for the SignupOneScreen.
///
/// This class manages the state of the SignupOneScreen, including the
/// current signupOneModelObj
class SignupOneController extends GetxController {
  TextEditingController fullnameoneController = TextEditingController();

  TextEditingController fullnamethreeController = TextEditingController();

  TextEditingController phoneNumberController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmpasswordController = TextEditingController();

  Rx<SignupOneModel> signupOneModelObj = SignupOneModel().obs;

  Rx<Country> selectedCountry =
      CountryPickerUtils.getCountryByPhoneCode('234').obs;

  Rx<bool> agreetoone = false.obs;

  SelectionPopupModel? selectedDropDownValue;

  @override
  void onClose() {
    super.onClose();
    fullnameoneController.dispose();
    fullnamethreeController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmpasswordController.dispose();
  }

  onSelected(dynamic value) {
    for (var element in signupOneModelObj.value.dropdownItemList.value) {
      element.isSelected = false;
      if (element.id == value.id) {
        element.isSelected = true;
      }
    }
    signupOneModelObj.value.dropdownItemList.refresh();
  }
}
