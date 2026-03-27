// TODO Implement this library.
import '../../../core/app_export.dart';
import '../controller/login_seven_controller.dart';

/// A binding class for the LoginSevenScreen.
///
/// This class ensures that the LoginSevenController is created when the
/// LoginSevenScreen is first loaded.
class LoginSevenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginSevenController());
  }
}
