// //import '../../../../lib/presentation/widgets/common/app_widgets.dart' hide EmptyState, AppButton;
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// // import '../../../../core/theme/app_theme.dart';
// // import '../../../../core/utils/app_utils.dart';
// // import '../../../../data/services/api_client.dart';
// // import '../../../../routes/app_routes.dart';
// // import '../../../../widgets/app_widgets.dart';
// // import '../../../auth/auth_controller.dart';
// import '../../../core/theme/app_theme.dart';
// import '../../../core/utils/app_utils.dart';
// import '../../../data/services/api_client.dart';
// import '../../../routes/app_routes.dart';
// import '../../../widgets/app_widgets.dart';
// import '../../auth/auth_controller.dart';
// //import '../../cart/cart_controller.dart';
// import '../cart/cart_controller.dart';
// import '../home/customer_home_controller.dart';
// //import '../../home/customer_home_controller.dart';
// //AIzaSyCE2eTleryeIXRkcgRft2AD45eKakmFybw

// class CheckoutScreen extends StatefulWidget {
//   const CheckoutScreen({super.key});
//   @override State<CheckoutScreen> createState() => _CheckoutState();
// }

// class _CheckoutState extends State<CheckoutScreen> {
//   final ctrl = CustomerHomeController.to;
//   final cart = CartController.to;
//   final auth = AuthController.to;

//   late int vendorId;
//   late String vendorName;
//   String payMethod = 'wallet';
//   bool loading = false;
//   String? error;

//   @override
//   void initState() {
//     super.initState();
//     final args = Get.arguments as Map<String, dynamic>? ?? {};
//     vendorId   = args['vendorId'] as int? ?? 0;
//     vendorName = args['vendorName'] as String? ?? '';
//     ctrl.loadCheckoutConfig();
//     ctrl.loadAddresses();
//   }

//   double get subtotal  => cart.vendorCart(vendorId)?.subtotal ?? 0;
//   double get delivFee  => ctrl.calcDeliveryFee(null);
//   double get svcCharge => ctrl.calcServiceCharge(subtotal);
//   double get total     => subtotal + delivFee + svcCharge;

//   Future<void> _place() async {
//     final vc = cart.vendorCart(vendorId);
//     if (vc == null) return;
//     final addr = ctrl.addresses.firstWhereOrNull((a) => a.isDefault) ?? ctrl.addresses.firstOrNull;
//     if (addr == null) { setState(() => error = 'Add a delivery address first'); return; }
//     setState(() { loading = true; error = null; });
//     final res = await ApiClient.instance.placeOrder({
//       'vendor_id':      vendorId,
//       'address_id':     addr.id,
//       'payment_method': payMethod,
//       'service_charge': svcCharge,
//       'delivery_fee':   delivFee,
//       'items': vc.items.map((i) => {'product_id': i.productId, 'quantity': i.quantity, 'price': i.price}).toList(),
//     }, auth.customerToken!);
//     setState(() => loading = false);
//     if (res['success'] == true) {
//       cart.clearVendor(vendorId);
//       final body = res['data'] as Map<String, dynamic>;
//       final orderId = body['data']?['id'] ?? body['order']?['id'];
//       Get.offNamed(AppRoutes.orderDetail, arguments: orderId);
//       Get.snackbar('', '✅ Order placed!', snackPosition: SnackPosition.BOTTOM);
//     } else {
//       setState(() => error = res['message'] ?? 'Failed to place order');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final vc = cart.vendorCart(vendorId);
//     if (vc == null) return Scaffold(appBar: OrangeTopBar(title: 'Checkout'),
//         body: const EmptyState(icon: Icons.shopping_bag_outlined, title: 'Cart is empty'));

//     return Scaffold(
//       backgroundColor: AppColors.bg,
//       appBar: OrangeTopBar(title: 'Checkout'),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           _label('🏪  $vendorName'),
//           // Items
//           _card(Column(children: vc.items.map((i) => Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//             child: Row(children: [
//               Expanded(child: Text('${i.quantity}x ${i.name}', style: const TextStyle(fontSize: 13))),
//               Text(AppUtils.formatNaira(i.price * i.quantity),
//                   style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.navy)),
//             ]),
//           )).toList())),
//           const SizedBox(height: 14),

