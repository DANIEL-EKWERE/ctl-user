import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/api_client.dart';
import '../../widgets/common/app_widgets.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});
  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  List<dynamic> _ongoing = [];
  List<dynamic> _completed = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    _load();
  }

  Future<void> _load() async {
    if (!mounted) return;
    setState(() => _loading = true);
    final r1 = await ApiClient.instance.getOrders(status: 'ongoing');
    final r2 = await ApiClient.instance.getOrders(status: 'completed');
    if (r1['success'] == true) {
      final d = r1['data'] as Map<String, dynamic>;
      final inner = (d['data'] ?? d) as Map<String, dynamic>;
      _ongoing = (inner['orders'] ?? inner['data'] ?? []) as List;
    }
    if (r2['success'] == true) {
      final d = r2['data'] as Map<String, dynamic>;
      final inner = (d['data'] ?? d) as Map<String, dynamic>;
      _completed = (inner['orders'] ?? inner['data'] ?? []) as List;
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Orders'),
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabCtrl,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelStyle:
              const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          tabs: const [Tab(text: 'Ongoing'), Tab(text: 'Completed')],
        ),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary))
          : RefreshIndicator(
              color: AppColors.primary,
              onRefresh: _load,
              child: TabBarView(
                controller: _tabCtrl,
                children: [
                  _OrderList(
                      orders: _ongoing, emptyLabel: 'No ongoing orders'),
                  _OrderList(
                      orders: _completed, emptyLabel: 'No completed orders'),
                ],
              ),
            ),
    );
  }
}

class _OrderList extends StatelessWidget {
  final List<dynamic> orders;
  final String emptyLabel;
  const _OrderList({required this.orders, required this.emptyLabel});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return EmptyState(
        icon: Icons.receipt_long_outlined,
        title: emptyLabel,
        subtitle: 'Your orders will appear here',
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (_, i) => _OrderCard(order: orders[i]),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final dynamic order;
  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final id = order['id']?.toString() ?? '';
    final status = order['status']?.toString() ?? 'pending';
    final vendorName = order['vendor']?['name']?.toString() ?? 'Vendor';
    final vendorLogo = order['vendor']?['logo']?.toString();
    final total = order['total']?.toString() ?? '0';
    final itemsList = order['items'] as List?;
    final itemCount = itemsList?.length ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Order #$id',
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textSecondary)),
              StatusBadge(status: status),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              AppNetworkImage(
                  url: vendorLogo,
                  width: 44,
                  height: 44,
                  borderRadius: BorderRadius.circular(22)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(vendorName,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 2),
                      Text('$itemCount item${itemCount == 1 ? '' : 's'}  •  N$total',
                          style: const TextStyle(
                              fontSize: 13, color: AppColors.textSecondary)),
                    ]),
              ),
            ]),
          ]),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(children: [
            Expanded(
              child: AppButton(
                label: 'Track Order',
                height: 42,
                outlined: true,
                onTap: () => Get.toNamed(AppRoutes.orderTracking,
                    arguments: order),
              ),
            ),
            if (status == 'delivered' || status == 'completed') ...[
              const SizedBox(width: 10),
              Expanded(
                child: AppButton(label: 'Reorder', height: 42, onTap: () {}),
              ),
            ],
          ]),
        ),
      ]),
    );
  }
}
