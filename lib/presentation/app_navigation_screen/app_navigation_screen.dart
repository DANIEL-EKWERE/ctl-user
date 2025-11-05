// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../account_information_bottomsheet/account_information_bottomsheet.dart';
import '../account_information_bottomsheet/controller/account_information_controller.dart';
import '../best_partners_vone_bottomsheet/best_partners_vone_bottomsheet.dart';
import '../best_partners_vone_bottomsheet/controller/best_partners_vone_controller.dart';
import '../best_partners_vtwo_bottomsheet/best_partners_vtwo_bottomsheet.dart';
import '../best_partners_vtwo_bottomsheet/controller/best_partners_vtwo_controller.dart';
import '../card_list_bottomsheet/card_list_bottomsheet.dart';
import '../card_list_bottomsheet/controller/card_list_controller.dart';
import '../change_password_bottomsheet/change_password_bottomsheet.dart';
import '../change_password_bottomsheet/controller/change_password_controller.dart';
import '../login_eight_bottomsheet/controller/login_eight_controller.dart';
import '../login_eight_bottomsheet/login_eight_bottomsheet.dart';
import '../login_nine_dialog/controller/login_nine_controller.dart';
import '../login_nine_dialog/login_nine_dialog.dart';
import '../payment_methods_bottomsheet/controller/payment_methods_controller.dart';
import '../payment_methods_bottomsheet/payment_methods_bottomsheet.dart';
import '../payment_methods_card_bottomsheet/controller/payment_methods_card_controller.dart';
import '../payment_methods_card_bottomsheet/payment_methods_card_bottomsheet.dart';
import '../rate_drive_bottomsheet/controller/rate_drive_controller.dart';
import '../rate_drive_bottomsheet/rate_drive_bottomsheet.dart';
import '../rate_shop1_dialog/controller/rate_shop1_controller.dart';
import '../rate_shop1_dialog/rate_shop1_dialog.dart';
import '../rate_shop_bottomsheet/controller/rate_shop_controller.dart';
import '../rate_shop_bottomsheet/rate_shop_bottomsheet.dart';
import 'controller/app_navigation_controller.dart'; // ignore_for_file: must_be_immutable

