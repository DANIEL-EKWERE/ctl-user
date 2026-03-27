// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_outlined_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'controller/new_password_one_controller.dart'; // ignore_for_file: must_be_immutable

class NewPasswordOneScreen extends GetWidget<NewPasswordOneController> {
  const NewPasswordOneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.colorScheme.onPrimary,
      appBar: _buildAppbar(),
      body: SafeArea(
        top: false,
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 2.h),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "msg_enter_a_new_password".tr,
                style: CustomTextStyles.titleSmallMontGray90015_1,
              ),
              SizedBox(height: 34.h),
              _buildColumnnewpasswo(),
              SizedBox(height: 32.h),
              _buildColumnconfrim(),
              Spacer(),
              CustomOutlinedButton(
                text: "lbl_submit".tr,
                buttonStyle: CustomButtonStyles.fillPrimary,
                buttonTextStyle: CustomTextStyles.titleSmallMontOnPrimaryBold,
                onPressed: () {
                  controller.passwordController.text.isNotEmpty ||
                          controller.newpasswordController.text.isNotEmpty ||
                          (controller.passwordController.text.isNotEmpty !=
                              controller.newpasswordController.text.isNotEmpty)
                      ? onTapSubmit()
                      : Get.snackbar(
                        'Opps',
                        'Fields can\'t be empty and password must be same',
                      );
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppbar() {
    return CustomAppBar(
      leadingWidth: 23.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeft,
        margin: EdgeInsets.only(left: 15.h),
        onTap: () {
          onTapArrowleftone();
        },
      ),
      title: AppbarTitle(
        text: "lbl_new_password".tr,
        margin: EdgeInsets.only(left: 18.h),
      ),
    );
  }

  /// Section Widget
  Widget _buildColumnnewpasswo() {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        spacing: 4,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "lbl_new_password".tr,
            style: CustomTextStyles.bodyMediumMontGray900,
          ),
          Obx(
            () => CustomTextFormField(
              controller: controller.newpasswordController,
              suffix: InkWell(
                onTap: () {
                  controller.isShowPassword.value =
                      !controller.isShowPassword.value;
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(16.h, 18.h, 14.h, 18.h),
                  child: CustomImageView(
                    imagePath: ImageConstant.imgEyecrossed1,
                    height: 12.h,
                    width: 14.h,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              suffixConstraints: BoxConstraints(maxHeight: 50.h),
              obscureText: controller.isShowPassword.value,
              contentPadding: EdgeInsets.fromLTRB(16.h, 18.h, 14.h, 18.h),
              borderDecoration: TextFormFieldStyleHelper.outlineGray2,
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildColumnconfrim() {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        spacing: 4,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "msg_confrim_password".tr,
            style: CustomTextStyles.bodyMediumMontGray900,
          ),
          Obx(
            () => CustomTextFormField(
              controller: controller.passwordController,
              textInputAction: TextInputAction.done,
              suffix: InkWell(
                onTap: () {
                  controller.isShowPassword1.value =
                      !controller.isShowPassword1.value;
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(16.h, 18.h, 14.h, 18.h),
                  child: CustomImageView(
                    imagePath: ImageConstant.imgEyecrossed1,
                    height: 12.h,
                    width: 14.h,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              suffixConstraints: BoxConstraints(maxHeight: 50.h),
              obscureText: controller.isShowPassword1.value,
              contentPadding: EdgeInsets.fromLTRB(16.h, 18.h, 14.h, 18.h),
              borderDecoration: TextFormFieldStyleHelper.outlineGray2,
            ),
          ),
        ],
      ),
    );
  }

  /// Navigates to the previous screen.
  onTapArrowleftone() {
    Get.back();
  }

  /// Navigates to the newPasswordTwoScreen when the action is triggered.
  onTapSubmit() {
    Get.toNamed(AppRoutes.loginScreen);
  }
}
