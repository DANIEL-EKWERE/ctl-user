// TODO Implement this library.
import '../../../core/app_export.dart';

/// This class is used in the [chipviewlabel_item_widget] screen.

// ignore_for_file: must_be_immutable
class ChipviewlabelItemModel {
  ChipviewlabelItemModel({this.labelFour, this.isSelected}) {
    labelFour = labelFour ?? Rx("lbl_clean".tr);
    isSelected = isSelected ?? Rx(false);
  }

  Rx<String>? labelFour;

  Rx<bool>? isSelected;
}
