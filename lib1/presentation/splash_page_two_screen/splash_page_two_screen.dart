import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'controller/splash_page_two_controller.dart';

// ignore_for_file: must_be_immutable
class SplashPageTwoScreen extends GetWidget<SplashPageTwoController> {
  const SplashPageTwoScreen({Key? key}) : super(key: key);

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
                decoration: const BoxDecoration(color: Color(0xFFFFF8E1)),
                child: const Center(child: Icon(Icons.restaurant_menu, size: 120, color: Color(0xFFF57F17))),
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
                        width: i == 1 ? 20 : 8, height: 8,
                        decoration: BoxDecoration(
                          color: i == 1 ? const Color(0xFF1B5E20) : const Color(0xFFDDDDDD),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      )),
                    ),
                    const SizedBox(height: 24),
                    const Text("Thousands of\nRestaurants", textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Color(0xFF1B1B1B), height: 1.2)),
                    const SizedBox(height: 12),
                    Text("Discover restaurants, shops, pharmacies and more near you.",
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
                        onTap: () => controller.onTapNext(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(color: const Color(0xFF1B5E20), borderRadius: BorderRadius.circular(12)),
                          child: const Center(child: Text("Next", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white))),
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
