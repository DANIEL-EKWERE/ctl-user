// TODO Implement this library.
import 'package:ctluser/presentation/profile_page/controller/proflle_controller.dart';
import 'package:ctluser/widgets/app_bar/appabr_trailing_image.dart';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_subtitle_two.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_switch.dart';

import 'models/listaccount_item_model.dart';
import 'models/profile_model.dart';
import 'widgets/listaccount_item_widget.dart';

// ignore_for_file: must_be_immutable
class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);

  ProfileController controller = Get.put(ProfileController(ProfileModel().obs));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.gray100,
      appBar: _buildAppbar(),
      body: SafeArea(
        top: false,
        child: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: SizedBox(
              width: double.maxFinite,
              child: Column(
                children: [
                  _buildColumnname(),
                  SizedBox(height: 42.h),
                  _buildColumngeneral(),
                  SizedBox(height: 16.h),
                  _buildColumnnotificat(),
                  SizedBox(height: 16.h),
                  _buildColumnmoreone(),
                  SizedBox(height: 32.h),
                  _buildColumnrefresh(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppbar() {
    return CustomAppBar(
      centerTitle: true,
      title: AppbarSubtitleTwo(text: "lbl_profile".tr),
      actions: [
        AppbarTrailingImage(
          imagePath: ImageConstant.imgClockBlueGray700,
          height: 24.h,
          width: 24.h,
          margin: EdgeInsets.only(right: 34.h),
        ),
      ],
      styleType: Style.bgFillOnPrimary,
    );
  }

  /// Section Widget
  Widget _buildColumnname() {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(vertical: 18.h),
      decoration: AppDecoration.neutral00,
      child: Column(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 4.h),
          CustomImageView(
            imagePath: ImageConstant.imgEllipse880x80,
            height: 80.h,
            width: 82.h,
            radius: BorderRadius.circular(40.h),
          ),
          Text("msg_philippe_troussier".tr, style: theme.textTheme.titleMedium),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildColumngeneral() {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 14.h),
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: AppDecoration.neutral00.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder14,
      ),
      child: Column(
        spacing: 16,
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 20.h),
              child: Text(
                "lbl_general".tr,
                style: CustomTextStyles.titleSmallBold,
              ),
            ),
          ),
          SizedBox(width: double.maxFinite, child: Divider()),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.h),
            child: Obx(
              () => ListView.separated(
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0.h),
                    child: Divider(
                      height: 1.h,
                      thickness: 1.h,
                      color: appTheme.gray100,
                    ),
                  );
                },
                itemCount:
                    controller
                        .profileModelObj
                        .value
                        .listaccountItemList
                        .value
                        .length,
                itemBuilder: (context, index) {
                  ListaccountItemModel model =
                      controller
                          .profileModelObj
                          .value
                          .listaccountItemList
                          .value[index];
                  return ListaccountItemWidget(model);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildColumnnotificat() {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 14.h),
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: AppDecoration.neutral00.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder14,
      ),
      child: Column(
        spacing: 16,
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 20.h),
              child: Text(
                "lbl_notifications".tr,
                style: CustomTextStyles.titleSmallBold,
              ),
            ),
          ),
          SizedBox(width: double.maxFinite, child: Divider()),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.h),
            padding: EdgeInsets.all(12.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadiusStyle.roundedBorder14,
            ),
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgIconControl,
                  height: 24.h,
                  width: 24.h,
                ),
                Expanded(
                  child: Column(
                    spacing: 2,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "lbl_notifications".tr,
                        style: theme.textTheme.titleSmall,
                      ),
                      Text(
                        "msg_you_will_receive".tr,
                        style: theme.textTheme.labelLarge,
                      ),
                    ],
                  ),
                ),
                Obx(
                  () => CustomSwitch(
                    value: controller.isSelectedSwitch.value,
                    onChange: (value) {
                      controller.isSelectedSwitch.value = value;
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.h),
            padding: EdgeInsets.all(12.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadiusStyle.roundedBorder14,
            ),
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgIconControl,
                  height: 24.h,
                  width: 26.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12.h),
                  child: Column(
                    spacing: 2,
                    children: [
                      Text(
                        "msg_promotional_notifications".tr,
                        style: theme.textTheme.titleSmall,
                      ),
                      Text(
                        "msg_get_notified_when".tr,
                        style: theme.textTheme.labelLarge,
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Obx(
                  () => CustomSwitch(
                    margin: EdgeInsets.only(right: 8.h),
                    value: controller.isSelectedSwitch1.value,
                    onChange: (value) {
                      controller.isSelectedSwitch1.value = value;
                    },
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
  Widget _buildColumnmoreone() {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 14.h),
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: AppDecoration.neutral00.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder14,
      ),
      child: Column(
        spacing: 16,
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 20.h),
              child: Text(
                "lbl_more".tr,
                style: CustomTextStyles.titleSmallBold,
              ),
            ),
          ),
          SizedBox(width: double.maxFinite, child: Divider()),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.h),
            padding: EdgeInsets.all(12.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadiusStyle.roundedBorder14,
            ),
            width: double.maxFinite,
            child: Row(
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgSignalGray400,
                  height: 24.h,
                  width: 24.h,
                ),
                Expanded(
                  child: _buildColumnplacehold(
                    placeholderSix: "lbl_rate_us".tr,
                    placeholder: "msg_you_will_receive".tr,
                  ),
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgArrowLeftGray400,
                  height: 24.h,
                  width: 24.h,
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.h),
            padding: EdgeInsets.all(12.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadiusStyle.roundedBorder14,
            ),
            width: double.maxFinite,
            child: Row(
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgUpload,
                  height: 24.h,
                  width: 24.h,
                ),
                Expanded(
                  child: _buildColumnplacehold(
                    placeholderSix: "lbl_faq".tr,
                    placeholder: "msg_frequently_asked".tr,
                  ),
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgArrowLeftGray400,
                  height: 24.h,
                  width: 24.h,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildColumnrefresh() {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 14.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadiusStyle.roundedBorder14,
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 32.h, vertical: 20.h),
            decoration: AppDecoration.neutral00.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder14,
            ),
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgRefresh,
                  height: 24.h,
                  width: 26.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12.h),
                  child: Text(
                    "lbl_log_out".tr,
                    style: theme.textTheme.titleSmall,
                  ),
                ),
                Spacer(),
                CustomImageView(
                  imagePath: ImageConstant.imgArrowLeftGray400,
                  height: 24.h,
                  width: 26.h,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Common widget
  Widget _buildColumnplacehold({
    required String placeholderSix,
    required String placeholder,
  }) {
    return Column(
      spacing: 2,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          placeholderSix,
          style: theme.textTheme.titleSmall!.copyWith(
            color: appTheme.blueGray900,
          ),
        ),
        Text(
          placeholder,
          style: theme.textTheme.labelLarge!.copyWith(
            color: appTheme.blueGray400,
          ),
        ),
      ],
    );
  }
}
