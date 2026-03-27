// TODO Implement this library.
import '../../../core/app_export.dart';
import '../controller/login_three_controller.dart';

/// A binding class for the LoginThreeScreen.
///
/// This class ensures that the LoginThreeController is created when the
/// LoginThreeScreen is first loaded.
class LoginThreeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginThreeController());
  }
}
