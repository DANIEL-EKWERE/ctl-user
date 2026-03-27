// TODO Implement this library.
import '../../../core/app_export.dart';
import '../controller/search_vone_controller.dart';

/// A binding class for the SearchVoneScreen.
///
/// This class ensures that the SearchVoneController is created when the
/// SearchVoneScreen is first loaded.
class SearchVoneBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SearchVoneController());
  }
}
