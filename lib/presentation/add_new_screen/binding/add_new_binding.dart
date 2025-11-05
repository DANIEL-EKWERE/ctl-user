// TODO Implement this library.
import '../../../core/app_export.dart';
import '../controller/add_new_controller.dart';

/// A binding class for the AddNewScreen.
///
/// This class ensures that the AddNewController is created when the
/// AddNewScreen is first loaded.
class AddNewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddNewController());
  }
}
