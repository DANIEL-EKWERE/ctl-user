// TODO Implement this library.
import '../../../core/app_export.dart';

/// This class is used in the [chipviewlabel_item_widget] screen.

// ignore_for_file: must_be_immutable
class ChipviewlabelItemModel {
  ChipviewlabelItemModel({this.labelSix, this.isSelected}) {
    labelSix = labelSix ?? Rx("lbl_good_service".tr);
    isSelected = isSelected ?? Rx(false);
  }

  Rx<String>? labelSix;

  Rx<bool>? isSelected;
}
