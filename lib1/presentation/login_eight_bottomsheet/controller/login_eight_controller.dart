// Schedule Delivery Bottomsheet Controller
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/login_eight_model.dart';

/// A controller class for the LoginEightBottomsheet.
///
/// This class manages the state of the LoginEightBottomsheet, including the
/// current loginEightModelObj
class LoginEightController extends GetxController {
  Rx<LoginEightModel> loginEightModelObj = LoginEightModel().obs;

  // Selected date and time for delivery scheduling
  RxString selectedDate = "Today".obs;
  RxString selectedTime = "9:00 AM".obs;

  @override
  void onClose() {
    super.onClose();
  }

  /// Handles the confirm button tap
  void onTapConfirm() {
    // TODO: Implement delivery scheduling logic
    // You can access selectedDate.value and selectedTime.value
    // to get the user's selected delivery date and time

    // For now, just show a success message
    Get.snackbar(
      "Delivery Scheduled",
      "Your order will be delivered on ${selectedDate.value} at ${selectedTime.value}",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}
