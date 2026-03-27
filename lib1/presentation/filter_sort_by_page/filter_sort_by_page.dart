// Redesigned: Sort by options
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'controller/filter_sort_by_controller.dart';

// ignore_for_file: must_be_immutable
class FilterSortByPage extends GetWidget<FilterSortByController> {
  const FilterSortByPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final options = ["Relevance", "Rating", "Delivery Time", "Price: Low to High", "Price: High to Low", "Distance"];
    return Obx(() => Column(
      children: options.map((opt) {
        final selected = controller.selectedSort.value == opt;
        return GestureDetector(
          onTap: () => controller.selectedSort.value = opt,
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: selected ? const Color(0xFFE8F5E9) : const Color(0xFFF8F8F8),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: selected ? const Color(0xFF1B5E20) : const Color(0xFFEEEEEE)),
            ),
            child: Row(
              children: [
                Expanded(child: Text(opt, style: TextStyle(fontSize: 14, fontWeight: selected ? FontWeight.w600 : FontWeight.w400, color: selected ? const Color(0xFF1B5E20) : const Color(0xFF333333)))),
                if (selected) const Icon(Icons.check_circle, color: Color(0xFF1B5E20), size: 18),
              ],
            ),
          ),
        );
      }).toList(),
    ));
  }
}
