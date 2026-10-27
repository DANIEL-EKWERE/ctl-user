import 'package:flutter/cupertino.dart';
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
import '../wallet/atomicWebViewScreen/atomic_webview_screen.dart';

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
  String payMethod = 'wallet'; // wallet | card (online via [gateway])
  String gateway = 'paystack'; // monnify | paystack | flutterwave
  bool loading = false;
  bool addrLoading = false;
  String? error;
  bool pinIssue = false; // last error was about the wallet PIN
  dynamic _cardOrderId; // order created for a card payment not yet completed

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    vendorId = args['vendorId'] as int? ?? 0;
    vendorName = args['vendorName'] as String? ?? '';
    ctrl.loadCheckoutConfig();
    _loadAddresses();
    _loadPaymentMethods();
  }

  /// Wallet + online gateways; replaced by `payment-methods` when it loads.
  List<PaymentGateway> _methods = const [
    PaymentGateway(
      'wallet',
      'Wallet Balance',
      'Pay with your NKsereke wallet',
      null,
      null,
      'wallet',
    ),
    ...PaymentGateway.all,
  ];

  void _select(PaymentGateway m) {
    if (m.isWallet) {
      payMethod = 'wallet';
    } else {
      payMethod = 'card';
      gateway = m.value;
    }
  }

  Future<void> _loadPaymentMethods() async {
    final res = await ApiClient.instance.getPaymentMethods('order_payment');
    if (!mounted || res['success'] != true) return;
    final parsed = PaymentGateway.fromResponse(res['data']);
    if (parsed == null) return;
    setState(() {
      _methods = parsed.methods;
      final def = parsed.methods
          .where((m) => m.value == parsed.defaultCode)
          .firstOrNull;
      if (def != null) _select(def);
    });
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

  /// Validates the cart/address and returns the common order payload, or
  /// null (with [error] set) when the order can't be placed yet.
  Future<Map<String, dynamic>?> _buildOrderPayload() async {
    final vc = cart.vendorCart(vendorId);
    if (vc == null) return null;

    final addr = ctrl.checkoutAddress;
    if (addr == null) {
      setState(
        () => error = 'Please add a delivery address before placing an order.',
      );
      return null;
    }

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

    return {
      'vendor_id': vendorId,
      if (addressId != null) 'address_id': addressId,
      'service_charge': svcCharge,
      'delivery_fee': delivFee,
      'delivery_address': addr.address,
      if (addr.latitude != null) 'delivery_latitude': addr.latitude,
      if (addr.longitude != null) 'delivery_longitude': addr.longitude,
      'items': vc.items
          .map(
            (i) => {
              'product_id': i.productId,
              'quantity': i.quantity,
              'price': i.price,
            },
          )
          .toList(),
    };
  }

  void _onOrderPlaced(dynamic orderId) {
    cart.clearVendor(vendorId);
    showToast('Order placed! Your order has been received.');
    if (orderId != null) {
      Get.offNamed(AppRoutes.orderDetail, arguments: orderId);
    } else {
      // Payment verified but no order id returned — show the Orders tab.
      Get.until((route) => route.isFirst);
      ctrl.switchTab(1);
    }
  }

  Future<void> _place(String pin) async {
    setState(() {
      loading = true;
      error = null;
      pinIssue = false;
    });

    final payload = await _buildOrderPayload();
    if (payload == null) {
      setState(() => loading = false);
      return;
    }

    final res = await ApiClient.instance.placeOrder({
      ...payload,
      'payment_method': 'wallet',
      'pin': pin,
    }, auth.customerToken!);

    setState(() => loading = false);

    if (res['success'] == true) {
      final body = res['data'] as Map<String, dynamic>;
      _onOrderPlaced(body['data']?['id'] ?? body['order']?['id']);
    } else {
      final msg = (res['message'] ?? 'Failed to place order. Please try again.')
          .toString();
      setState(() {
        error = msg;
        pinIssue = msg.toLowerCase().contains('pin');
      });
    }
  }

  /// Online checkout: create the order (`customer/orders`, payment_method =
  /// selected gateway), initiate its payment via `payments/order` with the
  /// order_id, complete it in the gateway WebView, then verify the reference.
  Future<void> _payWithCard() async {
    setState(() {
      loading = true;
      error = null;
      pinIssue = false;
    });

    final payload = await _buildOrderPayload();
    if (payload == null) {
      setState(() => loading = false);
      return;
    }

    // Reuse the order from an earlier abandoned card attempt so retrying
    // payment doesn't create duplicate orders.
    var orderId = _cardOrderId;
    if (orderId == null) {
      // The API rejects 'card'; online orders are tagged with the gateway.
      final orderRes = await ApiClient.instance.placeOrder({
        ...payload,
        'payment_method': gateway,
      }, auth.customerToken!);
      if (orderRes['success'] != true) {
        setState(() {
          loading = false;
          error = orderRes['message'] ?? 'Could not create your order.';
        });
        return;
      }
      final body = orderRes['data'] as Map<String, dynamic>;
      final order = AppUtils.findKey(body, 'order');
      orderId =
          body['data']?['id'] ??
          (order is Map ? order['id'] : null) ??
          AppUtils.findKey(body, 'order_id');
      if (orderId == null) {
        setState(() {
          loading = false;
          error = 'Order was created but no order id was returned.';
        });
        return;
      }
      _cardOrderId = orderId;
    }

    final res = await ApiClient.instance.initiateOrderPayment({
      'order_id': orderId,
      'vendor_id': vendorId,
      'amount': total,
      'gateway': gateway,
      'items': payload['items'],
      'delivery_address': payload['delivery_address'],
    }, auth.customerToken!);

    if (res['success'] != true) {
      setState(() {
        loading = false;
        error = res['message'] ?? 'Could not start card payment.';
      });
      return;
    }

    final authUrl = AppUtils.paymentLink(res['data']);
    final initRef =
        AppUtils.findKey(res['data'], 'reference') ??
        AppUtils.findKey(res['data'], 'paymentReference') ??
        AppUtils.findKey(res['data'], 'tx_ref');
    if (authUrl == null) {
      setState(() {
        loading = false;
        error = 'Payment gateway did not return a payment link.';
      });
      return;
    }

    setState(() => loading = false);
    if (!mounted) return;
    final callbackUrl = await Navigator.push<String>(
      context,
      CupertinoPageRoute(
        builder: (_) => AtomicWebViewScreen(
          url: authUrl.toString(),
          isOrderPayment: true,
        ),
      ),
    );
    if (callbackUrl == null) {
      showToast('Payment was not completed.', isError: true);
      return;
    }

    final params = Uri.tryParse(callbackUrl)?.queryParameters ?? {};
    final reference =
        params['reference'] ?? // Paystack
        params['trxref'] ??
        params['paymentReference'] ?? // Monnify
        params['tx_ref'] ?? // Flutterwave
        initRef?.toString();
    if (reference == null) {
      setState(
        () => error =
            'Payment finished but no reference was returned. Check your orders shortly.',
      );
      return;
    }

    setState(() => loading = true);
    final verify = await ApiClient.instance.verifyPayment(
      reference,
      auth.customerToken!,
    );
    setState(() => loading = false);

    if (verify['success'] == true) {
      _cardOrderId = null;
      _onOrderPlaced(orderId);
    } else {
      setState(
        () => error =
            verify['message'] ??
            'We could not confirm your payment. If you were charged, contact support.',
      );
    }
  }

  Future<void> _openSetPin() async {
    final created = await Get.toNamed(AppRoutes.setPin);
    if (created == true && mounted) {
      setState(() {
        error = null;
        pinIssue = false;
      });
      await _promptTransactionPin();
    }
  }

  Future<void> _promptTransactionPin() async {
    if (payMethod == 'card') {
      await _payWithCard();
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
                    const SizedBox(height: 6),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(_setPinSignal),
                      child: const Text(
                        "Don't have a PIN? Create or reset it",
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
            );
          },
        );
      },
    );

    if (enteredPin == _setPinSignal) {
      await _openSetPin();
    } else if (enteredPin != null) {
      await _place(enteredPin);
    }
  }

  static const _setPinSignal = '__set_pin__';

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
            for (final m in _methods)
              GatewayOption(
                gateway: m,
                selected: m.isWallet
                    ? payMethod == 'wallet'
                    : payMethod == 'card' && gateway == m.value,
                onTap: () => setState(() => _select(m)),
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
                    if (pinIssue)
                      TextButton(
                        onPressed: _openSetPin,
                        child: const Text(
                          'Set PIN',
                          style: TextStyle(
                            color: AppColors.orange,
                            fontWeight: FontWeight.w700,
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
