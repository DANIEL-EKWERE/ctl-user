// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_pin_code_text_field.dart';
import 'controller/forgot_password_otp_controller.dart'; // ignore_for_file: must_be_immutable

class ForgotPasswordOtpScreen extends GetWidget<ForgotPasswordOtpController> {
  const ForgotPasswordOtpScreen({Key? key}) : super(key: key);

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
          padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 10.h),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "msg_we_have_sent_a_con".tr,
                      style: CustomTextStyles.titleSmallMontGray90015,
                    ),
                    TextSpan(
                      text: "lbl_fi".tr,
                      style: CustomTextStyles.titleSmallMontGray90015,
                    ),
                    TextSpan(
                      text: "msg_rmation_code_to".tr,
                      style: CustomTextStyles.titleSmallMontGray90015,
                    ),
                    TextSpan(
                      text: "lbl_jacobpeter".tr,
                      style: CustomTextStyles.titleSmallMontGray900Bold,
                    ),
                    TextSpan(
                      text: "lbl3".tr,
                      style: CustomTextStyles.titleSmallMontGray900SemiBold,
                    ),
                    TextSpan(
                      text: "lbl_gmail_com".tr,
                      style: CustomTextStyles.titleSmallMontGray900Bold,
                    ),
                  ],
                ),
                textAlign: TextAlign.left,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 28.h),
              Container(
                width: double.maxFinite,
                margin: EdgeInsets.only(right: 16.h),
                child: Obx(
                  () => CustomPinCodeTextField(
                    context: Get.context!,
                    controller: controller.otpController.value,
                    onChanged: (value) {},
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "msg_didn_t_receive_email".tr,
                      style: CustomTextStyles.labelMediumMontBlack900,
                    ),
                    TextSpan(
                      text: "msg_send_a_new_email".tr,
                      style: CustomTextStyles.labelMediumMontBlueA40011,
                    ),
                  ],
                ),
                textAlign: TextAlign.left,
              ),
              Spacer(),
              CustomElevatedButton(
                text: "lbl_submit".tr,
                buttonStyle: CustomButtonStyles.fillPrimary,
                buttonTextStyle:
                    CustomTextStyles.titleSmallMontOnPrimaryExtraBold,
                onPressed: () {
                  onTapSubmit();
                },
              ),
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
        text: "msg_otp_verification".tr,
        margin: EdgeInsets.only(left: 18.h),
      ),
    );
  }

  /// Navigates to the previous screen.
  onTapArrowleftone() {
    Get.back();
  }

  /// Navigates to the newPasswordOneScreen when the action is triggered.
  onTapSubmit() {
    Get.toNamed(AppRoutes.newPasswordOneScreen);
  }
}
