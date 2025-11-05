// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_title_searchview.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';
import '../filter_price_page/filter_price_page.dart';
import '../filter_sort_by_page/filter_sort_by_page.dart';
import 'controller/filter_category_controller.dart';
import 'twenty_tab_page.dart'; // ignore_for_file: must_be_immutable

class FilterCategoryScreen extends GetWidget<FilterCategoryController> {
  const FilterCategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appTheme.gray100,
      body: SafeArea(
        child: Container(
          height: 770.h,
          width: double.maxFinite,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 770.h,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _buildTopbar(),
                    Container(
                      height: 770.h,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          _buildCategorytwo(),
                          _buildBestpartners(),
                          Container(
                            height: 770.h,
                            decoration: AppDecoration.neutral900,
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                CustomImageView(
                                  imagePath: ImageConstant.imgBase,
                                  height: 446.h,
                                  width: double.maxFinite,
                                ),
                                Container(
                                  width: double.maxFinite,
                                  decoration: AppDecoration.neutral00.copyWith(
                                    borderRadius:
                                        BorderRadiusStyle.customBorderBL30,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      _buildSearchone(),
                                      SizedBox(height: 26.h),
                                      _buildContentone(),
                                      SizedBox(height: 24.h),
                                      SizedBox(
                                        width: double.maxFinite,
                                        child: Divider(),
                                      ),
                                      SizedBox(height: 24.h),
                                      _buildTabview(),
                                      _buildTabbarview(),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildTopbar() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(horizontal: 34.h, vertical: 8.h),
        decoration: AppDecoration.neutral00.copyWith(
          borderRadius: BorderRadiusStyle.customBorderBL30,
        ),
        child: Column(
          spacing: 24,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomAppBar(
              height: 44.h,
              title: SizedBox(
                width: double.maxFinite,
                child: AppbarTitleSearchview(
                  hintText: "lbl_search_on_coody".tr,
                  controller: controller.searchController,
                ),
              ),
              styleType: Style.bgFillGray100_1,
            ),
            SizedBox(
              width: double.maxFinite,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.imgSaveGray40024x24,
                          height: 24.h,
                          width: 24.h,
                          radius: BorderRadius.vertical(
                            bottom: Radius.circular(12.h),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            spacing: 4,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "lbl_delivery_to".tr,
                                style: CustomTextStyles.labelLargePrimary,
                              ),
                              SizedBox(
                                width: double.maxFinite,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "msg_1014_prospect_vall".tr,
                                        style: CustomTextStyles.bodyMedium_1,
                                      ),
                                    ),
                                    CustomImageView(
                                      imagePath: ImageConstant.imgIconPrimary,
                                      height: 12.h,
                                      width: 12.h,
                                      radius: BorderRadius.vertical(
                                        bottom: Radius.circular(6.h),
                                      ),
                                      margin: EdgeInsets.only(
                                        left: 6.h,
                                        top: 2.h,
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
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.h,
                      vertical: 8.h,
                    ),
                    decoration: AppDecoration.fs42Cardlist.copyWith(
                      borderRadius: BorderRadiusStyle.customBorderBL20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.imgUserGray40024x24,
                          height: 24.h,
                          width: 24.h,
                          radius: BorderRadius.vertical(
                            bottom: Radius.circular(12.h),
                          ),
                        ),
                        Text(
                          "lbl_filter".tr,
                          style: CustomTextStyles.labelLargeBluegray900_1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 5.h,
              width: 40.h,
              decoration: BoxDecoration(
                color: appTheme.black900.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(2.h),
              ),
            ),
            SizedBox(height: 6.h),
          ],
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildColumnline() {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        spacing: 20,
        children: [
          SizedBox(width: double.maxFinite, child: Divider()),
          SizedBox(
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    spacing: 8,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        height: 100.h,
                        width: 102.h,
                        decoration: AppDecoration.yellow50.copyWith(
                          borderRadius: BorderRadiusStyle.circleBorder50,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CustomImageView(
                              imagePath: ImageConstant.imgFrame,
                              height: 48.h,
                              width: 50.h,
                              radius: BorderRadius.circular(14.h),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 24.h),
                        child: Text(
                          "lbl_sandwich".tr,
                          style: CustomTextStyles.labelLargeBluegray900_1,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 100.h,
                  child: Column(
                    spacing: 8,
                    children: [
                      Container(
                        height: 100.h,
                        width: double.maxFinite,
                        padding: EdgeInsets.only(right: 22.h),
                        decoration: AppDecoration.yellow50.copyWith(
                          borderRadius: BorderRadiusStyle.circleBorder50,
                        ),
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            CustomImageView(
                              imagePath: ImageConstant.imgFrameAmber400,
                              height: 48.h,
                              width: 50.h,
                              radius: BorderRadius.circular(14.h),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "lbl_pizza".tr,
                        style: CustomTextStyles.labelLargeBluegray900_1,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 82.h,
                  child: Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        height: 100.h,
                        width: double.maxFinite,
                        padding: EdgeInsets.only(top: 26.h, right: 8.h),
                        decoration: AppDecoration.yellow50.copyWith(
                          borderRadius: BorderRadiusStyle.circleBorder50,
                        ),
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            CustomImageView(
                              imagePath: ImageConstant.imgCloseYellow100,
                              height: 42.h,
                              width: 50.h,
                              radius: BorderRadius.circular(14.h),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 12.h),
                        child: Text(
                          "lbl_burgers".tr,
                          style: CustomTextStyles.labelLargeBluegray900_1,
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
  Widget _buildCategorytwo() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: double.maxFinite,
        margin: EdgeInsets.only(left: 16.h, top: 182.h, right: 16.h),
        padding: EdgeInsets.symmetric(vertical: 20.h),
        decoration: AppDecoration.neutral00.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder14,
        ),
        child: Column(
          spacing: 20,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.maxFinite,
              margin: EdgeInsets.symmetric(horizontal: 18.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "lbl_category".tr,
                    style: CustomTextStyles.titleMediumBold,
                  ),
                  Text("lbl_see_all".tr, style: theme.textTheme.titleSmall),
                ],
              ),
            ),
            _buildColumnline(),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildFortyFive() {
    return CustomElevatedButton(
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
      buttonTextStyle: CustomTextStyles.labelLargeOnPrimary,
    );
  }

  /// Section Widget
  Widget _buildOne() {
    return CustomElevatedButton(
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
      buttonTextStyle: CustomTextStyles.labelLargeOnPrimary,
    );
  }

  /// Section Widget
  Widget _buildBestpartners() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.maxFinite,
        margin: EdgeInsets.symmetric(horizontal: 16.h),
        padding: EdgeInsets.symmetric(vertical: 20.h),
        decoration: AppDecoration.neutral00.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder14,
        ),
        child: Column(
          spacing: 20,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.maxFinite,
              margin: EdgeInsets.symmetric(horizontal: 20.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "lbl_best_partners".tr,
                    style: CustomTextStyles.titleMediumBold,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      "lbl_see_all".tr,
                      style: theme.textTheme.titleSmall,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: double.maxFinite, child: Divider()),
            SizedBox(
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 18.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomImageView(
                            imagePath: ImageConstant.imgImportImage116x204,
                            height: 116.h,
                            width: double.maxFinite,
                            radius: BorderRadius.circular(14.h),
                            margin: EdgeInsets.only(right: 16.h),
                          ),
                          SizedBox(height: 16.h),
                          SizedBox(
                            width: double.maxFinite,
                            child: Row(
                              children: [
                                Text(
                                  "lbl_subway".tr,
                                  style: theme.textTheme.titleLarge,
                                ),
                                CustomImageView(
                                  imagePath: ImageConstant.imgCheckmarkTeal700,
                                  height: 24.h,
                                  width: 24.h,
                                ),
                              ],
                            ),
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
                                    "msg_santa_nella_ca".tr,
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
                                _buildFortyFive(),
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
                                    "lbl_1_5km2".tr,
                                    style:
                                        CustomTextStyles
                                            .labelLargeBluegray900_1,
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
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 8.h),
                                    child: Text(
                                      "lbl_free_shipping".tr,
                                      style:
                                          CustomTextStyles
                                              .labelLargeBluegray900_1,
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
                  SizedBox(
                    width: 102.h,
                    child: Column(
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.imgImportImage116x102,
                          height: 116.h,
                          width: double.maxFinite,
                          radius: BorderRadius.circular(14.h),
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "lbl_taco_bell".tr,
                              style: theme.textTheme.titleLarge,
                            ),
                            CustomImageView(
                              imagePath: ImageConstant.imgCheckmarkTeal70024x12,
                              height: 24.h,
                              width: 12.h,
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "lbl_close".tr,
                              style: CustomTextStyles.labelLargeTeal700_2,
                            ),
                            Container(
                              height: 2.h,
                              width: 2.h,
                              decoration: BoxDecoration(
                                color: appTheme.gray400,
                                borderRadius: BorderRadius.circular(1.h),
                              ),
                            ),
                            Text(
                              "msg_santa_nella_ca".tr,
                              style: theme.textTheme.labelLarge,
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildOne(),
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
                              padding: EdgeInsets.only(left: 6.h),
                              child: Text(
                                "lbl_0_2_km".tr,
                                style: CustomTextStyles.labelLargeBluegray900_1,
                              ),
                            ),
                            CustomImageView(
                              imagePath: ImageConstant.imgOval,
                              height: 2.h,
                              width: 1.h,
                              margin: EdgeInsets.only(left: 8.h),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 14.h),
                              child: Text(
                                "lbl_free_shipping".tr,
                                style: CustomTextStyles.labelLargeBluegray900_1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildSearchone() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 34.h),
      child: CustomTextFormField(
        controller: controller.searchoneController,
        hintText: "lbl_search_on_coody".tr,
        hintStyle: CustomTextStyles.bodyMediumBluegray400_1,
        textInputAction: TextInputAction.done,
        prefix: Container(
          margin: EdgeInsets.symmetric(horizontal: 12.h, vertical: 10.h),
          child: CustomImageView(
            imagePath: ImageConstant.imgLinkedin,
            height: 24.h,
            width: 24.h,
            fit: BoxFit.contain,
          ),
        ),
        prefixConstraints: BoxConstraints(maxHeight: 44.h),
        contentPadding: EdgeInsets.fromLTRB(12.h, 10.h, 10.h, 10.h),
        borderDecoration: TextFormFieldStyleHelper.fillGrayTL14,
        fillColor: appTheme.gray100,
      ),
    );
  }

  /// Section Widget
  Widget _buildFiltertwo() {
    return CustomElevatedButton(
      height: 40.h,
      width: 80.h,
      text: "lbl_filter".tr,
      leftIcon: Container(
        margin: EdgeInsets.only(right: 4.h),
        child: CustomImageView(
          imagePath: ImageConstant.imgUser,
          height: 24.h,
          width: 24.h,
          fit: BoxFit.contain,
        ),
      ),
      buttonStyle: CustomButtonStyles.fillGrayTL14,
      buttonTextStyle: CustomTextStyles.labelLargeBluegray900_1,
    );
  }

  /// Section Widget
  Widget _buildContentone() {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 34.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgSaveGray400,
                  height: 24.h,
                  width: 24.h,
                ),
                Expanded(
                  child: Column(
                    spacing: 4,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "lbl_delivery_to".tr,
                        style: CustomTextStyles.labelLargePrimary,
                      ),
                      SizedBox(
                        width: double.maxFinite,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                "msg_1014_prospect_vall".tr,
                                style: CustomTextStyles.bodyMedium_1,
                              ),
                            ),
                            CustomImageView(
                              imagePath: ImageConstant.imgColor,
                              height: 4.h,
                              width: 6.h,
                              margin: EdgeInsets.only(left: 8.h, top: 6.h),
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
          _buildFiltertwo(),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildTabview() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 34.h),
      width: double.maxFinite,
      child: TabBar(
        controller: controller.tabviewController,
        labelPadding: EdgeInsets.zero,
        labelColor: theme.colorScheme.primary,
        labelStyle: TextStyle(
          fontSize: 14.fSize,
          fontFamily: 'DM Sans',
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelColor: appTheme.blueGray900,
        unselectedLabelStyle: TextStyle(
          fontSize: 14.fSize,
          fontFamily: 'DM Sans',
          fontWeight: FontWeight.w500,
        ),
        indicatorColor: theme.colorScheme.primary,
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: [
          Tab(child: Text("lbl_category".tr)),
          Tab(child: Text("lbl_sort_by".tr)),
          Tab(child: Text("lbl_price".tr)),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildTabbarview() {
    return Expanded(
      child: Container(
        child: TabBarView(
          controller: controller.tabviewController,
          children: [TwentyTabPage(), FilterSortByPage(), FilterPricePage()],
        ),
      ),
    );
  }
}
