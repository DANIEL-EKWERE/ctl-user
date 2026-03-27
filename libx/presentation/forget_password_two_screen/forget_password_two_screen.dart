// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../core/utils/validation_functions.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'controller/forget_password_two_controller.dart';

// ignore_for_file: must_be_immutable
class ForgetPasswordTwoScreen extends GetWidget<ForgetPasswordTwoController> {
  ForgetPasswordTwoScreen({Key? key}) : super(key: key);

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.colorScheme.onPrimary,
      appBar: _buildAppbar(),
      body: SafeArea(
        top: false,
        child: SizedBox(
          height: SizeUtils.height,
          child: Form(
            key: _formKey,
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(horizontal: 14.h),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "msg_enter_your_registered".tr,
                    style: CustomTextStyles.titleSmallMontGray90015_1,
                  ),
                  SizedBox(height: 20.h),
                  CustomTextFormField(
                    controller: controller.emailController,
                    hintText: "msg_jacobpeter_gmai_com".tr,
                    hintStyle: CustomTextStyles.titleSmallMontGray900_2,
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.emailAddress,
                    contentPadding: EdgeInsets.all(16.h),
                    borderDecoration: TextFormFieldStyleHelper.outlineGrayTL8,
                    validator: (value) {
                      if (value == null ||
                          (!isValidEmail(value, isRequired: true))) {
                        return "err_msg_please_enter_valid_email".tr;
                      }
                      return null;
                    },
                  ),
                  Spacer(),
                  CustomElevatedButton(
                    text: "lbl_verify".tr,
                    buttonStyle: CustomButtonStyles.fillPrimary,
                    buttonTextStyle:
                        CustomTextStyles.titleSmallMontOnPrimaryExtraBold,
                    onPressed: () {
                      onTapVerify();
                    },
                  ),
                ],
              ),
            ),
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
      title: AppbarSubtitle(
        text: "lbl_forget_password".tr,
        margin: EdgeInsets.only(left: 10.h),
      ),
    );
  }

  /// Navigates to the previous screen.
  onTapArrowleftone() {
    Get.back();
  }

  /// Navigates to the falseForgotPasswordOtpScreen when the action is triggered.
  onTapVerify() {
    Get.toNamed(AppRoutes.falseForgotPasswordOtpScreen);
  }
}
