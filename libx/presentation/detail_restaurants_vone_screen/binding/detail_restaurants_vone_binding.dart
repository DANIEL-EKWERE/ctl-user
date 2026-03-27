// TODO Implement this library.
import '../../../core/app_export.dart';
import '../controller/detail_restaurants_vone_controller.dart';

/// A binding class for the DetailRestaurantsVoneScreen.
///
/// This class ensures that the DetailRestaurantsVoneController is created when the
/// DetailRestaurantsVoneScreen is first loaded.
class DetailRestaurantsVoneBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DetailRestaurantsVoneController());
  }
}
