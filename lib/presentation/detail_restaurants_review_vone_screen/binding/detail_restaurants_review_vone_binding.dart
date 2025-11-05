// TODO Implement this library.
import '../../../core/app_export.dart';
import '../controller/detail_restaurants_review_vone_controller.dart';

/// A binding class for the DetailRestaurantsReviewVoneScreen.
///
/// This class ensures that the DetailRestaurantsReviewVoneController is created when the
/// DetailRestaurantsReviewVoneScreen is first loaded.
class DetailRestaurantsReviewVoneBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DetailRestaurantsReviewVoneController());
  }
}