//           _label('📍  Delivery Address'),
//           Obx(() {
//             if (ctrl.addresses.isEmpty) {
//               return GestureDetector(
//                 onTap: () => Get.toNamed(AppRoutes.addAddress),
//                 child: _card(const Row(children: [
//                   Icon(Icons.add_location_alt_outlined, color: AppColors.orange),
//                   SizedBox(width: 8),
//                   Text('Add delivery address', style: TextStyle(color: AppColors.orange, fontWeight: FontWeight.w600)),
//                 ])),
//               );
//             }
//             final addr = ctrl.addresses.firstWhereOrNull((a) => a.isDefault) ?? ctrl.addresses.first;
//             return _card(Row(children: [
//               const Icon(Icons.location_on_outlined, color: AppColors.orange, size: 20),
//               const SizedBox(width: 8),
//               Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                 Text(addr.label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.navy)),
//                 Text(addr.address, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
//               ])),
//               TextButton(onPressed: () => Get.toNamed(AppRoutes.addresses),
//                 child: const Text('Change', style: TextStyle(color: AppColors.orange))),
//             ]));
//           }),
//           const SizedBox(height: 14),

//           _label('💳  Payment Method'),
//           _card(Column(children: [
//             _payOpt('wallet', '💰 Wallet', 'Pay with your NKsereke wallet'),
//             const Divider(height: 1),
//             _payOpt('card',   '💳 Card',   'Paystack online payment'),
//           ])),
//           const SizedBox(height: 14),

//           _label('📋  Order Summary'),
//           _card(Column(children: [
//             _sumRow('Subtotal',       AppUtils.formatNaira(subtotal)),
//             _sumRow('Delivery Fee',   AppUtils.formatNaira(delivFee)),
//             _sumRow('Service Charge', AppUtils.formatNaira(svcCharge)),
//             const Divider(height: 16),
//             Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//               const Text('Total', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.navy)),
//               Text(AppUtils.formatNaira(total),
//                   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.orange)),
//             ]),
//           ])),

//           if (error != null) ...[
//             const SizedBox(height: 12),
//             Container(padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(color: const Color(0xFFFEF2F2), borderRadius: BorderRadius.circular(10),
//                   border: Border.all(color: const Color(0xFFFECACA))),
//               child: Text(error!, style: const TextStyle(color: AppColors.red, fontSize: 13))),
//           ],
//           const SizedBox(height: 20),
//           AppButton(label: 'Place Order • ${AppUtils.formatNaira(total)}', loading: loading, onTap: _place),
//           const SizedBox(height: 30),
//         ]),
//       ),
//     );
//   }

//   Widget _label(String t) => Padding(padding: const EdgeInsets.only(bottom: 8),
//       child: Text(t, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.navy)));

//   Widget _card(Widget child) => Container(
//     margin: const EdgeInsets.only(bottom: 2),
//     decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
//     child: child,
//   );

//   Widget _payOpt(String value, String title, String sub) => GestureDetector(
//     onTap: () => setState(() => payMethod = value),
//     child: Padding(padding: const EdgeInsets.all(14), child: Row(children: [
//       AnimatedContainer(duration: const Duration(milliseconds: 200),
//         width: 18, height: 18,
//         decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: payMethod == value ? AppColors.orange : AppColors.border, width: 2)),
//         child: payMethod == value ? Center(child: Container(width: 8, height: 8,
//             decoration: const BoxDecoration(color: AppColors.orange, shape: BoxShape.circle))) : null),
//       const SizedBox(width: 12),
//       Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
//         Text(sub,   style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
//       ])),
//     ])),
//   );

//   Widget _sumRow(String l, String v) => Padding(padding: const EdgeInsets.symmetric(vertical: 5),
//     child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//       Text(l, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
//       Text(v, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.navy)),
//     ]));
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_utils.dart';
import '../../../data/models/models.dart';
import '../../../data/services/api_client.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/app_widgets.dart';
import '../../auth/auth_controller.dart';
import '../cart/cart_controller.dart';
import '../home/customer_home_controller.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});
  @override State<CheckoutScreen> createState() => _CheckoutState();
}

