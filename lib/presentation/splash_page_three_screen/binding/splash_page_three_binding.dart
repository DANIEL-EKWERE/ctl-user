// TODO Implement this library.
import '../../../core/app_export.dart';
import '../controller/splash_page_three_controller.dart';

/// A binding class for the SplashPageThreeScreen.
///
/// This class ensures that the SplashPageThreeController is created when the
/// SplashPageThreeScreen is first loaded.
class SplashPageThreeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashPageThreeController());
  }
}
