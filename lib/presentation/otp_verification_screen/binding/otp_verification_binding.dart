// TODO Implement this library.
import '../../../core/app_export.dart';
import '../controller/otp_verification_controller.dart';

/// A binding class for the OtpVerificationScreen.
///
/// This class ensures that the OtpVerificationController is created when the
/// OtpVerificationScreen is first loaded.
class OtpVerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OtpVerificationController());
  }
}
