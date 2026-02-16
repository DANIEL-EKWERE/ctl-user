// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_title_dropdown.dart';
import '../../widgets/app_bar/appbar_trailing_button.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import 'controller/login_three_controller.dart';
import 'models/login_three_initial_model.dart';
import 'models/login_three_one_item_model.dart';
import 'widgets/login_three_one_item_widget.dart';

// ignore_for_file: must_be_immutable
class LoginThreeInitialPage extends StatelessWidget {
  LoginThreeInitialPage({Key? key}) : super(key: key);

  LoginThreeController controller = Get.put(LoginThreeController());

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: AppDecoration.fs42Cardlist,
      child: Column(
        children: [
          SizedBox(width: double.maxFinite, child: _buildAppbar()),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(horizontal: 20.h),
                child: Column(
                  spacing: 12,
                  children: [
                    SizedBox(height: 12.h),
                    Container(
                      height: 68.h,
                      width: 352.h,
                      decoration: BoxDecoration(
                        color: appTheme.gray30001,
                        borderRadius: BorderRadius.circular(5.h),
                      ),
                    ),
                    _buildColumnhanoiviet(),
                    Container(
                      width: double.maxFinite,
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.h,
                        vertical: 30.h,
                      ),
                      decoration: AppDecoration.neutral00.copyWith(
                        borderRadius: BorderRadiusStyle.roundedBorder14,
                      ),
                      child: Column(
                        spacing: 20,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(
                                AppRoutes.detailRestaurantsVoneScreen,
                              );
                            },
                            child: _buildColumnnamemarke(),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(
                                AppRoutes.detailRestaurantsReviewVoneScreen,
                              );
                            },
                            child: Container(
                              width: double.maxFinite,
                              margin: EdgeInsets.symmetric(horizontal: 20.h),
                              child: Column(
                                children: [
                                  CustomImageView(
                                    imagePath:
                                        ImageConstant.imgImportImage172x302,
                                    height: 172.h,
                                    width: double.maxFinite,
                                    radius: BorderRadius.circular(14.h),
                                  ),
                                  SizedBox(height: 16.h),
                                  SizedBox(
                                    width: double.maxFinite,
                                    child: _buildNameOne(
                                      namemarketOne: "lbl_kfc".tr,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  SizedBox(
                                    width: double.maxFinite,
                                    child: Row(
                                      children: [
                                        Text(
                                          "lbl_open".tr,
                                          style:
                                              CustomTextStyles
                                                  .labelLargeTeal700_2,
                                        ),
                                        Container(
                                          height: 2.h,
                                          width: 2.h,
                                          margin: EdgeInsets.only(left: 8.h),
                                          decoration: BoxDecoration(
                                            color: appTheme.gray400,
                                            borderRadius: BorderRadius.circular(
                                              1.h,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 8.h),
                                          child: Text(
                                            "lbl_fastfood".tr,
                                            style: theme.textTheme.labelLarge,
                                          ),
                                        ),
                                        Container(
                                          height: 2.h,
                                          width: 2.h,
                                          margin: EdgeInsets.only(left: 8.h),
                                          decoration: BoxDecoration(
                                            color: appTheme.gray400,
                                            borderRadius: BorderRadius.circular(
                                              1.h,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 8.h),
                                          child: Text(
                                            "lbl_chicken".tr,
                                            style: theme.textTheme.labelLarge,
                                          ),
                                        ),
                                        Container(
                                          height: 2.h,
                                          width: 2.h,
                                          margin: EdgeInsets.only(left: 8.h),
                                          decoration: BoxDecoration(
                                            color: appTheme.gray400,
                                            borderRadius: BorderRadius.circular(
                                              1.h,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 8.h),
                                          child: Text(
                                            "lbl_rice".tr,
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Common widget
  Widget _buildNameOne({required String namemarketOne}) {
    return Row(
      children: [
        Text(
          namemarketOne,
          style: theme.textTheme.titleLarge!.copyWith(
            color: appTheme.blueGray900,
          ),
        ),
        CustomImageView(
          imagePath: ImageConstant.imgCheckmarkTeal700,
          height: 24.h,
          width: 24.h,
          margin: EdgeInsets.only(left: 2.h),
        ),
      ],
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
            items:
                controller
                    .loginThreeInitialModelObj
                    .value
                    .dropdownItemList!
                    .value,
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
  Widget _buildColumnhanoiviet() {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 22.h, vertical: 16.h),
      decoration: AppDecoration.neutral00.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder5,
      ),
      child: Column(
        spacing: 24,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "lbl_category".tr,
                  style: CustomTextStyles.titleSmallSemiBold,
                ),
                Text(
                  "lbl_see_all".tr,
                  style: CustomTextStyles.bodyMediumBluegray900_1,
                ),
              ],
            ),
          ),
          Container(
            width: double.maxFinite,
            child: Obx(
              () => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Wrap(
                  direction: Axis.horizontal,
                  spacing: 16.h,
                  children: List.generate(
                    controller
                        .loginThreeInitialModelObj
                        .value
                        .loginThreeOneItemList
                        .value
                        .length,
                    (index) {
                      LoginThreeOneItemModel model =
                          controller
                              .loginThreeInitialModelObj
                              .value
                              .loginThreeOneItemList
                              .value[index];
                      return LoginThreeOneItemWidget(model);
                    },
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
  Widget _buildColumnnamemarke() {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        spacing: 18,
        children: [
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.symmetric(horizontal: 20.h),
            child: Column(
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgImportImage,
                  height: 172.h,
                  width: double.maxFinite,
                  radius: BorderRadius.circular(14.h),
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: double.maxFinite,
                  child: _buildNameOne(namemarketOne: "lbl_burger_king".tr),
                ),
                SizedBox(height: 4.h),
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    children: [
                      Text(
                        "lbl_open".tr,
                        style: CustomTextStyles.labelLargeTeal700_2,
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
                          "lbl_burger".tr,
                          style: theme.textTheme.labelLarge,
                        ),
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
                          "lbl_rice".tr,
                          style: theme.textTheme.labelLarge,
                        ),
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
                          "lbl_spaghetti".tr,
                          style: theme.textTheme.labelLarge,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    children: [
                      CustomElevatedButton(
                        height: 24.h,
                        width: 48.h,
                        text: "lbl_4_8".tr,
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
                        buttonTextStyle: CustomTextStyles.labelLargeOnPrimary,
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
                        imagePath: ImageConstant.imgLinkedin,
                        height: 24.h,
                        width: 24.h,
                        margin: EdgeInsets.only(left: 6.h),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 4.h),
                        child: Text(
                          "lbl_2_6_km".tr,
                          style: CustomTextStyles.labelLargeBluegray900_1,
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
                            style: CustomTextStyles.labelLargeBluegray900_1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: double.maxFinite, child: Divider()),
        ],
      ),
    );
  }
}
