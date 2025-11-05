// TODO Implement this library.
import '../../../core/app_export.dart';
import '../controller/false_forgot_password_otp_controller.dart';

/// A binding class for the FalseForgotPasswordOtpScreen.
///
/// This class ensures that the FalseForgotPasswordOtpController is created when the
/// FalseForgotPasswordOtpScreen is first loaded.
class FalseForgotPasswordOtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FalseForgotPasswordOtpController());
  }
}
