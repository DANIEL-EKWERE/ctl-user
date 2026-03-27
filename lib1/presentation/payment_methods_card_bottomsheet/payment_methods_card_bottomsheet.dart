// Redesigned: Chewdeck-style Add Card Bottomsheet
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'controller/payment_methods_card_controller.dart';
import 'models/listplaceholder_item_model.dart';
import 'widgets/listplaceholder_item_widget.dart';

// ignore_for_file: must_be_immutable
class PaymentMethodsCardBottomsheet extends StatelessWidget {
  PaymentMethodsCardBottomsheet(this.controller, {Key? key}) : super(key: key);
  PaymentMethodsCardController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Container(margin: const EdgeInsets.symmetric(vertical: 12), width: 40, height: 4,
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
          const Text("Add New Card", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF1B1B1B))),
          const SizedBox(height: 20),
          // Card preview
          Container(
            height: 160, width: double.maxFinite,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(16)),
            padding: const EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Icon(Icons.credit_card, color: Colors.white, size: 32),
                const Text("VISA", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: 2)),
              ]),
              const Text("**** **** **** ****", style: TextStyle(color: Colors.white70, fontSize: 16, letterSpacing: 4)),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text("Card Holder Name", style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
                Text("MM/YY", style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
              ]),
            ]),
          ),
          const SizedBox(height: 20),
          _label("Card Number"), const SizedBox(height: 8),
          _textField("1234 5678 9012 3456", TextInputType.number),
          const SizedBox(height: 14),
          Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _label("Expiry Date"), const SizedBox(height: 8),
              _textField("MM/YY", TextInputType.number),
            ])),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _label("CVV"), const SizedBox(height: 8),
              _textField("•••", TextInputType.number, obscure: true),
            ])),
          ]),
          const SizedBox(height: 14),
          _label("Card Holder Name"), const SizedBox(height: 8),
          _textField("Full name on card", TextInputType.text),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(width: double.maxFinite, padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(color: const Color(0xFF1B5E20), borderRadius: BorderRadius.circular(12)),
              child: const Center(child: Text("Add Card", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)))),
          ),
        ],
      ),
    );
  }

  Widget _label(String t) => Text(t, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF333333)));
  Widget _textField(String hint, TextInputType type, {bool obscure = false}) => TextField(
    keyboardType: type, obscureText: obscure,
    style: const TextStyle(fontSize: 14, color: Color(0xFF1B1B1B)),
    decoration: InputDecoration(
      hintText: hint, hintStyle: TextStyle(fontSize: 14, color: Colors.grey[400]),
      filled: true, fillColor: const Color(0xFFF8F8F8),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFEEEEEE))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFEEEEEE))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF1B5E20), width: 1.5)),
    ),
  );
}
