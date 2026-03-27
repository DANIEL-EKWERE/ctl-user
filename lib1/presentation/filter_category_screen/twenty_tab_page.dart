import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'controller/filter_category_controller.dart';
// ignore_for_file: must_be_immutable
class TwentyTabPage extends GetWidget<FilterCategoryController> {
  const TwentyTabPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final cats = ["All", "Restaurants", "Shops", "Pharmacies", "Local Markets", "Events", "Packages", "More"];
    return Obx(() => Wrap(
      spacing: 8, runSpacing: 8,
      children: cats.map((c) {
        final sel = controller.selectedCategory.value == c;
        return GestureDetector(
          onTap: () => controller.selectedCategory.value = c,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: sel ? const Color(0xFFE8F5E9) : const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: sel ? const Color(0xFF1B5E20) : const Color(0xFFEEEEEE)),
            ),
            child: Text(c, style: TextStyle(fontSize: 13, fontWeight: sel ? FontWeight.w600 : FontWeight.w400, color: sel ? const Color(0xFF1B5E20) : const Color(0xFF555555))),
          ),
        );
      }).toList(),
    ));
  }
}
