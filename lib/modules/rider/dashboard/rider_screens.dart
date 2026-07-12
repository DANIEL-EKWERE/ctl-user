import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/toast.dart';
import '../../../core/utils/app_utils.dart';
import '../../../data/models/models.dart';
import '../../../data/services/api_client.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/app_widgets.dart';
import '../../auth/auth_controller.dart';
import '../dashboard/rider_controller.dart';

String _dateLabel(String? createdAt) {
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

List<({String label, List<Order> orders})> _groupByDate(List<Order> orders) {
  final map = <String, List<Order>>{};
  const sequence = ['Today', 'Yesterday', 'This Week', 'This Month', 'Earlier'];
  for (final o in orders) {
    (map[_dateLabel(o.createdAt)] ??= []).add(o);
  }
  return [
    for (final label in sequence)
      if (map.containsKey(label)) (label: label, orders: map[label]!),
  ];
}

// ─── Rider Shell ──────────────────────────────────────────────────────────────
class RiderShell extends StatelessWidget {
  const RiderShell({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(RiderController());
    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: ctrl.currentTab.value,
          children: const [
            RiderDashboardTab(),
            RiderOrdersTab(),
            RiderWalletTab(),
            RiderAccountTab(),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: AppColors.border, width: 1.5),
            ),
          ),
          padding: const EdgeInsets.only(top: 8, bottom: 6),
          child: Row(
            children:
                [
                      [Icons.home_outlined, Icons.home, 'Home'],
                      [
                        Icons.receipt_long_outlined,
                        Icons.receipt_long,
                        'Orders',
                      ],
                      [
                        Icons.account_balance_wallet_outlined,
                        Icons.account_balance_wallet,
                        'Earnings',
                      ],
                      [Icons.person_outline, Icons.person, 'Account'],
                    ]
                    .asMap()
                    .entries
                    .map(
                      (e) => Expanded(
                        child: GestureDetector(
                          onTap: () => ctrl.switchTab(e.key),
                          child: Obx(() {
                            final active = ctrl.currentTab.value == e.key;
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  active
                                      ? e.value[1] as IconData
                                      : e.value[0] as IconData,
                                  size: 22,
                                  color: active
                                      ? AppColors.orange
                                      : AppColors.textSecondary,
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  e.value[2] as String,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: active
                                        ? AppColors.orange
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ),
      ),
    );
  }
}

// ─── Dashboard Tab ────────────────────────────────────────────────────────────
class RiderDashboardTab extends StatelessWidget {
  const RiderDashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = RiderController.to;
    return Scaffold(
      backgroundColor: AppColors.bg,
      body:
          //  Obx(() =>
          RefreshIndicator(
            onRefresh: ctrl.loadDashboard,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _DashHeader()),
                SliverToBoxAdapter(child: _AvailOrders()),
              ],
            ),
          ),
    );
    //  );
  }
}

class _DashHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ctrl = RiderController.to;
    final user = AuthController.to.riderUser;
    return Container(
      color: AppColors.orange,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 20,
        right: 20,
        bottom: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.navy,
                child: Text(
                  user?.initials ?? 'NK',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi, ${user?.name.split(' ').first ?? 'Rider'}!',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Obx(() => Text(
                      ctrl.isAvailable.value ? 'Online' : 'Offline',
                      style: TextStyle(
                        color: ctrl.isAvailable.value
                            ? const Color(0xFFA8F0C6)
                            : Colors.white60,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                  ],
                ),
              ),
              Obx(() => ctrl.togglingAvailability.value
                  ? const SizedBox(
                      width: 36,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Switch(
                      value: ctrl.isAvailable.value,
                      onChanged: (_) => ctrl.toggleAvailability(),
                      activeThumbColor: Colors.white,
                      activeTrackColor: const Color(0xFF2ECC71),
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: Colors.white24,
                    )),
            ],
          ),
          const SizedBox(height: 20),
          Obx(
            () => Row(
              children: [
                _stat('Pending', '${ctrl.availOrders.length}'),
                const SizedBox(width: 10),
                _stat('Completed', '${ctrl.completedOrdersCount}'),
                const SizedBox(width: 10),
                _stat('Active', '${ctrl.acceptedOrdersCount}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String label, String value) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(color: Colors.white60, fontSize: 11),
          ),
        ],
      ),
    ),
  );
}

