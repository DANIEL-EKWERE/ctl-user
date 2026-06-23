import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_utils.dart';
import '../../../data/models/models.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/app_widgets.dart';
import '../home/customer_home_controller.dart';

String _dateGroupLabel(String? createdAt) {
  if (createdAt == null) return 'Earlier';
  final date = DateTime.tryParse(createdAt)?.toLocal();
  if (date == null) return 'Earlier';
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final d = DateTime(date.year, date.month, date.day);
  final diff = today.difference(d).inDays;
  if (diff == 0) return 'Today';
  if (diff == 1) return 'Yesterday';
  if (diff < 7) return 'This Week';
  if (diff < 30) return 'This Month';
  return 'Earlier';
}

List<({String label, List<Order> orders})> _groupOrders(List<Order> orders) {
  final Map<String, List<Order>> map = {};
  const order = ['Today', 'Yesterday', 'This Week', 'This Month', 'Earlier'];
  for (final o in orders) {
    final label = _dateGroupLabel(o.createdAt);
    (map[label] ??= []).add(o);
  }
  return [
    for (final label in order)
      if (map.containsKey(label)) (label: label, orders: map[label]!),
  ];
}

// ─── Orders Screen ────────────────────────────────────────────────────────────
class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});
  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final ctrl = CustomerHomeController.to;
  final filters = ['all', 'pending', 'accepted', 'delivered', 'cancelled'];
  final labels = ['All', 'Pending', 'Accepted', 'Delivered', 'Cancelled'];

  @override
  void initState() {
    super.initState();
    ctrl.loadOrders();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.bg,
    appBar: AppBar(
      backgroundColor: AppColors.navy,
      automaticallyImplyLeading: false,
      title: const Text(
        'My Orders',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(44),
        child:
            //  Obx(() =>
            SizedBox(
              height: 44,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                itemCount: filters.length,
                itemBuilder: (_, i) => GestureDetector(
                  onTap: () =>
                      setState(() => ctrl.orderFilter.value = filters[i]),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: ctrl.orderFilter.value == filters[i]
                          ? AppColors.orange
                          : Colors.white24,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      labels[i],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: ctrl.orderFilter.value == filters[i]
                            ? Colors.white
                            : Colors.white70,
                      ),
                    ),
                  ),
                ),
                //     ),
              ),
            ),
      ),
    ),
    body: Obx(() {
      if (ctrl.ordersLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.orange),
        );
      }
      final list = ctrl.filteredOrders;
      if (list.isEmpty) {
        return EmptyState(
          icon: Icons.receipt_long_outlined,
          title: 'No orders yet',
          subtitle: 'Your orders will appear here',
          buttonLabel: 'Start Shopping',
          onButton: () => ctrl.switchTab(0),
        );
      }
      final groups = _groupOrders(list);
      return RefreshIndicator(
        onRefresh: ctrl.loadOrders,
        child: ListView.builder(
          padding: const EdgeInsets.all(14),
          itemCount: groups.length,
          itemBuilder: (_, gi) {
            final group = groups[gi];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 8),
                  child: Text(
                    group.label,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
                ...group.orders.map((o) => OrderCard(order: o)),
              ],
            );
          },
        ),
      );
    }),
  );
}

