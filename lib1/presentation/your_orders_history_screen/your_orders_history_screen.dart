// Redesigned: Chewdeck-style Orders History Screen
import 'package:ctluser/presentation/your_orders_history_screen/models/order_model.dart';
import 'package:ctluser/presentation/your_orders_ongoing_screen/controller/your_orders_ongoing_controller.dart';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../profile_page/profile_page.dart';
import 'controller/your_orders_history_controller.dart';
import 'your_tab_page.dart';

// ignore_for_file: must_be_immutable
YourOrdersHistoryController controller = Get.put(YourOrdersHistoryController());
YourOrdersOngoingController controller1 = Get.put(YourOrdersOngoingController());

class YourOrdersHistoryScreen extends StatefulWidget {
  const YourOrdersHistoryScreen({Key? key}) : super(key: key);
  @override
  State<YourOrdersHistoryScreen> createState() => _YourOrdersHistoryScreenState();
}

class _YourOrdersHistoryScreenState extends State<YourOrdersHistoryScreen> {
  @override
  void initState() {
    super.initState();
    controller.fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: controller.tabviewController,
                children: [_buildOngoingTab(), YourTabPage()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Orders", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF1B1B1B))),
          TextButton(
            onPressed: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(border: Border.all(color: const Color(0xFFDDDDDD)), borderRadius: BorderRadius.circular(20)),
              child: const Text("Clear Cart", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF333333))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: controller.tabviewController,
        labelColor: const Color(0xFF1B1B1B),
        unselectedLabelColor: const Color(0xFF888888),
        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        unselectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        indicatorColor: const Color(0xFF1B5E20),
        indicatorWeight: 2.5,
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: const [Tab(text: "My Cart"), Tab(text: "Completed")],
      ),
    );
  }

  Widget _buildOngoingTab() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator(color: Color(0xFF1B5E20)));
      }
      final orders = controller.orderItem ?? [];
      if (orders.isEmpty) {
        return _buildEmptyState(Icons.shopping_bag_outlined, "No active orders", "Your ongoing orders will appear here");
      }
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) => _buildOrderCard(orders[index]),
      );
    });
  }

  Widget _buildOrderCard(OrderItem order) {
    final statusColor = order.status == 'delivered'
        ? const Color(0xFF2E7D32)
        : order.status == 'pending'
            ? const Color(0xFFF57F17)
            : const Color(0xFF1565C0);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          // Vendor row
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: const Color(0xFFE8F5E9),
                  child: const Icon(Icons.storefront, color: Color(0xFF1B5E20), size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.vendor?.businessName ?? "Vendor",
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1B1B1B)),
                      ),
                      Text(
                        "${order.items?.length ?? 0} Item${(order.items?.length ?? 0) > 1 ? 's' : ''} • ₦${order.total ?? '0'}",
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {},
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
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
            child: Row(
              children: [
                const Text("🛵", style: TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Text("Delivering to ${order.address?.city ?? 'Lagos'}", style: TextStyle(fontSize: 13, color: Colors.grey[700])),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: double.maxFinite,
                padding: const EdgeInsets.symmetric(vertical: 13),
                decoration: BoxDecoration(color: const Color(0xFF1B5E20), borderRadius: BorderRadius.circular(10)),
                child: const Center(child: Text("Checkout", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700))),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TextButton(onPressed: () {}, child: const Text("Clear Selection", style: TextStyle(fontSize: 13, color: Color(0xFF1B5E20)))),
          ),
        ],
      ),
    );
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
}
