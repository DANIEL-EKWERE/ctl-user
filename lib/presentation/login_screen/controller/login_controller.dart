// TODO Implement this library.
import 'dart:convert';
import 'dart:developer' as myLog;
import 'package:ctluser/data/apiClient/apiClient.dart';
import 'package:ctluser/presentation/otp_screen/controller/otp_controller.dart';
import 'package:ctluser/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:overlay_kit/overlay_kit.dart';
import '../../../core/app_export.dart';
import '../models/login_model.dart';

/// A controller class for the LoginScreen.
///
/// This class manages the state of the LoginScreen, including the
/// current loginModelObj
class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();

  //TextEditingController visibleoneController = TextEditingController();

  Rx<LoginModel> loginModelObj = LoginModel().obs;

  Rx<bool> isShowPassword = true.obs;

  Rx<bool> keepmeloginone = false.obs;

  @override
  void onClose() {
    super.onClose();
    emailController.dispose();
    passwordController.dispose();
  }

  //final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  RxBool isButtonEnabled = false.obs;

  OtpController controller = Get.put(OtpController());

  RxBool isLoading = false.obs;
  // bool get isLoading => _isLoading;

  LoginModel loginModel = LoginModel(
    status: true,
    message: '',
    data: LoginData(),
  );
  LoginData data = LoginData();

  // set isLoading(bool value) {
  //   _isLoading = value;
  //   update();
  // }

  ApiClient _apiService = ApiClient(Duration(seconds: 60 * 5));

  Future<void> login() async {
    // if (!_formKey.currentState!.validate()) {
    //   return;
    // }
    myLog.log(emailController.text);
    myLog.log(passwordController.text);

    // Save context early before any async operations
    final BuildContext? context = Get.context;

    OverlayLoadingProgress.start(circularProgressColor: Color(0xff004BFD));
    isLoading.value = true;

    try {
      final response = await _apiService.login({
        'email': emailController.text,
        'password': passwordController.text,
      });

      isLoading.value = false;
      OverlayLoadingProgress.stop();

      if (response.statusCode == 200 || response.statusCode == 201) {
        loginModel = loginModelFromJson(response.body);
        data = loginModel.data!;

        if (!data.emailVerified!) {
          //await dataBase.saveEmail(email);

          Get.toNamed(
            AppRoutes.otpScreen,
            arguments: {
              'email': emailController.text,
              // 'password': password,
            },
          );

          emailController.clear();
          passwordController.clear();
          return;
        }

        // Save token and user data to shared preferences
        await dataBase.saveToken(data.token ?? 'N/A');
        await dataBase.saveUserId((data.id!.toInt()).toString());
        await dataBase.saveFirstName(data.firstname ?? 'N/A');
        await dataBase.saveLastName(data.lastname ?? 'N/A');
        await dataBase.saveFullName(data.name ?? 'N/A');
        await dataBase.saveEmail(data.email ?? 'N/A');
        await dataBase.savePhoneNumber(data.phoneNumber ?? 'N/A');
        await dataBase.saveRole(data.role ?? 'N/A');
        await dataBase.saveReferalCode(data.referralCode ?? 'N/A');
        await dataBase.saveReferalCount(
          data.referralCount?.toString() ?? 'N/A',
        );
        await dataBase.saveRefererId(data.referrerId?.toString() ?? 'N/A');
        await dataBase.saveVendorId(data.vendor?.id.toString() ?? 'N/A');
        await dataBase.saveCategoryId(
          data.vendor?.category?.id.toString() ?? 'N/A',
        );
        await dataBase.saveCompanyId(
          //data.contactAddress?.first.id.toString() ?? 'N/A',
          data.vendor?.locations?.first.id.toString() ?? '0',
        );

        //TODO: save vendor details

        // await dataBase.saveVendor(data.vendor?.toJson() ?? {});
        // await dataBase.saveLocations(data.vendor?.locations ?? []);
        // await dataBase.saveVendorCategory(data.vendor?.category?.toJson() ?? {});
        // await dataBase.saveVendorPlan(data.vendor?.plan?.toJson() ?? {});
        // await dataBase.saveVehicles(data.vendor?.vehicles ?? []);
        //TODO: done saving vendor details
        // myLog.log(data.bankAccount.toString());
        // await dataBase.saveBankName(data.bankAccount!.bankName);
        // await dataBase.saveAcctName(data.bankAccount!.accountName);
        // await dataBase.saveAcctNumber(data.bankAccount!.accountNumber);
        // await dataBase.saveBrmName(data.bankAccount!.bankCode);
        // await dataBase.saveBrmPhone(data.bankAccount!.bankId.toString());
        // await dataBase.saveLogo(data.vendor!.logo!);
        // await dataBase.saveBanner(data.vendor!.banner!);
        emailController.clear();
        passwordController.clear();

        // Use Get.snackbar instead of ScaffoldMessenger
        Get.snackbar(
          'Success',
          loginModel.message ?? 'Login successful',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );

        // Navigate to dashboard
        Get.offAllNamed(AppRoutes.loginThreeScreen);
      } else if (response.statusCode == 400) {
        // Handle unauthorized response'

        var responseData = jsonDecode(response.body);
        if (responseData['errors']['scalar'] == 422) {
          Get.snackbar(
            'Error',
            responseData['message'] ?? 'Login failed',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: Duration(seconds: 6),
          );
        } else {
          controller.resendOtp({'email': emailController.text});
          Get.toNamed(
            '/email-verification',
            arguments: {
              'email': emailController.text,
              // 'password': password,
            },
          );
        }
        emailController.clear();
        passwordController.clear();
      } else if (response.statusCode == 422) {
        var responseData = jsonDecode(response.body);
        String errorMessage = responseData['message'] ?? 'Login failed';
        String errorMessage1 = responseData['error']['email'] ?? 'Login failed';
        myLog.log('Login error: $errorMessage1');
        myLog.log('Login error: $errorMessage');
      } else {
        // Handle error response
        var errorData = jsonDecode(response.body);
        String errorMessage = errorData['message'] ?? 'Login failed';

        Get.snackbar(
          'Error',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
        return;
      }
    } catch (e) {
      isLoading.value = false;
      OverlayLoadingProgress.stop();

      myLog.log('Login error: ${e.toString()}');

      // Use Get.snackbar instead of ScaffoldMessenger
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
      OverlayLoadingProgress.stop();
    }
  }
}
