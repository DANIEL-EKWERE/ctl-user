import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_utils.dart';
import '../../../data/models/models.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/app_widgets.dart';
import '../../auth/auth_controller.dart';
import 'rider_controller.dart';

// ─── Rider Shell ──────────────────────────────────────────────────────────────
class RiderShell extends StatelessWidget {
  const RiderShell({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(RiderController());
    return Obx(() => Scaffold(
      body: IndexedStack(index: ctrl.currentTab.value, children: const [
        RiderDashboardTab(), RiderOrdersTab(), RiderWalletTab(), RiderAccountTab(),
      ]),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: AppColors.border, width: 1.5))),
        padding: const EdgeInsets.only(top: 8, bottom: 6),
        child: Row(children: [
          ['🏠', 'Home'], ['📋', 'Orders'], ['💰', 'Earnings'], ['👤', 'Account'],
        ].asMap().entries.map((e) => Expanded(
          child: GestureDetector(
            onTap: () => ctrl.switchTab(e.key),
            child: Obx(() => Column(mainAxisSize: MainAxisSize.min, children: [
              Text(e.value[0], style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 3),
              Text(e.value[1], style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600,
                  color: ctrl.currentTab.value == e.key ? AppColors.orange : AppColors.textSecondary)),
            ])),
          ),
        )).toList(),
      ),
    )));
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
        child: CustomScrollView(slivers: [
          SliverToBoxAdapter(child: _DashHeader()),
          SliverToBoxAdapter(child: _AvailOrders()),
        ]),
      //)
      ),
    );
  }
}

class _DashHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ctrl = RiderController.to;
    final user = AuthController.to.riderUser;
    return Container(
      color: AppColors.navy,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 16, left: 20, right: 20, bottom: 24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          CircleAvatar(radius: 22, backgroundColor: AppColors.orange,
            child: Text(user?.initials ?? 'NK', style: const TextStyle(color: AppColors.navy, fontSize: 14, fontWeight: FontWeight.w800))),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Hi, ${user?.name.split(' ').first ?? 'Rider'}! 👋',
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
            const Text('🏍️ Rider', style: TextStyle(color: Colors.white60, fontSize: 12)),
          ]),
        ]),
        const SizedBox(height: 20),
        Obx(() => 
        Row(children: [
          _stat('Deliveries', '${ctrl.dashboard.value?.totalDeliveries ?? 0}'),
          const SizedBox(width: 10),
          _stat('Earnings', AppUtils.formatNaira(ctrl.dashboard.value?.totalEarnings ?? 0)),
          const SizedBox(width: 10),
          _stat('Active', '${ctrl.dashboard.value?.pendingDeliveries ?? 0}'),
        ])),
      ]),
    );
  }

  Widget _stat(String label, String value) => Expanded(
    child: Container(padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(12)),
      child: Column(children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 11)),
      ])),
  );
}

