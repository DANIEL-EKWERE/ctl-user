import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/controllers/auth_controller.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/api_client.dart';
import '../../../utils/storage_service.dart';
import '../../widgets/common/app_widgets.dart';

class RiderHomeScreen extends StatefulWidget {
  const RiderHomeScreen({super.key});
  @override
  State<RiderHomeScreen> createState() => _RiderHomeScreenState();
}

class _RiderHomeScreenState extends State<RiderHomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authCtrl = Get.put(AuthController());
    final tabs = [
      const _AvailableOrdersTab(),
      const _MyDeliveriesTab(),
      const _RiderWalletTab(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10)),
            child: const Center(
                child: Text('NK',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: AppColors.white))),
          ),
          const SizedBox(width: 10),
          const Text('Rider Dashboard'),
        ]),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => authCtrl.logout(),
            tooltip: 'Sign out',
          ),
        ],
      ),
      body: IndexedStack(index: _currentIndex, children: tabs),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping_outlined),
            activeIcon: Icon(Icons.local_shipping_rounded),
            label: 'Available',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            activeIcon: Icon(Icons.list_alt_rounded),
            label: 'Deliveries',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            activeIcon: Icon(Icons.account_balance_wallet_rounded),
            label: 'Wallet',
          ),
        ],
      ),
    );
  }
}

// ─── Available Orders ────────────────────────────────────────────────────────

class _AvailableOrdersTab extends StatefulWidget {
  const _AvailableOrdersTab();
  @override
  State<_AvailableOrdersTab> createState() => _AvailableOrdersTabState();
}

class _AvailableOrdersTabState extends State<_AvailableOrdersTab> {
  List<dynamic> _orders = [];
  bool _loading = true;
  String _riderName = '';

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    _riderName = await StorageService.instance.getUserName();
    await _load();
  }

  Future<void> _load() async {
    if (!mounted) return;
    setState(() => _loading = true);
    final res = await ApiClient.instance.getAvailableOrders();
    if (res['success'] == true) {
      final d = res['data'] as Map<String, dynamic>;
      final inner = (d['data'] ?? d) as Map<String, dynamic>;
      _orders = (inner['orders'] ?? inner['data'] ?? []) as List;
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _load,
      child: _loading
          ? const Center(
              child:
                  CircularProgressIndicator(color: AppColors.primary))
          : CustomScrollView(slivers: [
              SliverToBoxAdapter(
                child: _buildHeader(),
              ),
              _orders.isEmpty
                  ? const SliverFillRemaining(
                      child: EmptyState(
                          icon: Icons.local_shipping_outlined,
                          title: 'No available orders',
                          subtitle: 'Pull to refresh for new orders'),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, i) => Padding(
                          padding: EdgeInsets.fromLTRB(
                              16, i == 0 ? 8 : 0, 16, 12),
                          child: _AvailableOrderCard(
                            order: _orders[i],
                            onActionDone: _load,
                          ),
                        ),
                        childCount: _orders.length,
                      ),
                    ),
            ]),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              'Hi, ${_riderName.isNotEmpty ? _riderName : 'Rider'} 👋',
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white),
            ),
            const SizedBox(height: 4),
            Text(
              '${_orders.length} order${_orders.length == 1 ? '' : 's'} available near you',
              style: const TextStyle(
                  fontSize: 13, color: Colors.white70),
            ),
          ]),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.delivery_dining_rounded,
              color: AppColors.white, size: 28),
        ),
      ]),
    );
  }
}

class _AvailableOrderCard extends StatefulWidget {
  final dynamic order;
  final VoidCallback onActionDone;
  const _AvailableOrderCard(
      {required this.order, required this.onActionDone});
  @override
  State<_AvailableOrderCard> createState() =>
      _AvailableOrderCardState();
}

class _AvailableOrderCardState extends State<_AvailableOrderCard> {
  bool _acting = false;

  Future<void> _accept() async {
    setState(() => _acting = true);
    final id =
        int.tryParse(widget.order['id']?.toString() ?? '0') ?? 0;
    await ApiClient.instance.acceptOrder(id);
    widget.onActionDone();
  }

  Future<void> _reject() async {
    setState(() => _acting = true);
    final id =
        int.tryParse(widget.order['id']?.toString() ?? '0') ?? 0;
    await ApiClient.instance.rejectOrder(id, reason: 'Not available');
    widget.onActionDone();
  }