class _AvailOrders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ctrl = RiderController.to;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Available Orders',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),
        ),
        Obx(() {
          if (ctrl.loading.value)
            return const Padding(
              padding: EdgeInsets.all(32),
              child: Center(
                child: CircularProgressIndicator(color: AppColors.orange),
              ),
            );
          if (ctrl.availOrders.isEmpty)
            return const EmptyState(
              icon: Icons.delivery_dining_outlined,
              title: 'No available orders',
              subtitle: 'New orders will appear here',
            );
          return Column(
            children: ctrl.availOrders
                .map((o) => _AvailCard(order: o))
                .toList(),
          );
        }),
      ],
    );
  }
}

class _AvailCard extends StatelessWidget {
  final Order order;
  const _AvailCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final ctrl = RiderController.to;
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [const BoxShadow(color: Color(0x0A000000), blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                const Icon(
                  Icons.store_outlined,
                  color: AppColors.navy,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    order.vendor?.name ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                ),
                StatusBadge(order.status),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColors.chipBg,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.store_outlined,
                          size: 13,
                          color: AppColors.navy,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        order.vendor?.address ?? '',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF5E6),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.home_outlined,
                          size: 13,
                          color: AppColors.orange,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        order.deliveryAddress!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
            child: Row(
              children: [
                Text(
                  AppUtils.formatNaira(order.total),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.navy,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: 90,
                  child: OutlinedButton(
                    onPressed: () => ctrl.rejectOrder(order.id),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.border),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Reject',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 90,
                  child: ElevatedButton(
                    onPressed: () => ctrl.acceptOrder(order.id),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.green,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Accept',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Orders Tab ───────────────────────────────────────────────────────────────
class RiderOrdersTab extends StatefulWidget {
  const RiderOrdersTab({super.key});
  @override
  State<RiderOrdersTab> createState() => _RiderOrdersState();
}

class _RiderOrdersState extends State<RiderOrdersTab> {
  final ctrl = RiderController.to;
  @override
  void initState() {
    super.initState();
    ctrl.loadMyDeliveries();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.bg,
    appBar: AppBar(
      backgroundColor: AppColors.orangeDark,
      automaticallyImplyLeading: false,
      title: const Text(
        'My Deliveries',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    body: Obx(() {
      if (ctrl.myDeliveries.isEmpty)
        return const EmptyState(
          icon: Icons.delivery_dining_outlined,
          title: 'No deliveries yet',
          subtitle: 'Accept orders to see them here',
        );
      final groups = _groupByDate(ctrl.myDeliveries);
      return RefreshIndicator(
        onRefresh: ctrl.loadMyDeliveries,
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
                ...group.orders.map((o) => _DelivCard(order: o)),
              ],
            );
          },
        ),
      );
    }),
  );
}

class _DelivCard extends StatelessWidget {
  final Order order;
  const _DelivCard({required this.order});
  @override
  Widget build(BuildContext context) {
    final ctrl = RiderController.to;
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.riderOrderDetail, arguments: order.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.reference,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.orange,
                          ),
                        ),
                        Text(
                          order.vendor?.name ?? '',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          order.deliveryAddress!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  StatusBadge(order.status),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
              child: Row(
                children: [
                  Text(
                    AppUtils.timeAgo(order.createdAt),
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    AppUtils.formatNaira(order.deliveryFee ?? 0),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.green,
                    ),
                  ),
                ],
              ),
            ),
            if (order.status == 'picked_up')
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                child: AppButton(
                  label: 'Mark as Delivered',
                  height: 42,
                  color: AppColors.green,
                  onTap: () => ctrl.markDelivered(order.id),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Rider Order Detail ───────────────────────────────────────────────────────
class RiderOrderDetailScreen extends StatelessWidget {
  const RiderOrderDetailScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final ctrl = RiderController.to;
    final orderId = Get.arguments as int?;
    final order = [
      ...ctrl.myDeliveries,
      ...ctrl.availOrders,
    ].firstWhereOrNull((o) => o.id == orderId);
    if (order == null)
      return Scaffold(
        appBar: OrangeTopBar(title: 'Order'),
        body: const EmptyState(
          icon: Icons.error_outline,
          title: 'Order not found',
        ),
      );

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: OrangeTopBar(
        title: 'Active Delivery',
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(child: StatusBadge(order.status)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            _card([
              _lbl('PICKUP FROM'),
              Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: AppColors.chipBg,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.store_outlined,
                        size: 16,
                        color: AppColors.navy,
                      ),
                    ),
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
                        if (order.vendor?.address != null)
                          Text(
                            order.vendor!.address!,
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
              const SizedBox(height: 16),
              _lbl('DELIVER TO'),
              Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF5E6),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.home_outlined,
                        size: 16,
                        color: AppColors.orange,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.customer?.name ?? 'Customer',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                          ),
                        ),
                        Text(
                          order.deliveryAddress!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (order.customer?.phone != null)
                    Container(
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
                ],
              ),
            ]),
            const SizedBox(height: 12),
            _card([
              _lbl('FINANCIALS'),
              _row('Order Total', AppUtils.formatNaira(order.total)),
              _row(
                'Delivery Fee',
                AppUtils.formatNaira(order.deliveryFee ?? 0),
              ),
              const Divider(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Your Earning (~80%)',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    AppUtils.formatNaira((order.deliveryFee ?? 0) * 0.8),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.green,
                    ),
                  ),
                ],
              ),
            ]),
            if (order.status == 'picked_up') ...[
              const SizedBox(height: 16),
              AppButton(
                label: '📦 Mark as Delivered',
                color: AppColors.green,
                onTap: () async {
                  final ok = await ctrl.markDelivered(order.id);
                  if (ok) Get.back();
                },
              ),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _card(List<Widget> children) => Container(
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
  Widget _lbl(String t) => Padding(
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
  Widget _row(String l, String v) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          l,
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        Text(
          v,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.navy,
          ),
        ),
      ],
    ),
  );
}