class _AvailOrders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ctrl = RiderController.to;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Padding(padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Text('Available Orders', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.navy))),
      Obx(() {
        if (ctrl.loading.value) return const Padding(padding: EdgeInsets.all(32),
            child: Center(child: CircularProgressIndicator(color: AppColors.orange)));
        if (ctrl.availOrders.isEmpty) return const EmptyState(icon: Icons.delivery_dining_outlined,
            title: 'No available orders', subtitle: 'New orders will appear here');
        return Column(children: ctrl.availOrders.map((o) => _AvailCard(order: o)).toList());
      }),
    ]);
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
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [const BoxShadow(color: Color(0x0A000000), blurRadius: 4)]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(padding: const EdgeInsets.all(14), child: Row(children: [
          const Icon(Icons.store_outlined, color: AppColors.navy, size: 18), const SizedBox(width: 8),
          Expanded(child: Text(order.vendor?.name ?? '',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.navy))),
          StatusBadge(order.status),
        ])),
        const Divider(height: 1),
        Padding(padding: const EdgeInsets.all(14), child: Column(children: [
          Row(children: [
            Container(width: 24, height: 24, decoration: BoxDecoration(color: AppColors.chipBg, borderRadius: BorderRadius.circular(7)),
              child: const Center(child: Text('🏪', style: TextStyle(fontSize: 12)))),
            const SizedBox(width: 8),
            Expanded(child: Text(order.vendor?.address ?? '', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary), overflow: TextOverflow.ellipsis)),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            Container(width: 24, height: 24, decoration: BoxDecoration(color: const Color(0xFFFFF5E6), borderRadius: BorderRadius.circular(7)),
              child: const Center(child: Text('🏠', style: TextStyle(fontSize: 12)))),
            const SizedBox(width: 8),
            Expanded(child: Text(order.address?.contactAddress ?? '', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary), overflow: TextOverflow.ellipsis)),
          ]),
        ])),
        const Divider(height: 1),
        Padding(padding: const EdgeInsets.fromLTRB(14, 10, 14, 14), child: Row(children: [
          Text(AppUtils.formatNaira(order.total),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.navy)),
          const Spacer(),
          SizedBox(width: 90, child: OutlinedButton(
            onPressed: () => ctrl.rejectOrder(order.id),
            style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.border), padding: const EdgeInsets.symmetric(vertical: 8), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: const Text('Reject', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)))),
          const SizedBox(width: 8),
          SizedBox(width: 90, child: ElevatedButton(
            onPressed: () => ctrl.acceptOrder(order.id),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.green, padding: const EdgeInsets.symmetric(vertical: 8), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: const Text('Accept', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)))),
        ])),
      ]),
    );
  }
}

// ─── Orders Tab ───────────────────────────────────────────────────────────────
class RiderOrdersTab extends StatefulWidget {
  const RiderOrdersTab({super.key});
  @override State<RiderOrdersTab> createState() => _RiderOrdersState();
}
class _RiderOrdersState extends State<RiderOrdersTab> {
  final ctrl = RiderController.to;
  @override void initState() { super.initState(); ctrl.loadMyDeliveries(); }
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.bg,
    appBar: AppBar(backgroundColor: AppColors.navy, automaticallyImplyLeading: false,
      title: const Text('My Deliveries', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700))),
    body: Obx(() {
      if (ctrl.myDeliveries.isEmpty) return const EmptyState(icon: Icons.delivery_dining_outlined,
          title: 'No deliveries yet', subtitle: 'Accept orders to see them here');
      return RefreshIndicator(onRefresh: ctrl.loadMyDeliveries,
        child: ListView.builder(padding: const EdgeInsets.all(14), itemCount: ctrl.myDeliveries.length,
          itemBuilder: (_, i) => _DelivCard(order: ctrl.myDeliveries[i])));
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
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
        child: Column(children: [
          Padding(padding: const EdgeInsets.all(14), child: Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(order.reference, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.navy)),
              Text(order.vendor?.name ?? '', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              Text(order.address?.contactAddress ?? '', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary), overflow: TextOverflow.ellipsis),
            ])),
            StatusBadge(order.status),
          ])),
          const Divider(height: 1),
          Padding(padding: const EdgeInsets.fromLTRB(14, 10, 14, 10), child: Row(children: [
            Text(AppUtils.timeAgo(order.createdAt), style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            const Spacer(),
            Text(AppUtils.formatNaira(order.deliveryFee ?? 0),
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.green)),
          ])),
          if (order.status == 'picked_up')
            Padding(padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: AppButton(label: '📦 Mark as Delivered', height: 42, color: AppColors.green,
                onTap: () => ctrl.markDelivered(order.id))),
        ]),
      ),
    );
  }
}

