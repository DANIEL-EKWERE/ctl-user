import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/controllers/cart_controller.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/api_client.dart';
import '../../widgets/common/app_widgets.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});
  @override State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final cartCtrl = Get.find<CartController>();
  int _step = 0;
  String _paymentMethod = 'online';
  List<dynamic> _addresses = [];
  int? _selectedAddressId;
  bool _loadingAddresses = true;
  bool _placingOrder = false;
  late int vendorId;
  late String vendorName;

  static const double _deliveryFee = 400;
  static const double _serviceFee = 600;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    vendorId = args['vendorId'] as int? ?? 0;
    vendorName = args['vendorName']?.toString() ?? '';
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    final res = await ApiClient.instance.getAddresses();
    if (res['success'] == true) {
      final data = res['data'];
      _addresses = (data['data']?['addresses'] ?? data['data'] ?? data['addresses'] ?? []) as List;
      if (_addresses.isNotEmpty) {
        _selectedAddressId = int.tryParse(_addresses.first['id']?.toString() ?? '0');
      }
    }
    if (mounted) setState(() => _loadingAddresses = false);
  }

  List<CartItem> get _vendorItems => cartCtrl.items.where((i) => i.vendorId == vendorId).toList();
  double get _subtotal => _vendorItems.fold(0, (s, i) => s + i.subtotal);
  double get _total => _subtotal + _deliveryFee + _serviceFee;

  Future<void> _placeOrder() async {
    if (_selectedAddressId == null) {
      Get.snackbar('Error', 'Please select a delivery address', snackPosition: SnackPosition.TOP);
      return;
    }
    setState(() => _placingOrder = true);
    final items = _vendorItems.map((i) => <String, dynamic>{'product_id': i.productId, 'quantity': i.quantity}).toList();
    final res = await ApiClient.instance.placeOrder(
      vendorId: vendorId, addressId: _selectedAddressId!,
      paymentMethod: _paymentMethod, items: items,
    );
    setState(() => _placingOrder = false);
    if (res['success'] == true) {
      cartCtrl.clearVendorCart(vendorId);
      _showSuccessSheet();
    } else {
      Get.snackbar('Error', res['message'] ?? 'Failed to place order', snackPosition: SnackPosition.TOP);
    }
  }

  void _showSuccessSheet() {
    showModalBottomSheet(context: context, isDismissible: false, backgroundColor: Colors.transparent, builder: (_) => Container(
      padding: const EdgeInsets.all(32),
      decoration: const BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 72, height: 72, decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
          child: const Icon(Icons.check_rounded, color: AppColors.white, size: 40)),
        const SizedBox(height: 16),
        const Text('Order Placed!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        const Text('Your order is being prepared.', style: TextStyle(color: AppColors.textSecondary)),
        const SizedBox(height: 28),
        AppButton(label: 'Back to Home', onTap: () { Get.back(); Get.back(); Get.back(); }),
      ]),
    ));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.white,
    appBar: AppBar(title: const Text('Checkout')),
    body: Column(children: [
      _buildStepBar(),
      Expanded(child: _step == 0 ? _buildOrderSummary() : _buildDeliveryPayment()),
    ]),
    bottomNavigationBar: SafeArea(child: Padding(padding: const EdgeInsets.all(16),
      child: _step == 0
        ? AppButton(label: 'Continue to Payment', onTap: () => setState(() => _step = 1))
        : AppButton(label: 'Place Order', isLoading: _placingOrder, onTap: _placeOrder),
    )),
  );

  Widget _buildStepBar() => Container(
    color: AppColors.white,
    padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
    child: Row(children: [
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Your Order', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _step == 0 ? AppColors.textPrimary : AppColors.textSecondary)),
        const SizedBox(height: 6),
        ClipRRect(borderRadius: BorderRadius.circular(4), child: const LinearProgressIndicator(value: 1, minHeight: 4, backgroundColor: AppColors.grey200, valueColor: AlwaysStoppedAnimation(AppColors.primary))),
      ])),
      const SizedBox(width: 16),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Delivery & Payment', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _step == 1 ? AppColors.textPrimary : AppColors.textSecondary)),
        const SizedBox(height: 6),
        ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: _step == 1 ? 1 : 0, minHeight: 4, backgroundColor: AppColors.grey200, valueColor: const AlwaysStoppedAnimation(AppColors.primary))),
      ])),
    ]),
  );

  Widget _buildOrderSummary() => SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const Text('Order Summary', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
    const SizedBox(height: 16),
    Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.grey50, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)), child: Column(children: [
      Row(children: [
        AppNetworkImage(url: _vendorItems.isNotEmpty ? _vendorItems.first.imageUrl : null, width: 40, height: 40, borderRadius: BorderRadius.circular(20)),
        const SizedBox(width: 12),
        Expanded(child: Text(vendorName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700))),
        Text('${_vendorItems.fold(0,(s,i)=>s+i.quantity)} items', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
      ]),
      const Divider(height: 24),
      ..._vendorItems.map((item) => Padding(padding: const EdgeInsets.only(bottom: 10), child: Row(children: [
        Expanded(child: Text(item.productName, style: const TextStyle(fontSize: 14))),
        Text('x${item.quantity}', style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        const SizedBox(width: 12),
        Text('N${item.subtotal.toStringAsFixed(0)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      ]))),
    ])),
    const SizedBox(height: 20),
    _SummaryRow('Sub-total', 'N${_subtotal.toStringAsFixed(0)}'),
    _SummaryRow('Delivery Fee', 'N${_deliveryFee.toStringAsFixed(0)}'),
    _SummaryRow('Service Fee', 'N${_serviceFee.toStringAsFixed(0)}'),
    const Divider(height: 24),
    _SummaryRow('Total', 'N${_total.toStringAsFixed(0)}', bold: true),
  ]));

  Widget _buildDeliveryPayment() => SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const Text('Delivery Address', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
    const SizedBox(height: 12),
    if (_loadingAddresses) const CircularProgressIndicator(color: AppColors.primary)
    else if (_addresses.isEmpty) AppButton(label: '+ Add Address', outlined: true, height: 44, onTap: _showAddAddressSheet)
    else ...[
      ..._addresses.map((addr) {
        final id = int.tryParse(addr['id']?.toString() ?? '0') ?? 0;
        return GestureDetector(onTap: () => setState(() => _selectedAddressId = id), child: Container(
          margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: _selectedAddressId==id?AppColors.primary:AppColors.border, width: _selectedAddressId==id?2:1)),
          child: Row(children: [
            Icon(Icons.location_on_rounded, color: _selectedAddressId==id?AppColors.primary:AppColors.grey400, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(addr['label']?.toString() ?? 'Address', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              Text(addr['address']?.toString() ?? '', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ])),
            if (_selectedAddressId==id) const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 20),
          ]),
        ));
      }),
      TextButton.icon(onPressed: _showAddAddressSheet, icon: const Icon(Icons.add_location_alt_outlined, color: AppColors.primary), label: const Text('Add new address', style: TextStyle(color: AppColors.primary))),
    ],
    const SizedBox(height: 20),
    const Text('Payment Method', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
    const SizedBox(height: 12),
    _PaymentOption(icon: Icons.account_balance_wallet_outlined, label: 'Wallet', subtitle: 'N0 balance', value: 'wallet', selected: _paymentMethod, onTap: (v) => setState(() => _paymentMethod=v)),
    _PaymentOption(icon: Icons.language_rounded, label: 'Pay online', subtitle: 'Cards, bank transfer', value: 'online', selected: _paymentMethod, onTap: (v) => setState(() => _paymentMethod=v)),
    _PaymentOption(icon: Icons.people_outlined, label: 'Pay for me', subtitle: 'Ask someone to pay', value: 'pay_for_me', selected: _paymentMethod, onTap: (v) => setState(() => _paymentMethod=v)),
    const SizedBox(height: 20),
    _SummaryRow('Total', 'N${_total.toStringAsFixed(0)}', bold: true),
  ]));

  void _showAddAddressSheet() {
    final labelCtrl = TextEditingController();
    final addrCtrl = TextEditingController();
    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (_) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(padding: const EdgeInsets.all(24), decoration: const BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Add Address', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          AppTextField(label: 'Label', hint: 'Home, Work...', controller: labelCtrl),
          const SizedBox(height: 14),
          AppTextField(label: 'Address', hint: 'Full address', controller: addrCtrl),
          const SizedBox(height: 20),
          AppButton(label: 'Save Address', onTap: () async {
            await ApiClient.instance.addAddress(label: labelCtrl.text, address: addrCtrl.text, latitude: 6.5244, longitude: 3.3792);
            Get.back();
            _loadAddresses();
          }),
        ]),
      ),
    ));
  }
}

class _SummaryRow extends StatelessWidget {
  final String label; final String value; final bool bold;
  const _SummaryRow(this.label, this.value, {this.bold = false});
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 10),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: TextStyle(fontSize: 14, color: bold?AppColors.textPrimary:AppColors.textSecondary, fontWeight: bold?FontWeight.w700:FontWeight.w400)),
      Text(value, style: TextStyle(fontSize: bold?18:14, fontWeight: bold?FontWeight.w800:FontWeight.w600)),
    ]));
}

class _PaymentOption extends StatelessWidget {
  final IconData icon; final String label; final String subtitle;
  final String value; final String selected; final void Function(String) onTap;
  const _PaymentOption({required this.icon, required this.label, required this.subtitle, required this.value, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(onTap: () => onTap(value), child: Container(
    margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: selected==value?AppColors.primary:AppColors.border, width: selected==value?2:1)),
    child: Row(children: [
      Icon(icon, size: 22, color: AppColors.textSecondary),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ])),
      Radio<String>(value: value, groupValue: selected, onChanged: (v) => onTap(v!), activeColor: AppColors.primary),
    ]),
  ));
}