class _CheckoutState extends State<CheckoutScreen> {
  final ctrl = CustomerHomeController.to;
  final cart = CartController.to;
  final auth = AuthController.to;

  late int    vendorId;
  late String vendorName;
  String  payMethod = 'wallet';
  bool    loading   = false;
  bool    addrLoading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    vendorId   = args['vendorId']   as int?    ?? 0;
    vendorName = args['vendorName'] as String? ?? '';
    ctrl.loadCheckoutConfig();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    setState(() => addrLoading = true);
    await ctrl.loadAddresses();
    setState(() => addrLoading = false);
  }

  double get subtotal  => cart.vendorCart(vendorId)?.subtotal ?? 0;
  double get delivFee  => ctrl.calcDeliveryFee(null);
  double get svcCharge => ctrl.calcServiceCharge(subtotal);
  double get total     => subtotal + delivFee + svcCharge;

  Future<void> _place() async {
    final vc   = cart.vendorCart(vendorId);
    if (vc == null) return;

    // Use controller's smart fallback — covers GPS-only users
    final addr = ctrl.checkoutAddress;
    if (addr == null) {
      setState(() => error = 'Please add a delivery address before placing an order.');
      return;
    }

    setState(() { loading = true; error = null; });

    // If address has no server ID, save it first
    int? addressId = addr.id;
    if (addressId == null && auth.customerToken != null) {
      final saveRes = await ApiClient.instance.saveAddress({
        'label':      addr.label,
        'address':    addr.address,
        'city':       addr.city ?? '',
        'state':      addr.state ?? '',
        'latitude':   addr.latitude,
        'longitude':  addr.longitude,
        'is_default': true,
      }, auth.customerToken!);
      if (saveRes['success'] == true) {
        final body = saveRes['data'] as Map<String, dynamic>;
        addressId = (body['data'] ?? body['address'])?['id'] as int?;
        await ctrl.loadAddresses();
      }
    }

    final res = await ApiClient.instance.placeOrder({
      'vendor_id':      vendorId,
      if (addressId != null) 'address_id': addressId,
      'payment_method': payMethod,
      'service_charge': svcCharge,
      'delivery_fee':   delivFee,
      'delivery_address': addr.address,
      'items': vc.items.map((i) => {
        'product_id': i.productId,
        'quantity':   i.quantity,
        'price':      i.price,
      }).toList(),
    }, auth.customerToken!);

    setState(() => loading = false);

    if (res['success'] == true) {
      cart.clearVendor(vendorId);
      final body    = res['data'] as Map<String, dynamic>;
      final orderId = body['data']?['id'] ?? body['order']?['id'];
      Get.offNamed(AppRoutes.orderDetail, arguments: orderId);
      Get.snackbar('Order placed!', 'Your order has been received.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.green, colorText: Colors.white);
    } else {
      setState(() => error = res['message'] ?? 'Failed to place order. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final vc = cart.vendorCart(vendorId);
    if (vc == null) {
      return Scaffold(
        appBar: OrangeTopBar(title: 'Checkout'),
        body: const EmptyState(icon: Icons.shopping_bag_outlined, title: 'Cart is empty'));
    }

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: OrangeTopBar(title: 'Checkout'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          // ── Vendor label ──
          _label('Vendor'),
          _card(Padding(
            padding: const EdgeInsets.all(14),
            child: Row(children: [
              const Icon(Icons.store_outlined, color: AppColors.navy, size: 20),
              const SizedBox(width: 10),
              Text(vendorName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.navy)),
            ]),
          )),
          const SizedBox(height: 14),

          // ── Items ──
          _label('Order Items'),
          _card(Column(children: vc.items.map((i) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(children: [
              Expanded(child: Text('${i.quantity}x ${i.name}',
                  style: const TextStyle(fontSize: 13, color: AppColors.textPrimary))),
              Text(AppUtils.formatNaira(i.price * i.quantity),
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.navy)),
            ]),
          )).toList())),
          const SizedBox(height: 14),

          // ── Delivery Address ──
          _label('Delivery Address'),
          addrLoading
              ? const Padding(padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator(color: AppColors.orange, strokeWidth: 2)))
              : Obx(() {
                  final addr = ctrl.checkoutAddress;
                  if (addr == null) {
                    // No address at all — prompt to add one
                    return GestureDetector(
                      onTap: () async {
                        await Get.toNamed(AppRoutes.addAddress);
                        await _loadAddresses();
                      },
                      child: _card(const Padding(
                        padding: EdgeInsets.all(14),
                        child: Row(children: [
                          Icon(Icons.add_location_alt_outlined, color: AppColors.orange),
                          SizedBox(width: 10),
                          Expanded(child: Text('Tap to add a delivery address',
                              style: TextStyle(color: AppColors.orange, fontWeight: FontWeight.w600, fontSize: 13))),
                        ]),
                      )),
                    );
                  }
                  return _card(Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(children: [
                      const Icon(Icons.location_on_outlined, color: AppColors.orange, size: 20),
                      const SizedBox(width: 10),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(addr.label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.navy)),
                        const SizedBox(height: 2),
                        Text(addr.address, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                        if (addr.city != null || addr.state != null)
                          Text('${addr.city ?? ''}, ${addr.state ?? ''}',
                              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      ])),
                      TextButton(
                        onPressed: () async {
                          await Get.toNamed(AppRoutes.addresses);
                          await _loadAddresses();
                        },
                        child: const Text('Change', style: TextStyle(color: AppColors.orange, fontWeight: FontWeight.w600)),
                      ),
                    ]),
                  ));
                }),
          const SizedBox(height: 14),

          // ── Payment Method ──
          _label('Payment Method'),
          _card(Column(children: [
            _payOpt('wallet', Icons.account_balance_wallet_outlined, 'Wallet Balance', 'Pay with your NKsereke wallet'),
            const Divider(height: 1),
            _payOpt('card', Icons.credit_card_outlined, 'Pay with Card', 'Paystack online payment'),
          ])),
          const SizedBox(height: 14),

          // ── Order Summary ──
          _label('Order Summary'),
          _card(Padding(
            padding: const EdgeInsets.all(14),
            child: Column(children: [
              _sumRow('Subtotal',       AppUtils.formatNaira(subtotal)),
              _sumRow('Delivery Fee',   AppUtils.formatNaira(delivFee)),
              _sumRow('Service Charge', AppUtils.formatNaira(svcCharge)),
              const Divider(height: 16),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Total', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.navy)),
                Text(AppUtils.formatNaira(total),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.orange)),
              ]),
            ]),
          )),

          // ── Error ──
          if (error != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2), borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFECACA))),
              child: Row(children: [
                const Icon(Icons.error_outline, color: AppColors.red, size: 16),
                const SizedBox(width: 8),
                Expanded(child: Text(error!, style: const TextStyle(color: AppColors.red, fontSize: 13))),
              ]),
            ),
          ],

          const SizedBox(height: 20),
          AppButton(
            label: 'Place Order • ${AppUtils.formatNaira(total)}',
            loading: loading,
            onTap: _place,
          ),
          const SizedBox(height: 30),
        ]),
      ),
    );
  }

  Widget _label(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(t, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
        color: AppColors.textSecondary, letterSpacing: 0.3)),
  );

  Widget _card(Widget child) => Container(
    margin: const EdgeInsets.only(bottom: 2),
    decoration: BoxDecoration(
      color: Colors.white, borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.border),
    ),
    child: child,
  );

  Widget _payOpt(String value, IconData icon, String title, String sub) =>
    GestureDetector(
      onTap: () => setState(() => payMethod = value),
      child: Padding(padding: const EdgeInsets.all(14), child: Row(children: [
        AnimatedContainer(duration: const Duration(milliseconds: 200),
          width: 18, height: 18,
          decoration: BoxDecoration(shape: BoxShape.circle,
              border: Border.all(color: payMethod == value ? AppColors.orange : AppColors.border, width: 2)),
          child: payMethod == value
              ? Center(child: Container(width: 8, height: 8,
                  decoration: const BoxDecoration(color: AppColors.orange, shape: BoxShape.circle)))
              : null),
        const SizedBox(width: 12),
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.navy)),
          Text(sub,   style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ])),
      ])),
    );

  Widget _sumRow(String l, String v) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(l, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
      Text(v, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.navy)),
    ]),
  );
}