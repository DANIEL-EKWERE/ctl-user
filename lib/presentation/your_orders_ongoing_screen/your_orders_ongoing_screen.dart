import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:timelines_plus/timelines_plus.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_icon_button.dart';
import '../login_five_page/login_five_page.dart';
import '../profile_page/profile_page.dart';
import 'controller/your_orders_ongoing_controller.dart';
import 'models/timelineclose_item_model.dart';
import 'widgets/columnname_one_item_widget.dart';
import 'widgets/stackclose_one_item_widget.dart'; // ignore_for_file: must_be_immutable

class YourOrdersOngoingScreen extends GetWidget<YourOrdersOngoingController> {
  const YourOrdersOngoingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.gray100,
      body: SafeArea(
        child: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: SizedBox(
              width: double.maxFinite,
              child: Column(
                spacing: 44,
                children: [
                  Container(
                    height: 812.h,
                    width: double.maxFinite,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.h,
                      vertical: 62.h,
                    ),
                    decoration: AppDecoration.stack12,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [_buildMapone(), _buildColumn()],
                    ),
                  ),
                  _buildRowuserthree(),
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
  Widget _buildMapone() {
    return SizedBox(
      height: 644.h,
      width: 342.h,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(37.43296265331129, -122.08832357078792),
          zoom: 14.4746,
        ),
        onMapCreated: (GoogleMapController controller) {
          this.controller.googleMapController.complete(controller);
        },
        zoomControlsEnabled: false,
        zoomGesturesEnabled: false,
        myLocationButtonEnabled: false,
        myLocationEnabled: false,
      ),
    );
  }

  /// Section Widget
  Widget _buildColumn() {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(bottom: 40.h),
      child: Column(
        spacing: 16,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.all(16.h),
            decoration: AppDecoration.neutral00.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder14,
            ),
            child: Column(
              spacing: 16,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconButton(
                        height: 48.h,
                        width: 48.h,
                        padding: EdgeInsets.all(12.h),
                        decoration: IconButtonStyleHelper.fillPrimary,
                        child: CustomImageView(
                          imagePath: ImageConstant.imgThumbsUp,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          spacing: 2,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "msg_delivery_your_order".tr,
                              style: CustomTextStyles.titleMediumBold,
                            ),
                            Text(
                              "msg_coming_within_30".tr,
                              style: CustomTextStyles.bodyMediumBluegray400,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: Divider(color: appTheme.blueGray50),
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          spacing: 4,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "msg_prime_beef_pizza".tr,
                              style: theme.textTheme.titleSmall,
                            ),
                            SizedBox(
                              width: double.maxFinite,
                              child: Row(
                                children: [
                                  Text(
                                    "lbl_20_99".tr,
                                    style: CustomTextStyles.labelLargePrimary,
                                  ),
                                  Container(
                                    height: 4.h,
                                    width: 4.h,
                                    margin: EdgeInsets.only(left: 8.h),
                                    decoration: BoxDecoration(
                                      color: appTheme.gray400,
                                      borderRadius: BorderRadius.circular(2.h),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8.h),
                                    child: Text(
                                      "lbl_2_items".tr,
                                      style: CustomTextStyles.labelLargeGray400,
                                    ),
                                  ),
                                  Container(
                                    height: 4.h,
                                    width: 4.h,
                                    margin: EdgeInsets.only(left: 8.h),
                                    decoration: BoxDecoration(
                                      color: appTheme.gray400,
                                      borderRadius: BorderRadius.circular(2.h),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8.h),
                                    child: Text(
                                      "lbl_credit_card".tr,
                                      style: CustomTextStyles.labelLargeGray400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      CustomElevatedButton(width: 86.h, text: "lbl_detail".tr),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.all(16.h),
            decoration: AppDecoration.neutral00.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder14,
            ),
            child: Column(
              spacing: 22,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.maxFinite,
                  child: Obx(
                    () => Timeline.tileBuilder(
                      shrinkWrap: true,
                      theme: TimelineThemeData(
                        nodePosition: 0.1,
                        indicatorPosition: 0,
                      ),
                      builder: TimelineTileBuilder.connected(
                        connectionDirection: ConnectionDirection.before,
                        itemCount:
                            controller
                                .yourOrdersOngoingModelObj
                                .value
                                .timelinecloseItemList
                                .value
                                .length,
                        indicatorBuilder: (context, index) {
                          TimelinecloseItemModel model =
                              controller
                                  .yourOrdersOngoingModelObj
                                  .value
                                  .timelinecloseItemList
                                  .value[index];
                          return StackcloseOneItemWidget(model);
                        },
                        contentsBuilder: (context, index) {
                          TimelinecloseItemModel model =
                              controller
                                  .yourOrdersOngoingModelObj
                                  .value
                                  .timelinecloseItemList
                                  .value[index];
                          return ColumnnameOneItemWidget(model);
                        },
                        connectorBuilder: (context, index, type) {
                          return DashedLineConnector(
                            thickness: 1.h,
                            color: appTheme.gray400,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomImageView(
                        imagePath: ImageConstant.imgEllipse8,
                        height: 40.h,
                        width: 40.h,
                        radius: BorderRadius.circular(20.h),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "msg_philippe_troussier".tr,
                              style: theme.textTheme.titleSmall,
                            ),
                            SizedBox(
                              width: double.maxFinite,
                              child: Row(
                                children: [
                                  Text(
                                    "lbl_delivery".tr,
                                    style: theme.textTheme.labelLarge,
                                  ),
                                  Container(
                                    height: 4.h,
                                    width: 4.h,
                                    margin: EdgeInsets.only(left: 4.h),
                                    decoration: BoxDecoration(
                                      color: appTheme.gray400,
                                      borderRadius: BorderRadius.circular(2.h),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 4.h),
                                    child: Text(
                                      "lbl_0145425765".tr,
                                      style: theme.textTheme.labelLarge,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      CustomIconButton(
                        height: 40.h,
                        width: 40.h,
                        padding: EdgeInsets.all(8.h),
                        decoration: IconButtonStyleHelper.fillTeal,
                        child: CustomImageView(
                          imagePath: ImageConstant.imgCall,
                        ),
                      ),
                      CustomIconButton(
                        height: 40.h,
                        width: 40.h,
                        padding: EdgeInsets.all(8.h),
                        decoration: IconButtonStyleHelper.fillPrimaryTL20,
                        child: CustomImageView(
                          imagePath: ImageConstant.imgUserOnprimary,
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
  Widget _buildRowuserthree() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14.h),
      padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 24.h),
      decoration: AppDecoration.neutral00.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder14,
      ),
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgUserPrimary,
            height: 24.h,
            width: 26.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 12.h),
            child: Text(
              "lbl_add_voucher".tr,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30.h, vertical: 2.h),
            decoration: AppDecoration.red50.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder8,
            ),
            child: Text(
              "lbl_add".tr,
              textAlign: TextAlign.center,
              style: CustomTextStyles.labelLargePrimary,
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
