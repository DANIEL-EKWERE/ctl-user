// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';
import 'controller/filter_sort_by_controller.dart';
import 'models/filter_sort_by_model.dart';

// ignore_for_file: must_be_immutable
class FilterSortByPage extends StatelessWidget {
  FilterSortByPage({Key? key}) : super(key: key);

  FilterSortByController controller = Get.put(
    FilterSortByController(FilterSortByModel().obs),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: SafeArea(child: _buildScrollview()),
    );
  }

  /// Section Widget
  Widget _buildScrollview() {
    return SingleChildScrollView(
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(horizontal: 34.h, vertical: 12.h),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: 12.h),
            SizedBox(
              width: double.maxFinite,
              child: Column(
                spacing: 24,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.h,
                      vertical: 10.h,
                    ),
                    decoration: AppDecoration.fs42Cardlist.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder14,
                    ),
                    width: double.maxFinite,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.imgBookmark,
                          height: 24.h,
                          width: 26.h,
                          radius: BorderRadius.circular(12.h),
                          margin: EdgeInsets.only(left: 2.h),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 12.h),
                          child: Text(
                            "lbl_recomended".tr,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                        Spacer(),
                        CustomImageView(
                          imagePath: ImageConstant.imgCheckmarkTeal70024x24,
                          height: 24.h,
                          width: 26.h,
                          radius: BorderRadius.circular(12.h),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.h,
                      vertical: 10.h,
                    ),
                    decoration: AppDecoration.fs42Cardlist.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder14,
                    ),
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.imgClock,
                          height: 24.h,
                          width: 24.h,
                          radius: BorderRadius.circular(12.h),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 12.h),
                          child: Text(
                            "msg_fastest_delivery".tr,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.h,
                      vertical: 10.h,
                    ),
                    decoration: AppDecoration.fs42Cardlist.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder14,
                    ),
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.imgFire,
                          height: 24.h,
                          width: 24.h,
                          radius: BorderRadius.circular(12.h),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 12.h),
                          child: Text(
                            "lbl_most_popular".tr,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomElevatedButton(text: "lbl_complete".tr),
                  Container(
                    height: 5.h,
                    width: 40.h,
                    decoration: BoxDecoration(
                      color: appTheme.black900.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(2.h),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
