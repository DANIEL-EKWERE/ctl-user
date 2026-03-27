// Redesigned: Chewdeck-style Vendor Reviews Screen (standalone)
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'controller/detail_restaurants_review_vone_controller.dart';
import 'models/listtoday16fort_item_model.dart';
import 'widgets/listtoday16fort_item_widget.dart';

// ignore_for_file: must_be_immutable
class DetailRestaurantsReviewVoneScreen
    extends GetWidget<DetailRestaurantsReviewVoneController> {
  const DetailRestaurantsReviewVoneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: GestureDetector(onTap: () => Get.back(), child: const Icon(Icons.arrow_back, color: Color(0xFF1B1B1B))),
        title: const Text("Reviews", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF1B1B1B))),
      ),
      body: Column(
        children: [
          // Rating summary card
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
            child: Column(children: [
              // Vendor name + status
              Row(children: [
                const Expanded(child: Text("Burger King", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF1B1B1B)))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFFFFEBEE), borderRadius: BorderRadius.circular(6)),
                  child: const Text("Take Away", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFFD32F2F))),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.favorite_border, size: 20, color: Color(0xFF555555)),
              ]),
              const SizedBox(height: 6),
              Row(children: [
                const Text("Open", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E7D32))),
                const SizedBox(width: 6),
                Container(width: 3, height: 3, decoration: const BoxDecoration(color: Color(0xFFBBBBBB), shape: BoxShape.circle)),
                const SizedBox(width: 6),
                Text("1453 W Manchester Ave", style: TextStyle(fontSize: 12, color: Colors.grey[500])),
              ]),
              const SizedBox(height: 14),
              const Divider(height: 1, color: Color(0xFFF0F0F0)),
              const SizedBox(height: 14),
              // Stats row
              Row(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFF1B5E20), borderRadius: BorderRadius.circular(6)),
                  child: Row(children: const [
                    Icon(Icons.star, color: Colors.white, size: 12),
                    SizedBox(width: 3),
                    Text("4.5", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                  ]),
                ),
                const SizedBox(width: 10),
                Text("(2,950 reviews)", style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                const SizedBox(width: 10),
                Container(width: 3, height: 3, decoration: const BoxDecoration(color: Color(0xFFBBBBBB), shape: BoxShape.circle)),
                const SizedBox(width: 10),
                const Icon(Icons.access_time, size: 14, color: Color(0xFF555555)),
                const SizedBox(width: 4),
                Text("15 mins", style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                const Spacer(),
                Text("Free shipping", style: TextStyle(fontSize: 12, color: Colors.grey[500])),
              ]),
              const SizedBox(height: 12),
              // Chowpass promo
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(color: const Color(0xFFEDE7F6), borderRadius: BorderRadius.circular(8)),
                child: Row(children: [
                  Container(padding: const EdgeInsets.all(6), decoration: const BoxDecoration(color: Color(0xFF6A1B9A), shape: BoxShape.circle),
                    child: const Icon(Icons.star_outline, color: Colors.white, size: 14)),
                  const SizedBox(width: 10),
                  const Expanded(child: Text("Save ₦15.00 with Chowpass", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF4A148C)))),
                ]),
              ),
            ]),
          ),
          // Reviews list
          Expanded(
            child: Obx(() => ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: controller.detailRestaurantsReviewVoneModelObj.value.listtoday16fortItemList.value.length,
              separatorBuilder: (_, __) => const Divider(height: 20, color: Color(0xFFEEEEEE)),
              itemBuilder: (context, index) {
                Listtoday16fortItemModel model = controller.detailRestaurantsReviewVoneModelObj.value.listtoday16fortItemList.value[index];
                return Listtoday16fortItemWidget(model);
              },
            )),
          ),
        ],
      ),
    );
  }
}
