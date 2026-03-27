import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'controller/splash_page_three_controller.dart';

// ignore_for_file: must_be_immutable
class SplashPageThreeScreen extends GetWidget<SplashPageThreeController> {
  const SplashPageThreeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 6,
              child: Container(
                width: double.maxFinite,
                decoration: const BoxDecoration(color: Color(0xFFE3F2FD)),
                child: const Center(child: Icon(Icons.track_changes, size: 120, color: Color(0xFF1565C0))),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (i) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: i == 2 ? 20 : 8, height: 8,
                        decoration: BoxDecoration(
                          color: i == 2 ? const Color(0xFF1B5E20) : const Color(0xFFDDDDDD),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      )),
                    ),
                    const SizedBox(height: 24),
                    const Text("Track your Order\nin Real-time", textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Color(0xFF1B1B1B), height: 1.2)),
                    const SizedBox(height: 12),
                    Text("Know exactly where your order is at every step of the way.",
                      textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.5)),
                    const SizedBox(height: 32),
                    Row(children: [
                      Expanded(child: GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(border: Border.all(color: const Color(0xFFDDDDDD)), borderRadius: BorderRadius.circular(12)),
                          child: const Center(child: Text("Back", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1B1B1B)))),
                        ),
                      )),
                      const SizedBox(width: 12),
                      Expanded(child: GestureDetector(
                        onTap: () => Get.toNamed(AppRoutes.loginScreen),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(color: const Color(0xFF1B5E20), borderRadius: BorderRadius.circular(12)),
                          child: const Center(child: Text("Get Started", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white))),
                        ),
                      )),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
