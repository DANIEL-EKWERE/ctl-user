// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/best_partners_vone_model.dart';

/// A controller class for the BestPartnersVoneBottomsheet.
///
/// This class manages the state of the BestPartnersVoneBottomsheet, including the
/// current bestPartnersVoneModelObj
class BestPartnersVoneController extends GetxController {
  Rx<BestPartnersVoneModel> bestPartnersVoneModelObj =
      BestPartnersVoneModel().obs;
}
