// TODO Implement this library.
import '../../../core/app_export.dart';

/// This class is used in the [sectionlisthotc_item_widget] screen.

// ignore_for_file: must_be_immutable
class SectionlisthotcItemModel {
  SectionlisthotcItemModel({
    this.groupBy,
    this.nameOne,
    this.comboSpicy,
    this.price,
    this.burgerCombo,
    this.comboSpicy1,
    this.id,
  }) {
    groupBy = groupBy ?? Rx("");
    nameOne = nameOne ?? Rx("msg_combo_spicy_tender".tr);
    comboSpicy = comboSpicy ?? Rx(ImageConstant.imgSignalOrange400);
    price = price ?? Rx("lbl_10_15".tr);
    burgerCombo = burgerCombo ?? Rx("lbl_burger_combo".tr);
    comboSpicy1 = comboSpicy1 ?? Rx(ImageConstant.imgImportImage5);
    id = id ?? Rx("");
  }

  Rx<String>? groupBy;

  Rx<String>? nameOne;

  Rx<String>? comboSpicy;

  Rx<String>? price;

  Rx<String>? burgerCombo;

  Rx<String>? comboSpicy1;

  Rx<String>? id;
}
