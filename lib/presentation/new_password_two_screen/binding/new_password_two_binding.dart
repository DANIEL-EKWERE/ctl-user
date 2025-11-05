// TODO Implement this library.
import '../../../core/app_export.dart';
import '../controller/new_password_two_controller.dart';

/// A binding class for the NewPasswordTwoScreen.
///
/// This class ensures that the NewPasswordTwoController is created when the
/// NewPasswordTwoScreen is first loaded.
class NewPasswordTwoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NewPasswordTwoController());
  }
}
