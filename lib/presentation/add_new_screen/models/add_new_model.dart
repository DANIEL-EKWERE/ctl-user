// TODO Implement this library.
import '../../../core/app_export.dart';
import 'items_item_model.dart';

/// This class defines the variables used in the [add_new_screen],
/// and is typically used to hold data that is passed between different parts of the application.

// ignore_for_file: must_be_immutable
class AddNewModel {
  Rx<List<ItemsItemModel>> itemsItemList = Rx([
    ItemsItemModel(
      imageOne: ImageConstant.imgPngwing1.obs,
      name: "msg_prime_beef_pizza".tr.obs,
      price: "lbl_20_99".tr.obs,
    ),
    ItemsItemModel(
      imageOne: ImageConstant.imgPngwing150x62.obs,
      name: "msg_double_bbq_bacon".tr.obs,
      price: "lbl_15_99".tr.obs,
    ),
  ]);
}
