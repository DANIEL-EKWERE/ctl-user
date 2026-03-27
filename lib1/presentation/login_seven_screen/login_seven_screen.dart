// Redesigned: Confirm Order Screen (login_seven = order confirmation with address)
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'controller/login_seven_controller.dart';
import 'models/items_item_model.dart';
import 'widgets/items_item_widget.dart';

// ignore_for_file: must_be_immutable
class LoginSevenScreen extends GetWidget<LoginSevenController> {
  const LoginSevenScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: GestureDetector(onTap: () => Get.back(), child: const Icon(Icons.arrow_back, color: Color(0xFF1B1B1B))),
        title: const Text("Confirm Order", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF1B1B1B))),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                _buildDeliveryCard(),
                const SizedBox(height: 16),
                _buildOrderCard(),
                const SizedBox(height: 16),
                _buildVoucherCard(),
                const SizedBox(height: 16),
                _buildPaymentCard(),
              ]),
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: GestureDetector(
              onTap: () => controller.createOrder(),
              child: Container(
                width: double.maxFinite, padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(color: const Color(0xFF1B5E20), borderRadius: BorderRadius.circular(12)),
                child: const Center(child: Text("Place Order", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700))),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6)]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text("Delivery To", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1B1B1B))),
        const Divider(height: 16, color: Color(0xFFF0F0F0)),
        Row(children: [
          Container(width: 80, height: 80, decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.location_on_outlined, color: Color(0xFF1B5E20), size: 36)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text("CBC Towers, 10/...", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1B1B1B))),
            const SizedBox(height: 4),
            Row(children: [
              const Icon(Icons.directions_walk, size: 14, color: Color(0xFF555555)),
              const SizedBox(width: 4),
              Text("1.5 km away", style: TextStyle(fontSize: 12, color: Colors.grey[500])),
            ]),
          ])),
        ]),
      ]),
    );
  }

  Widget _buildOrderCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6)]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text("Order Details", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1B1B1B))),
        const Divider(height: 16, color: Color(0xFFF0F0F0)),
        Obx(() => ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.loginSevenModelObj.value.itemsItemList.value.length,
          separatorBuilder: (_, __) => const Divider(height: 12, color: Color(0xFFF0F0F0)),
          itemBuilder: (context, index) {
            ItemsItemModel model = controller.loginSevenModelObj.value.itemsItemList.value[index];
            return ItemsItemWidget(model);
          },
        )),
        const Divider(height: 20, color: Color(0xFFF0F0F0)),
        _row("Subtotal", "₦6,000"),
        const SizedBox(height: 8),
        _row("Delivery", "₦400"),
        const SizedBox(height: 8),
        _row("Service Fee", "₦600"),
        const Divider(height: 16, color: Color(0xFFF0F0F0)),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
          Text("Total", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          Text("₦7,000", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF1B1B1B))),
        ]),
      ]),
    );
  }

  Widget _buildVoucherCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6)]),
      child: Row(children: [
        const Icon(Icons.local_offer_outlined, color: Color(0xFF1B5E20), size: 22),
        const SizedBox(width: 12),
        const Expanded(child: Text("Add Voucher / Promo Code", style: TextStyle(fontSize: 14, color: Color(0xFF333333)))),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(16)),
          child: const Text("Add", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1B5E20))),
        ),
      ]),
    );
  }

  Widget _buildPaymentCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6)]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text("Payment Method", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1B1B1B))),
        const SizedBox(height: 12),
        _payMethod(Icons.account_balance_wallet_outlined, "Wallet", "₦0 balance"),
        const SizedBox(height: 8),
        _payMethod(Icons.language, "Pay Online", "Card / Bank Transfer"),
        const SizedBox(height: 8),
        _payMethod(Icons.people_outline, "Pay For Me", "Share with someone"),
      ]),
    );
  }

  Widget _payMethod(IconData icon, String title, String sub) => ListTile(
    contentPadding: EdgeInsets.zero,
    leading: Container(width: 40, height: 40,
      decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(10)),
      child: Icon(icon, size: 20, color: const Color(0xFF333333))),
    title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
    subtitle: Text(sub, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
    trailing: Container(width: 20, height: 20,
      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFFDDDDDD), width: 2))),
    onTap: () {},
  );

  Widget _row(String l, String v) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    Text(l, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
    Text(v, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1B1B1B))),
  ]);
}
