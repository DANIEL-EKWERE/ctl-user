// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/card_list_model.dart';

/// A controller class for the CardListBottomsheet.
///
/// This class manages the state of the CardListBottomsheet, including the
/// current cardListModelObj
class CardListController extends GetxController {
  Rx<CardListModel> cardListModelObj = CardListModel().obs;
}
