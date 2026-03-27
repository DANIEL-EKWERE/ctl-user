// TODO Implement this library.
import '../../../core/app_export.dart';
import '../controller/account_information_controller.dart';

/// A binding class for the AccountInformationBottomsheet.
///
/// This class ensures that the AccountInformationController is created when the
/// AccountInformationBottomsheet is first loaded.
class AccountInformationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AccountInformationController());
  }
}
