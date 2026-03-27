// TODO Implement this library.
import '../../../core/app_export.dart';
import '../controller/splash_page_five_controller.dart';

/// A binding class for the SplashPageFiveScreen.
///
/// This class ensures that the SplashPageFiveController is created when the
/// SplashPageFiveScreen is first loaded.
class SplashPageFiveBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashPageFiveController());
  }
}
