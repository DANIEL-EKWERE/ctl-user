// TODO Implement this library.
import '../../../core/app_export.dart';
import 'login_four_one_item_model.dart';

/// This class defines the variables used in the [login_four_screen],
/// and is typically used to hold data that is passed between different parts of the application.

// ignore_for_file: must_be_immutable
class LoginFourModel {
  Rx<List<LoginFourOneItemModel>> loginFourOneItemList = Rx([
    LoginFourOneItemModel(namemarket: "msg_extreme_cheese_whopper".tr.obs),
    LoginFourOneItemModel(),
    LoginFourOneItemModel(),
  ]);
}
