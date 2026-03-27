// TODO Implement this library.
import '../../../core/app_export.dart';
import '../controller/intro_splash_controller.dart';

/// A binding class for the IntroSplashScreen.
///
/// This class ensures that the IntroSplashController is created when the
/// IntroSplashScreen is first loaded.
class IntroSplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => IntroSplashController());
  }
}
