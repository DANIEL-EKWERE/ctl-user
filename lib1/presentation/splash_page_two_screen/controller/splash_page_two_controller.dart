// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/splash_page_two_model.dart';

/// A controller class for the SplashPageTwoScreen.
///
/// This class manages the state of the SplashPageTwoScreen, including the
/// current splashPageTwoModelObj
class SplashPageTwoController extends GetxController {
  Rx<SplashPageTwoModel> splashPageTwoModelObj = SplashPageTwoModel().obs;

  // PageView controller
  final PageController pageController = PageController();
  
  // Current page index
  final currentPage = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  /// Called when page changes
  void onPageChanged(int index) {
    currentPage.value = index;
  }

  /// Navigate to next page
  void nextPage() {
    if (currentPage.value < 3) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Navigate to previous page
  void previousPage() {
    if (currentPage.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Skip to signup
  void skipToSignup() {
    Get.toNamed(AppRoutes.signupScreen);
  }
}
