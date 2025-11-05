// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:country_pickers/country.dart';
import '../../core/app_export.dart';
import '../../core/utils/validation_functions.dart';
import '../../domain/facebookauth/facebook_auth_helper.dart';
import '../../domain/googleauth/google_auth_helper.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_checkbox_button.dart';
import '../../widgets/custom_drop_down.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_outlined_button.dart';
import '../../widgets/custom_phone_number.dart';
import '../../widgets/custom_text_form_field.dart';
import 'controller/signup_controller.dart';

// ignore_for_file: must_be_immutable
class SignupScreen extends GetWidget<SignupController> {
  SignupScreen({Key? key}) : super(key: key);

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colorScheme.onPrimary,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Container(
                width: double.maxFinite,
                padding: EdgeInsets.only(left: 16.h, top: 20.h, right: 16.h),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "msg_create_an_account".tr,
                        style: CustomTextStyles.titleLargeMontPrimarySemiBold,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "msg_welcome_please".tr,
                        style: CustomTextStyles.bodyMediumMontGray900,
                      ),
                    ),
                    SizedBox(height: 22.h),
                    _buildName(),
                    SizedBox(height: 20.h),
                    _buildLastName(),
                    SizedBox(height: 20.h),
                    Container(
                      width: double.maxFinite,
                      margin: EdgeInsets.only(right: 2.h),
                      child: _buildPhoneNumber(),
                    ),
                    SizedBox(height: 20.h),
                    _buildEmail(),
                    SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.only(right: 2.h),
                      child: CustomDropDown(
                        hintText: "lbl_country".tr,
                        hintStyle:
                            CustomTextStyles.titleSmallMontOnPrimaryContainer_2,
                        items:
                            controller
                                .signupModelObj
                                .value
                                .dropdownItemList!
                                .value,
                        contentPadding: EdgeInsets.all(16.h),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    _buildPassword(),
                    SizedBox(height: 20.h),
                    _buildConfirmpassword(),
                    SizedBox(height: 20.h),
                    _buildRowagreeto(),
                    SizedBox(height: 36.h),
                    _buildSignup(),
                    SizedBox(height: 36.h),
                    Container(
                      width: double.maxFinite,
                      margin: EdgeInsets.symmetric(horizontal: 62.h),
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
                    SizedBox(height: 52.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "msg_already_have_an".tr,
                          style:
                              CustomTextStyles.labelLargeMontOnPrimaryContainer,
                        ),
                        Text(
                          "lbl_log_in".tr,
                          style: CustomTextStyles.labelLargeMontPrimary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildName() {
    return Padding(
      padding: EdgeInsets.only(right: 2.h),
      child: CustomTextFormField(
        controller: controller.nameController,
        hintText: "lbl_frist_name".tr,
        contentPadding: EdgeInsets.all(16.h),
        validator: (value) {
          if (!isText(value)) {
            return "err_msg_please_enter_valid_text".tr;
          }
          return null;
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildLastName() {
    return Padding(
      padding: EdgeInsets.only(right: 2.h),
      child: CustomTextFormField(
        controller: controller.lastNameController,
        hintText: "lbl_last_name".tr,
        contentPadding: EdgeInsets.all(16.h),
        validator: (value) {
          if (!isText(value)) {
            return "err_msg_please_enter_valid_text".tr;
          }
          return null;
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildPhoneNumber() {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(right: 2.h),
      child: Obx(
        () => CustomPhoneNumber(
          country: controller.selectedCountry.value,
          controller: controller.phoneNumberController,
          onTap: (Country value) {
            controller.selectedCountry.value = value;
          },
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildEmail() {
    return Padding(
      padding: EdgeInsets.only(right: 2.h),
      child: CustomTextFormField(
        controller: controller.emailController,
        hintText: "lbl_email".tr,
        textInputType: TextInputType.emailAddress,
        contentPadding: EdgeInsets.all(16.h),
        validator: (value) {
          if (value == null || (!isValidEmail(value, isRequired: true))) {
            return "err_msg_please_enter_valid_email".tr;
          }
          return null;
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildPassword() {
    return Padding(
      padding: EdgeInsets.only(right: 2.h),
      child: CustomTextFormField(
        controller: controller.passwordController,
        hintText: "lbl_password".tr,
        textInputType: TextInputType.visiblePassword,
        obscureText: true,
        contentPadding: EdgeInsets.all(16.h),
        validator: (value) {
          if (value == null || (!isValidPassword(value, isRequired: true))) {
            return "err_msg_please_enter_valid_password".tr;
          }
          return null;
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildConfirmpassword() {
    return Padding(
      padding: EdgeInsets.only(right: 2.h),
      child: CustomTextFormField(
        controller: controller.confirmpasswordController,
        hintText: "msg_confirm_password".tr,
        textInputAction: TextInputAction.done,
        textInputType: TextInputType.visiblePassword,
        obscureText: true,
        contentPadding: EdgeInsets.all(16.h),
        validator: (value) {
          if (value == null || (!isValidPassword(value, isRequired: true))) {
            return "err_msg_please_enter_valid_password".tr;
          }
          return null;
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildRowagreeto() {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        children: [
          Obx(
            () => CustomCheckboxButton(
              text: "lbl_agree_to".tr,
              value: controller.agreetoone.value,
              onChange: (value) {
                controller.agreetoone.value = value;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 4.h),
            child: Text(
              "msg_terms_of_services".tr,
              style: CustomTextStyles.labelMediumMontBlueA400,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 4.h),
            child: Text(
              "lbl".tr,
              style: CustomTextStyles.labelMediumMontBlack900Medium,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 4.h),
            child: Text(
              "lbl_privacy_policy".tr,
              style: CustomTextStyles.labelMediumMontBlueA400,
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildSignup() {
    return CustomOutlinedButton(
      text: "lbl_sign_up".tr,
      margin: EdgeInsets.only(right: 2.h),
      buttonStyle: CustomButtonStyles.outlineOnPrimaryContainer,
      buttonTextStyle: CustomTextStyles.titleSmallMontOnPrimaryContainer,
      onPressed: () {
        onTapSignup();
      },
    );
  }

  /// Navigates to the signupOneScreen when the action is triggered.
  onTapSignup() {
    Get.toNamed(AppRoutes.signupOneScreen);
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
