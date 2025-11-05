// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/splash_page_three_model.dart';

/// A controller class for the SplashPageThreeScreen.
///
/// This class manages the state of the SplashPageThreeScreen, including the
/// current splashPageThreeModelObj
class SplashPageThreeController extends GetxController {
  Rx<SplashPageThreeModel> splashPageThreeModelObj = SplashPageThreeModel().obs;
}
