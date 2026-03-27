// Redesigned: Chewdeck-style Search Screen
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'controller/search_vone_controller.dart';
import 'models/listburger_king_item_model.dart';
import 'widgets/listburger_king_item_widget.dart';

// ignore_for_file: must_be_immutable
class SearchVoneScreen extends GetWidget<SearchVoneController> {
  const SearchVoneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        title: TextField(
          controller: controller.searchController,
          autofocus: true,
          style: const TextStyle(fontSize: 14, color: Color(0xFF1B1B1B)),
          decoration: InputDecoration(
            hintText: "Search for restaurants, food...",
            hintStyle: TextStyle(fontSize: 14, color: Colors.grey[400]),
            prefixIcon: const Icon(Icons.search, color: Color(0xFF888888), size: 20),
            suffixIcon: IconButton(
              icon: const Icon(Icons.close, color: Color(0xFF888888), size: 20),
              onPressed: () => controller.searchController.clear(),
            ),
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          ),
        ),
      ),
      body: Obx(() {
        final items = controller.searchVoneModelObj.value.listburgerKingItemList.value;
        if (items.isEmpty) {
          return _buildEmptySearch();
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF0F0F0)),
          itemBuilder: (context, index) {
            ListburgerKingItemModel model = items[index];
            return ListburgerKingItemWidget(model);
          },
        );
      }),
    );
  }

  Widget _buildEmptySearch() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Popular Searches", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1B1B1B))),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: ["Jollof Rice", "Sharwama", "Chicken", "Pizza", "Burgers", "Seafood", "Suya", "Pepper Soup"].map((tag) =>
              GestureDetector(
                onTap: () => controller.searchController.text = tag,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFDDDDDD)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(tag, style: const TextStyle(fontSize: 13, color: Color(0xFF333333))),
                ),
              ),
            ).toList(),
          ),
        ],
      ),
    );
  }
}
