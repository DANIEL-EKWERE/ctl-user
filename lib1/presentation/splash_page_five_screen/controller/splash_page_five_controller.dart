// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/splash_page_five_model.dart';

/// A controller class for the SplashPageFiveScreen.
///
/// This class manages the state of the SplashPageFiveScreen, including the
/// current splashPageFiveModelObj
class SplashPageFiveController extends GetxController {
  Rx<SplashPageFiveModel> splashPageFiveModelObj = SplashPageFiveModel().obs;
}
