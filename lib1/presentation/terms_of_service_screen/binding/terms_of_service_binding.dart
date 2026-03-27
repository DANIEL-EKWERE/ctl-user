// TODO Implement this library.
import '../../../core/app_export.dart';
import '../controller/terms_of_service_controller.dart';

/// A binding class for the TermsOfServiceScreen.
///
/// This class ensures that the TermsOfServiceController is created when the
/// TermsOfServiceScreen is first loaded.
class TermsOfServiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TermsOfServiceController());
  }
}
