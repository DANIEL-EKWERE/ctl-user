// TODO Implement this library.
import '../../../core/app_export.dart';
import '../controller/splash_page_one_controller.dart';

/// A binding class for the SplashPageOneScreen.
///
/// This class ensures that the SplashPageOneController is created when the
/// SplashPageOneScreen is first loaded.
class SplashPageOneBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashPageOneController());
  }
}