// ─── Wallet Tab ───────────────────────────────────────────────────────────────
class RiderWalletTab extends StatefulWidget {
  const RiderWalletTab({super.key});
  @override
  State<RiderWalletTab> createState() => _RiderWalletState();
}

class _RiderWalletState extends State<RiderWalletTab> {
  final ctrl = RiderController.to;
  @override
  void initState() {
    super.initState();
    ctrl.loadWallet();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.bg,
    body: Column(
      children: [
        Container(
          color: AppColors.orange,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 16,
            left: 20,
            right: 20,
            bottom: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Earnings Wallet',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Available Balance',
                style: TextStyle(color: Colors.white60, fontSize: 12),
              ),
              const SizedBox(height: 6),
              Obx(
                () => Text(
                  AppUtils.formatNaira(ctrl.walletBalance.value),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  SizedBox(
                    width: 130,
                    child: AppButton(
                      label: 'Withdraw',
                      color: AppColors.navy,
                      height: 42,
                      onTap: () => _showWithdrawSheet(context),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _showBankAccountsSheet(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white38),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 42),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Bank Accounts',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    'Earning History',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                ),
                Expanded(
                  child: ctrl.walletTxns.isEmpty
                      ? const EmptyState(
                          icon: Icons.account_balance_wallet_outlined,
                          title: 'No transactions yet',
                        )
                      : RefreshIndicator(
                          onRefresh: ctrl.loadWallet,
                          child: ListView.builder(
                            itemCount: ctrl.walletTxns.length,
                            itemBuilder: (_, i) {
                              final t = ctrl.walletTxns[i];
                              final isC = t.type == 'credit';
                              return Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    bottom: BorderSide(color: AppColors.border),
                                  ),
                                ),
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  14,
                                  16,
                                  14,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: isC
                                            ? const Color(0xFFF0FDF4)
                                            : const Color(0xFFFEF2F2),
                                        borderRadius: BorderRadius.circular(11),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          isC
                                              ? Icons.arrow_downward_rounded
                                              : Icons.arrow_upward_rounded,
                                          color: isC
                                              ? AppColors.green
                                              : AppColors.red,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        t.description ??
                                            t.category ??
                                            'Transaction',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.navy,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      '${isC ? '+' : '-'}${AppUtils.formatNaira(t.amount)}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: isC
                                            ? AppColors.green
                                            : AppColors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

// ─── Bank Accounts Sheet ──────────────────────────────────────────────────────
void _showBankAccountsSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _BankAccountsSheet(),
  );
}

class _BankAccountsSheet extends StatefulWidget {
  const _BankAccountsSheet();
  @override
  State<_BankAccountsSheet> createState() => _BankAccountsSheetState();
}

class _BankAccountsSheetState extends State<_BankAccountsSheet> {
  final ctrl = RiderController.to;
  bool _adding = false;

  final _bankCtrl = TextEditingController();
  final _acctNumCtrl = TextEditingController();
  final _acctNameCtrl = TextEditingController();
  BankOption? _selectedBank;
  bool _saving = false;
  bool _loadingBanks = false;

  @override
  void initState() {
    super.initState();
    _fetchBanks();
  }

  Future<void> _fetchBanks() async {
    if (ctrl.availableBanks.isNotEmpty) return;
    setState(() => _loadingBanks = true);
    await ctrl.loadBanks();
    if (mounted) setState(() => _loadingBanks = false);
  }

  @override
  void dispose() {
    _bankCtrl.dispose();
    _acctNumCtrl.dispose();
    _acctNameCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickBank(BuildContext context) async {
    if (_loadingBanks) return;
    if (ctrl.availableBanks.isEmpty) {
      setState(() => _loadingBanks = true);
      await ctrl.loadBanks();
      if (!mounted) return;
      setState(() => _loadingBanks = false);
    }
    if (!mounted) return;
    final picked = await showDialog<BankOption>(
      context: this.context,
      builder: (_) => _BankPickerDialog(banks: ctrl.availableBanks),
    );
    if (picked != null) setState(() => _selectedBank = picked);
  }

  Future<void> _save() async {
    if (_selectedBank == null ||
        _acctNumCtrl.text.isEmpty ||
        _acctNameCtrl.text.isEmpty) {
      showToast('Fill all fields', isError: true);
      return;
    }
    setState(() => _saving = true);
    final ok = await ctrl.addBankAccount({
      'bank_code': _selectedBank!.code,
      'bank_name': _selectedBank!.name,
      'account_number': _acctNumCtrl.text.trim(),
      'account_name': _acctNameCtrl.text.trim(),
    });
    setState(() => _saving = false);
    if (ok && mounted) setState(() => _adding = false);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (_, sc) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 16, 4),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Bank Accounts',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => setState(() => _adding = !_adding),
                    icon: Icon(_adding ? Icons.close : Icons.add, size: 18),
                    label: Text(_adding ? 'Cancel' : 'Add New'),
                  ),
                ],
              ),
            ),
            if (_adding) ...[
              const Divider(height: 1),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  20,
                  14,
                  20,
                  MediaQuery.of(context).viewInsets.bottom + 14,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: _loadingBanks ? null : () => _pickBank(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _selectedBank?.name ?? 'Select Bank',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: _selectedBank == null
                                      ? Colors.grey.shade600
                                      : Colors.black87,
                                ),
                              ),
                            ),
                            if (_loadingBanks)
                              const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            else
                              const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Colors.grey,
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _acctNumCtrl,
                      keyboardType: TextInputType.number,
                      decoration: _inputDec('Account Number'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _acctNameCtrl,
                      decoration: _inputDec('Account Name'),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        label: _saving ? 'Saving…' : 'Save Account',
                        onTap: _saving ? null : _save,
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              const Divider(height: 1),
              Expanded(
                child: Obx(
                  () => ctrl.bankAccounts.isEmpty
                      ? const EmptyState(
                          icon: Icons.account_balance_outlined,
                          title: 'No bank accounts added yet',
                        )
                      : ListView.separated(
                          controller: sc,
                          itemCount: ctrl.bankAccounts.length,
                          separatorBuilder: (_, _) => const Divider(height: 1),
                          itemBuilder: (_, i) {
                            final b = ctrl.bankAccounts[i];
                            return ListTile(
                              leading: Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: AppColors.orange.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                child: const Icon(
                                  Icons.account_balance_outlined,
                                  color: AppColors.orange,
                                  size: 20,
                                ),
                              ),
                              title: Text(
                                b.accountName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              subtitle: Text(
                                '${b.bankName} · ${b.accountNumber}',
                                style: const TextStyle(fontSize: 12),
                              ),
                              trailing: b.isDefault
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.green.withValues(
                                          alpha: 0.12,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Text(
                                        'Default',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: AppColors.green,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    )
                                  : null,
                            );
                          },
                        ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Bank Picker Dialog ───────────────────────────────────────────────────────
class _BankPickerDialog extends StatefulWidget {
  final List<BankOption> banks;
  const _BankPickerDialog({required this.banks});
  @override
  State<_BankPickerDialog> createState() => _BankPickerDialogState();
}

class _BankPickerDialogState extends State<_BankPickerDialog> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = _query.isEmpty
        ? widget.banks
        : widget.banks
              .where((b) => b.name.toLowerCase().contains(_query.toLowerCase()))
              .toList();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              autofocus: true,
              decoration: _inputDec('Search bank…'),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.45,
            ),
            child: filtered.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'No banks found',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (_, i) => ListTile(
                      title: Text(
                        filtered[i].name,
                        style: const TextStyle(fontSize: 14),
                      ),
                      onTap: () => Navigator.pop(context, filtered[i]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ─── Withdraw Sheet ───────────────────────────────────────────────────────────
void _showWithdrawSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _WithdrawSheet(),
  );
}

class _WithdrawSheet extends StatefulWidget {
  const _WithdrawSheet();
  @override
  State<_WithdrawSheet> createState() => _WithdrawSheetState();
}

class _WithdrawSheetState extends State<_WithdrawSheet> {
  final ctrl = RiderController.to;
  final _amountCtrl = TextEditingController();
  final _pinCtrl = TextEditingController();
  BankAccount? _selectedAccount;
  bool _loading = false;

  @override
  void dispose() {
    _amountCtrl.dispose();
    _pinCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickAccount(BuildContext context) async {
    if (ctrl.bankAccounts.isEmpty) {
      showToast('No bank accounts saved. Add one first.', isError: true);
      return;
    }
    final picked = await showDialog<BankAccount>(
      context: this.context,
      builder: (_) => SimpleDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Select Account',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        children: ctrl.bankAccounts
            .map(
              (b) => SimpleDialogOption(
                onPressed: () => Navigator.pop(this.context, b),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      b.bankName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      b.accountNumber,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
    if (picked != null) setState(() => _selectedAccount = picked);
  }

  Future<void> _submit() async {
    final amount = double.tryParse(_amountCtrl.text.trim());
    if (amount == null || amount <= 0) {
      showToast('Enter a valid amount', isError: true);
      return;
    }
    if (_selectedAccount == null) {
      showToast('Select a bank account', isError: true);
      return;
    }
    if (_pinCtrl.text.length < 4) {
      showToast('Enter your 4-digit PIN', isError: true);
      return;
    }
    setState(() => _loading = true);
    final ok = await ctrl.withdrawEarnings(
      amount: amount,
      bankAccountId: _selectedAccount!.id,
      pin: _pinCtrl.text.trim(),
    );
    setState(() => _loading = false);
    if (ok && mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final inset = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, inset + 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Withdraw Earnings',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 4),
          Obx(
            () => Text(
              'Available: ${AppUtils.formatNaira(ctrl.walletBalance.value)}',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _amountCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: _inputDec('Amount (₦)'),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => _pickAccount(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedAccount != null
                          ? '${_selectedAccount!.bankName} · ${_selectedAccount!.accountNumber}'
                          : 'Select Bank Account',
                      style: TextStyle(
                        fontSize: 14,
                        color: _selectedAccount == null
                            ? Colors.grey.shade600
                            : Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _pinCtrl,
            obscureText: true,
            maxLength: 4,
            keyboardType: TextInputType.number,
            decoration: _inputDec('Transaction PIN'),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: _loading ? 'Processing…' : 'Withdraw',
              onTap: _loading ? null : _submit,
            ),
          ),
        ],
      ),
    );
  }
}

InputDecoration _inputDec(String label) => InputDecoration(
  labelText: label,
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
);

// ─── Account Tab ──────────────────────────────────────────────────────────────
class RiderAccountTab extends StatelessWidget {
  const RiderAccountTab({super.key});
  @override
  Widget build(BuildContext context) {
    final auth = AuthController.to;
    final u = auth.riderUser;
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: AppColors.orange,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 16,
                left: 20,
                right: 20,
                bottom: 24,
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: AppColors.navy,
                    child: Text(
                      u?.initials ?? 'NK',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    u?.name ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    u?.email ?? '',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.delivery_dining_outlined,
                          color: Colors.white,
                          size: 14,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Rider',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  _t(
                    Icons.person_outline,
                    'Edit Profile',
                    () => Get.to(() => const RiderEditProfileScreen()),
                  ),
                  _t(
                    Icons.delivery_dining_outlined,
                    'Vehicle Info',
                    () => Get.to(() => const RiderVehicleInfoScreen()),
                  ),
                  _t(
                    Icons.lock_outline,
                    'Change Password',
                    () => Get.to(() => const RiderChangePasswordScreen()),
                  ),
                  _t(
                    Icons.pin_outlined,
                    'Set Transaction PIN',
                    () => _showSetPinSheet(context),
                  ),
                  _t(
                    Icons.chat_bubble_outline,
                    'Support',
                    () => Get.to(() => const RiderSupportScreen()),
                    last: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              color: Colors.white,
              child: _t(
                Icons.logout,
                'Logout',
                () => _logout(context, auth),
                color: AppColors.red,
                last: true,
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _t(
    IconData icon,
    String label,
    VoidCallback onTap, {
    bool last = false,
    Color? color,
  }) => InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: last
            ? null
            : const Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color != null ? const Color(0xFFFEF2F2) : AppColors.chipBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Icon(icon, size: 18, color: color ?? AppColors.navy),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color ?? AppColors.navy,
              ),
            ),
          ),
          Icon(
            Icons.chevron_right,
            size: 20,
            color: color ?? AppColors.textLight,
          ),
        ],
      ),
    ),
  );

  void _logout(BuildContext ctx, AuthController auth) => showDialog(
    context: ctx,
    builder: (_) => AlertDialog(
      title: const Text(
        'Sign out?',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      actions: [
        TextButton(onPressed: Get.back, child: const Text('Cancel')),
        ElevatedButton(
          onPressed: auth.logout,
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
          child: const Text('Sign out'),
        ),
      ],
    ),
  );
}

// ─── Rider Edit Profile ───────────────────────────────────────────────────────
class RiderEditProfileScreen extends StatefulWidget {
  const RiderEditProfileScreen({super.key});
  @override
  State<RiderEditProfileScreen> createState() => _RiderEditProfileState();
}

class _RiderEditProfileState extends State<RiderEditProfileScreen> {
  final auth = AuthController.to;
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final u = auth.riderUser;
    _nameCtrl = TextEditingController(text: u?.name ?? '');
    _emailCtrl = TextEditingController(text: u?.email ?? '');
    _phoneCtrl = TextEditingController(text: u?.phone ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty) {
      setState(() => _error = 'Name is required');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    final res = await ApiClient.instance.updateProfile({
      'name': _nameCtrl.text.trim(),
      'email': _emailCtrl.text.trim(),
      'phone': _phoneCtrl.text.trim(),
    }, auth.riderToken!);
    setState(() => _loading = false);
    if (res['success'] == true) {
      await auth.updateRiderProfile(
        _nameCtrl.text.trim(),
        _phoneCtrl.text.trim(),
      );
      Get.back();
      showToast('Profile updated successfully');
    } else {
      setState(() => _error = res['message'] ?? 'Failed to update profile');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.bg,
    appBar: OrangeTopBar(title: 'Edit Profile'),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _field('Full Name', _nameCtrl, TextInputType.name),
          const SizedBox(height: 16),
          _field('Email Address', _emailCtrl, TextInputType.emailAddress),
          const SizedBox(height: 16),
          _field('Phone Number', _phoneCtrl, TextInputType.phone),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFECACA)),
              ),
              child: Text(
                _error!,
                style: const TextStyle(color: AppColors.red, fontSize: 13),
              ),
            ),
          ],
          const SizedBox(height: 28),
          AppButton(label: 'Save Changes', loading: _loading, onTap: _save),
        ],
      ),
    ),
  );

  Widget _field(String label, TextEditingController ctrl, TextInputType type) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: ctrl,
            keyboardType: type,
            style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
            decoration: InputDecoration(hintText: label),
          ),
        ],
      );
}

