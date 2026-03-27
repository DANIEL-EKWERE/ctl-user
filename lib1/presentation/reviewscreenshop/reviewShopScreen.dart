import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'controller/review_shop_controller.dart';
// ignore_for_file: must_be_immutable
class ReviewShopScreen extends GetWidget<ReviewShopController> {
  const ReviewShopScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0.5,
        leading: GestureDetector(onTap: () => Get.back(), child: const Icon(Icons.arrow_back, color: Color(0xFF1B1B1B))),
        title: const Text("Shop Reviews", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF1B1B1B))),
      ),
      body: Column(children: [
        Container(color: Colors.white, padding: const EdgeInsets.all(16), child: Row(children: [
          const Text("4.3", style: TextStyle(fontSize: 48, fontWeight: FontWeight.w800, color: Color(0xFF1B1B1B))),
          const SizedBox(width: 16),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: List.generate(5, (i) => Icon(i < 4 ? Icons.star : Icons.star_half, color: const Color(0xFFFFC107), size: 20))),
            const SizedBox(height: 4),
            Text("516 reviews", style: TextStyle(fontSize: 13, color: Colors.grey[500])),
          ]),
        ])),
        const Divider(height: 1, color: Color(0xFFF0F0F0)),
        Expanded(child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: 5,
          separatorBuilder: (_, __) => const Divider(height: 24, color: Color(0xFFEEEEEE)),
          itemBuilder: (context, index) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              CircleAvatar(radius: 18, backgroundColor: const Color(0xFFE8F5E9), child: const Icon(Icons.person, color: Color(0xFF1B5E20), size: 18)),
              const SizedBox(width: 10),
              const Expanded(child: Text("Customer Name", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1B1B1B)))),
              Row(children: const [Icon(Icons.star, color: Color(0xFFFFC107), size: 14), SizedBox(width: 3), Text("4.5", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600))]),
            ]),
            const SizedBox(height: 8),
            const Text("Great shop with excellent service and quality products!", style: TextStyle(fontSize: 13, color: Color(0xFF555555), height: 1.5)),
          ]),
        )),
      ]),
    );
  }
}
