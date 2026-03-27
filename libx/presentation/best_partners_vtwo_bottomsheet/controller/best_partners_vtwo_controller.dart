// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/best_partners_vtwo_model.dart';

/// A controller class for the BestPartnersVtwoBottomsheet.
///
/// This class manages the state of the BestPartnersVtwoBottomsheet, including the
/// current bestPartnersVtwoModelObj
class BestPartnersVtwoController extends GetxController {
  Rx<BestPartnersVtwoModel> bestPartnersVtwoModelObj =
      BestPartnersVtwoModel().obs;
}
