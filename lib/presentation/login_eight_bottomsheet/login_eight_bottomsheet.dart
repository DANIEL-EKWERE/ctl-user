// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../core/utils/date_time_utils.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'controller/login_eight_controller.dart';

// ignore_for_file: must_be_immutable
class LoginEightBottomsheet extends StatelessWidget {
  LoginEightBottomsheet(this.controller, {Key? key}) : super(key: key);

  LoginEightController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: AppDecoration.neutral00.copyWith(
        borderRadius: BorderRadiusStyle.customBorderTL30,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: SizedBox(
                width: double.maxFinite,
                child: Column(
                  children: [
                    Container(
                      height: 4.h,
                      width: 40.h,
                      decoration: BoxDecoration(
                        color: appTheme.black900.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(2.h),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      "msg_add_your_payment".tr,
                      style: CustomTextStyles.titleMediumBold_2,
                    ),
                    SizedBox(height: 24.h),
                    SizedBox(
                      width: double.maxFinite,
                      child: Divider(color: appTheme.blueGray50),
                    ),
                    SizedBox(height: 24.h),
                    _buildCreditcardone(),
                    SizedBox(height: 14.h),
                    Container(
                      width: double.maxFinite,
                      margin: EdgeInsets.symmetric(horizontal: 36.h),
                      child: Row(children: [_buildMmyyone(), _buildCvcone()]),
                    ),
                    SizedBox(height: 32.h),
                    _buildAddcard(),
                    SizedBox(height: 8.h),
                    _buildScancard(),
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
  Widget _buildCreditcardone() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 36.h),
      child: CustomTextFormField(
        controller: controller.creditcardoneController,
        hintText: "msg_3999_1234_5678".tr,
        hintStyle: theme.textTheme.bodyMedium!,
        prefix: Container(
          margin: EdgeInsets.symmetric(horizontal: 12.h, vertical: 10.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.h)),
          ),
          child: CustomImageView(
            imagePath: ImageConstant.imgIconFinanceSecurityCreditcard,
            height: 24.h,
            width: 24.h,
            fit: BoxFit.contain,
          ),
        ),
        prefixConstraints: BoxConstraints(maxHeight: 46.h),
        suffix: Container(
          margin: EdgeInsets.fromLTRB(16.h, 10.h, 10.h, 10.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.h)),
          ),
          child: CustomImageView(
            imagePath: ImageConstant.imgCheckmark24x24,
            height: 24.h,
            width: 24.h,
            fit: BoxFit.contain,
          ),
        ),
        suffixConstraints: BoxConstraints(maxHeight: 46.h),
        contentPadding: EdgeInsets.fromLTRB(12.h, 10.h, 10.h, 10.h),
        borderDecoration: TextFormFieldStyleHelper.fillGray,
        fillColor: appTheme.gray100,
      ),
    );
  }

  /// Section Widget
  Widget _buildMmyyone() {
    return Expanded(
      child: CustomTextFormField(
        readOnly: true,
        controller: controller.mmyyoneController,
        hintText: "lbl_mm_yy".tr,
        hintStyle: CustomTextStyles.bodyMediumBluegray400_3,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 10.h),
        borderDecoration: TextFormFieldStyleHelper.fillGray,
        fillColor: appTheme.gray100,
        onTap: () {
          onTapMmyyone();
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildCvcone() {
    return Expanded(
      child: CustomTextFormField(
        controller: controller.cvconeController,
        hintText: "lbl_cvc".tr,
        hintStyle: CustomTextStyles.bodyMediumBluegray400_3,
        textInputAction: TextInputAction.done,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 10.h),
        borderDecoration: TextFormFieldStyleHelper.fillGray,
        fillColor: appTheme.gray100,
      ),
    );
  }

  /// Section Widget
  Widget _buildAddcard() {
    return CustomElevatedButton(
      height: 46.h,
      text: "lbl_add_card".tr,
      margin: EdgeInsets.symmetric(horizontal: 36.h),
      buttonStyle: CustomButtonStyles.fillPrimaryTL22,
      buttonTextStyle: CustomTextStyles.titleSmallOnPrimary,
    );
  }

  /// Section Widget
  Widget _buildScancard() {
    return CustomElevatedButton(
      height: 46.h,
      text: "lbl_scan_card".tr,
      margin: EdgeInsets.symmetric(horizontal: 36.h),
      buttonStyle: CustomButtonStyles.fillGrayTL22,
      buttonTextStyle: theme.textTheme.titleSmall!,
    );
  }

  /// Displays a date picker dialog and updates the selected date in the
  /// [loginEightModelObj] object of the current [mmyyoneController] if the user
  /// selects a valid date.
  ///
  /// This function returns a `Future` that completes with `void`.
  Future<void> onTapMmyyone() async {
    DateTime? dateTime = await showDatePicker(
      context: Get.context!,
      initialDate: controller.loginEightModelObj.value.selectedMmyyOne!.value,
      firstDate: DateTime(1970),
      lastDate: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ),
    );
    if (dateTime != null) {
      controller.loginEightModelObj.value.selectedMmyyOne!.value = dateTime;
      controller.mmyyoneController.text = dateTime.format(
        pattern: dateTimeFormatPattern,
      );
    }
  }
}
