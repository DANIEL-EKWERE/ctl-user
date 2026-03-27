// TODO Implement this library.
import '../../../core/app_export.dart';
import '../controller/otp_controller.dart';

/// A binding class for the OtpScreen.
///
/// This class ensures that the OtpController is created when the
/// OtpScreen is first loaded.
class OtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OtpController());
  }
}
