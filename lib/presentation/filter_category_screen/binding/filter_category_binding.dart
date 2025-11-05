// TODO Implement this library.
import '../../../core/app_export.dart';
import '../controller/filter_category_controller.dart';

/// A binding class for the FilterCategoryScreen.
///
/// This class ensures that the FilterCategoryController is created when the
/// FilterCategoryScreen is first loaded.
class FilterCategoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FilterCategoryController());
  }
}
