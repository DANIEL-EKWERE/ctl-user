// Redesigned: Onboarding Page 1
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'controller/splash_page_one_controller.dart';

// ignore_for_file: must_be_immutable
class SplashPageOneScreen extends GetWidget<SplashPageOneController> {
  const SplashPageOneScreen({Key? key}) : super(key: key);

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
                decoration: const BoxDecoration(color: Color(0xFFE8F5E9)),
                child: const Center(
                  child: Icon(Icons.delivery_dining, size: 120, color: Color(0xFF1B5E20)),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildDots(0),
                    const SizedBox(height: 24),
                    const Text(
                      "Fast & Reliable\nFood Delivery",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Color(0xFF1B1B1B), height: 1.2),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Get your favourite meals delivered to your door in minutes.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.5),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Get.toNamed(AppRoutes.loginScreen),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(border: Border.all(color: const Color(0xFFDDDDDD)), borderRadius: BorderRadius.circular(12)),
                              child: const Center(child: Text("Sign In", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1B1B1B)))),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => controller.onTapNext(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(color: const Color(0xFF1B5E20), borderRadius: BorderRadius.circular(12)),
                              child: const Center(child: Text("Get Started", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white))),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDots(int active) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: i == active ? 20 : 8,
        height: 8,
        decoration: BoxDecoration(
          color: i == active ? const Color(0xFF1B5E20) : const Color(0xFFDDDDDD),
          borderRadius: BorderRadius.circular(4),
        ),
      )),
    );
  }
}
