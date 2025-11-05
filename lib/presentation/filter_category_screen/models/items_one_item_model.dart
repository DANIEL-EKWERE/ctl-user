// TODO Implement this library.
import '../../../core/app_export.dart';

/// This class is used in the [items_one_item_widget] screen.

// ignore_for_file: must_be_immutable
class ItemsOneItemModel {
  ItemsOneItemModel({this.sandwichOne, this.namecategory, this.id}) {
    sandwichOne = sandwichOne ?? Rx(ImageConstant.imgGroup5);
    namecategory = namecategory ?? Rx("lbl_sandwich".tr);
    id = id ?? Rx("");
  }

  Rx<String>? sandwichOne;

  Rx<String>? namecategory;

  Rx<String>? id;
}
