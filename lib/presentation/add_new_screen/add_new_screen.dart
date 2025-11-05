// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle_two.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import 'controller/add_new_controller.dart';
import 'models/items_item_model.dart';
import 'widgets/items_item_widget.dart'; // ignore_for_file: must_be_immutable

class AddNewScreen extends GetWidget<AddNewController> {
  const AddNewScreen({Key? key}) : super(key: key);

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
                spacing: 14,
                children: [
                  SizedBox(height: 14.h),
                  _buildDeliveryone(),
                  _buildColumnline(),
                  _buildRowuserone(),
                  _buildColumnuser(),
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
      leadingWidth: 59.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeft24x24,
        height: 24.h,
        width: 24.h,
        margin: EdgeInsets.only(left: 35.h),
        onTap: () {
          onTapArrowleftone();
        },
      ),
      centerTitle: true,
      title: AppbarSubtitleTwo(text: "lbl_confirm_order".tr),
      styleType: Style.bgFillOnPrimary,
    );
  }

  /// Section Widget
  Widget _buildDeliveryone() {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 14.h),
      padding: EdgeInsets.symmetric(vertical: 20.h),
      decoration: AppDecoration.neutral00.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder14,
      ),
      child: Column(
        spacing: 18,
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 20.h),
              child: Text(
                "lbl_delivery_to".tr,
                style: CustomTextStyles.titleMediumBold,
              ),
            ),
          ),
          SizedBox(width: double.maxFinite, child: Divider()),
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.symmetric(horizontal: 20.h),
            child: Row(
              children: [
                Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  color: appTheme.gray100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusStyle.roundedBorder14,
                  ),
                  child: Container(
                    height: 80.h,
                    width: 80.h,
                    decoration: AppDecoration.fs42Cardlist.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder14,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.imgMaps80x80,
                          height: 80.h,
                          width: 80.h,
                          radius: BorderRadius.circular(14.h),
                        ),
                        CustomImageView(
                          imagePath: ImageConstant.imgCloseTeal40040x32,
                          height: 40.h,
                          width: 34.h,
                          radius: BorderRadius.circular(14.h),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    spacing: 6,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "msg_323_238_0678_909_1_2".tr,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: CustomTextStyles.labelLargeBluegray900_1,
                      ),
                      SizedBox(
                        width: double.maxFinite,
                        child: Row(
                          children: [
                            CustomImageView(
                              imagePath: ImageConstant.imgLinkedin,
                              height: 24.h,
                              width: 24.h,
                              radius: BorderRadius.circular(12.h),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 4.h),
                              child: Text(
                                "lbl_1_5_km".tr,
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
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildColumnline() {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 14.h),
      decoration: AppDecoration.neutral00.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder14,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: double.maxFinite, child: Divider()),
          SizedBox(height: 18.h),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 20.h),
              child: Text(
                "lbl_burger_king".tr,
                style: CustomTextStyles.titleMediumBold,
              ),
            ),
          ),
          SizedBox(height: 40.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.h),
            child: Obx(
              () => ListView.separated(
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0.h),
                    child: Divider(
                      height: 1.h,
                      thickness: 1.h,
                      color: appTheme.gray100,
                    ),
                  );
                },
                itemCount:
                    controller.addNewModelObj.value.itemsItemList.value.length,
                itemBuilder: (context, index) {
                  ItemsItemModel model =
                      controller
                          .addNewModelObj
                          .value
                          .itemsItemList
                          .value[index];
                  return ItemsItemWidget(model);
                },
              ),
            ),
          ),
          SizedBox(height: 20.h),
          SizedBox(width: double.maxFinite, child: Divider()),
          SizedBox(height: 16.h),
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.symmetric(horizontal: 18.h),
            child: _buildRowvoucher(
              voucherOne: "msg_subtotal_2_items".tr,
              priceThree: "lbl_36_98".tr,
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.maxFinite,
            child: Divider(indent: 20.h, endIndent: 20.h),
          ),
          SizedBox(height: 16.h),
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.symmetric(horizontal: 20.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("lbl_delivery".tr, style: theme.textTheme.bodyMedium),
                Text("lbl_0_00".tr, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.maxFinite,
            child: Divider(indent: 20.h, endIndent: 20.h),
          ),
          SizedBox(height: 16.h),
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.symmetric(horizontal: 18.h),
            child: _buildRowvoucher(
              voucherOne: "lbl_voucher".tr,
              priceThree: "lbl4".tr,
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.maxFinite,
            child: Divider(indent: 20.h, endIndent: 20.h),
          ),
          SizedBox(height: 16.h),
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.symmetric(horizontal: 18.h),
            child: _buildRowvoucher(
              voucherOne: "lbl_total".tr,
              priceThree: "lbl_36_98".tr,
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildRowuserone() {
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
          CustomElevatedButton(
            height: 24.h,
            width: 84.h,
            text: "lbl_add".tr,
            buttonStyle: CustomButtonStyles.fillDeepOrange,
            buttonTextStyle: CustomTextStyles.labelLargePrimary,
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildColumnuser() {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(34.h),
      decoration: AppDecoration.neutral00,
      child: Column(
        spacing: 24,
        children: [
          SizedBox(
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16.h),
                    decoration: AppDecoration.red50.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder14,
                    ),
                    child: Row(
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.imgUserIndigo900,
                          height: 24.h,
                          width: 24.h,
                        ),
                        Expanded(
                          child: Column(
                            spacing: 2,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "lbl_36_98".tr,
                                style: CustomTextStyles.titleSmallPrimary_1,
                              ),
                              Text(
                                "lbl_paypal".tr,
                                style: CustomTextStyles.labelLargeYellow8007f,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16.h),
                    decoration: AppDecoration.fs42Cardlist.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder14,
                    ),
                    child: Row(
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.imgCash,
                          height: 24.h,
                          width: 24.h,
                        ),
                        Expanded(
                          child: Column(
                            spacing: 2,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "lbl_36_98".tr,
                                style: CustomTextStyles.titleSmall_1,
                              ),
                              Text(
                                "lbl_cash".tr,
                                style: theme.textTheme.labelLarge,
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
          CustomElevatedButton(text: "lbl_submit".tr),
        ],
      ),
    );
  }

  /// Common widget
  Widget _buildRowvoucher({
    required String voucherOne,
    required String priceThree,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          voucherOne,
          style: theme.textTheme.bodyMedium!.copyWith(
            color: appTheme.blueGray900,
          ),
        ),
        Text(
          priceThree,
          style: theme.textTheme.bodyMedium!.copyWith(
            color: appTheme.blueGray900,
          ),
        ),
      ],
    );
  }

  /// Navigates to the previous screen.
  onTapArrowleftone() {
    Get.back();
  }
}
