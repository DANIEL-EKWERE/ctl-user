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
}
