import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'controller/review_controller.dart';
// ignore_for_file: must_be_immutable
class ReviewScreen extends GetWidget<ReviewController> {
  const ReviewScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0.5,
        leading: GestureDetector(onTap: () => Get.back(), child: const Icon(Icons.arrow_back, color: Color(0xFF1B1B1B))),
        title: const Text("Reviews", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF1B1B1B))),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        separatorBuilder: (_, __) => const Divider(height: 24, color: Color(0xFFEEEEEE)),
        itemBuilder: (context, index) => _buildReviewItem(),
      ),
    );
  }
  Widget _buildReviewItem() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        CircleAvatar(radius: 18, backgroundColor: const Color(0xFFE8F5E9), child: const Icon(Icons.person, color: Color(0xFF1B5E20), size: 18)),
        const SizedBox(width: 10),
        const Expanded(child: Text("Customer Name", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1B1B1B)))),
        Row(children: const [Icon(Icons.star, color: Color(0xFFFFC107), size: 14), SizedBox(width: 3), Text("4.5", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600))]),
      ]),
      const SizedBox(height: 8),
      const Text("Great food and fast delivery! Will definitely order again.", style: TextStyle(fontSize: 13, color: Color(0xFF555555), height: 1.5)),
      const SizedBox(height: 6),
      Text("2 hours ago", style: TextStyle(fontSize: 11, color: Colors.grey[400])),
    ]);
  }
}
