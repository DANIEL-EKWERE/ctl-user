// TODO Implement this library.
import '../../../core/app_export.dart';
import '../controller/payment_methods_card_controller.dart';

/// A binding class for the PaymentMethodsCardBottomsheet.
///
/// This class ensures that the PaymentMethodsCardController is created when the
/// PaymentMethodsCardBottomsheet is first loaded.
class PaymentMethodsCardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PaymentMethodsCardController());
  }
}
