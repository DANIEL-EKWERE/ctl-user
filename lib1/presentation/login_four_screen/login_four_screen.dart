// Redesigned: Checkout Screen (login_four = checkout flow)
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'controller/login_four_controller.dart';

// ignore_for_file: must_be_immutable
class LoginFourScreen extends GetWidget<LoginFourController> {
  const LoginFourScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back, color: Color(0xFF1B1B1B)),
        ),
        title: const Text(
          "Checkout",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1B1B1B),
          ),
        ),
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            child: Row(
              children: [
                _step("Your Order", true, true),
                Expanded(
                  child: Container(height: 2, color: const Color(0xFF1B5E20)),
                ),
                _step("Delivery & Payment", false, true),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildOrderSummary(),
                  const SizedBox(height: 16),
                  _buildChowpassPromo(),
                ],
              ),
            ),
          ),
          // Bottom CTA
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.paymentMethodsBottomsheet),
              child: Container(
                width: double.maxFinite,
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B5E20),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    "Make Payment",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _step(String label, bool active, bool done) {
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: done ? const Color(0xFF1B5E20) : const Color(0xFFF0F0F0),
            shape: BoxShape.circle,
          ),
          child: done
              ? const Icon(Icons.check, color: Colors.white, size: 14)
              : null,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: active ? FontWeight.w600 : FontWeight.w400,
            color: active ? const Color(0xFF1B1B1B) : const Color(0xFF888888),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Order Summary",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1B1B1B),
            ),
          ),
          const SizedBox(height: 12),
          // Vendor row
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: const Color(0xFFE8F5E9),
                child: const Icon(
                  Icons.storefront,
                  color: Color(0xFF1B5E20),
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                "Thiancee – Abule Ijesha",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              Text(
                "2 Items",
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ],
          ),
          const Divider(height: 20, color: Color(0xFFF0F0F0)),
          // Pack
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Pack 1",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              Row(
                children: [
                  _actionChip("+ Add to this pack"),
                  const SizedBox(width: 6),
                  Icon(Icons.copy_outlined, size: 18, color: Colors.grey[400]),
                  const SizedBox(width: 6),
                  Icon(Icons.delete_outline, size: 18, color: Colors.red[300]),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          _orderItem("✦ Jollof Rice", "₦1,300"),
          _orderItem("✦ Food Pack", "₦400"),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF1B5E20)),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "+ Add Another Pack",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1B5E20),
                ),
              ),
            ),
          ),
          const Divider(height: 20, color: Color(0xFFF0F0F0)),
          // Totals
          _summaryRow("Sub-total (1 item)", "₦6,000"),
          const SizedBox(height: 8),
          _summaryRow("Delivery Fee", "₦400"),
          const SizedBox(height: 8),
          _summaryRow("Service Fee", "₦600"),
          const Divider(height: 16, color: Color(0xFFF0F0F0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Total",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
              Text(
                "₦7,000",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1B1B1B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Leave message
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(
              Icons.storefront_outlined,
              color: Color(0xFF555555),
              size: 20,
            ),
            title: const Text(
              "Leave a message for the restaurant",
              style: TextStyle(fontSize: 13, color: Color(0xFF555555)),
            ),
            trailing: const Icon(
              Icons.chevron_right,
              size: 18,
              color: Color(0xFF999999),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildChowpassPromo() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEDE7F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Color(0xFF6A1B9A),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.star_outline,
              color: Colors.white,
              size: 14,
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              "You can save ₦520 on this order",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4A148C),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF6A1B9A),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              "Start trial",
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionChip(String label) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      border: Border.all(color: const Color(0xFFDDDDDD)),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Text(
      label,
      style: const TextStyle(fontSize: 11, color: Color(0xFF333333)),
    ),
  );

  Widget _orderItem(String name, String price) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: const TextStyle(fontSize: 13, color: Color(0xFF333333)),
        ),
        Text(
          price,
          style: const TextStyle(fontSize: 13, color: Color(0xFF555555)),
        ),
      ],
    ),
  );

  Widget _summaryRow(String label, String value) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
      Text(
        value,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Color(0xFF1B1B1B),
        ),
      ),
    ],
  );
}
