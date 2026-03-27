// TODO Implement this library.
import '../../../core/app_export.dart';
import '../controller/payment_methods_controller.dart';

/// A binding class for the PaymentMethodsBottomsheet.
///
/// This class ensures that the PaymentMethodsController is created when the
/// PaymentMethodsBottomsheet is first loaded.
class PaymentMethodsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PaymentMethodsController());
  }
}
