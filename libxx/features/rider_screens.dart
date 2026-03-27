import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:async';
import '../../lib/core/app_colors.dart';
import '../../lib/core/app_text_styles.dart';
import '../core/models.dart';
import '../../lib/core/network.dart';
import '../shared/widgets.dart';

// ── Rider Shell ───────────────────────────────────────────────────────────────
class RiderShell extends StatefulWidget {
  const RiderShell({super.key});
  @override State<RiderShell> createState() => _RiderShellState();
}

class _RiderShellState extends State<RiderShell> {
  int _tab = 0;
  final _screens = const [
    RiderDashboardScreen(), AvailableOrdersScreen(),
    MyDeliveriesScreen(), RiderWalletScreen(), RiderAccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_tab],
      bottomNavigationBar: NKBottomNav(
        currentIndex: _tab,
        onTap: (i) => setState(() => _tab = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), activeIcon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.local_shipping_outlined), activeIcon: Icon(Icons.local_shipping), label: 'Available'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), activeIcon: Icon(Icons.receipt_long), label: 'Mine'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), activeIcon: Icon(Icons.account_balance_wallet), label: 'Wallet'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}

// ── Rider Dashboard ───────────────────────────────────────────────────────────
class RiderDashboardScreen extends StatefulWidget {
  const RiderDashboardScreen({super.key});
  @override State<RiderDashboardScreen> createState() => _RiderDashboardScreenState();
}

class _RiderDashboardScreenState extends State<RiderDashboardScreen> {
  Map<String, dynamic> _data = {};
  bool _loading = true, _togglingAvail = false;
  Timer? _locationTimer;

  @override
  void initState() { super.initState(); _loadDashboard(); _startLocationUpdates(); }

  @override
  void dispose() { _locationTimer?.cancel(); super.dispose(); }

  Future<void> _loadDashboard() async {
    setState(() => _loading = true);
    try {
      final res = await ApiClient().get(ApiEndpoints.riderDashboard);
      setState(() => _data = res.data as Map<String, dynamic>);
    } catch (_) {}
    setState(() => _loading = false);
  }

  void _startLocationUpdates() {
    _sendLocation();
    _locationTimer = Timer.periodic(const Duration(seconds: 60), (_) => _sendLocation());
  }

