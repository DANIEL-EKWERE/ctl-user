// TODO Implement this library.
import '../login_three_screen/controller/login_three_controller.dart';
import '../login_three_screen/models/model.dart';
import '../login_three_screen/models/vendors_by_category.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'controller/best_partners_vone_controller.dart';

// ignore_for_file: must_be_immutable
class BestPartnersVoneBottomsheet extends StatelessWidget {
  BestPartnersVoneBottomsheet(this.controller, this.name, {Key? key})
    : super(key: key);

  BestPartnersVoneController controller;
  String name;
  LoginThreeController controllerx = Get.find<LoginThreeController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: AppDecoration.outlineGray1001,
      child: Column(
        spacing: 18,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 2.h),
          // Container(
          //   height: 5.h,
          //   width: 40.h,
          //   decoration: BoxDecoration(
          //     color: appTheme.black900.withValues(alpha: 0.05),
          //     borderRadius: BorderRadius.circular(2.h),
          //   ),
          // ),
          Text(name, style: CustomTextStyles.titleMediumBold),
          SizedBox(height: 10.h),
          SizedBox(
            height: 240.h,
            width: double.maxFinite,
            child:
                controllerx.vendorsByCategoryItem!.isEmpty
                    ? Center(
                      child: Text(
                        'No Vendors Available for this Category',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: appTheme.gray500,
                        ),
                      ),
                    )
                    : ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: controllerx.vendorData?.length ?? 0,
                      itemBuilder: (context, index) {
                        Vendor? vendor = controllerx.vendorData?[index];
                        controllerx.vendorsByCategoryItem?[index];
                        return GestureDetector(
                          onTap:
                              () => Get.toNamed(
                                AppRoutes.detailRestaurantsVoneScreen,
                                arguments: vendor as Vendor,
                              ),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: _buildColumnnamemarke(vendor),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(height: 12.h);
                      },
                    ),
          ),
          SizedBox(height: 24.h),
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

  Widget _buildColumnnamemarke(Vendor? vendor) {
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
                  imagePath: vendor?.banner ?? ImageConstant.imgImportImage,
                  height: 172.h,
                  width: double.maxFinite,
                  radius: BorderRadius.circular(14.h),
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: double.maxFinite,
                  child: _buildNameOne(
                    namemarketOne: vendor?.businessName ?? "lbl_burger_king".tr,
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
                          vendor?.category?.name ?? "lbl_burger".tr,
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
                          vendor?.locations?.first.contactAddress ??
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
                          "${vendor?.distanceKm ?? 0} km",
                          style: theme.textTheme.labelLarge,
                        ),
                      ),
                      // Container(
                      //   height: 2.h,
                      //   width: 2.h,
                      //   margin: EdgeInsets.only(left: 8.h),
                      //   decoration: BoxDecoration(
                      //     color: appTheme.gray400,
                      //     borderRadius: BorderRadius.circular(1.h),
                      //   ),
                      // ),
                      // Padding(
                      //   padding: EdgeInsets.only(left: 8.h),
                      //   child: Text(
                      //     "lbl_rice".tr,
                      //     style: theme.textTheme.labelLarge,
                      //   ),
                      // ),
                      // Container(
                      //   height: 2.h,
                      //   width: 2.h,
                      //   margin: EdgeInsets.only(left: 8.h),
                      //   decoration: BoxDecoration(
                      //     color: appTheme.gray400,
                      //     borderRadius: BorderRadius.circular(1.h),
                      //   ),
                      // ),
                      // Padding(
                      //   padding: EdgeInsets.only(left: 8.h),
                      //   child: Text(
                      //     "lbl_spaghetti".tr,
                      //     style: theme.textTheme.labelLarge,
                      //   ),
                      // ),
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
