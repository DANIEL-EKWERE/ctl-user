import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'controller/terms_of_service_controller.dart';
// ignore_for_file: must_be_immutable
class TermsOfServiceScreen extends GetWidget<TermsOfServiceController> {
  const TermsOfServiceScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0.5,
        leading: GestureDetector(onTap: () => Get.back(), child: const Icon(Icons.arrow_back, color: Color(0xFF1B1B1B))),
        title: const Text("Terms of Service", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF1B1B1B))),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Effective: January 2025", style: TextStyle(fontSize: 12, color: Color(0xFF888888))),
          SizedBox(height: 20),
          _Section("1. Acceptance of Terms", "By accessing or using ChewDeck, you agree to be bound by these Terms of Service."),
          _Section("2. Use of Service", "You may use our service only for lawful purposes and in accordance with these terms."),
          _Section("3. Account Registration", "You must provide accurate and complete information when creating an account."),
          _Section("4. Orders and Payments", "All orders are subject to availability. Payment must be made at the time of placing an order."),
          _Section("5. Cancellation Policy", "Orders may be cancelled within 5 minutes of placement. After this window, cancellations may not be possible."),
        ]),
      ),
    );
  }
}
class _Section extends StatelessWidget {
  final String title, body;
  const _Section(this.title, this.body);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1B1B1B))),
      const SizedBox(height: 8),
      Text(body, style: const TextStyle(fontSize: 14, color: Color(0xFF555555), height: 1.6)),
    ]),
  );
}
