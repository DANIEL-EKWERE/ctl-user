// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/search_vone_model.dart';

/// A controller class for the SearchVoneScreen.
///
/// This class manages the state of the SearchVoneScreen, including the
/// current searchVoneModelObj
class SearchVoneController extends GetxController {
  TextEditingController searchController = TextEditingController();

  Rx<SearchVoneModel> searchVoneModelObj = SearchVoneModel().obs;

  @override
  void onClose() {
    super.onClose();
    searchController.dispose();
  }
}
