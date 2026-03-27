// TODO Implement this library.
import '../../../core/app_export.dart';
import '../controller/new_password_one_controller.dart';

/// A binding class for the NewPasswordOneScreen.
///
/// This class ensures that the NewPasswordOneController is created when the
/// NewPasswordOneScreen is first loaded.
class NewPasswordOneBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NewPasswordOneController());
  }
}
