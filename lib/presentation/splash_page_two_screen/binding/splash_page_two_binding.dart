// TODO Implement this library.
import '../../../core/app_export.dart';
import '../controller/splash_page_two_controller.dart';

/// A binding class for the SplashPageTwoScreen.
///
/// This class ensures that the SplashPageTwoController is created when the
/// SplashPageTwoScreen is first loaded.
class SplashPageTwoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashPageTwoController());
  }
}