// ─── Rider Order Detail ───────────────────────────────────────────────────────
class RiderOrderDetailScreen extends StatelessWidget {
  const RiderOrderDetailScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final ctrl    = RiderController.to;
    final orderId = Get.arguments as int?;
    final order   = [...ctrl.myDeliveries, ...ctrl.availOrders].firstWhereOrNull((o) => o.id == orderId);
    if (order == null) return Scaffold(appBar: OrangeTopBar(title: 'Order'),
        body: const EmptyState(icon: Icons.error_outline, title: 'Order not found'));

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: OrangeTopBar(title: 'Active Delivery',
        actions: [Padding(padding: const EdgeInsets.only(right: 12), child: Center(child: StatusBadge(order.status)))]),
      body: SingleChildScrollView(padding: const EdgeInsets.all(14), child: Column(children: [
        _card([
          _lbl('PICKUP FROM'),
          Row(children: [
            Container(width: 30, height: 30, decoration: BoxDecoration(color: AppColors.chipBg, borderRadius: BorderRadius.circular(9)),
              child: const Center(child: Text('🏪', style: TextStyle(fontSize: 14)))),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(order.vendor?.name ?? '', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.navy)),
              if (order.vendor?.address != null) Text(order.vendor!.address!, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ])),
          ]),
          const SizedBox(height: 16),
          _lbl('DELIVER TO'),
          Row(children: [
            Container(width: 30, height: 30, decoration: BoxDecoration(color: const Color(0xFFFFF5E6), borderRadius: BorderRadius.circular(9)),
              child: const Center(child: Text('🏠', style: TextStyle(fontSize: 14)))),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(order.customer?.name ?? 'Customer', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.navy)),
              Text(order.address?.contactAddress ?? '', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ])),
            if (order.customer?.phone != null)
              Container(width: 36, height: 36, decoration: const BoxDecoration(color: Color(0xFFF0FDF4), shape: BoxShape.circle),
                child: const Icon(Icons.phone_outlined, color: AppColors.green, size: 18)),
          ]),
        ]),
        const SizedBox(height: 12),
        _card([
          _lbl('FINANCIALS'),
          _row('Order Total',   AppUtils.formatNaira(order.total)),
          _row('Delivery Fee',  AppUtils.formatNaira(order.deliveryFee ?? 0)),
          const Divider(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Your Earning (~80%)', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
            Text(AppUtils.formatNaira((order.deliveryFee ?? 0) * 0.8),
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.green)),
          ]),
        ]),
        if (order.status == 'picked_up') ...[
          const SizedBox(height: 16),
          AppButton(label: '📦 Mark as Delivered', color: AppColors.green,
            onTap: () async { final ok = await ctrl.markDelivered(order.id); if (ok) Get.back(); }),
        ],
        const SizedBox(height: 24),
      ])),
    );
  }

  Widget _card(List<Widget> children) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
  );
  Widget _lbl(String t) => Padding(padding: const EdgeInsets.only(bottom: 10),
    child: Text(t, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textSecondary, letterSpacing: 0.5)));
  Widget _row(String l, String v) => Padding(padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(l, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
      Text(v, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.navy)),
    ]));
}

// ─── Wallet Tab ───────────────────────────────────────────────────────────────
class RiderWalletTab extends StatefulWidget {
  const RiderWalletTab({super.key});
  @override State<RiderWalletTab> createState() => _RiderWalletState();
}
class _RiderWalletState extends State<RiderWalletTab> {
  final ctrl = RiderController.to;
  @override void initState() { super.initState(); ctrl.loadWallet(); }
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.bg,
    body: Column(children: [
      Container(color: AppColors.navy,
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 16, left: 20, right: 20, bottom: 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Earnings Wallet', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          const Text('Available Balance', style: TextStyle(color: Colors.white60, fontSize: 12)),
          const SizedBox(height: 6),
          Obx(() => Text(AppUtils.formatNaira(ctrl.walletBalance.value),
              style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w800))),
          const SizedBox(height: 16),
          Row(children: [
            SizedBox(width: 130, child: AppButton(label: 'Withdraw', height: 42, onTap: () => Get.snackbar('', 'Coming soon'))),
            const SizedBox(width: 10),
            Expanded(child: OutlinedButton(onPressed: () => Get.snackbar('', 'Coming soon'),
              style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white38), foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 42), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              child: const Text('Bank Accounts', style: TextStyle(fontWeight: FontWeight.w700)))),
          ]),
        ])),
      Expanded(child: Obx(() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Padding(padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text('Earning History', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.navy))),
        Expanded(child: ctrl.walletTxns.isEmpty
            ? const EmptyState(icon: Icons.account_balance_wallet_outlined, title: 'No transactions yet')
            : RefreshIndicator(onRefresh: ctrl.loadWallet,
                child: ListView.builder(itemCount: ctrl.walletTxns.length,
                  itemBuilder: (_, i) {
                    final t = ctrl.walletTxns[i]; final isC = t.type == 'credit';
                    return Container(decoration: const BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: AppColors.border))),
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                      child: Row(children: [
                        Container(width: 40, height: 40, decoration: BoxDecoration(color: isC ? const Color(0xFFF0FDF4) : const Color(0xFFFEF2F2), borderRadius: BorderRadius.circular(11)),
                          child: Center(child: Text(isC ? '🚚' : '⬆️', style: const TextStyle(fontSize: 18)))),
                        const SizedBox(width: 12),
                        Expanded(child: Text(t.description ?? t.category ?? 'Transaction',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.navy), overflow: TextOverflow.ellipsis)),
                        Text('${isC ? '+' : '-'}${AppUtils.formatNaira(t.amount)}',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: isC ? AppColors.green : AppColors.red)),
                      ]));
                  }))),
      ]))),
    ]),
  );
}

