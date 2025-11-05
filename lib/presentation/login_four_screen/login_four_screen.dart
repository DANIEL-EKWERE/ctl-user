// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../login_five_page/login_five_page.dart';
import '../profile_page/profile_page.dart';
import 'controller/login_four_controller.dart';
import 'models/login_four_one_item_model.dart';
import 'widgets/login_four_one_item_widget.dart'; // ignore_for_file: must_be_immutable

class LoginFourScreen extends GetWidget<LoginFourController> {
  const LoginFourScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.gray100,
      body: SafeArea(
        child: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Container(
              height: 1662.h,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  CustomImageView(
                    imagePath: ImageConstant.imgImportImage174x392,
                    height: 174.h,
                    width: double.maxFinite,
                    alignment: Alignment.topCenter,
                  ),
                  Container(
                    width: double.maxFinite,
                    margin: EdgeInsets.only(top: 144.h),
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    decoration: AppDecoration.neutral00.copyWith(
                      borderRadius: BorderRadiusStyle.customBorderTL30,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildColumnlineone(),
                        SizedBox(height: 24.h),
                        SizedBox(width: double.maxFinite, child: Divider()),
                        SizedBox(height: 18.h),
                        Container(
                          width: double.maxFinite,
                          margin: EdgeInsets.only(left: 92.h, right: 88.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "lbl_delivery".tr,
                                style: CustomTextStyles.labelLargePrimary13_1,
                              ),
                              Text(
                                "lbl_review".tr,
                                style:
                                    CustomTextStyles.labelLargeBluegray90013_2,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 14.h),
                        SizedBox(
                          width: 188.h,
                          child: Divider(
                            color: theme.colorScheme.primary,
                            indent: 36.h,
                          ),
                        ),
                        SizedBox(width: double.maxFinite, child: Divider()),
                        SizedBox(height: 34.h),
                        Padding(
                          padding: EdgeInsets.only(left: 36.h),
                          child: Text(
                            "lbl_popular_items".tr,
                            style: CustomTextStyles.titleMediumBold_1,
                          ),
                        ),
                        SizedBox(height: 14.h),
                        _buildStacknamemarket(),
                        SizedBox(height: 42.h),
                        Padding(
                          padding: EdgeInsets.only(left: 36.h),
                          child: Text(
                            "msg_hot_burger_combo".tr,
                            style: CustomTextStyles.titleMediumBold_1,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        _buildRownamethree(),
                        Spacer(flex: 42),
                        Padding(
                          padding: EdgeInsets.only(left: 36.h),
                          child: Text(
                            "lbl_fried_chicken".tr,
                            style: CustomTextStyles.titleMediumBold_1,
                          ),
                        ),
                        Spacer(flex: 57),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
  Widget _buildColumnlineone() {
    return Container(
      width: 320.h,
      margin: EdgeInsets.only(left: 36.h),
      child: Column(
        children: [
          Container(
            height: 4.h,
            width: 40.h,
            decoration: BoxDecoration(
              color: appTheme.black900.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(2.h),
            ),
          ),
          SizedBox(height: 18.h),
          SizedBox(
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "lbl_burger_king".tr,
                            style: theme.textTheme.titleLarge,
                          ),
                        ),
                        CustomImageView(
                          imagePath: ImageConstant.imgCheckmarkTeal700,
                          height: 24.h,
                          width: 24.h,
                          margin: EdgeInsets.only(left: 2.h),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.h),
                  decoration: AppDecoration.red50.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder8,
                  ),
                  child: Text(
                    "lbl_take_away".tr,
                    textAlign: TextAlign.center,
                    style: CustomTextStyles.labelLargePrimary_2,
                  ),
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgFavoritePrimary,
                  height: 24.h,
                  width: 24.h,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("lbl_open".tr, style: CustomTextStyles.labelLargeTeal700),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: 2.h,
                  width: 2.h,
                  margin: EdgeInsets.only(top: 6.h),
                  decoration: BoxDecoration(
                    color: appTheme.gray400,
                    borderRadius: BorderRadius.circular(1.h),
                  ),
                ),
              ),
              Text(
                "msg_1453_w_manchester".tr,
                style: theme.textTheme.labelLarge,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          SizedBox(width: double.maxFinite, child: Divider()),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.maxFinite,
            child: Row(
              children: [
                CustomElevatedButton(
                  height: 24.h,
                  width: 50.h,
                  text: "lbl_4_5".tr,
                  leftIcon: Container(
                    margin: EdgeInsets.only(right: 4.h),
                    child: CustomImageView(
                      imagePath: ImageConstant.imgSignal,
                      height: 16.h,
                      width: 16.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                  buttonStyle: CustomButtonStyles.fillPrimary,
                  buttonTextStyle: CustomTextStyles.labelLargeOnPrimary_1,
                ),
                Container(
                  height: 2.h,
                  width: 2.h,
                  margin: EdgeInsets.only(left: 12.h),
                  decoration: BoxDecoration(
                    color: appTheme.gray400,
                    borderRadius: BorderRadius.circular(1.h),
                  ),
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgClock,
                  height: 24.h,
                  width: 24.h,
                  margin: EdgeInsets.only(left: 6.h),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 4.h),
                  child: Text(
                    "lbl_15_mins".tr,
                    style: CustomTextStyles.labelLargeBluegray900,
                  ),
                ),
                Container(
                  height: 2.h,
                  width: 2.h,
                  margin: EdgeInsets.only(left: 12.h),
                  decoration: BoxDecoration(
                    color: appTheme.gray400,
                    borderRadius: BorderRadius.circular(1.h),
                  ),
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgIconGeneralTime,
                  height: 24.h,
                  width: 24.h,
                  margin: EdgeInsets.only(left: 6.h),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(left: 4.h),
                    child: Text(
                      "lbl_free_shipping".tr,
                      style: CustomTextStyles.labelLargeBluegray900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 10.h),
            decoration: AppDecoration.fs42Cardlist.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder14,
            ),
            width: double.maxFinite,
            child: Row(
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgUserPrimary,
                  height: 24.h,
                  width: 24.h,
                  radius: BorderRadius.circular(12.h),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12.h),
                  child: Text(
                    "msg_save_15_00_with".tr,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildLoginfourone() {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        child: Obx(
          () => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Wrap(
              direction: Axis.horizontal,
              spacing: 8.h,
              children: List.generate(
                controller
                    .loginFourModelObj
                    .value
                    .loginFourOneItemList
                    .value
                    .length,
                (index) {
                  LoginFourOneItemModel model =
                      controller
                          .loginFourModelObj
                          .value
                          .loginFourOneItemList
                          .value[index];
                  return LoginFourOneItemWidget(model);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildStacknamemarket() {
    return Container(
      height: 226.h,
      width: double.maxFinite,
      margin: EdgeInsets.only(left: 36.h),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          _buildLoginfourone(),
          Align(
            alignment: Alignment.bottomLeft,
            child: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.maxFinite,
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Row(
                        children: [
                          Text(
                            "lbl_5_99".tr,
                            style: CustomTextStyles.labelLargeTeal700,
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              height: 2.h,
                              width: 2.h,
                              margin: EdgeInsets.only(left: 8.h, top: 8.h),
                              decoration: BoxDecoration(
                                color: appTheme.gray400,
                                borderRadius: BorderRadius.circular(1.h),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 8.h),
                            child: Text(
                              "lbl_burger".tr,
                              style: theme.textTheme.labelLarge,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 144.h,
            margin: EdgeInsets.only(right: 52.h),
            child: Column(
              spacing: 20,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.maxFinite,
                  child: Text(
                    "msg_singles_bbq_bacon".tr,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    children: [
                      Text(
                        "lbl_7_99".tr,
                        style: CustomTextStyles.labelLargeTeal700,
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          height: 2.h,
                          width: 2.h,
                          margin: EdgeInsets.only(left: 8.h, top: 8.h),
                          decoration: BoxDecoration(
                            color: appTheme.gray400,
                            borderRadius: BorderRadius.circular(1.h),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.h),
                        child: Text(
                          "lbl_burger".tr,
                          style: theme.textTheme.labelLarge,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 320.h),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: IntrinsicWidth(
                  child: SizedBox(
                    width: 150.h,
                    child: Column(
                      spacing: 18,
                      children: [
                        SizedBox(
                          width: double.maxFinite,
                          child: Text(
                            "msg_potato_chip_burrger".tr,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                        SizedBox(
                          width: double.maxFinite,
                          child: Row(
                            children: [
                              Text(
                                "lbl_3_99".tr,
                                style: CustomTextStyles.labelLargeTeal700,
                              ),
                              Container(
                                height: 2.h,
                                width: 2.h,
                                margin: EdgeInsets.only(left: 8.h),
                                decoration: BoxDecoration(
                                  color: appTheme.gray400,
                                  borderRadius: BorderRadius.circular(1.h),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 8.h),
                                child: Text(
                                  "lbl_coffee".tr,
                                  style: theme.textTheme.labelLarge,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildRownamethree() {
    return Container(
      width: 322.h,
      margin: EdgeInsets.only(left: 36.h),
      child: Row(
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgImportImage82x82,
            height: 82.h,
            width: 82.h,
            radius: BorderRadius.circular(14.h),
          ),
          Expanded(
            child: Column(
              spacing: 8,
              children: [
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "msg_combo_spicy_tender".tr,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                      CustomImageView(
                        imagePath: ImageConstant.imgSignalOrange400,
                        height: 24.h,
                        width: 24.h,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    children: [
                      Text(
                        "lbl_10_15".tr,
                        textAlign: TextAlign.right,
                        style: CustomTextStyles.labelLargePrimary_2,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 18.h),
                        child: Text(
                          "lbl_burger_combo".tr,
                          style: theme.textTheme.labelLarge,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
