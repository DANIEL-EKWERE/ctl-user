// TODO Implement this library.
import '../../../core/app_export.dart';
import '../controller/login_four_controller.dart';

/// A binding class for the LoginFourScreen.
///
/// This class ensures that the LoginFourController is created when the
/// LoginFourScreen is first loaded.
class LoginFourBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginFourController());
  }
}
