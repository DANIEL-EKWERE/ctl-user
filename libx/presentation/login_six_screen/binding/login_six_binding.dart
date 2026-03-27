// TODO Implement this library.
import '../../../core/app_export.dart';
import '../controller/login_six_controller.dart';

/// A binding class for the LoginSixScreen.
///
/// This class ensures that the LoginSixController is created when the
/// LoginSixScreen is first loaded.
class LoginSixBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginSixController());
  }
}
