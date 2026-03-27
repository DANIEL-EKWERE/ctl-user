// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/detail_restaurants_review_vone_model.dart';

/// A controller class for the DetailRestaurantsReviewVoneScreen.
///
/// This class manages the state of the DetailRestaurantsReviewVoneScreen, including the
/// current detailRestaurantsReviewVoneModelObj
class DetailRestaurantsReviewVoneController extends GetxController {
  Rx<DetailRestaurantsReviewVoneModel> detailRestaurantsReviewVoneModelObj =
      DetailRestaurantsReviewVoneModel().obs;
}
