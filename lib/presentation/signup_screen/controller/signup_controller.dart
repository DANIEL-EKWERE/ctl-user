// TODO Implement this library.
import 'package:ctluser/data/apiClient/apiClient.dart';
import 'package:ctluser/data/model/selectionPopupModel/selection_popup_model.dart';
import 'package:ctluser/presentation/signup_screen/models/country_model.dart';
import 'package:flutter/material.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:overlay_kit/overlay_kit.dart';
import '../../../core/app_export.dart';
import '../models/signup_model.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'dart:developer' as myLog;

/// A controller class for the SignupScreen.
///
/// This class manages the state of the SignupScreen, including the
/// current signupModelObj
class SignupController extends GetxController {
  TextEditingController nameController = TextEditingController();

  TextEditingController lastNameController = TextEditingController();

  TextEditingController phoneNumberController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmpasswordController = TextEditingController();

  Rx<SignupModel> signupModelObj = SignupModel().obs;

  Rx<Country> selectedCountry =
      CountryPickerUtils.getCountryByPhoneCode('234').obs;

  Rx<bool> agreetoone = false.obs;
  Rx<bool> obscurePassword = true.obs;
  Rx<bool> obscurePassword1 = true.obs;

  ApiClient _apiService = ApiClient(Duration(seconds: 60 * 5));
  CountryData? selectedCountryx;
  RxBool isCountryLoading = false.obs;
  String? selectedCountry1;
  int? selectedCountryId;

  List<String> countries = [];
  CountryModel countryModel = CountryModel();
  CountryData selectedCountryData = CountryData();

  List<CountryData> countryDataList = [];

  SelectionPopupModel? selectedDropDownValue;

  @override
  void onClose() {
    super.onClose();
    nameController.dispose();
    lastNameController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmpasswordController.dispose();
  }

  @override
  void onInit() {
    super.onInit();
    fetchCountries();
  }

  fetchCountries() async {
    isCountryLoading.value = true;

    final response = await _apiService.fetchCountry();
    if (response.statusCode == 200 || response.statusCode == 201) {
      countryModel = countryModelFromJson(response.body);
      countries = countryModel.data!.map((e) => e.name!).toList();
      countryDataList = countryModel.data!;
      isCountryLoading.value = false;
      myLog.log(
        'Countries fetched successfully: ${countries.length} countries loaded.',
      );
      myLog.log('Countries: ${countries.join(', ')}');
    } else {
      isCountryLoading.value = false;
      Get.snackbar(
        'Error',
        'Failed to load countries: ${response.body}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  onSelected(dynamic value) {
    for (var element in signupModelObj.value.dropdownItemList.value) {
      element.isSelected = false;
      if (element.id == value.id) {
        element.isSelected = true;
      }
    }
    signupModelObj.value.dropdownItemList.refresh();
  }

  // void signup() {
  //   myLog.log(nameController.text);
  //   myLog.log(lastNameController.text);

  //   myLog.log(phoneNumberController.text);
  //   myLog.log(emailController.text);
  //   myLog.log(passwordController.text);
  //   myLog.log(confirmpasswordController.text);
  //   myLog.log(selectedCountry.value.name.toString());
  // }

  void processSignUp() {
    // Implement your sign-up logic here
    // For example, you can call an API to create a new account
    // and handle the response accordingly.
    //OverlayLoadingProgress.start(circularProgressColor: Color(0xFF004DBF));
    apiClient.onboarding_signup(
      nameController.text,
      lastNameController.text,
      emailController.text,
      phoneNumberController.text,
      passwordController.text,
      int.parse(selectedCountryId.toString()),
    );
    // OverlayLoadingProgress.stop();
  }

  final Rx<PhoneNumber> phoneNumber = PhoneNumber(isoCode: 'NG').obs;
  final RxString errorMessage = ''.obs;
  final RxBool isValid = false.obs;

  // void validatePhoneNumber() async {
  //   try {
  //     // getParsableNumber returns String?, not bool?
  //     String? parsableNumber = await PhoneNumber.getParsableNumber(phoneNumberController.text);

  //     if (parsableNumber != null && parsableNumber.isNotEmpty) {
  //       isValid.value = true;
  //       errorMessage.value = '';
  //     } else {
  //       isValid.value = false;
  //       errorMessage.value = 'Invalid phone number';
  //     }
  //   } catch (e) {
  //     isValid.value = false;
  //     errorMessage.value = 'Invalid phone number';
  //     print('Validation error: $e');
  //   }
  // }
}
