
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

abstract class SnackbarUtils {
  static showSnackbarMessage({
    String title = 'Note!',
    String message = 'Action performed successfully !!!',
  }) {
    Get.snackbar(title, message,
        backgroundColor: Colors.green,
        overlayColor: Colors.greenAccent,
        colorText: Colors.white);
  }

  static showSnackbarError(
      [String title = 'Error', String message = 'Something went wrong']) {
    Get.snackbar(title, message,
        backgroundColor: Colors.red,
        overlayColor: Colors.redAccent,
        colorText: Colors.white);
  }
}
