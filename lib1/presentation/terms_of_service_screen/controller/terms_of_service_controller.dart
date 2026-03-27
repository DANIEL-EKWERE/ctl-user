// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/terms_of_service_model.dart';

/// A controller class for the TermsOfServiceScreen.
///
/// This class manages the state of the TermsOfServiceScreen, including the
/// current termsOfServiceModelObj
class TermsOfServiceController extends GetxController {
  Rx<TermsOfServiceModel> termsOfServiceModelObj = TermsOfServiceModel().obs;
}
