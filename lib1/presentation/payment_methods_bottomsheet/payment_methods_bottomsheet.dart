// Redesigned: Chewdeck-style Payment Methods Bottomsheet
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'controller/payment_methods_controller.dart';

// ignore_for_file: must_be_immutable
class PaymentMethodsBottomsheet extends StatelessWidget {
  PaymentMethodsBottomsheet(this.controller, {Key? key}) : super(key: key);
  PaymentMethodsController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // handle
          Container(margin: const EdgeInsets.symmetric(vertical: 10), width: 40, height: 4,
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text("Payment Method", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF1B1B1B))),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 16, color: Color(0xFF1B5E20)),
                label: const Text("Add", style: TextStyle(fontSize: 13, color: Color(0xFF1B5E20), fontWeight: FontWeight.w600)),
              ),
              const SizedBox(width: 12),
            ],
          ),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 8),
          // Wallet row
          _buildMethodTile(Icons.account_balance_wallet_outlined, "₦0", "Wallet", false),
          const Divider(height: 1, indent: 64, color: Color(0xFFF5F5F5)),
          _buildMethodTile(Icons.language, "Pay online", "", false),
          const Divider(height: 1, indent: 64, color: Color(0xFFF5F5F5)),
          _buildMethodTile(Icons.people_outline, "Pay for me", "", false),
          const SizedBox(height: 8),
          // Access bank promo
          Container(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                  child: const Center(child: Text("💳", style: TextStyle(fontSize: 20))),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    "Enjoy ₦2,500 cashback when you spend ₦7,000+ with Access Bank Mastercard.",
                    style: TextStyle(fontSize: 12, color: Color(0xFF1B5E20), height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                width: double.maxFinite,
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(color: const Color(0xFF1B5E20), borderRadius: BorderRadius.circular(12)),
                child: const Center(child: Text("Place Order", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700))),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMethodTile(IconData icon, String title, String subtitle, bool selected) {
    return ListTile(
      leading: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, size: 20, color: const Color(0xFF333333)),
      ),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1B1B1B))),
      subtitle: subtitle.isNotEmpty ? Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[500])) : null,
      trailing: Container(
        width: 22, height: 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: selected ? const Color(0xFF1B5E20) : const Color(0xFFDDDDDD), width: 2),
        ),
        child: selected ? const Center(child: CircleAvatar(radius: 5, backgroundColor: Color(0xFF1B5E20))) : null,
      ),
    );
  }
}
