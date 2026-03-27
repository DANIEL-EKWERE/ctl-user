// TODO Implement this library.
import '../../../core/app_export.dart';
import '../controller/change_password_controller.dart';

/// A binding class for the ChangePasswordBottomsheet.
///
/// This class ensures that the ChangePasswordController is created when the
/// ChangePasswordBottomsheet is first loaded.
class ChangePasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChangePasswordController());
  }
}
