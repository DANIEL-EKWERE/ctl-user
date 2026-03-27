// TODO Implement this library.
import '../../../core/app_export.dart';
import 'sectionlisthotc_item_model.dart';

/// This class defines the variables used in the [detail_restaurants_vone_screen],
/// and is typically used to hold data that is passed between different parts of the application.

// ignore_for_file: must_be_immutable
class DetailRestaurantsVoneModel {
  Rx<List<SectionlisthotcItemModel>> sectionlisthotcItemList = Rx([
    SectionlisthotcItemModel(
      groupBy: "Hot Burger Combo".obs,
      nameOne: "msg_combo_bbq_bacon".tr.obs,
      comboSpicy: ImageConstant.imgSignalGray400.obs,
      price: "lbl_10_15".tr.obs,
      burgerCombo: "lbl_burger_combo".tr.obs,
    ),
    SectionlisthotcItemModel(
      groupBy: "Hot Burger Combo".obs,
      nameOne: "msg_combo_bbq_bacon".tr.obs,
      comboSpicy: ImageConstant.imgSignalGray400.obs,
      price: "lbl_10_15".tr.obs,
      burgerCombo: "lbl_burger_combo".tr.obs,
    ),
    SectionlisthotcItemModel(
      groupBy: "Hot Burger Combo".obs,
      nameOne: "msg_combo_bbq_bacon".tr.obs,
      comboSpicy: ImageConstant.imgSignalGray400.obs,
      price: "lbl_10_15".tr.obs,
      burgerCombo: "lbl_burger_combo".tr.obs,
    ),
    SectionlisthotcItemModel(
      groupBy: "Fried Chicken".obs,
      comboSpicy: ImageConstant.imgImportImage80x80.obs,
      nameOne: "msg_combo_bbq_bacon".tr.obs,
      comboSpicy1: ImageConstant.imgSignalOrange400.obs,
      price: "lbl_10_15".tr.obs,
      burgerCombo: "lbl_burger_combo".tr.obs,
    ),
    SectionlisthotcItemModel(
      groupBy: "Fried Chicken".obs,
      comboSpicy: ImageConstant.imgImportImage80x80.obs,
      nameOne: "msg_combo_bbq_bacon".tr.obs,
      comboSpicy1: ImageConstant.imgSignalOrange400.obs,
      price: "lbl_10_15".tr.obs,
      burgerCombo: "lbl_burger_combo".tr.obs,
    ),
    SectionlisthotcItemModel(
      groupBy: "Fried Chicken".obs,
      comboSpicy: ImageConstant.imgImportImage80x80.obs,
      nameOne: "msg_combo_bbq_bacon".tr.obs,
      comboSpicy1: ImageConstant.imgSignalOrange400.obs,
      price: "lbl_10_15".tr.obs,
      burgerCombo: "lbl_burger_combo".tr.obs,
    ),
  ]);
}
