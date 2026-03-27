// Redesigned: Chewdeck-style Orders / Cart Screen
import 'package:ctluser/presentation/add_new_screen/models/cartModel.dart';
import 'package:ctluser/presentation/detail_restaurants_vone_screen/models/cat_prod.dart';
import 'package:ctluser/presentation/detail_restaurants_vone_screen/models/model.dart';
import 'package:ctluser/presentation/login_three_screen/models/model.dart' hide State;
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'controller/add_new_controller.dart';
import 'models/items_item_model.dart';
import 'widgets/items_item_widget.dart';

// ignore_for_file: must_be_immutable
AddNewController controller = Get.find<AddNewController>();

class AddNewScreen extends StatefulWidget {
  AddNewScreen({Key? key}) : super(key: key);
  @override
  State<AddNewScreen> createState() => _AddNewScreenState();
}

class _AddNewScreenState extends State<AddNewScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  CatProductItems? productItem;
  String? quantity;
  double? finalPrice;
  Vendor? vendorData;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    final args = Get.arguments as Map?;
    if (args != null) {
      productItem = args['product'] as CatProductItems?;
      quantity = args['quantity'] as String?;
      finalPrice = args['finalPrice'] as double?;
      vendorData = args['vendor'] as Vendor?;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCartTab(),
                _buildOngoingTab(),
                _buildCompletedTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      leading: GestureDetector(
        onTap: () => Get.back(),
        child: const Icon(Icons.arrow_back, color: Color(0xFF1B1B1B)),
      ),
      title: const Text("Orders", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF1B1B1B))),
      actions: [
        TextButton(
          onPressed: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF1B5E20)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text("Clear Cart", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1B5E20))),
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: Colors.white,
        unselectedLabelColor: const Color(0xFF555555),
        indicator: BoxDecoration(
          color: const Color(0xFF1B1B1B),
          borderRadius: BorderRadius.circular(8),
        ),
        labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        tabs: const [Tab(text: "My Cart"), Tab(text: "Ongoing"), Tab(text: "Completed")],
      ),
    );
  }

  Widget _buildCartTab() {
    if (controller.cartList.isEmpty) {
      return _buildEmptyState(Icons.shopping_bag_outlined, "Your cart is empty", "Add items from a restaurant to get started");
    }
    // Group cart items by vendor
    final Map<String, List<Cartmodel>> grouped = {};
    for (final item in controller.cartList) {
      final key = item.name ?? "Unknown";
      grouped.putIfAbsent(key, () => []).add(item);
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: grouped.entries.map((entry) => _buildCartGroup(entry.key, entry.value)).toList(),
    );
  }

  Widget _buildCartGroup(String vendorName, List<Cartmodel> items) {
    final total = items.fold<double>(0, (sum, i) => sum + (double.tryParse(i.price ?? "0") ?? 0));
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          // Vendor header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xFFE8F5E9),
                  child: const Icon(Icons.storefront, color: Color(0xFF1B5E20), size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(vendorName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1B1B1B))),
                      Text("${items.length} Item${items.length > 1 ? 's' : ''} • ₦${total.toStringAsFixed(0)}",
                          style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      const Text("View Selection", style: TextStyle(fontSize: 12, color: Color(0xFF1B5E20))),
                      const Icon(Icons.keyboard_arrow_up, size: 16, color: Color(0xFF1B5E20)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          // Delivery info
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: Row(
              children: [
                const Text("🛵", style: TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Text("Delivering to Lagos", style: TextStyle(fontSize: 13, color: Colors.grey[700])),
              ],
            ),
          ),
          // Checkout button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: GestureDetector(
              onTap: () => controller.createOrder(),
              child: Container(
                width: double.maxFinite,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(color: const Color(0xFF1B5E20), borderRadius: BorderRadius.circular(10)),
                child: const Center(child: Text("Checkout", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700))),
              ),
            ),
          ),
          // Clear
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TextButton(
              onPressed: () {},
              child: const Text("Clear Selection", style: TextStyle(fontSize: 13, color: Color(0xFF1B5E20))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOngoingTab() {
    return _buildEmptyState(Icons.delivery_dining_outlined, "No ongoing orders", "Your active orders will appear here");
  }

  Widget _buildCompletedTab() {
    return _buildEmptyState(Icons.check_circle_outline, "No completed orders", "Your order history will appear here");
  }

  Widget _buildEmptyState(IconData icon, String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF333333))),
          const SizedBox(height: 8),
          Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey[500]), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  onTapArrowleftone() => Get.back();
}