class AppNavigationScreen extends GetWidget<AppNavigationController> {
  const AppNavigationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFFFFFFF),
      body: SafeArea(
        child: SizedBox(
          width: 375.h,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(color: Color(0XFFFFFFFF)),
                child: Column(
                  children: [
                    SizedBox(height: 10.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.h),
                      child: Text(
                        "App Navigation",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0XFF000000),
                          fontSize: 20.fSize,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Padding(
                      padding: EdgeInsets.only(left: 20.h),
                      child: Text(
                        "Check your app's UI from the below demo screens of your app.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0XFF888888),
                          fontSize: 16.fSize,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Divider(
                      height: 1.h,
                      thickness: 1.h,
                      color: Color(0XFF000000),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(color: Color(0XFFFFFFFF)),
                    child: Column(
                      children: [
                        _buildScreenTitle(
                          screenTitle: "Intro Splash",
                          onTapScreenTitle:
                              () =>
                                  onTapScreenTitle(AppRoutes.introSplashScreen),
                        ),
                        _buildScreenTitle(
                          screenTitle: "Splash page One",
                          onTapScreenTitle:
                              () => onTapScreenTitle(
                                AppRoutes.splashPageOneScreen,
                              ),
                        ),
                        _buildScreenTitle(
                          screenTitle: "Splash page Two",
                          onTapScreenTitle:
                              () => onTapScreenTitle(
                                AppRoutes.splashPageTwoScreen,
                              ),
                        ),
                        _buildScreenTitle(
                          screenTitle: "Splash page Three",
                          onTapScreenTitle:
                              () => onTapScreenTitle(
                                AppRoutes.splashPageThreeScreen,
                              ),
                        ),
                        _buildScreenTitle(
                          screenTitle: "Splash page Five",
                          onTapScreenTitle:
                              () => onTapScreenTitle(
                                AppRoutes.splashPageFiveScreen,
                              ),
                        ),
                        _buildScreenTitle(
                          screenTitle: "Signup",
                          onTapScreenTitle:
                              () => onTapScreenTitle(AppRoutes.signupScreen),
                        ),
                        _buildScreenTitle(
                          screenTitle: "Signup One",
                          onTapScreenTitle:
                              () => onTapScreenTitle(AppRoutes.signupOneScreen),
                        ),
                        _buildScreenTitle(
                          screenTitle: "OTP Screen",
                          onTapScreenTitle:
                              () => onTapScreenTitle(AppRoutes.otpScreen),
                        ),
                        _buildScreenTitle(
                          screenTitle: "OTP Verification",
                          onTapScreenTitle:
                              () => onTapScreenTitle(
                                AppRoutes.otpVerificationScreen,
                              ),
                        ),
                        _buildScreenTitle(
                          screenTitle: "Terms of Service",
                          onTapScreenTitle:
                              () => onTapScreenTitle(
                                AppRoutes.termsOfServiceScreen,
                              ),
                        ),
                        _buildScreenTitle(
                          screenTitle: "Privacy policy",
                          onTapScreenTitle:
                              () => onTapScreenTitle(
                                AppRoutes.privacyPolicyScreen,
                              ),
                        ),
                        _buildScreenTitle(
                          screenTitle: "Login",
                          onTapScreenTitle:
                              () => onTapScreenTitle(AppRoutes.loginScreen),
                        ),
                        _buildScreenTitle(
                          screenTitle: "Login One",
                          onTapScreenTitle:
                              () => onTapScreenTitle(AppRoutes.loginOneScreen),
                        ),
                        _buildScreenTitle(
                          screenTitle: "FORGET PASSWORD One",
                          onTapScreenTitle:
                              () => onTapScreenTitle(
                                AppRoutes.forgetPasswordOneScreen,
                              ),
                        ),
                        _buildScreenTitle(
                          screenTitle: "FORGET PASSWORD Two",
                          onTapScreenTitle:
                              () => onTapScreenTitle(
                                AppRoutes.forgetPasswordTwoScreen,
                              ),
                        ),
                        _buildScreenTitle(
                          screenTitle: "False - Forgot Password OTP",
                          onTapScreenTitle:
                              () => onTapScreenTitle(
                                AppRoutes.falseForgotPasswordOtpScreen,
                              ),
                        ),
                        _buildScreenTitle(
                          screenTitle: "Forgot Password OTP",
                          onTapScreenTitle:
                              () => onTapScreenTitle(
                                AppRoutes.forgotPasswordOtpScreen,
                              ),
                        ),
                        _buildScreenTitle(
                          screenTitle: "NEW PASSWORD One",
                          onTapScreenTitle:
                              () => onTapScreenTitle(
                                AppRoutes.newPasswordOneScreen,
                              ),
                        ),
                        _buildScreenTitle(
                          screenTitle: "NEW PASSWORD Two",
                          onTapScreenTitle:
                              () => onTapScreenTitle(
                                AppRoutes.newPasswordTwoScreen,
                              ),
                        ),
                        _buildScreenTitle(
                          screenTitle: "Login Two",
                          onTapScreenTitle:
                              () => onTapScreenTitle(AppRoutes.loginTwoScreen),
                        ),
                        _buildScreenTitle(
                          screenTitle: "HOME SCREEN",
                          onTapScreenTitle:
                              () => onTapScreenTitle(AppRoutes.homeScreen),
                        ),
                        _buildScreenTitle(
                          screenTitle: "Login Three",
                          onTapScreenTitle:
                              () =>
                                  onTapScreenTitle(AppRoutes.loginThreeScreen),
                        ),
                        _buildScreenTitle(
                          screenTitle: "Login Four",
                          onTapScreenTitle:
                              () => onTapScreenTitle(AppRoutes.loginFourScreen),
                        ),
                        _buildScreenTitle(
                          screenTitle: "24 - Detail Restaurants_VOne",
                          onTapScreenTitle:
                              () => onTapScreenTitle(
                                AppRoutes.detailRestaurantsVoneScreen,
                              ),
                        ),
                        _buildScreenTitle(
                          screenTitle: "26 - Detail Restaurants_Review_VOne",
                          onTapScreenTitle:
                              () => onTapScreenTitle(
                                AppRoutes.detailRestaurantsReviewVoneScreen,
                              ),
                        ),
                        _buildScreenTitle(
                          screenTitle: "Login Six",
                          onTapScreenTitle:
                              () => onTapScreenTitle(AppRoutes.loginSixScreen),
                        ),
                        _buildScreenTitle(
                          screenTitle: "Login Seven",
                          onTapScreenTitle:
                              () =>
                                  onTapScreenTitle(AppRoutes.loginSevenScreen),
                        ),
                        _buildScreenTitle(
                          screenTitle: "29 - Add New Item",
                          onTapScreenTitle:
                              () => onTapScreenTitle(AppRoutes.addNewScreen),
                        ),
                        _buildScreenTitle(
                          screenTitle: "Login Eight - BottomSheet",
                          onTapScreenTitle:
                              () => onTapBottomSheetTitle(
                                context,
                                LoginEightBottomsheet(
                                  Get.put(LoginEightController()),
                                ),
                              ),
                        ),
                        _buildScreenTitle(
                          screenTitle: "Login Nine - Dialog",
                          onTapScreenTitle:
                              () => onTapDialogTitle(
                                context,
                                LoginNineDialog(Get.put(LoginNineController())),
                              ),
                        ),
                        _buildScreenTitle(
                          screenTitle: "32 - Your Orders_Ongoing",
                          onTapScreenTitle:
                              () => onTapScreenTitle(
                                AppRoutes.yourOrdersOngoingScreen,
                              ),
                        ),
                        _buildScreenTitle(
                          screenTitle: "33 - Your Orders_History",
                          onTapScreenTitle:
                              () => onTapScreenTitle(
                                AppRoutes.yourOrdersHistoryScreen,
                              ),
                        ),
                        _buildScreenTitle(
                          screenTitle: "34 - Rate Drive - BottomSheet",
                          onTapScreenTitle:
                              () => onTapBottomSheetTitle(
                                context,
                                RateDriveBottomsheet(
                                  Get.put(RateDriveController()),
                                ),
                              ),
                        ),
                        _buildScreenTitle(
                          screenTitle: "35 - Rate shop - BottomSheet",
                          onTapScreenTitle:
                              () => onTapBottomSheetTitle(
                                context,
                                RateShopBottomsheet(
                                  Get.put(RateShopController()),
                                ),
                              ),
                        ),
                        _buildScreenTitle(
                          screenTitle: "36- Rate shop - Dialog",
                          onTapScreenTitle:
                              () => onTapDialogTitle(
                                context,
                                RateShop1Dialog(Get.put(RateShop1Controller())),
                              ),
                        ),
                        _buildScreenTitle(
                          screenTitle: "38 - Account information - BottomSheet",
                          onTapScreenTitle:
                              () => onTapBottomSheetTitle(
                                context,
                                AccountInformationBottomsheet(
                                  Get.put(AccountInformationController()),
                                ),
                              ),
                        ),
                        _buildScreenTitle(
                          screenTitle: "39 - Change Password - BottomSheet",
                          onTapScreenTitle:
                              () => onTapBottomSheetTitle(
                                context,
                                ChangePasswordBottomsheet(
                                  Get.put(ChangePasswordController()),
                                ),
                              ),
                        ),
                        _buildScreenTitle(
                          screenTitle: "40 - Payment Methods - BottomSheet",
                          onTapScreenTitle:
                              () => onTapBottomSheetTitle(
                                context,
                                PaymentMethodsBottomsheet(
                                  Get.put(PaymentMethodsController()),
                                ),
                              ),
                        ),
                        _buildScreenTitle(
                          screenTitle:
                              "41 - Payment Methods_Card - BottomSheet",
                          onTapScreenTitle:
                              () => onTapBottomSheetTitle(
                                context,
                                PaymentMethodsCardBottomsheet(
                                  Get.put(PaymentMethodsCardController()),
                                ),
                              ),
                        ),
                        _buildScreenTitle(
                          screenTitle: "42 - Card list - BottomSheet",
                          onTapScreenTitle:
                              () => onTapBottomSheetTitle(
                                context,
                                CardListBottomsheet(
                                  Get.put(CardListController()),
                                ),
                              ),
                        ),
                        _buildScreenTitle(
                          screenTitle: "18 - Best Partners_VOne - BottomSheet",
                          onTapScreenTitle:
                              () => onTapBottomSheetTitle(
                                context,
                                BestPartnersVoneBottomsheet(
                                  Get.put(BestPartnersVoneController()),
                                ),
                              ),
                        ),
                        _buildScreenTitle(
                          screenTitle: "19 - Best Partners_VTwo - BottomSheet",
                          onTapScreenTitle:
                              () => onTapBottomSheetTitle(
                                context,
                                BestPartnersVtwoBottomsheet(
                                  Get.put(BestPartnersVtwoController()),
                                ),
                              ),
                        ),
                        _buildScreenTitle(
                          screenTitle: "20 - Filter_Category",
                          onTapScreenTitle:
                              () => onTapScreenTitle(
                                AppRoutes.filterCategoryScreen,
                              ),
                        ),
                        _buildScreenTitle(
                          screenTitle: "23 - Search_VOne",
                          onTapScreenTitle:
                              () =>
                                  onTapScreenTitle(AppRoutes.searchVoneScreen),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Common click event for bottomsheet
  void onTapBottomSheetTitle(BuildContext context, Widget className) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return className;
      },
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  /// Common click event for dialog
  void onTapDialogTitle(BuildContext context, Widget className) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: className,
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
        );
      },
    );
  }

  /// Common widget
  Widget _buildScreenTitle({
    required String screenTitle,
    Function? onTapScreenTitle,
  }) {
    return GestureDetector(
      onTap: () {
        onTapScreenTitle?.call();
      },
      child: Container(
        decoration: BoxDecoration(color: Color(0XFFFFFFFF)),
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: Text(
                screenTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0XFF000000),
                  fontSize: 20.fSize,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            SizedBox(height: 5.h),
            Divider(height: 1.h, thickness: 1.h, color: Color(0XFF888888)),
          ],
        ),
      ),
    );
  }

  /// Common click event
  void onTapScreenTitle(String routeName) {
    Get.toNamed(routeName);
  }
}