// ─── Rider Vehicle Info ───────────────────────────────────────────────────────
class RiderVehicleInfoScreen extends StatefulWidget {
  const RiderVehicleInfoScreen({super.key});
  @override
  State<RiderVehicleInfoScreen> createState() => _RiderVehicleInfoState();
}

class _RiderVehicleInfoState extends State<RiderVehicleInfoScreen> {
  final _api  = ApiClient.instance;
  final _auth = AuthController.to;
  Map<String, dynamic>? _rider;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    final res = await _api.getRiderInfo(_auth.riderToken!);
    if (!mounted) return;
    if (res['success'] == true) {
      final body = res['data'] as Map<String, dynamic>;
      setState(() {
        _rider = body['rider'] ?? body;
        _loading = false;
      });
    } else {
      setState(() {
        _error = res['message'] ?? 'Failed to load info';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.bg,
    appBar: OrangeTopBar(title: 'Vehicle Info'),
    body: _loading
        ? const Center(child: CircularProgressIndicator())
        : _error != null
            ? Center(child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_error!, style: const TextStyle(color: AppColors.red)),
                  const SizedBox(height: 16),
                  AppButton(label: 'Retry', onTap: _load),
                ],
              ))
            : RefreshIndicator(
                onRefresh: _load,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _section('Vehicle Details', [
                      _row(Icons.two_wheeler_outlined, 'Vehicle Type', _rider!['vehicle_type']?.toString().toUpperCase() ?? '—'),
                      _row(Icons.pin_outlined, 'Plate Number', _rider!['plate_number'] ?? '—'),
                      _row(Icons.badge_outlined, 'License Number', _rider!['license_number'] ?? '—'),
                    ]),
                    const SizedBox(height: 14),
                    _section('Location', [
                      _row(Icons.location_city_outlined, 'City', _rider!['current_city'] ?? '—'),
                      _row(Icons.map_outlined, 'State', _rider!['current_state'] ?? '—'),
                      _row(Icons.home_outlined, 'Home Address', _rider!['home_address'] ?? '—'),
                    ]),
                    const SizedBox(height: 14),
                    _section('Guarantor', [
                      _row(Icons.person_outline, 'Name', _rider!['guarantor_name'] ?? '—'),
                      _row(Icons.phone_outlined, 'Phone', _rider!['guarantor_phone'] ?? '—'),
                    ]),
                    const SizedBox(height: 14),
                    _section('Documents', [
                      _docRow('Means of ID',       _rider!['documents']?['means_of_id']),
                      _docRow('Driver\'s License', _rider!['documents']?['drivers_license']),
                      _docRow('Vehicle Document',  _rider!['documents']?['vehicle_document']),
                      _docRow('Guarantor Form',    _rider!['documents']?['guarantor_form']),
                    ]),
                    const SizedBox(height: 14),
                    _section('Account Status', [
                      _row(Icons.verified_outlined, 'Status',
                          (_rider!['status'] ?? '').toString().toUpperCase()),
                      _row(Icons.calendar_today_outlined, 'Approved At',
                          _rider!['approved_at']?.toString().split(' ').first ?? '—'),
                    ]),
                  ],
                ),
              ),
  );

  Widget _section(String title, List<Widget> rows) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
          child: Text(title,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.navy)),
        ),
        const Divider(height: 1),
        ...rows,
      ],
    ),
  );

  Widget _row(IconData icon, String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(
      children: [
        Icon(icon, size: 18, color: AppColors.orange),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary))),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
      ],
    ),
  );

  Widget _docRow(String label, dynamic value) {
    final uploaded = value != null;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(uploaded ? Icons.check_circle_outline : Icons.upload_file_outlined,
              size: 18, color: uploaded ? AppColors.green : AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary))),
          Text(uploaded ? 'Uploaded' : 'Not uploaded',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                  color: uploaded ? AppColors.green : AppColors.red)),
        ],
      ),
    );
  }
}

