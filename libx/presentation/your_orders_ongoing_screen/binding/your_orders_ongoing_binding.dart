// TODO Implement this library.
import '../../../core/app_export.dart';
import '../controller/your_orders_ongoing_controller.dart';

/// A binding class for the YourOrdersOngoingScreen.
///
/// This class ensures that the YourOrdersOngoingController is created when the
/// YourOrdersOngoingScreen is first loaded.
class YourOrdersOngoingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => YourOrdersOngoingController());
  }
}