  Future<void> _sendLocation() async {
    try {
      final perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied || perm == LocationPermission.deniedForever) return;
      final pos   = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
      final marks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
      final place = marks.first;
      await ApiClient().post(ApiEndpoints.riderLocation, data: {
        'latitude':  pos.latitude, 'longitude': pos.longitude,
        'city':  place.locality ?? place.subLocality,
        'state': place.administrativeArea,
      });
    } catch (_) {}
  }

  Future<void> _toggleAvailability() async {
    setState(() => _togglingAvail = true);
    try {
      final res = await ApiClient().post(ApiEndpoints.riderToggle);
      setState(() => _data['is_available'] = res.data['is_available']);
    } catch (_) {}
    setState(() => _togglingAvail = false);
  }

  @override
  Widget build(BuildContext context) {
    final isAvail = _data['is_available'] == true;
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: RefreshIndicator(
        onRefresh: _loadDashboard, color: AppColors.primary,
        child: CustomScrollView(slivers: [
          SliverAppBar(
            pinned: false, expandedHeight: 130,
            backgroundColor: AppColors.secondary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: AppColors.navyGradient),
                padding: const EdgeInsets.fromLTRB(16, 52, 16, 14),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(children: [
                      Text('NKsereke Rider', style: AppTextStyles.subtitle.copyWith(color: AppColors.white)),
                      const Spacer(),
                      const Icon(Icons.notifications_outlined, color: AppColors.white, size: 22),
                    ]),
                    const SizedBox(height: 6),
                    Text('Good to see you! 👋', style: AppTextStyles.bodyMd.copyWith(color: AppColors.white.withOpacity(.9))),
                    Text('📍 ${_data['current_city'] ?? ''} ${_data['current_state'] ?? ''}',
                      style: AppTextStyles.caption2.copyWith(color: AppColors.white.withOpacity(.7))),
                  ],
                ),
              ),
            ),
          ),
          if (_loading)
            const SliverToBoxAdapter(child: Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator(color: AppColors.primary))))
          else
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(children: [
                  // ── Earnings wallet card
                  Container(
                    width: double.infinity, padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: AppColors.brandGradient,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(.3), blurRadius: 16, offset: const Offset(0, 6))],
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Earnings Wallet', style: AppTextStyles.caption.copyWith(color: AppColors.white.withOpacity(.85))),
                      const SizedBox(height: 6),
                      Text(fmtPrice((_data['wallet_balance'] ?? 0).toDouble()), style: AppTextStyles.priceLg),
                      const SizedBox(height: 4),
                      Text('Total earned: ${fmtPrice((_data['total_earned'] ?? 0).toDouble())}',
                        style: AppTextStyles.caption2.copyWith(color: AppColors.white.withOpacity(.8))),
                    ]),
                  ),
                  const SizedBox(height: 14),
                  // ── Stats row
                  Row(children: [
                    Expanded(child: _statCard('🚚', '${_data['today_deliveries'] ?? 0}', "Today's deliveries")),
                    const SizedBox(width: 12),
                    Expanded(child: _statCard('✅', '${_data['total_deliveries'] ?? 0}', 'Total deliveries')),
                  ]),
                  const SizedBox(height: 14),
                  // ── Availability toggle
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: isAvail ? const Color(0xFFBBF7D0) : AppColors.border),
                    ),
                    child: Row(children: [
                      Container(
                        width: 42, height: 42,
                        decoration: BoxDecoration(
                          color: isAvail ? AppColors.doneBg : AppColors.chipBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(child: Text(isAvail ? '📡' : '📵', style: const TextStyle(fontSize: 20))),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(isAvail ? 'You are Online' : 'You are Offline',
                          style: AppTextStyles.subtitle.copyWith(color: isAvail ? AppColors.success : AppColors.textLight, fontSize: 14)),
                        Text(isAvail ? 'Receiving new order requests' : 'Toggle to start receiving orders',
                          style: AppTextStyles.caption2),
                      ])),
                      _togglingAvail
                          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary))
                          : Switch.adaptive(
                              value: isAvail, onChanged: (_) => _toggleAvailability(),
                              activeColor: AppColors.success,
                            ),
                    ]),
                  ),
                  const SizedBox(height: 14),
                  // ── Status card
                  NKCard(margin: EdgeInsets.zero, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('ACCOUNT STATUS', style: AppTextStyles.sectionLabel),
                    const SizedBox(height: 10),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('Approval', style: AppTextStyles.caption),
                      StatusBadge(status: _data['status'] ?? 'pending'),
                    ]),
                    const Divider(height: 16),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('Mode', style: AppTextStyles.caption),
                      Text(isAvail ? 'Online ●' : 'Offline ○',
                        style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w700,
                          color: isAvail ? AppColors.success : AppColors.textLight)),
                    ]),
                  ])),
                ]),
              ),
            ),
        ]),
      ),
    );
  }

  Widget _statCard(String emoji, String value, String label) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white, borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border), boxShadow: AppColors.shadowSm,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 8),
        Text(value, style: AppTextStyles.h2.copyWith(fontSize: 26)),
        const SizedBox(height: 2),
        Text(label, style: AppTextStyles.caption2),
      ]),
    );
  }
}

// ── Available Orders ──────────────────────────────────────────────────────────
class AvailableOrdersScreen extends StatefulWidget {
  const AvailableOrdersScreen({super.key});
  @override State<AvailableOrdersScreen> createState() => _AvailableOrdersScreenState();
}

