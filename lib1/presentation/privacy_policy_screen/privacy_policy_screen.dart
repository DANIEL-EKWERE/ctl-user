import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'controller/privacy_policy_controller.dart';
// ignore_for_file: must_be_immutable
class PrivacyPolicyScreen extends GetWidget<PrivacyPolicyController> {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0.5,
        leading: GestureDetector(onTap: () => Get.back(), child: const Icon(Icons.arrow_back, color: Color(0xFF1B1B1B))),
        title: const Text("Privacy Policy", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF1B1B1B))),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Last updated: January 2025", style: TextStyle(fontSize: 12, color: Color(0xFF888888))),
          SizedBox(height: 20),
          _PolicySection("1. Information We Collect", "We collect information you provide directly to us, such as when you create an account, place an order, or contact us for support."),
          _PolicySection("2. How We Use Your Information", "We use the information we collect to provide, maintain, and improve our services, process transactions, and send related information."),
          _PolicySection("3. Information Sharing", "We do not sell, trade, or otherwise transfer your personal information to outside parties except as described in this policy."),
          _PolicySection("4. Data Security", "We implement appropriate technical and organizational measures to protect your personal information against unauthorized access."),
          _PolicySection("5. Contact Us", "If you have questions about this Privacy Policy, please contact us at privacy@chewdeck.com"),
        ]),
      ),
    );
  }
}
class _PolicySection extends StatelessWidget {
  final String title, body;
  const _PolicySection(this.title, this.body);
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
