// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle_two.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import 'controller/login_seven_controller.dart';
import 'models/items_item_model.dart';
import 'widgets/items_item_widget.dart'; // ignore_for_file: must_be_immutable

class LoginSevenScreen extends GetWidget<LoginSevenController> {
  const LoginSevenScreen({Key? key}) : super(key: key);

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
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(horizontal: 14.h),
              child: Column(
                spacing: 14,
                children: [
                  SizedBox(height: 14.h),
                  _buildDeliveryone(),
                  Container(
                    width: double.maxFinite,
                    decoration: AppDecoration.neutral00.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder14,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(width: double.maxFinite, child: Divider()),
                        SizedBox(height: 20.h),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 20.h),
                            child: Text(
                              "lbl_burger_king".tr,
                              style: CustomTextStyles.titleMediumBold_2,
                            ),
                          ),
                        ),
                        SizedBox(height: 40.h),
                        _buildItems(),
                        SizedBox(height: 20.h),
                        SizedBox(width: double.maxFinite, child: Divider()),
                        SizedBox(height: 16.h),
                        Container(
                          width: double.maxFinite,
                          margin: EdgeInsets.symmetric(horizontal: 20.h),
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
                        _buildRowdelivery(),
                        SizedBox(height: 16.h),
                        SizedBox(
                          width: double.maxFinite,
                          child: Divider(indent: 20.h, endIndent: 20.h),
                        ),
                        SizedBox(height: 16.h),
                        Container(
                          width: double.maxFinite,
                          margin: EdgeInsets.symmetric(horizontal: 20.h),
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
                        SizedBox(height: 14.h),
                        Container(
                          width: double.maxFinite,
                          margin: EdgeInsets.symmetric(horizontal: 20.h),
                          child: _buildRowvoucher(
                            voucherOne: "lbl_total".tr,
                            priceThree: "lbl_36_98".tr,
                          ),
                        ),
                        SizedBox(height: 22.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildColumn(),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppbar() {
    return CustomAppBar(
      leadingWidth: 60.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeftGray40024x24,
        height: 24.h,
        width: 24.h,
        margin: EdgeInsets.only(left: 36.h),
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
      padding: EdgeInsets.symmetric(vertical: 20.h),
      decoration: AppDecoration.neutral00.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder14,
      ),
      child: Column(
        spacing: 18,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 20.h),
              child: Text(
                "lbl_delivery_to".tr,
                style: CustomTextStyles.titleMediumBold_2,
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
                    height: 82.h,
                    width: 82.h,
                    decoration: AppDecoration.fs42Cardlist.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder14,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.imgMaps,
                          height: 82.h,
                          width: 82.h,
                          radius: BorderRadius.circular(14.h),
                        ),
                        CustomImageView(
                          imagePath: ImageConstant.imgCloseTeal400,
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
                        style: CustomTextStyles.labelLargeBluegray900_2,
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
  Widget _buildItems() {
    return Padding(
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
              controller.loginSevenModelObj.value.itemsItemList.value.length,
          itemBuilder: (context, index) {
            ItemsItemModel model =
                controller.loginSevenModelObj.value.itemsItemList.value[index];
            return ItemsItemWidget(model);
          },
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildRowdelivery() {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("lbl_delivery".tr, style: theme.textTheme.bodyMedium),
          Text("lbl_0_00".tr, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildColumn() {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 14.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.symmetric(horizontal: 18.h, vertical: 24.h),
            decoration: AppDecoration.neutral00.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder14,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
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
                        padding: EdgeInsets.symmetric(
                          horizontal: 30.h,
                          vertical: 2.h,
                        ),
                        decoration: AppDecoration.red50.copyWith(
                          borderRadius: BorderRadiusStyle.roundedBorder8,
                        ),
                        child: Text(
                          "lbl_add".tr,
                          textAlign: TextAlign.center,
                          style: CustomTextStyles.labelLargePrimary_3,
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
