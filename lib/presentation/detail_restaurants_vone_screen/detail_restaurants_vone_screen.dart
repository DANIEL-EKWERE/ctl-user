// TODO Implement this library.
import 'package:ctluser/presentation/detail_restaurants_review_vone_screen/controller/detail_restaurants_review_vone_controller.dart';
import 'package:ctluser/presentation/detail_restaurants_review_vone_screen/models/listtoday16fort_item_model.dart';
import 'package:ctluser/presentation/detail_restaurants_review_vone_screen/widgets/listtoday16fort_item_widget.dart';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';
import 'controller/detail_restaurants_vone_controller.dart';
import 'detail_tab_page.dart'; // ignore_for_file: must_be_immutable

DetailRestaurantsReviewVoneController controller1 = Get.put(
  DetailRestaurantsReviewVoneController(),
);

class DetailRestaurantsVoneScreen
    extends GetWidget<DetailRestaurantsVoneController> {
  const DetailRestaurantsVoneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.gray100,
      body: SafeArea(
        child: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Container(
              height: 1588.h,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  CustomImageView(
                    imagePath: ImageConstant.imgImportImage168x374,
                    height: 168.h,
                    width: double.maxFinite,
                    alignment: Alignment.topCenter,
                  ),
                  Container(
                    width: double.maxFinite,
                    decoration: AppDecoration.neutral00.copyWith(
                      borderRadius: BorderRadiusStyle.customBorderTL30,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 16.h),
                        _buildColumnlineone(),
                        SizedBox(height: 24.h),
                        _buildTabview(),
                        SizedBox(
                          height: 1152.h,
                          child: TabBarView(
                            controller: controller.tabviewController,
                            children: [
                              DetailTabPage(),
                              _buildListtoday16fort(),
                            ],
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
    );
  }

  /// Section Widget
  Widget _buildListtoday16fort() {
    return Padding(
      padding: EdgeInsets.only(left: 38.h, right: 30.h, top: 30.h),
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
              controller1
                  .detailRestaurantsReviewVoneModelObj
                  .value
                  .listtoday16fortItemList
                  .value
                  .length,
          itemBuilder: (context, index) {
            Listtoday16fortItemModel model =
                controller1
                    .detailRestaurantsReviewVoneModelObj
                    .value
                    .listtoday16fortItemList
                    .value[index];
            return Listtoday16fortItemWidget(model);
          },
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildColumnlineone() {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 34.h),
      child: Column(
        children: [
          Container(
            height: 5.h,
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
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.h,
                    vertical: 2.h,
                  ),
                  decoration: AppDecoration.red50.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder8,
                  ),
                  child: Text(
                    "lbl_take_away".tr,
                    textAlign: TextAlign.center,
                    style: CustomTextStyles.labelLargePrimary,
                  ),
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgFavorite,
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
              Text("lbl_open".tr, style: CustomTextStyles.labelLargeTeal700_2),
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
          SizedBox(height: 14.h),
          SizedBox(width: double.maxFinite, child: Divider()),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.maxFinite,
            child: Row(
              children: [
                CustomElevatedButton(
                  height: 24.h,
                  width: 48.h,
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
                  imagePath: ImageConstant.imgClock,
                  height: 24.h,
                  width: 24.h,
                  margin: EdgeInsets.only(left: 6.h),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 4.h),
                  child: Text(
                    "lbl_15_mins".tr,
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
  Widget _buildTabview() {
    return SizedBox(
      width: double.maxFinite,
      child: TabBar(
        controller: controller.tabviewController,
        labelPadding: EdgeInsets.zero,
        labelColor: theme.colorScheme.primary,
        labelStyle: TextStyle(
          fontSize: 13.fSize,
          fontFamily: 'DM Sans',
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelColor: appTheme.blueGray900,
        unselectedLabelStyle: TextStyle(
          fontSize: 13.fSize,
          fontFamily: 'DM Sans',
          fontWeight: FontWeight.w500,
        ),
        indicatorColor: theme.colorScheme.primary,
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: [
          Tab(child: Text("lbl_delivery".tr)),
          Tab(child: Text("lbl_review".tr)),
        ],
      ),
    );
  }
}