// ─── Account Tab ──────────────────────────────────────────────────────────────
class RiderAccountTab extends StatelessWidget {
  const RiderAccountTab({super.key});
  @override
  Widget build(BuildContext context) {
    final auth = AuthController.to;
    final u    = auth.riderUser;
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SingleChildScrollView(child: Column(children: [
        Container(color: AppColors.orange,
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 16, left: 20, right: 20, bottom: 24),
          child: Column(children: [
            CircleAvatar(radius: 36, backgroundColor: AppColors.navy,
              child: Text(u?.initials ?? 'NK', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700))),
            const SizedBox(height: 10),
            Text(u?.name ?? '', style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800)),
            Text(u?.email ?? '', style: const TextStyle(color: Colors.white70, fontSize: 12)),
            const SizedBox(height: 8),
            Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(14)),
              child: const Text('🏍️ Rider', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700))),
          ])),
        const SizedBox(height: 10),
        Container(color: Colors.white, child: Column(children: [
          _t('👤', 'Edit Profile',     () => Get.snackbar('', 'Coming soon')),
          _t('🏍️', 'Vehicle Info',    () => Get.snackbar('', 'Coming soon')),
          _t('🔒', 'Change Password',  () => Get.snackbar('', 'Coming soon')),
          _t('💬', 'Support',          () => Get.snackbar('', 'Coming soon'), last: true),
        ])),
        const SizedBox(height: 10),
        Container(color: Colors.white, child: _t('🚪', 'Logout', () => _logout(context, auth), color: AppColors.red, last: true)),
        const SizedBox(height: 30),
      ])),
    );
  }

  Widget _t(String icon, String label, VoidCallback onTap, {bool last = false, Color? color}) =>
    InkWell(onTap: onTap, child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(border: last ? null : const Border(bottom: BorderSide(color: AppColors.border))),
      child: Row(children: [
        Container(width: 36, height: 36,
          decoration: BoxDecoration(color: color != null ? const Color(0xFFFEF2F2) : AppColors.chipBg, borderRadius: BorderRadius.circular(10)),
          child: Center(child: Text(icon, style: const TextStyle(fontSize: 16)))),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: color ?? AppColors.navy))),
        Icon(Icons.chevron_right, size: 20, color: color ?? AppColors.textLight),
      ]),
    ));

  void _logout(BuildContext ctx, AuthController auth) => showDialog(
    context: ctx, builder: (_) => AlertDialog(
      title: const Text('Sign out?', style: TextStyle(fontWeight: FontWeight.w700)),
      actions: [
        TextButton(onPressed: Get.back, child: const Text('Cancel')),
        ElevatedButton(onPressed: auth.logout, style: ElevatedButton.styleFrom(backgroundColor: AppColors.red), child: const Text('Sign out')),
      ],
    ));
}