import 'package:ctluser/theme/custom_button_style.dart';
import 'package:ctluser/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../core/app_export.dart';
import 'controller/splash_page_two_controller.dart';

class SplashPageTwoScreen extends GetWidget<SplashPageTwoController> {
  const SplashPageTwoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colorScheme.onPrimary,
      body: SafeArea(
        child: Obx(
          () => Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 40.h),
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: controller.pageController,
                    onPageChanged: controller.onPageChanged,
                    children: [
                      _buildOnboardingPage(
                        image: '',
                        title: "msg_lorem_ipsum_dolor".tr,
                        description: "msg_lorem_ipsum_dolor2".tr,
                      ),
                      _buildOnboardingPage(
                        image: '',
                        title: "msg_lorem_ipsum_dolor".tr,
                        description: "msg_lorem_ipsum_dolor2".tr,
                      ),
                      _buildOnboardingPage(
                        image: '',
                        title: "msg_lorem_ipsum_dolor".tr,
                        description: "msg_lorem_ipsum_dolor2".tr,
                      ),
                      _buildOnboardingPage(
                        image: '',
                        title: "msg_lorem_ipsum_dolor".tr,
                        description: "msg_lorem_ipsum_dolor2".tr,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40.h),
                _buildBottomNavigation(),
                SizedBox(height: 20.h),
                //currentPage
                Obx(
                  () =>
                      controller.currentPage.value == 0
                          ? CustomElevatedButton(
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
                            buttonTextStyle:
                                CustomTextStyles.titleSmallMontOnPrimary,
                            onPressed: () {
                              onTapAlready();
                            },
                          )
                          : const SizedBox.shrink(),
                ),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build individual onboarding page
  Widget _buildOnboardingPage({
    required String image,
    required String title,
    required String description,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 3,
          child: Container(
            padding: EdgeInsets.all(20.h),
            child: SizedBox.shrink(),
            // Image.asset(
            //   image,
            //   fit: BoxFit.contain,
            // ),
          ),
        ),
        SizedBox(height: 35.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.h),
          child: Text(
            title,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: CustomTextStyles.headlineSmallMontOnPrimaryContainer
                .copyWith(height: 1.21),
          ),
        ),
        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.h),
          child: Text(
            description,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: CustomTextStyles.labelLargeMontOnPrimaryContainer13.copyWith(
              height: 1.31,
            ),
          ),
        ),
        SizedBox(height: 40.h),
      ],
    );
  }

  /// Bottom navigation with skip, indicator, and next
  Widget _buildBottomNavigation() {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Skip button
          GestureDetector(
            onTap: () => onTapSkip(),
            child: Padding(
              padding: EdgeInsets.only(left: 6.h),
              child: Text(
                "lbl_skip".tr,
                style: CustomTextStyles.bodyMediumMontOnPrimaryContainer,
              ),
            ),
          ),

          // Page indicator
          Align(
            alignment: Alignment.center,
            child: SmoothPageIndicator(
              controller: controller.pageController,
              count: 4,
              effect: ScrollingDotsEffect(
                spacing: 8,
                activeDotColor: theme.colorScheme.onPrimaryContainer.withValues(
                  alpha: 0.8,
                ),
                dotColor: theme.colorScheme.onPrimaryContainer.withValues(
                  alpha: 0.3,
                ),
                dotHeight: 8.h,
                dotWidth: 8.h,
                activeDotScale: 1.3,
              ),
            ),
          ),

          // Next/Get Started button
          GestureDetector(
            onTap: () => onTapNext(),
            child: Padding(
              padding: EdgeInsets.only(right: 6.h),
              child: Text(
                controller.currentPage.value == 3
                    ? "get started"
                    : "lbl_next".tr,
                style: CustomTextStyles.bodyMediumMontOnPrimaryContainer
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Navigate to signup when skip is tapped
  void onTapSkip() {
    Get.toNamed(AppRoutes.signupScreen);
  }

  /// Navigate to next page or signup on last page
  void onTapNext() {
    if (controller.currentPage.value == 3) {
      Get.toNamed(AppRoutes.signupScreen);
    } else {
      controller.pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void onTapAlready() {
    Get.toNamed(AppRoutes.loginScreen);
  }
}
