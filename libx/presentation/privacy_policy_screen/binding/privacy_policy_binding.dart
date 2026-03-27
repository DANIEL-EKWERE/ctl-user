// TODO Implement this library.
import '../../../core/app_export.dart';
import '../controller/privacy_policy_controller.dart';

/// A binding class for the PrivacyPolicyScreen.
///
/// This class ensures that the PrivacyPolicyController is created when the
/// PrivacyPolicyScreen is first loaded.
class PrivacyPolicyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PrivacyPolicyController());
  }
}
