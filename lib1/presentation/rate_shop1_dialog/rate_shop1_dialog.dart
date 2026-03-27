// Redesigned: Quick Rate Shop Dialog
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'controller/rate_shop1_controller.dart';

// ignore_for_file: must_be_immutable
class RateShop1Dialog extends StatelessWidget {
  RateShop1Dialog(this.controller, {Key? key}) : super(key: key);
  RateShop1Controller controller;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          CircleAvatar(radius: 32, backgroundColor: const Color(0xFFE8F5E9),
            child: const Icon(Icons.storefront, color: Color(0xFF1B5E20), size: 32)),
          const SizedBox(height: 14),
          const Text("Rate this Shop", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF1B1B1B))),
          const SizedBox(height: 6),
          Text("How was your experience?", style: TextStyle(fontSize: 13, color: Colors.grey[500])),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(5, (i) =>
            GestureDetector(
              onTap: () => controller.rating.value = i + 1.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Obx(() => Icon(i < controller.rating.value ? Icons.star : Icons.star_border,
                  color: const Color(0xFFFFC107), size: 32)),
              ),
            ))),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(border: Border.all(color: const Color(0xFFDDDDDD)), borderRadius: BorderRadius.circular(10)),
                child: const Center(child: Text("Skip", style: TextStyle(fontSize: 14, color: Color(0xFF555555))))),
            )),
            const SizedBox(width: 12),
            Expanded(child: GestureDetector(
              onTap: () { controller.onTapSubmit(); Get.back(); },
              child: Container(padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(color: const Color(0xFF1B5E20), borderRadius: BorderRadius.circular(10)),
                child: const Center(child: Text("Submit", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)))),
            )),
          ]),
        ]),
      ),
    );
  }
}
