// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';
import 'controller/splash_page_one_controller.dart'; // ignore_for_file: must_be_immutable

class SplashPageOneScreen extends GetWidget<SplashPageOneController> {
  const SplashPageOneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colorScheme.onPrimary,
      body: SafeArea(
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 92.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Spacer(),
              Text(
                "msg_lorem_ipsum_dolor".tr,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: CustomTextStyles.headlineSmallMontOnPrimaryContainer
                    .copyWith(height: 1.21),
              ),
              SizedBox(height: 22.h),
              Text(
                "msg_lorem_ipsum_dolor2".tr,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: CustomTextStyles.labelLargeMontOnPrimaryContainer13
                    .copyWith(height: 1.31),
              ),
              SizedBox(height: 72.h),
              _buildRowskip(),
              SizedBox(height: 28.h),
              CustomElevatedButton(
                height: 42.h,
                text: "msg_already_existing".tr,
                margin: EdgeInsets.only(right: 4.h),
                rightIcon: Container(
                  margin: EdgeInsets.only(left: 30.h),
                  child: CustomImageView(
                    imagePath: ImageConstant.imgArrowright,
                    height: 16.h,
                    width: 8.h,
                    fit: BoxFit.contain,
                  ),
                ),
                buttonStyle: CustomButtonStyles.fillPrimary,
                buttonTextStyle: CustomTextStyles.titleSmallMontOnPrimary,
                onPressed: () {
                  onTapAlready();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildRowskip() {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              onTapTxtSkipone();
            },
            child: Text(
              "lbl_skip".tr,
              style: CustomTextStyles.bodyMediumMontOnPrimaryContainer,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 6.h,
              margin: EdgeInsets.only(bottom: 6.h),
              child: AnimatedSmoothIndicator(
                activeIndex: 0,
                count: 4,
                effect: ScrollingDotsEffect(
                  spacing: 5,
                  activeDotColor: theme.colorScheme.onPrimaryContainer
                      .withValues(alpha: 0.6),
                  dotColor: theme.colorScheme.onPrimaryContainer.withValues(
                    alpha: 0.3,
                  ),
                  dotHeight: 6.h,
                  dotWidth: 6.h,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              onTapTxtNextone();
            },
            child: Padding(
              padding: EdgeInsets.only(right: 6.h),
              child: Text(
                "lbl_next".tr,
                style: CustomTextStyles.bodyMediumMontOnPrimaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Navigates to the signupScreen when the action is triggered.
  onTapTxtSkipone() {
    Get.toNamed(AppRoutes.signupScreen);
  }

  /// Navigates to the splashPageTwoScreen when the action is triggered.
  onTapTxtNextone() {
    Get.toNamed(AppRoutes.splashPageTwoScreen);
  }

  /// Navigates to the signupScreen when the action is triggered.
  onTapAlready() {
    Get.toNamed(AppRoutes.signupScreen);
  }
}
