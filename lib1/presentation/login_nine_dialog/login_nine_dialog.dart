// Redesigned: Order Success Dialog
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'controller/login_nine_controller.dart';

// ignore_for_file: must_be_immutable
class LoginNineDialog extends StatelessWidget {
  LoginNineDialog(this.controller, {Key? key}) : super(key: key);
  LoginNineController controller;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 72, height: 72,
              decoration: const BoxDecoration(color: Color(0xFFE8F5E9), shape: BoxShape.circle),
              child: const Icon(Icons.check_circle, color: Color(0xFF1B5E20), size: 40)),
            const SizedBox(height: 16),
            const Text("Order Placed!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF1B1B1B))),
            const SizedBox(height: 8),
            Text(
              "Your order has been placed successfully and is being prepared.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.5),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.yourOrdersOngoingScreen),
              child: Container(width: double.maxFinite, padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(color: const Color(0xFF1B5E20), borderRadius: BorderRadius.circular(12)),
                child: const Center(child: Text("Track Order", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)))),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => Get.back(),
              child: Container(width: double.maxFinite, padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(border: Border.all(color: const Color(0xFFDDDDDD)), borderRadius: BorderRadius.circular(12)),
                child: const Center(child: Text("Keep Browsing", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1B1B1B))))),
            ),
          ],
        ),
      ),
    );
  }
}