  @override
  Widget build(BuildContext context) {
    final id = widget.order['id']?.toString() ?? '';
    final vendorName =
        widget.order['vendor']?['name']?.toString() ?? 'Vendor';
    final vendorAddress =
        widget.order['vendor']?['address']?.toString() ?? '';
    final deliveryAddress =
        widget.order['delivery_address']?.toString() ?? '';
    final total = widget.order['total']?.toString() ?? '0';
    final itemCount =
        (widget.order['items'] as List?)?.length ?? 0;
    final distance = widget.order['distance_km']?.toString();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Header
        Container(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
          decoration: const BoxDecoration(
            color: AppColors.grey50,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Row(children: [
            const Icon(Icons.receipt_outlined,
                size: 16, color: AppColors.primary),
            const SizedBox(width: 6),
            Text('Order #$id',
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w700)),
            const Spacer(),
            Text('N$total',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary)),
          ]),
        ),

        Padding(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Pickup
            _AddressRow(
              icon: Icons.store_outlined,
              iconColor: AppColors.warning,
              label: 'Pickup',
              address: vendorAddress.isNotEmpty
                  ? vendorAddress
                  : vendorName,
            ),
            const SizedBox(height: 10),
            // Delivery
            _AddressRow(
              icon: Icons.location_on_outlined,
              iconColor: AppColors.primary,
              label: 'Deliver to',
              address: deliveryAddress,
            ),
            const Divider(height: 18),
            Row(children: [
              _Chip(Icons.inventory_2_outlined,
                  '$itemCount item${itemCount == 1 ? '' : 's'}'),
              const SizedBox(width: 12),
              if (distance != null)
                _Chip(Icons.social_distance_outlined,
                    '${distance}km away'),
            ]),
          ]),
        ),

        // Actions
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          child: Row(children: [
            Expanded(
              child: AppButton(
                label: 'Accept',
                height: 44,
                isLoading: _acting,
                onTap: _accept,
                icon: Icons.check_rounded,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: AppButton(
                label: 'Reject',
                height: 44,
                outlined: true,
                color: AppColors.error,
                textColor: AppColors.error,
                onTap: _acting ? null : _reject,
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}

class _AddressRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String address;
  const _AddressRow(
      {required this.icon,
      required this.iconColor,
      required this.label,
      required this.address});

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, size: 16, color: iconColor),
      const SizedBox(width: 8),
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500)),
          Text(address.isNotEmpty ? address : '—',
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w500)),
        ]),
      ),
    ]);
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Chip(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, size: 14, color: AppColors.textSecondary),
      const SizedBox(width: 4),
      Text(label,
          style: const TextStyle(
              fontSize: 12, color: AppColors.textSecondary)),
    ]);
  }
}

// ─── My Deliveries ───────────────────────────────────────────────────────────

class _MyDeliveriesTab extends StatefulWidget {
  const _MyDeliveriesTab();
  @override
  State<_MyDeliveriesTab> createState() => _MyDeliveriesTabState();
}

class _MyDeliveriesTabState extends State<_MyDeliveriesTab> {
  List<dynamic> _orders = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (!mounted) return;
    setState(() => _loading = true);
    final res = await ApiClient.instance.getRiderOrders();
    if (res['success'] == true) {
      final d = res['data'] as Map<String, dynamic>;
      final inner = (d['data'] ?? d) as Map<String, dynamic>;
      _orders = (inner['orders'] ?? inner['data'] ?? []) as List;
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
          child: CircularProgressIndicator(color: AppColors.primary));
    }
    if (_orders.isEmpty) {
      return const EmptyState(
          icon: Icons.inbox_outlined, title: 'No deliveries yet');
    }
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _load,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _orders.length,
        itemBuilder: (_, i) =>
            _DeliveryCard(order: _orders[i], onDone: _load),
      ),
    );
  }
}

class _DeliveryCard extends StatefulWidget {
  final dynamic order;
  final VoidCallback onDone;
  const _DeliveryCard({required this.order, required this.onDone});
  @override
  State<_DeliveryCard> createState() => _DeliveryCardState();
}

