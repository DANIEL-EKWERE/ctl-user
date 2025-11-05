// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_title_dropdown.dart';
import '../../widgets/app_bar/appbar_trailing_button.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../login_five_page/login_five_page.dart';
import '../profile_page/profile_page.dart';
import 'controller/login_two_controller.dart'; // ignore_for_file: must_be_immutable

class LoginTwoScreen extends GetWidget<LoginTwoController> {
  const LoginTwoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.gray100,
      appBar: _buildAppbar(),
      body: SafeArea(
        top: false,
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.only(left: 20.h, top: 12.h, right: 20.h),
          child: Column(
            children: [
              Container(
                width: double.maxFinite,
                decoration: AppDecoration.fillGray.copyWith(
                  borderRadius: BorderRadiusStyle.roundedBorder5,
                ),
                child: Column(
                  spacing: 8,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "msg_no_vendor_in_this".tr,
                      style:
                          CustomTextStyles
                              .labelLargeMontOnPrimaryContainerSemiBold,
                    ),
                    Text(
                      "msg_change_location".tr,
                      style: CustomTextStyles.labelLargeMontPrimary13,
                    ),
                    SizedBox(height: 12.h),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        width: double.maxFinite,
        child: _buildBottombar(),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppbar() {
    return CustomAppBar(
      leadingWidth: 34.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgSave,
        height: 14.h,
        width: 14.h,
        margin: EdgeInsets.only(left: 20.h),
      ),
      title: SizedBox(
        width: double.maxFinite,
        child: Obx(
          () => AppbarTitleDropdown(
            margin: EdgeInsets.only(left: 17.h),
            hintText: "msg_1014_prospect_vall".tr,
            items: controller.loginTwoModelObj.value.dropdownItemList!.value,
            onTap: (value) {
              controller.onSelected(value);
            },
          ),
        ),
      ),
      actions: [
        AppbarTrailingButton(
          margin: EdgeInsets.only(top: 8.h, right: 19.h, bottom: 8.h),
        ),
      ],
    );
  }

  /// Section Widget
  Widget _buildBottombar() {
    return SizedBox(
      width: double.maxFinite,
      child: CustomBottomBar(
        onChanged: (BottomBarEnum type) {
          Get.toNamed(getCurrentRoute(type), id: 1);
        },
      ),
    );
  }

  ///Handling route based on bottom click actions
  String getCurrentRoute(BottomBarEnum type) {
    switch (type) {
      case BottomBarEnum.Home:
        return AppRoutes.loginThreeInitialPage;
      case BottomBarEnum.Browse:
        return AppRoutes.loginFivePage;
      case BottomBarEnum.Favourites:
        return "/";
      case BottomBarEnum.Cart:
        return AppRoutes.profilePage;
      case BottomBarEnum.Profile:
        return "/";
      default:
        return "/";
    }
  }
}