class _AvailableOrdersScreenState extends State<AvailableOrdersScreen> {
  List<OrderModel> _orders = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final res = await ApiClient().get(ApiEndpoints.riderAvailOrders, params: {'radius_km': 10});
      setState(() => _orders = (res.data['data'] as List).map((j) => OrderModel.fromJson(j)).toList());
    } catch (_) { setState(() => _orders = []); }
    setState(() => _loading = false);
  }

  Future<void> _accept(int id) async {
    try {
      await ApiClient().post(ApiEndpoints.acceptOrder(id));
      _snack('Order accepted! Head to vendor for pickup 🚀', AppColors.success);
      _load();
    } on DioException catch (e) {
      _snack(e.response?.data['message'] ?? 'Failed', AppColors.error);
    }
  }

  Future<void> _reject(int id) async {
    try { await ApiClient().post(ApiEndpoints.rejectOrder(id)); } catch (_) {}
    _load();
  }

  void _snack(String msg, Color bg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: bg, duration: const Duration(seconds: 3)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: NKAppBar(
        title: 'Available Orders',
        actions: [IconButton(icon: const Icon(Icons.refresh, color: AppColors.white), onPressed: _load)],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _orders.isEmpty
              ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Text('🚚', style: TextStyle(fontSize: 64)),
                  const SizedBox(height: 12),
                  Text('No orders in your area', style: AppTextStyles.h3),
                  const SizedBox(height: 6),
                  Text('Make sure you are online and location is shared',
                    style: AppTextStyles.body.copyWith(color: AppColors.textLight), textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  SizedBox(width: 140, child: NKButton(label: 'Refresh', onTap: _load)),
                ]))
              : RefreshIndicator(
                  onRefresh: _load, color: AppColors.primary,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(14),
                    itemCount: _orders.length,
                    itemBuilder: (_, i) => _orderCard(_orders[i]),
                  ),
                ),
    );
  }

  Widget _orderCard(OrderModel o) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white, borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border), boxShadow: AppColors.shadowSm,
      ),
      child: Column(children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: const BoxDecoration(
            color: Color(0xFFFFFBEB),
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('#${o.reference}', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700, color: AppColors.secondary)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(color: AppColors.doneBg, borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.doneText.withOpacity(.3))),
              child: Text('Earn ~${fmtPrice((o.deliveryFee * .8).roundToDouble())}',
                style: AppTextStyles.badgeSm.copyWith(color: AppColors.doneText)),
            ),
          ]),
        ),
        // Body
        Padding(
          padding: const EdgeInsets.all(14),
          child: Column(children: [
            // Pickup
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              LocDot(emoji: '🏪', bg: AppColors.chipBg),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(o.vendor['name'] ?? '', style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w600)),
                Text(o.vendor['address'] ?? '', style: AppTextStyles.caption2, maxLines: 1, overflow: TextOverflow.ellipsis),
                if (o.vendor['vendor_distance_km'] != null)
                  Text('${(o.vendor['vendor_distance_km'] as num).toStringAsFixed(1)}km away',
                    style: AppTextStyles.caption2.copyWith(fontWeight: FontWeight.w600, color: AppColors.secondary)),
              ])),
            ]),
            const SizedBox(height: 10),
            // Deliver
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              LocDot(emoji: '🏠', bg: const Color(0xFFFFF5E6)),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Deliver to customer', style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w600)),
                Text(o.deliveryAddress ?? '', style: AppTextStyles.caption2, maxLines: 1, overflow: TextOverflow.ellipsis),
                if (o.vendor['distance_km'] != null)
                  Text('${(o.vendor['distance_km'] as num).toStringAsFixed(1)}km trip',
                    style: AppTextStyles.caption2.copyWith(fontWeight: FontWeight.w600, color: AppColors.primary)),
              ])),
            ]),
            const SizedBox(height: 12),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Delivery fee', style: AppTextStyles.caption),
              Text(fmtPrice(o.deliveryFee), style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w700)),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: NKButton.red(label: '✗ Reject', onTap: () => _reject(o.id))),
              const SizedBox(width: 10),
              Expanded(child: NKButton(label: '✓ Accept', onTap: () => _accept(o.id))),
            ]),
          ]),
        ),
      ]),
    );
  }
}

// ── My Deliveries ─────────────────────────────────────────────────────────────
class MyDeliveriesScreen extends StatefulWidget {
  const MyDeliveriesScreen({super.key});
  @override State<MyDeliveriesScreen> createState() => _MyDeliveriesScreenState();
}

