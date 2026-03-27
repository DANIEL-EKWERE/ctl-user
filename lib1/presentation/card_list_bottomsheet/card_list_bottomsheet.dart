import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'controller/card_list_controller.dart';
// ignore_for_file: must_be_immutable
class CardListBottomsheet extends StatelessWidget {
  CardListBottomsheet(this.controller, {Key? key}) : super(key: key);
  CardListController controller;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Center(child: Container(margin: const EdgeInsets.symmetric(vertical: 12), width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
        const Text("Saved Cards", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF1B1B1B))),
        const SizedBox(height: 16),
        const Divider(height: 1, color: Color(0xFFF0F0F0)),
        const SizedBox(height: 16),
        Center(child: Column(children: [
          Icon(Icons.credit_card_off_outlined, size: 52, color: Colors.grey[300]),
          const SizedBox(height: 12),
          const Text("No saved cards", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF333333))),
          const SizedBox(height: 8),
          Text("Add a card to pay faster on your next order", style: TextStyle(fontSize: 13, color: Colors.grey[500]), textAlign: TextAlign.center),
        ])),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: () => Get.toNamed(AppRoutes.paymentMethodsCardBottomsheet),
          child: Container(width: double.maxFinite, padding: const EdgeInsets.symmetric(vertical: 15), decoration: BoxDecoration(color: const Color(0xFF1B5E20), borderRadius: BorderRadius.circular(12)),
            child: const Center(child: Text("Add New Card", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)))),
        ),
      ]),
    );
  }
}
