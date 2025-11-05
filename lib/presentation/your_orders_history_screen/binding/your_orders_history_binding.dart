// TODO Implement this library.
import '../../../core/app_export.dart';
import '../controller/your_orders_history_controller.dart';

/// A binding class for the YourOrdersHistoryScreen.
///
/// This class ensures that the YourOrdersHistoryController is created when the
/// YourOrdersHistoryScreen is first loaded.
class YourOrdersHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => YourOrdersHistoryController());
  }
}
