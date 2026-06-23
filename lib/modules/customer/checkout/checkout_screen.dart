import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/utils/toast.dart';
import '../../../data/models/models.dart';
import '../../../data/services/api_client.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/app_widgets.dart';
import '../../auth/auth_controller.dart';
import '../cart/cart_controller.dart';
import '../home/customer_home_controller.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});
  @override
  State<CheckoutScreen> createState() => _CheckoutState();
}

class _CheckoutState extends State<CheckoutScreen> {
  final ctrl = CustomerHomeController.to;
  final cart = CartController.to;
  final auth = AuthController.to;
  final TextEditingController _pinController = TextEditingController();

  late int vendorId;
  late String vendorName;
  String payMethod = 'wallet';
  bool loading = false;
  bool addrLoading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    vendorId = args['vendorId'] as int? ?? 0;
    vendorName = args['vendorName'] as String? ?? '';
    ctrl.loadCheckoutConfig();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    setState(() => addrLoading = true);
    await ctrl.loadAddresses();
    setState(() => addrLoading = false);
  }

  double get subtotal => cart.vendorCart(vendorId)?.subtotal ?? 0;
  double get delivFee => ctrl.calcDeliveryFee(null);
  double get svcCharge => ctrl.calcServiceCharge(subtotal);
  double get total => subtotal + delivFee + svcCharge;

  Future<void> _place(String pin) async {
    final vc = cart.vendorCart(vendorId);
    if (vc == null) return;

    final addr = ctrl.checkoutAddress;
    if (addr == null) {
      setState(
        () => error = 'Please add a delivery address before placing an order.',
      );
      return;
    }

    setState(() {
      loading = true;
      error = null;
    });

    int? addressId = addr.id;
    if (addressId == null && auth.customerToken != null) {
      final saveRes = await ApiClient.instance.saveAddress({
        'label': addr.label,
        'address': addr.address,
        'city': addr.city ?? '',
        'state': addr.state ?? '',
        'latitude': addr.latitude,
        'longitude': addr.longitude,
        'is_default': true,
      }, auth.customerToken!);
      if (saveRes['success'] == true) {
        final body = saveRes['data'] as Map<String, dynamic>;
        addressId = (body['data'] ?? body['address'])?['id'] as int?;
        await ctrl.loadAddresses();
      }
    }

    final res = await ApiClient.instance.placeOrder({
      'vendor_id': vendorId,
      if (addressId != null) 'address_id': addressId,
      'payment_method': payMethod,
      'service_charge': svcCharge,
      'delivery_fee': delivFee,
      'delivery_address': addr.address,
      if (payMethod == 'wallet') 'pin': pin,
      'items': vc.items
          .map(
            (i) => {
              'product_id': i.productId,
              'quantity': i.quantity,
              'price': i.price,
            },
          )
          .toList(),
    }, auth.customerToken!);

    setState(() => loading = false);

    if (res['success'] == true) {
      cart.clearVendor(vendorId);
      final body = res['data'] as Map<String, dynamic>;
      final orderId = body['data']?['id'] ?? body['order']?['id'];
      Get.offNamed(AppRoutes.orderDetail, arguments: orderId);
      showToast('Order placed! Your order has been received.');
    } else {
      setState(
        () => error =
            res['message'] ?? 'Failed to place order. Please try again.',
      );
    }
  }

  Future<void> _promptTransactionPin() async {
    // Card payments don't use a PIN — place order directly
    if (payMethod == 'card') {
      await _place('');
      return;
    }

    _pinController.text = '';
    String? pinError;

    final enteredPin = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              insetPadding: const EdgeInsets.symmetric(horizontal: 24),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 48,
                        height: 5,
                        decoration: BoxDecoration(
                          color: AppColors.border,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Confirm Transaction PIN',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Enter your 4-digit PIN to authorize payment for ${AppUtils.formatNaira(total)}.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 22),
                    TextField(
                      controller: _pinController,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      maxLength: 4,
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: const Color(0xFFF8F8FB),
                        hintText: 'Enter PIN',
                        hintStyle: const TextStyle(
                          color: AppColors.textSecondary,
                        ),
                        errorText: pinError,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 18,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        letterSpacing: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      onChanged: (_) {
                        if (pinError != null) {
                          setState(() => pinError = null);
                        }
                      },
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(null),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.border),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: AppColors.navy,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (_pinController.text.trim().length != 4) {
                                setState(() {
                                  pinError = 'PIN must be 4 digits';
                                });
                                return;
                              }
                              Navigator.of(
                                context,
                              ).pop(_pinController.text.trim());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.orange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text(
                              'Confirm PIN',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (enteredPin != null) {
      await _place(enteredPin);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vc = cart.vendorCart(vendorId);
    if (vc == null) {
      return Scaffold(
        appBar: OrangeTopBar(title: 'Checkout'),
        body: const EmptyState(
          icon: Icons.shopping_bag_outlined,
          title: 'Cart is empty',
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: OrangeTopBar(title: 'Checkout'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Vendor label ──
            _label('Vendor'),
            _card(
              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    const Icon(
                      Icons.store_outlined,
                      color: AppColors.navy,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      vendorName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // ── Items ──
            _label('Order Items'),
            _card(
              Column(
                children: vc.items
                    .map(
                      (i) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${i.quantity}x ${i.name}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            Text(
                              AppUtils.formatNaira(i.price * i.quantity),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.navy,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 14),

            // ── Delivery Address ──
            _label('Delivery Address'),
            addrLoading
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.orange,
                        strokeWidth: 2,
                      ),
                    ),
                  )
                : Obx(() {
                    final addr = ctrl.checkoutAddress;
                    if (addr == null) {
                      // No address at all — prompt to add one
                      return GestureDetector(
                        onTap: () async {
                          await Get.toNamed(AppRoutes.addAddress);
                          await _loadAddresses();
                        },
                        child: _card(
                          const Padding(
                            padding: EdgeInsets.all(14),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.add_location_alt_outlined,
                                  color: AppColors.orange,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Tap to add a delivery address',
                                    style: TextStyle(
                                      color: AppColors.orange,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    return _card(
                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              color: AppColors.orange,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    addr.label,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.navy,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    addr.address,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  if (addr.city != null || addr.state != null)
                                    Text(
                                      '${addr.city ?? ''}, ${addr.state ?? ''}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                await Get.toNamed(AppRoutes.addresses);
                                await _loadAddresses();
                              },
                              child: const Text(
                                'Change',
                                style: TextStyle(
                                  color: AppColors.orange,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            const SizedBox(height: 14),

            // ── Payment Method ──
            _label('Payment Method'),
            _card(
              Column(
                children: [
                  _payOpt(
                    'wallet',
                    Icons.account_balance_wallet_outlined,
                    'Wallet Balance',
                    'Pay with your NKsereke wallet',
                  ),
                  const Divider(height: 1),
                  _payOpt(
                    'card',
                    Icons.credit_card_outlined,
                    'Pay with Card',
                    'Paystack online payment',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // ── Order Summary ──
            _label('Order Summary'),
            _card(
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    _sumRow('Subtotal', AppUtils.formatNaira(subtotal)),
                    _sumRow('Delivery Fee', AppUtils.formatNaira(delivFee)),
                    _sumRow('Service Charge', AppUtils.formatNaira(svcCharge)),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.navy,
                          ),
                        ),
                        Text(
                          AppUtils.formatNaira(total),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.orange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Error ──
            if (error != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFFECACA)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: AppColors.red,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        error!,
                        style: const TextStyle(
                          color: AppColors.red,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 20),
            AppButton(
              label: 'Place Order • ${AppUtils.formatNaira(total)}',
              loading: loading,
              onTap: _promptTransactionPin,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _label(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      t,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.textSecondary,
        letterSpacing: 0.3,
      ),
    ),
  );

  Widget _card(Widget child) => Container(
    margin: const EdgeInsets.only(bottom: 2),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.border),
    ),
    child: child,
  );

  Widget _payOpt(String value, IconData icon, String title, String sub) =>
      GestureDetector(
        onTap: () => setState(() => payMethod = value),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: payMethod == value
                        ? AppColors.orange
                        : AppColors.border,
                    width: 2,
                  ),
                ),
                child: payMethod == value
                    ? Center(
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.orange,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Icon(icon, size: 18, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.navy,
                      ),
                    ),
                    Text(
                      sub,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget _sumRow(String l, String v) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          l,
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        Text(
          v,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.navy,
          ),
        ),
      ],
    ),
  );
}
