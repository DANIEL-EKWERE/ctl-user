// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'controller/home_controller.dart';
import 'models/home_screen_one_item_model.dart';
import 'widgets/home_screen_one_item_widget.dart'; // ignore_for_file: must_be_immutable

class HomeScreen extends GetWidget<HomeController> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colorScheme.onPrimary,
      body: SafeArea(
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.only(left: 24.h, top: 40.h, right: 24.h),
          child: Column(
            spacing: 32,
            mainAxisSize: MainAxisSize.max,
            children: [_buildRow725westheime(), _buildHomescreenone()],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildRow725westheime() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.h, vertical: 12.h),
      decoration: AppDecoration.fillGray10001.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder8,
      ),
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 2.h),
            child: Text(
              "msg_725_westheimer_rd".tr,
              style: CustomTextStyles.bodyMediumNexaTextTrialOnPrimaryContainer,
            ),
          ),
          CustomImageView(
            imagePath: ImageConstant.imgClose,
            height: 8.h,
            width: 10.h,
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildHomescreenone() {
    return Expanded(
      child: Obx(
        () => ListView.separated(
          padding: EdgeInsets.zero,
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          separatorBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0.h),
              child: Divider(
                height: 1.h,
                thickness: 1.h,
                color: appTheme.black900.withValues(alpha: 0.1),
              ),
            );
          },
          itemCount:
              controller.homeModelObj.value.homeScreenOneItemList.value.length,
          itemBuilder: (context, index) {
            HomeScreenOneItemModel model =
                controller
                    .homeModelObj
                    .value
                    .homeScreenOneItemList
                    .value[index];
            return HomeScreenOneItemWidget(model);
          },
        ),
      ),
    );
  }
}
