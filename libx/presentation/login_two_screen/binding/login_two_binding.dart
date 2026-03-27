// TODO Implement this library.
import '../../../core/app_export.dart';
import '../controller/login_two_controller.dart';

/// A binding class for the LoginTwoScreen.
///
/// This class ensures that the LoginTwoController is created when the
/// LoginTwoScreen is first loaded.
class LoginTwoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginTwoController());
  }
}
