// TODO Implement this library.
import '../../../core/app_export.dart';
import '../controller/login_one_controller.dart';

/// A binding class for the LoginOneScreen.
///
/// This class ensures that the LoginOneController is created when the
/// LoginOneScreen is first loaded.
class LoginOneBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginOneController());
  }
}
