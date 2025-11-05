// TODO Implement this library.
// TODO Implement this library.
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/app_export.dart';
import '../models/your_orders_ongoing_model.dart';

/// A controller class for the YourOrdersOngoingScreen.
///
/// This class manages the state of the YourOrdersOngoingScreen, including the
/// current yourOrdersOngoingModelObj
class YourOrdersOngoingController extends GetxController {
  Rx<YourOrdersOngoingModel> yourOrdersOngoingModelObj =
      YourOrdersOngoingModel().obs;

  Completer<GoogleMapController> googleMapController = Completer();
}
