// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/rate_drive_model.dart';

/// A controller class for the RateDriveBottomsheet.
///
/// This class manages the state of the RateDriveBottomsheet, including the
/// current rateDriveModelObj
class RateDriveController extends GetxController {
  TextEditingController commentController = TextEditingController();

  Rx<RateDriveModel> rateDriveModelObj = RateDriveModel().obs;

  @override
  void onClose() {
    super.onClose();
    commentController.dispose();
  }
}
