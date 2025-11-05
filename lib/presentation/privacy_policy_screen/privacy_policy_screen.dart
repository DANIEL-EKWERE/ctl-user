// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_outlined_button.dart';
import 'controller/privacy_policy_controller.dart'; // ignore_for_file: must_be_immutable

class PrivacyPolicyScreen extends GetWidget<PrivacyPolicyController> {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colorScheme.onPrimary,
      body: SafeArea(
        child: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsets.only(top: 36.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRowarrowleft(),
                  SizedBox(height: 4.h),
                  Padding(
                    padding: EdgeInsets.only(left: 24.h),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "msg_last_updated_on".tr,
                            style: CustomTextStyles.labelLargeMontGray900,
                          ),
                          TextSpan(
                            text: "lbl2".tr,
                            style: CustomTextStyles.bodyMediumPoppinsGray900,
                          ),
                          TextSpan(
                            text: "lbl_12".tr,
                            style: CustomTextStyles.labelLargeMontGray900,
                          ),
                          TextSpan(
                            text: "lbl2".tr,
                            style: CustomTextStyles.bodyMediumPoppinsGray900,
                          ),
                          TextSpan(
                            text: "lbl_2022".tr,
                            style: CustomTextStyles.labelLargeMontGray900,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(
                    width: double.maxFinite,
                    child: Divider(
                      color: appTheme.gray900.withValues(alpha: 0.3),
                    ),
                  ),
                  SizedBox(height: 22.h),
                  Container(
                    height: 608.h,
                    width: double.maxFinite,
                    margin: EdgeInsets.symmetric(horizontal: 24.h),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        CustomOutlinedButton(
                          width: 170.h,
                          text: "lbl_accept".tr,
                          buttonStyle: CustomButtonStyles.outlineGrayTL8,
                          buttonTextStyle:
                              CustomTextStyles.titleSmallMontGray5001,
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            "msg_clause_1_lorem_ipsum".tr,
                            maxLines: 22,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.justify,
                            style: CustomTextStyles.titleSmallMontGray90015_2
                                .copyWith(height: 1.73),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 22.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildRowarrowleft() {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 24.h),
      child: Row(
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgArrowLeft,
            height: 16.h,
            width: 8.h,
            onTap: () {
              onTapImgArrowleftone();
            },
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.h),
            child: Text(
              "lbl_privacy_policy".tr,
              style: CustomTextStyles.titleLargeMontPrimary,
            ),
          ),
        ],
      ),
    );
  }

  /// Navigates to the previous screen.
  onTapImgArrowleftone() {
    Get.back();
  }
}
