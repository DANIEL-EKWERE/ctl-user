// Redesigned: Best Partners V2 (alternate vendor list sheet)
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../best_partners_vone_bottomsheet/best_partners_vone_bottomsheet.dart';
import 'controller/best_partners_vtwo_controller.dart';

// ignore_for_file: must_be_immutable
class BestPartnersVtwoBottomsheet extends StatelessWidget {
  BestPartnersVtwoBottomsheet(this.controller, {Key? key}) : super(key: key);
  BestPartnersVtwoController controller;

  @override
  Widget build(BuildContext context) {
    // Reuses the V1 design with same layout
    return Container(
      decoration: const BoxDecoration(color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))),
      child: Column(children: [
        Container(margin: const EdgeInsets.symmetric(vertical: 10), width: 40, height: 4,
          decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text("Top Partners", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF1B1B1B))),
        ),
        const SizedBox(height: 8),
        Center(child: Column(children: [
          Icon(Icons.storefront_outlined, size: 52, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text("No partners available", style: TextStyle(color: Colors.grey[500], fontSize: 14)),
        ])),
        const SizedBox(height: 24),
      ]),
    );
  }
}
