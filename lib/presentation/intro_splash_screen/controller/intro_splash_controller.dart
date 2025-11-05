// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/intro_splash_model.dart';

/// A controller class for the IntroSplashScreen.
///
/// This class manages the state of the IntroSplashScreen, including the
/// current introSplashModelObj
class IntroSplashController extends GetxController {
  Rx<IntroSplashModel> introSplashModelObj = IntroSplashModel().obs;

  @override
  void onReady() {
    Future.delayed(const Duration(milliseconds: 3000), () {
      Get.offNamed(AppRoutes.splashPageOneScreen);
    });
  }
}