class _MyDeliveriesScreenState extends State<MyDeliveriesScreen> {
  List<OrderModel> _orders = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final res = await ApiClient().get(ApiEndpoints.riderOrders);
      setState(() => _orders = (res.data['data'] as List).map((j) => OrderModel.fromJson(j)).toList());
    } catch (_) {}
    setState(() => _loading = false);
  }

  Future<void> _markDelivered(int id) async {
    try {
      await ApiClient().post(ApiEndpoints.deliverOrder(id));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('✅ Delivered! Earnings credited 💰'),
        backgroundColor: AppColors.success, duration: Duration(seconds: 3)));
      _load();
    } on DioException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.response?.data['message'] ?? 'Failed'),
        backgroundColor: AppColors.error));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: NKAppBar(
        title: 'My Deliveries',
        actions: [IconButton(icon: const Icon(Icons.refresh, color: AppColors.white), onPressed: _load)],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _orders.isEmpty
              ? const Center(child: Text('No deliveries yet', style: AppTextStyles.body))
              : RefreshIndicator(
                  onRefresh: _load, color: AppColors.primary,
                  child: ListView.builder(
                    itemCount: _orders.length,
                    itemBuilder: (_, i) {
                      final o = _orders[i];
                      return NKCard(
                        onTap: () => Navigator.pushNamed(context, '/rider-order-detail', arguments: o),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text('#${o.reference}', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700, color: AppColors.secondary)),
                            StatusBadge(status: o.status),
                          ]),
                          const SizedBox(height: 8),
                          Text(o.vendor['name'] ?? '', style: AppTextStyles.subtitle.copyWith(fontSize: 14)),
                          const SizedBox(height: 4),
                          Text(o.deliveryAddress ?? '', style: AppTextStyles.caption2, maxLines: 1, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 6),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text(o.date.length > 10 ? o.date.substring(0, 10) : o.date, style: AppTextStyles.caption2),
                            Text('+${fmtPrice(o.deliveryFee)}',
                              style: AppTextStyles.subtitle.copyWith(fontSize: 13, color: AppColors.success)),
                          ]),
                          if (o.status == 'picked_up') ...[
                            const SizedBox(height: 12),
                            NKButton.green(label: '📦 Mark as Delivered', onTap: () => _markDelivered(o.id)),
                          ],
                        ]),
                      );
                    },
                  ),
                ),
    );
  }
}

// ── Rider Wallet ──────────────────────────────────────────────────────────────
class RiderWalletScreen extends StatefulWidget {
  const RiderWalletScreen({super.key});
  @override State<RiderWalletScreen> createState() => _RiderWalletScreenState();
}

class _RiderWalletScreenState extends State<RiderWalletScreen> {
  double _balance = 0;
  List<WalletTransaction> _txns = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final _riderWallet = await Future.wait([
        ApiClient().get(ApiEndpoints.riderWalletBal),
        ApiClient().get(ApiEndpoints.riderWalletTxns),
      ]);
      final bRes = _riderWallet[0];
      final tRes = _riderWallet[1];
      setState(() {
        _balance = (bRes.data['balance'] ?? 0).toDouble();
        _txns    = (tRes.data['data'] as List).map((j) => WalletTransaction.fromJson(j)).toList();
      });
    } catch (_) {}
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: RefreshIndicator(
        onRefresh: _load, color: AppColors.primary,
        child: CustomScrollView(slivers: [
          SliverAppBar(
            pinned: true, expandedHeight: 180,
            backgroundColor: AppColors.secondary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: AppColors.navyGradient),
                padding: const EdgeInsets.fromLTRB(16, 56, 16, 16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end, children: [
                  Text('Earnings Wallet', style: AppTextStyles.subtitle.copyWith(color: AppColors.white)),
                  const SizedBox(height: 4),
                  Text('Available Balance', style: AppTextStyles.caption.copyWith(color: AppColors.white.withOpacity(.7))),
                  const SizedBox(height: 4),
                  Text(fmtPrice(_balance), style: AppTextStyles.priceLg),
                  const SizedBox(height: 14),
                  Row(children: [
                    SizedBox(width: 120, child: NKButton(label: 'Withdraw', height: 38, onTap: () {})),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 140,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.white,
                          side: const BorderSide(color: Colors.white38, width: 1.5),
                          minimumSize: const Size(double.infinity, 38),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {},
                        child: const Text('Bank Accounts', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.white)),
                      ),
                    ),
                  ]),
                ]),
              ),
            ),
          ),
          SliverToBoxAdapter(child: SectionHeader(title: 'Earning History')),
          if (_loading)
            const SliverToBoxAdapter(child: Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator(color: AppColors.primary))))
          else if (_txns.isEmpty)
            const SliverToBoxAdapter(child: Center(child: Padding(padding: EdgeInsets.all(40), child: Text('No transactions yet', style: AppTextStyles.body))))
          else
            SliverList(delegate: SliverChildBuilderDelegate(
              (_, i) => Column(children: [
                WalletTransactionTile(tx: _txns[i]),
                if (i < _txns.length - 1) const Divider(height: 1, indent: 62),
              ]),
              childCount: _txns.length,
            )),
        ]),
      ),
    );
  }
}

