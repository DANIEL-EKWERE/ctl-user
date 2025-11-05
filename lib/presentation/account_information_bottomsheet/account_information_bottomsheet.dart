// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../core/utils/validation_functions.dart';
import '../../widgets/custom_text_form_field.dart';
import 'controller/account_information_controller.dart';

// ignore_for_file: must_be_immutable
class AccountInformationBottomsheet extends StatelessWidget {
  AccountInformationBottomsheet(this.controller, {Key? key}) : super(key: key);

  AccountInformationController controller;

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
              _buildColumnlineone(),
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
  Widget _buildColumnlineone() {
    return Container(
      width: double.maxFinite,
      decoration: AppDecoration.neutral00,
      child: Column(
        spacing: 18,
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
            "msg_account_information".tr,
            style: CustomTextStyles.titleMediumBold,
          ),
        ],
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
          Text("lbl_full_name".tr, style: CustomTextStyles.titleSmallGray400),
          CustomTextFormField(
            controller: controller.fullNameController,
            hintText: "msg_philippe_troussier".tr,
            hintStyle: theme.textTheme.bodyMedium!,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.h,
              vertical: 10.h,
            ),
            borderDecoration: TextFormFieldStyleHelper.fillGrayTL14,
            fillColor: appTheme.gray100,
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
            "lbl_email_address".tr,
            style: CustomTextStyles.titleSmallGray400,
          ),
          CustomTextFormField(
            controller: controller.emailController,
            hintText: "msg_troussier_gmail_com".tr,
            hintStyle: theme.textTheme.bodyMedium!,
            textInputType: TextInputType.emailAddress,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.h,
              vertical: 10.h,
            ),
            borderDecoration: TextFormFieldStyleHelper.fillGrayTL14,
            fillColor: appTheme.gray100,
            validator: (value) {
              if (value == null || (!isValidEmail(value, isRequired: true))) {
                return "err_msg_please_enter_valid_email".tr;
              }
              return null;
            },
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
            "lbl_phone_number".tr,
            style: CustomTextStyles.titleSmallGray400,
          ),
          CustomTextFormField(
            controller: controller.phoneNumberController,
            hintText: "lbl_1_6102347305".tr,
            hintStyle: theme.textTheme.bodyMedium!,
            textInputAction: TextInputAction.done,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.h,
              vertical: 10.h,
            ),
            borderDecoration: TextFormFieldStyleHelper.fillGrayTL14,
            fillColor: appTheme.gray100,
          ),
        ],
      ),
    );
  }
}