// ─── Rider Change Password ────────────────────────────────────────────────────
class RiderChangePasswordScreen extends StatefulWidget {
  const RiderChangePasswordScreen({super.key});
  @override
  State<RiderChangePasswordScreen> createState() => _RiderChangePasswordState();
}

class _RiderChangePasswordState extends State<RiderChangePasswordScreen> {
  final auth = AuthController.to;
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _loading = false;
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  String? _error;

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _change() async {
    if (_newCtrl.text != _confirmCtrl.text) {
      setState(() => _error = 'New passwords do not match');
      return;
    }
    if (_newCtrl.text.length < 6) {
      setState(() => _error = 'Password must be at least 6 characters');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    final res = await ApiClient.instance.changePassword({
      'current_password': _currentCtrl.text,
      'password': _newCtrl.text,
      'password_confirmation': _confirmCtrl.text,
    }, auth.riderToken!);
    setState(() => _loading = false);
    if (res['success'] == true) {
      Get.back();
      showToast('Password changed successfully');
    } else {
      setState(() => _error = res['message'] ?? 'Failed to change password');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.bg,
    appBar: OrangeTopBar(title: 'Change Password'),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _passField(
            'Current Password',
            _currentCtrl,
            _obscureCurrent,
            () => setState(() => _obscureCurrent = !_obscureCurrent),
          ),
          const SizedBox(height: 16),
          _passField(
            'New Password',
            _newCtrl,
            _obscureNew,
            () => setState(() => _obscureNew = !_obscureNew),
          ),
          const SizedBox(height: 16),
          _passField(
            'Confirm New Password',
            _confirmCtrl,
            _obscureConfirm,
            () => setState(() => _obscureConfirm = !_obscureConfirm),
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFECACA)),
              ),
              child: Text(
                _error!,
                style: const TextStyle(color: AppColors.red, fontSize: 13),
              ),
            ),
          ],
          const SizedBox(height: 28),
          AppButton(
            label: 'Change Password',
            loading: _loading,
            onTap: _change,
          ),
        ],
      ),
    ),
  );

  Widget _passField(
    String label,
    TextEditingController ctrl,
    bool obscure,
    VoidCallback toggle,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
      ),
      const SizedBox(height: 6),
      TextField(
        controller: ctrl,
        obscureText: obscure,
        style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: '••••••••',
          suffixIcon: IconButton(
            icon: Icon(
              obscure
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              size: 20,
              color: AppColors.textSecondary,
            ),
            onPressed: toggle,
          ),
        ),
      ),
    ],
  );
}