// ── Rider Account ─────────────────────────────────────────────────────────────
class RiderAccountScreen extends StatefulWidget {
  const RiderAccountScreen({super.key});
  @override State<RiderAccountScreen> createState() => _RiderAccountScreenState();
}

class _RiderAccountScreenState extends State<RiderAccountScreen> {
  UserModel? _user;
  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    try {
      final res = await ApiClient().get(ApiEndpoints.profile);
      setState(() => _user = UserModel.fromJson(res.data['user']));
    } catch (_) {}
  }

  Future<void> _logout() async {
    try { await ApiClient().post(ApiEndpoints.logout); } catch (_) {}
    await ApiClient().clearToken();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: CustomScrollView(slivers: [
        SliverAppBar(
          expandedHeight: 180, pinned: true,
          backgroundColor: AppColors.primary,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              color: AppColors.primary,
              padding: const EdgeInsets.fromLTRB(20, 56, 20, 16),
              child: Column(children: [
                CircleAvatar(
                  radius: 34, backgroundColor: AppColors.secondary,
                  child: Text(_user?.initials ?? 'R', style: AppTextStyles.h2.copyWith(color: AppColors.white)),
                ),
                const SizedBox(height: 10),
                Text(_user?.name ?? 'Rider', style: AppTextStyles.subtitle.copyWith(color: AppColors.white)),
                Text(_user?.email ?? '', style: AppTextStyles.caption.copyWith(color: AppColors.white.withOpacity(.85))),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                  decoration: BoxDecoration(color: AppColors.white.withOpacity(.2), borderRadius: BorderRadius.circular(14)),
                  child: const Text('🏍️ Rider', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.white)),
                ),
              ]),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Column(children: [
            const SizedBox(height: 10),
            Container(color: AppColors.white, child: Column(children: [
              _tile('👤', 'Edit Profile', false),
              const Divider(height: 1, indent: 62),
              _tile('🏍️', 'Vehicle Info', false),
              const Divider(height: 1, indent: 62),
              _tile('📋', 'Guarantor Info', false),
              const Divider(height: 1, indent: 62),
              _tile('🔒', 'Change Password', false),
              const Divider(height: 1, indent: 62),
              _tile('💬', 'Support', false),
            ])),
            const SizedBox(height: 10),
            Container(color: AppColors.white, child: _tile('🚪', 'Logout', true, onTap: _logout)),
            const SizedBox(height: 30),
          ]),
        ),
      ]),
    );
  }

  Widget _tile(String emoji, String label, bool isRed, {VoidCallback? onTap}) {
    return ListTile(
      leading: Container(width: 34, height: 34,
        decoration: BoxDecoration(color: isRed ? AppColors.cancelBg : AppColors.chipBg, borderRadius: BorderRadius.circular(10)),
        child: Center(child: Text(emoji, style: const TextStyle(fontSize: 16)))),
      title: Text(label, style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w600,
        color: isRed ? AppColors.error : AppColors.text)),
      trailing: Icon(Icons.chevron_right, color: isRed ? AppColors.error : AppColors.textHint),
      onTap: onTap,
    );
  }
}
