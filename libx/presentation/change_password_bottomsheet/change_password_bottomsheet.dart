// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../core/utils/validation_functions.dart';
import '../../widgets/custom_text_form_field.dart';
import 'controller/change_password_controller.dart';

// ignore_for_file: must_be_immutable
class ChangePasswordBottomsheet extends StatelessWidget {
  ChangePasswordBottomsheet(this.controller, {Key? key}) : super(key: key);

  ChangePasswordController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            spacing: 22,
            children: [
              Container(
                height: 5.h,
                width: 40.h,
                decoration: BoxDecoration(
                  color: appTheme.black900.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(2.h),
                ),
              ),
              Text(
                "lbl_change_password".tr,
                style: CustomTextStyles.titleMediumBold,
              ),
              SizedBox(width: double.maxFinite, child: Divider()),
              _buildItem(),
              SizedBox(
                width: double.maxFinite,
                child: Divider(indent: 34.h, endIndent: 34.h),
              ),
              _buildItemone(),
              SizedBox(
                width: double.maxFinite,
                child: Divider(indent: 34.h, endIndent: 34.h),
              ),
              _buildItemtwo(),
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildItem() {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 34.h),
      child: Column(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("lbl_password".tr, style: CustomTextStyles.titleSmallGray400),
          Obx(
            () => CustomTextFormField(
              controller: controller.passwordController,
              hintText: "msg".tr,
              hintStyle: theme.textTheme.bodyMedium!,
              textInputType: TextInputType.visiblePassword,
              suffix: InkWell(
                onTap: () {
                  controller.isShowPassword.value =
                      !controller.isShowPassword.value;
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(16.h, 10.h, 10.h, 10.h),
                  child: CustomImageView(
                    imagePath: ImageConstant.imgEye,
                    height: 24.h,
                    width: 24.h,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              suffixConstraints: BoxConstraints(maxHeight: 44.h),
              obscureText: controller.isShowPassword.value,
              contentPadding: EdgeInsets.fromLTRB(12.h, 10.h, 10.h, 10.h),
              borderDecoration: TextFormFieldStyleHelper.fillGrayTL14,
              fillColor: appTheme.gray100,
              validator: (value) {
                if (value == null ||
                    (!isValidPassword(value, isRequired: true))) {
                  return "err_msg_please_enter_valid_password".tr;
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildItemone() {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 34.h),
      child: Column(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "lbl_new_password".tr,
            style: CustomTextStyles.titleSmallGray400,
          ),
          Obx(
            () => CustomTextFormField(
              controller: controller.newpasswordController,
              hintText: "msg2".tr,
              hintStyle: theme.textTheme.bodyMedium!,
              textInputType: TextInputType.visiblePassword,
              suffix: InkWell(
                onTap: () {
                  controller.isShowPassword1.value =
                      !controller.isShowPassword1.value;
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(16.h, 10.h, 10.h, 10.h),
                  child: CustomImageView(
                    imagePath: ImageConstant.imgEye,
                    height: 24.h,
                    width: 24.h,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              suffixConstraints: BoxConstraints(maxHeight: 44.h),
              obscureText: controller.isShowPassword1.value,
              contentPadding: EdgeInsets.fromLTRB(12.h, 10.h, 10.h, 10.h),
              borderDecoration: TextFormFieldStyleHelper.fillGrayTL14,
              fillColor: appTheme.gray100,
              validator: (value) {
                if (value == null ||
                    (!isValidPassword(value, isRequired: true))) {
                  return "err_msg_please_enter_valid_password".tr;
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildItemtwo() {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 34.h),
      child: Column(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "msg_confirm_password2".tr,
            style: CustomTextStyles.titleSmallGray400,
          ),
          Obx(
            () => CustomTextFormField(
              controller: controller.confirmpasswordController,
              hintText: "msg2".tr,
              hintStyle: theme.textTheme.bodyMedium!,
              textInputAction: TextInputAction.done,
              textInputType: TextInputType.visiblePassword,
              suffix: InkWell(
                onTap: () {
                  controller.isShowPassword2.value =
                      !controller.isShowPassword2.value;
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(16.h, 10.h, 10.h, 10.h),
                  child: CustomImageView(
                    imagePath: ImageConstant.imgEye,
                    height: 24.h,
                    width: 24.h,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              suffixConstraints: BoxConstraints(maxHeight: 44.h),
              obscureText: controller.isShowPassword2.value,
              contentPadding: EdgeInsets.fromLTRB(12.h, 10.h, 10.h, 10.h),
              borderDecoration: TextFormFieldStyleHelper.fillGrayTL14,
              fillColor: appTheme.gray100,
              validator: (value) {
                if (value == null ||
                    (!isValidPassword(value, isRequired: true))) {
                  return "err_msg_please_enter_valid_password".tr;
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
