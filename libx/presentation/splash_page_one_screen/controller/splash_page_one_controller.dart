// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/splash_page_one_model.dart';

/// A controller class for the SplashPageOneScreen.
///
/// This class manages the state of the SplashPageOneScreen, including the
/// current splashPageOneModelObj
class SplashPageOneController extends GetxController {
  Rx<SplashPageOneModel> splashPageOneModelObj = SplashPageOneModel().obs;
}