class _DeliveryCardState extends State<_DeliveryCard> {
  bool _marking = false;

  @override
  Widget build(BuildContext context) {
    final id = widget.order['id']?.toString() ?? '';
    final status = widget.order['status']?.toString() ?? '';
    final vendorName =
        widget.order['vendor']?['name']?.toString() ?? 'Vendor';
    final total = widget.order['total']?.toString() ?? '0';
    final createdAt = widget.order['created_at']?.toString() ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Order #$id',
              style: const TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 15)),
          StatusBadge(status: status),
        ]),
        const SizedBox(height: 8),
        Text(vendorName,
            style: const TextStyle(
                fontSize: 13, color: AppColors.textSecondary)),
        Text('N$total',
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600)),
        if (createdAt.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(createdAt,
              style: const TextStyle(
                  fontSize: 11, color: AppColors.textSecondary)),
        ],
        if (status == 'assigned') ...[
          const SizedBox(height: 12),
          AppButton(
            label: 'Mark as Delivered',
            height: 42,
            isLoading: _marking,
            icon: Icons.check_circle_outline_rounded,
            onTap: () async {
              setState(() => _marking = true);
              await ApiClient.instance
                  .markDelivered(int.tryParse(id) ?? 0);
              widget.onDone();
            },
          ),
        ],
      ]),
    );
  }
}

// ─── Wallet ──────────────────────────────────────────────────────────────────

class _RiderWalletTab extends StatefulWidget {
  const _RiderWalletTab();
  @override
  State<_RiderWalletTab> createState() => _RiderWalletTabState();
}

class _RiderWalletTabState extends State<_RiderWalletTab> {
  String _balance = '0';
  List<dynamic> _transactions = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final wRes = await ApiClient.instance.getRiderWallet();
    final tRes = await ApiClient.instance.getRiderTransactions();
    if (wRes['success'] == true) {
      final d = wRes['data'] as Map<String, dynamic>;
      final inner = (d['data'] ?? d) as Map<String, dynamic>;
      _balance = inner['balance']?.toString() ?? '0';
    }
    if (tRes['success'] == true) {
      final d = tRes['data'] as Map<String, dynamic>;
      final inner = (d['data'] ?? d) as Map<String, dynamic>;
      _transactions =
          (inner['transactions'] ?? inner['data'] ?? []) as List;
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
          child: CircularProgressIndicator(color: AppColors.primary));
    }
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Balance card
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(children: [
              const Text('Available Balance',
                  style: TextStyle(
                      color: Colors.white70, fontSize: 14)),
              const SizedBox(height: 8),
              Text(
                'N$_balance',
                style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 38,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1),
              ),
              const SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                _WalletAction(
                    Icons.arrow_downward_rounded, 'Withdraw', () {}),
                const SizedBox(width: 20),
                _WalletAction(Icons.history_rounded, 'History', () {}),
              ]),
            ]),
          ),
          const SizedBox(height: 24),
          const Text('Transactions',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          if (_transactions.isEmpty)
            const EmptyState(
                icon: Icons.receipt_long_outlined,
                title: 'No transactions yet',
                subtitle: 'Your earnings will appear here')
          else
            ..._transactions.map((t) {
              final type = t['type']?.toString() ?? '';
              final isCredit = type == 'credit';
              return ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 4),
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isCredit
                        ? AppColors.success.withOpacity(0.1)
                        : AppColors.error.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isCredit
                        ? Icons.arrow_downward_rounded
                        : Icons.arrow_upward_rounded,
                    color: isCredit
                        ? AppColors.success
                        : AppColors.error,
                    size: 20,
                  ),
                ),
                title: Text(
                    t['description']?.toString() ?? 'Transaction',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600)),
                subtitle: Text(t['created_at']?.toString() ?? '',
                    style: const TextStyle(fontSize: 12)),
                trailing: Text(
                  '${isCredit ? '+' : '-'}N${t['amount']}',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isCredit
                          ? AppColors.success
                          : AppColors.error),
                ),
              );
            }),
        ],
      ),
    );
  }
}

class _WalletAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _WalletAction(this.icon, this.label, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.white, size: 22),
        ),
        const SizedBox(height: 6),
        Text(label,
            style: const TextStyle(
                color: Colors.white70, fontSize: 12)),
      ]),
    );
  }
}
