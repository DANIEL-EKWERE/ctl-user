// TODO Implement this library.
import '../../../core/app_export.dart';
import 'login_six_one_item_model.dart';

/// This class defines the variables used in the [login_six_screen],
/// and is typically used to hold data that is passed between different parts of the application.

// ignore_for_file: must_be_immutable
class LoginSixModel {
  Rx<List<LoginSixOneItemModel>> loginSixOneItemList = Rx([
    LoginSixOneItemModel(frame: "lbl_s".tr.obs),
    LoginSixOneItemModel(frame: "lbl_m".tr.obs),
    LoginSixOneItemModel(frame: "lbl_l".tr.obs),
  ]);
}
