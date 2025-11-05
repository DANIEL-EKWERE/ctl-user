import 'package:ctluser/widgets/app_bar/appabr_subtitle_one.dart';
import 'package:ctluser/widgets/custom_outlined_button.dart';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_pin_code_text_field.dart';
import 'controller/otp_verification_controller.dart'; // ignore_for_file: must_be_immutable

class OtpVerificationScreen extends GetWidget<OtpVerificationController> {
  const OtpVerificationScreen({Key? key}) : super(key: key);

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
          padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 14.h),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                "msg_we_have_sent_a_confirmation".tr,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: CustomTextStyles.titleSmallMontOnPrimaryContainer15
                    .copyWith(height: 1.40),
              ),
              SizedBox(height: 38.h),
              Container(
                width: double.maxFinite,
                margin: EdgeInsets.only(right: 16.h),
                child: Obx(
                  () => CustomPinCodeTextField(
                    context: Get.context!,
                    controller: controller.otpController.value,
                    onChanged: (value) {
                      if (value.length == 4) {
                        controller.isCompleted.value = true;
                        controller.update();
                      } else {
                        controller.isCompleted.value = false;
                        controller.update();
                      }
                    },
                  ),
                ),
              ),
              SizedBox(height: 18.h),
              Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "msg_didn_t_receive_email".tr,
                        style:
                            CustomTextStyles
                                .labelMediumMontOnPrimaryContainerMedium,
                      ),
                      TextSpan(
                        text: "msg_send_a_new_email".tr,
                        style: CustomTextStyles.labelMediumMontBlueA400Medium,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Spacer(),
              // CustomElevatedButton(
              //   text: "lbl_verify".tr,
              //   margin: EdgeInsets.only(left: 10.h, right: 8.h),
              //   buttonStyle: CustomButtonStyles.fillPrimary,
              //   buttonTextStyle:
              //       CustomTextStyles.titleSmallMontOnPrimaryExtraBold,
              //   onPressed: () {
              //     onTapVerify();
              //   },
              // ),
              Obx(() {
                return CustomOutlinedButton(
                  buttonStyle:
                      controller.isCompleted.value
                          ? CustomButtonStyles.fillPrimary
                          : CustomButtonStyles.outlineOnPrimaryContainer,
                  text: "lbl_verify".tr,
                  margin: EdgeInsets.only(left: 10.h, right: 8.h),
                  buttonTextStyle:
                      controller.isCompleted.value
                          ? CustomTextStyles.titleSmallMontOnPrimaryExtraBold
                          : CustomTextStyles.titleSmallMontGray900Bold_1,
                  onPressed: () {
                    controller.isCompleted.value ? onTapVerify() : null;
                  },
                );
              }),
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
      leadingWidth: 24.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeft,
        margin: EdgeInsets.only(left: 16.h),
        onTap: () {
          onTapArrowleftone();
        },
      ),
      title: AppbarSubtitleOne(
        text: "msg_email_verifcation".tr,
        margin: EdgeInsets.only(left: 16.h),
      ),
    );
  }

  /// Navigates to the previous screen.
  onTapArrowleftone() {
    Get.back();
  }

  /// Navigates to the loginScreen when the action is triggered.
  onTapVerify() {
    Get.toNamed(AppRoutes.newPasswordOneScreen);
  }
}