// ─── Set Transaction PIN Sheet ────────────────────────────────────────────────
void _showSetPinSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _SetPinSheet(),
  );
}

class _SetPinSheet extends StatefulWidget {
  const _SetPinSheet();
  @override
  State<_SetPinSheet> createState() => _SetPinSheetState();
}

class _SetPinSheetState extends State<_SetPinSheet> {
  final ctrl = RiderController.to;
  final _pinCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _loading = false;
  bool _obscurePin = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _pinCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final pin = _pinCtrl.text.trim();
    final confirm = _confirmCtrl.text.trim();
    if (pin.length < 4) {
      showToast('PIN must be at least 4 digits', isError: true);
      return;
    }
    if (pin != confirm) {
      showToast('PINs do not match', isError: true);
      return;
    }
    setState(() => _loading = true);
    final ok = await ctrl.setTransactionPin(pin);
    setState(() => _loading = false);
    if (ok && mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final inset = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, inset + 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Set Transaction PIN',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'This PIN is used to authorise withdrawals',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _pinCtrl,
            obscureText: _obscurePin,
            keyboardType: TextInputType.number,
            maxLength: 4,
            decoration: _inputDec('PIN').copyWith(
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePin
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20,
                ),
                onPressed: () => setState(() => _obscurePin = !_obscurePin),
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _confirmCtrl,
            obscureText: _obscureConfirm,
            keyboardType: TextInputType.number,
            maxLength: 4,
            decoration: _inputDec('Confirm PIN').copyWith(
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirm
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20,
                ),
                onPressed: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: _loading ? 'Saving…' : 'Set PIN',
              onTap: _loading ? null : _submit,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Rider Support Screen ─────────────────────────────────────────────────────
class RiderSupportScreen extends StatefulWidget {
  const RiderSupportScreen({super.key});
  @override
  State<RiderSupportScreen> createState() => _RiderSupportScreenState();
}

class _RiderSupportScreenState extends State<RiderSupportScreen> {
  final auth = AuthController.to;
  final _subCtrl = TextEditingController();
  final _msgCtrl = TextEditingController();
  String _category = 'general';
  String _priority = 'medium';
  bool _loading = false;

  @override
  void dispose() {
    _subCtrl.dispose();
    _msgCtrl.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (_subCtrl.text.trim().isEmpty || _msgCtrl.text.trim().isEmpty) {
      showToast('Please fill all fields', isError: true);
      return;
    }
    setState(() => _loading = true);
    final res = await ApiClient.instance.createSupportTicket({
      'category': _category,
      'subject': _subCtrl.text.trim(),
      'message': _msgCtrl.text.trim(),
      'priority': _priority,
    }, auth.riderToken!);
    setState(() => _loading = false);
    if (res['success'] == true) {
      Get.back();
      showToast('Message sent!');
    } else {
      showToast(res['message'] ?? 'Failed', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.white,
    appBar: OrangeTopBar(title: 'Support'),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.inputBg,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              children: [
                Icon(Icons.support_agent_outlined, size: 40, color: AppColors.orange),
                SizedBox(height: 8),
                Text(
                  'How can we help?',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.navy),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Category', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _category,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.inputBg,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
            ),
            items: const [
              DropdownMenuItem(value: 'general', child: Text('General')),
              DropdownMenuItem(value: 'order', child: Text('Order Issue')),
              DropdownMenuItem(value: 'payment', child: Text('Payment')),
              DropdownMenuItem(value: 'account', child: Text('Account')),
              DropdownMenuItem(value: 'technical', child: Text('Technical')),
            ],
            onChanged: (v) => setState(() => _category = v!),
          ),
          const SizedBox(height: 14),
          const Text('Priority', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _priority,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.inputBg,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
            ),
            items: const [
              DropdownMenuItem(value: 'low', child: Text('Low')),
              DropdownMenuItem(value: 'medium', child: Text('Medium')),
              DropdownMenuItem(value: 'high', child: Text('High')),
            ],
            onChanged: (v) => setState(() => _priority = v!),
          ),
          const SizedBox(height: 14),
          AppInput(label: 'Subject', hint: 'Brief description', controller: _subCtrl),
          const SizedBox(height: 14),
          const Text('Message', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
          const SizedBox(height: 5),
          TextFormField(
            controller: _msgCtrl,
            maxLines: 5,
            decoration: const InputDecoration(hintText: 'Describe your issue...'),
          ),
          const SizedBox(height: 24),
          AppButton(label: 'Send Message', loading: _loading, onTap: _send),
        ],
      ),
    ),
  );
}
