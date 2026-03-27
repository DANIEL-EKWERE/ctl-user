import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'controller/splash_page_five_controller.dart';
// ignore_for_file: must_be_immutable
class SplashPageFiveScreen extends GetWidget<SplashPageFiveController> {
  const SplashPageFiveScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B5E20),
      body: SafeArea(child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(width: 80, height: 80, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: const Icon(Icons.fastfood, color: Color(0xFF1B5E20), size: 44)),
        const SizedBox(height: 20),
        const Text("ChewDeck", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white)),
        const SizedBox(height: 8),
        Text("Food delivered fast", style: TextStyle(fontSize: 15, color: Colors.white.withOpacity(0.7))),
        const SizedBox(height: 60),
        const SizedBox(width: 32, height: 32, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3)),
      ]))),
    );
  }
}
