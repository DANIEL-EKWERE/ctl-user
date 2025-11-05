// TODO Implement this library.
import '../../../core/app_export.dart';
import '../controller/forgot_password_otp_controller.dart';

/// A binding class for the ForgotPasswordOtpScreen.
///
/// This class ensures that the ForgotPasswordOtpController is created when the
/// ForgotPasswordOtpScreen is first loaded.
class ForgotPasswordOtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ForgotPasswordOtpController());
  }
}
