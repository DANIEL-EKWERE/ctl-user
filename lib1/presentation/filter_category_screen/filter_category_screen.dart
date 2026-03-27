// Redesigned: Chewdeck-style Filter Screen
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'controller/filter_category_controller.dart';
import '../filter_price_page/filter_price_page.dart';
import '../filter_sort_by_page/filter_sort_by_page.dart';
import 'twenty_tab_page.dart';

// ignore_for_file: must_be_immutable
class FilterCategoryScreen extends GetWidget<FilterCategoryController> {
  const FilterCategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(Icons.close, color: Color(0xFF1B1B1B)),
        ),
        title: const Text("Filter", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF1B1B1B))),
        actions: [
          TextButton(
            onPressed: () => controller.clearFilters(),
            child: const Text("Clear all", style: TextStyle(fontSize: 13, color: Color(0xFF1B5E20), fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection("Sort by", child: FilterSortByPage()),
                  const SizedBox(height: 16),
                  _buildSection("Price Range", child: FilterPricePage()),
                  const SizedBox(height: 16),
                  _buildSection("Categories", child: TwentyTabPage()),
                ],
              ),
            ),
          ),
          // Apply button
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                width: double.maxFinite,
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(color: const Color(0xFF1B5E20), borderRadius: BorderRadius.circular(12)),
                child: const Center(child: Text("Apply Filters", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700))),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, {required Widget child}) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1B1B1B))),
          ),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          Padding(padding: const EdgeInsets.all(16), child: child),
        ],
      ),
    );
  }
}
