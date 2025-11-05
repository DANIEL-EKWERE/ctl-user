// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_rating_bar.dart';
import '../../widgets/custom_text_form_field.dart';
import 'controller/rate_drive_controller.dart';
import 'models/chipviewlabel_item_model.dart';
import 'widgets/chipviewlabel_item_widget.dart';

// ignore_for_file: must_be_immutable
class RateDriveBottomsheet extends StatelessWidget {
  RateDriveBottomsheet(this.controller, {Key? key}) : super(key: key);

  RateDriveController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: AppDecoration.neutral900,
      child: Column(
        children: [
          SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: SizedBox(
                width: double.maxFinite,
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
                    Text(
                      "lbl_rate_driver".tr,
                      style: CustomTextStyles.titleMediumBold,
                    ),
                    SizedBox(height: 24.h),
                    SizedBox(
                      width: double.maxFinite,
                      child: Divider(color: appTheme.blueGray50),
                    ),
                    SizedBox(height: 34.h),
                    CustomImageView(
                      imagePath: ImageConstant.imgEllipse880x80,
                      height: 80.h,
                      width: 82.h,
                      radius: BorderRadius.circular(40.h),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "msg_philippe_troussier".tr,
                      style: theme.textTheme.titleMedium,
                    ),
                    SizedBox(height: 8.h),
                    CustomRatingBar(initialRating: 0, itemSize: 24),
                    SizedBox(height: 4.h),
                    Text("lbl_excellent".tr, style: theme.textTheme.labelLarge),
                    SizedBox(height: 32.h),
                    SizedBox(width: double.maxFinite, child: Divider()),
                    SizedBox(height: 30.h),
                    _buildChipviewlabel(),
                    SizedBox(height: 30.h),
                    SizedBox(width: double.maxFinite, child: Divider()),
                    SizedBox(height: 30.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 34.h),
                      child: CustomTextFormField(
                        controller: controller.commentController,
                        hintText: "msg_do_you_have_something".tr,
                        hintStyle: CustomTextStyles.bodyMediumBluegray900,
                        textInputAction: TextInputAction.done,
                        maxLines: 4,
                        contentPadding: EdgeInsets.fromLTRB(
                          24.h,
                          24.h,
                          24.h,
                          22.h,
                        ),
                        borderDecoration: TextFormFieldStyleHelper.fillGrayTL14,
                        fillColor: appTheme.gray100,
                      ),
                    ),
                    SizedBox(height: 54.h),
                    CustomElevatedButton(
                      text: "lbl_next".tr,
                      margin: EdgeInsets.symmetric(horizontal: 34.h),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 18.h),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildChipviewlabel() {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 34.h),
      child: Obx(
        () => Wrap(
          runSpacing: 6.h,
          spacing: 6.h,
          children: List<Widget>.generate(
            controller
                .rateDriveModelObj
                .value
                .chipviewlabelItemList
                .value
                .length,
            (index) {
              ChipviewlabelItemModel model =
                  controller
                      .rateDriveModelObj
                      .value
                      .chipviewlabelItemList
                      .value[index];
              return ChipviewlabelItemWidget(model);
            },
          ),
        ),
      ),
    );
  }
}
