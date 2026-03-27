// Redesigned: Home Screen (simple redirect shell)
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'controller/home_controller.dart';

// ignore_for_file: must_be_immutable
class HomeScreen extends GetWidget<HomeController> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 80, height: 80,
                decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(20)),
                child: const Icon(Icons.fastfood, color: Color(0xFF1B5E20), size: 44)),
              const SizedBox(height: 16),
              const Text("ChewDeck", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFF1B1B1B))),
              const SizedBox(height: 8),
              Text("Food delivered fast", style: TextStyle(fontSize: 14, color: Colors.grey[600])),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.loginThreeScreen),
                child: Container(padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  decoration: BoxDecoration(color: const Color(0xFF1B5E20), borderRadius: BorderRadius.circular(12)),
                  child: const Text("Explore Restaurants", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