// ─── Order Card ───────────────────────────────────────────────────────────────
class OrderCard extends StatelessWidget {
  final Order order;
  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => Get.toNamed(AppRoutes.orderDetail, arguments: order.id),
    child: Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [const BoxShadow(color: Color(0x0A000000), blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                order.vendor?.logo != null
                    ? AppNetworkImage(
                        url: order.vendor!.logo,
                        width: 44,
                        height: 44,
                        borderRadius: BorderRadius.circular(11),
                      )
                    : AvatarFallback(
                        initials: (order.vendor?.name ?? 'NK').substring(0, 2),
                        size: 44,
                      ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.vendor?.name ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                        ),
                      ),
                      Text(
                        order.reference,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                StatusBadge(order.status),
              ],
            ),
          ),
          const Divider(height: 1),
          // Items
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: order.items
                  .take(2)
                  .map(
                    (i) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${i.quantity}x ${i.productName}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Text(
                            AppUtils.formatNaira(i.unitPrice),
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const Divider(height: 1),
          // Footer
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    order.vendor!.address ?? 'N/A',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  AppUtils.formatNaira(order.total),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.orange,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

// ─── Order Detail Screen ──────────────────────────────────────────────────────
class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({super.key});
  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final ctrl = CustomerHomeController.to;

  @override
  void initState() {
    super.initState();
    final id = Get.arguments;
    if (id != null)
      ctrl.loadOrderDetail(id is int ? id : int.tryParse(id.toString()) ?? 0);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.bg,
    appBar: OrangeTopBar(title: 'Order Detail'),
    body: Obx(() {
      final o = ctrl.orderDetail.value;
      if (o == null) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.orange),
        );
      }
      return SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              o.reference,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.navy,
                              ),
                            ),
                            if (o.createdAt != null)
                              Text(
                                AppUtils.timeAgo(o.createdAt),
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                          ],
                        ),
                      ),
                      StatusBadge(o.status),
                    ],
                  ),
                  if (o.histories.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    _trackingTimeline(o.histories),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Vendor + items
            _card(
              children: [
                _sectionLabel('VENDOR'),
                Row(
                  children: [
                    o.vendor?.logo != null
                        ? AppNetworkImage(
                            url: o.vendor!.logo,
                            width: 44,
                            height: 44,
                            borderRadius: BorderRadius.circular(11),
                          )
                        : AvatarFallback(
                            initials: (o.vendor?.name ?? 'NK').substring(0, 2),
                            size: 44,
                          ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            o.vendor?.name ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.navy,
                            ),
                          ),
                          if (o.vendor?.address != null)
                            Text(
                              o.vendor!.address!,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 20),
                _sectionLabel('ITEMS'),
                ...o.items.map(
                  (i) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${i.quantity}x ${i.productName}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Text(
                          AppUtils.formatNaira(i.unitPrice * i.quantity),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.navy,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Delivery address
            _card(
              children: [
                _sectionLabel('DELIVERY ADDRESS'),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: AppColors.orange,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        o.deliveryAddress!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Financial breakdown
            _card(
              children: [
                _sectionLabel('PAYMENT'),
                _row(
                  'Subtotal',
                  AppUtils.formatNaira(
                    o.total - (o.deliveryFee ?? 0) - (o.serviceCharge ?? 0),
                  ),
                ),
                if (o.deliveryFee != null)
                  _row('Delivery Fee', AppUtils.formatNaira(o.deliveryFee!)),
                if (o.serviceCharge != null)
                  _row(
                    'Service Charge',
                    AppUtils.formatNaira(o.serviceCharge!),
                  ),
                const Divider(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.navy,
                      ),
                    ),
                    Text(
                      AppUtils.formatNaira(o.total),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.orange,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Rider info
            if (o.rider != null) ...[
              const SizedBox(height: 12),
              _card(
                children: [
                  _sectionLabel('YOUR RIDER'),
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: AppColors.chipBg,
                        child: Icon(
                          Icons.delivery_dining_outlined,
                          color: AppColors.navy,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          o.rider!.name,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.navy,
                          ),
                        ),
                      ),
                      if (o.rider!.phone != null)
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF0FDF4),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.phone_outlined,
                              color: AppColors.green,
                              size: 18,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
            const SizedBox(height: 24),
          ],
        ),
      );
    }),
  );

  Widget _card({required List<Widget> children}) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    ),
  );

  Widget _sectionLabel(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(
      t,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: AppColors.textSecondary,
        letterSpacing: 0.5,
      ),
    ),
  );

  Widget _row(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.navy,
          ),
        ),
      ],
    ),
  );

  Widget _trackingTimeline(List<OrderHistory> histories) => Column(
    children: histories.asMap().entries.map((e) {
      final h = e.value;
      final isLast = e.key == histories.length - 1;
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  color: AppColors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 12, color: Colors.white),
              ),
              if (!isLast)
                Container(width: 2, height: 24, color: AppColors.border),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppUtils.statusLabel(h.status),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                  if (h.note != null)
                    Text(
                      'by ${h.note}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  if (h.createdAt != null)
                    Text(
                      AppUtils.timeAgo(h.createdAt),
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      );
    }).toList(),
  );
}
