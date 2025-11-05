// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../core/utils/validation_functions.dart';
import '../../domain/facebookauth/facebook_auth_helper.dart';
import '../../domain/googleauth/google_auth_helper.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_checkbox_button.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'controller/login_controller.dart';

// ignore_for_file: must_be_immutable
class LoginScreen extends GetWidget<LoginController> {
  LoginScreen({Key? key}) : super(key: key);

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.colorScheme.onPrimary,
      body: SafeArea(
        child: SizedBox(
          height: SizeUtils.height,
          child: Form(
            key: _formKey,
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsets.only(left: 14.h, top: 22.h, right: 14.h),
              child: Column(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: double.maxFinite,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "msg_access_your_account".tr,
                            style:
                                CustomTextStyles.titleLargeMontPrimarySemiBold,
                          ),
                          Text(
                            "msg_please_enter_your".tr,
                            style: CustomTextStyles.bodyMediumMontGray900,
                          ),
                          SizedBox(height: 22.h),
                          Padding(
                            padding: EdgeInsets.only(right: 4.h),
                            child: CustomTextFormField(
                              controller: controller.emailController,
                              hintText: "lbl_email".tr,
                              textInputType: TextInputType.emailAddress,
                              contentPadding: EdgeInsets.all(16.h),
                              validator: (value) {
                                if (value == null ||
                                    (!isValidEmail(value, isRequired: true))) {
                                  return "err_msg_please_enter_valid_email".tr;
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Padding(
                            padding: EdgeInsets.only(right: 4.h),
                            child: Obx(
                              () => CustomTextFormField(
                                controller: controller.visibleoneController,
                                textInputAction: TextInputAction.done,
                                suffix: InkWell(
                                  onTap: () {
                                    controller.isShowPassword.value =
                                        !controller.isShowPassword.value;
                                  },
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(
                                      16.h,
                                      18.h,
                                      14.h,
                                      18.h,
                                    ),
                                    child: CustomImageView(
                                      imagePath: ImageConstant.imgVisible,
                                      height: 12.h,
                                      width: 14.h,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                suffixConstraints: BoxConstraints(
                                  maxHeight: 50.h,
                                ),
                                obscureText: controller.isShowPassword.value,
                                contentPadding: EdgeInsets.fromLTRB(
                                  16.h,
                                  18.h,
                                  14.h,
                                  18.h,
                                ),
                                borderDecoration:
                                    TextFormFieldStyleHelper.outlineGray1,
                                fillColor: appTheme.gray500,
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          _buildKeepmeloginone(),
                          SizedBox(height: 40.h),
                          CustomElevatedButton(
                            text: "lbl_log_in".tr,
                            margin: EdgeInsets.only(right: 4.h),
                            buttonStyle: CustomButtonStyles.fillPrimary,
                            buttonTextStyle:
                                CustomTextStyles.titleSmallMontOnPrimaryBold,
                            onPressed: () {
                              onTapLogin();
                            },
                          ),
                          SizedBox(height: 40.h),
                          _buildRowvectorone(),
                          SizedBox(height: 30.h),
                          Container(
                            width: double.maxFinite,
                            margin: EdgeInsets.only(left: 62.h, right: 66.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomIconButton(
                                  height: 62.h,
                                  width: 62.h,
                                  padding: EdgeInsets.all(16.h),
                                  decoration: IconButtonStyleHelper.none,
                                  child: CustomImageView(
                                    imagePath: ImageConstant.imgGroup13,
                                  ),
                                ),
                                CustomIconButton(
                                  height: 62.h,
                                  width: 62.h,
                                  padding: EdgeInsets.all(16.h),
                                  decoration: IconButtonStyleHelper.none,
                                  onTap: () {
                                    onTapBtnGoogleone();
                                  },
                                  child: CustomImageView(
                                    imagePath: ImageConstant.imgGoogle,
                                  ),
                                ),
                                CustomIconButton(
                                  height: 62.h,
                                  width: 62.h,
                                  padding: EdgeInsets.all(16.h),
                                  decoration: IconButtonStyleHelper.none,
                                  onTap: () {
                                    onTapBtnFacebookone();
                                  },
                                  child: CustomImageView(
                                    imagePath: ImageConstant.imgFacebook,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          Align(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "msg_i_don_t_have_an".tr,
                                  style:
                                      CustomTextStyles
                                          .labelLargeMontOnPrimaryContainer,
                                ),
                                Text(
                                  "lbl_sign_up".tr,
                                  style: CustomTextStyles.labelLargeMontPrimary,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 60.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildKeepmeloginone() {
    return Obx(
      () => CustomCheckboxButton(
        text: "lbl_keep_me_log_in".tr,
        value: controller.keepmeloginone.value,
        onChange: (value) {
          controller.keepmeloginone.value = value;
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildRowvectorone() {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(left: 8.h, right: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: 6.h),
              child: Divider(color: appTheme.gray700),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              "lbl_or_log_in_with".tr,
              style: CustomTextStyles.labelMediumMontBlack900Medium,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: 6.h),
              child: Divider(color: appTheme.gray700),
            ),
          ),
        ],
      ),
    );
  }

  /// Navigates to the forgetPasswordOneScreen when the action is triggered.
  onTapLogin() {
    Get.toNamed(AppRoutes.forgetPasswordOneScreen);
  }

  onTapBtnGoogleone() async {
    await GoogleAuthHelper()
        .googleSignInProcess()
        .then((googleUser) {
          if (googleUser != null) {
          } else {
            Get.snackbar('Error', 'user data is empty');
          }
        })
        .catchError((onError) {
          Get.snackbar('Error', onError.toString());
        });
  }

  onTapBtnFacebookone() async {
    await FacebookAuthHelper()
        .facebookSignInProcess()
        .then((facebookUser) {})
        .catchError((onError) {
          Get.snackbar('Error', onError.toString());
        });
  }
}
