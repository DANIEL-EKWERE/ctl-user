import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../lib/core/app_colors.dart';
import '../../lib/core/app_text_styles.dart';
import '../core/models.dart';
import '../../lib/core/network.dart';
import '../../lib/core/cart_provider.dart';
import '../shared/widgets.dart';
import 'review_support_payment_screens.dart';

// ── Customer Shell ────────────────────────────────────────────────────────────
class CustomerShell extends StatefulWidget {
  const CustomerShell({super.key});
  @override State<CustomerShell> createState() => _CustomerShellState();
}

class _CustomerShellState extends State<CustomerShell> {
  int _tab = 0;
  final _screens = const [
    CustomerHomeScreen(), CustomerOrdersScreen(),
    CustomerWalletScreen(), CustomerAccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_tab],
      bottomNavigationBar: NKBottomNav(
        currentIndex: _tab,
        onTap: (i) => setState(() => _tab = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined),   activeIcon: Icon(Icons.home),              label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), activeIcon: Icon(Icons.receipt_long), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), activeIcon: Icon(Icons.account_balance_wallet), label: 'Wallet'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline),  activeIcon: Icon(Icons.person),            label: 'Account'),
        ],
      ),
    );
  }
}

// ── Home Screen ───────────────────────────────────────────────────────────────
class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});
  @override State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  List<CategoryModel>      _categories = [];
  List<VendorModel>        _vendors    = [];
  List<Map<String,dynamic>> _ads       = [];
  int    _adFrequency = 5;
  bool _loading       = true;
  bool _vendorsLoading= false;
  bool _vendorsLoaded = false;
  String? _vendorsError;
  String _deliveryAddr = '';
  double? _deliveryLat, _deliveryLng;

  AddressModel? _defaultAddress;
  bool _locationReady = false;

  @override
  void initState() { super.initState(); _initLocation(); }

  /// Step 1: load saved addresses; if none with coords → show location screen
  Future<void> _initLocation() async {
    setState(() => _loading = true);
    try {
      final res = await ApiClient().get(ApiEndpoints.addresses);
      final addresses = (res.data['addresses'] as List? ?? [])
          .map((j) => AddressModel.fromJson(j)).toList();
      final def = addresses.firstWhere((a) => a.isDefault,
          orElse: () => addresses.isNotEmpty ? addresses.first : AddressModel.empty());

      if (def.latitude != null && def.longitude != null) {
        setState(() {
          _defaultAddress = def;
          _deliveryAddr   = def.address;
          _deliveryLat    = def.latitude!;
          _deliveryLng    = def.longitude!;
          _locationReady  = true;
        });
        await _loadData();
      } else {
        // No address → prompt location setup
        setState(() { _locationReady = false; _loading = false; });
      }
    } catch (_) {
      setState(() { _locationReady = false; _loading = false; });
    }
  }

  Future<void> _loadData({int? catId}) async {
    if (_deliveryLat == null || _deliveryLng == null) return;
    setState(() => _loading = true);
    try {
      final params = {
        'latitude':  _deliveryLat.toString(),
        'longitude': _deliveryLng.toString(),
        'radius_km': '10',
        'include_closed': '0',
        if (catId != null) 'category_id': catId.toString(),
      };
        setState(() => _vendorsError = null);

      // Load categories and ads in parallel (non-critical)
      final _results1 = await Future.wait([
        ApiClient().get(ApiEndpoints.categories),
        ApiClient().get(ApiEndpoints.advertisements).catchError((_) async {
          return Response(data: {'data': [], 'frequency': 5}, statusCode: 200,
              requestOptions: RequestOptions(path: ''));
        }),
      ]);
      final cRes = _results1[0];
      final adRes = _results1[1];

      setState(() {
        _categories = (cRes.data['categories'] as List? ?? [])
            .map((j) => CategoryModel.fromJson(j)).toList();
        try {
          _ads = (adRes.data['data'] as List? ?? []).cast<Map<String,dynamic>>();
          _adFrequency = (adRes.data['frequency'] as int?) ?? 5;
        } catch (_) {}
      });

      // Load vendors separately so we can show proper error
      setState(() => _vendorsLoading = true);
      try {
        final vRes = await ApiClient().get(ApiEndpoints.vendors, params: params)
            .timeout(const Duration(seconds: 15));
        setState(() {
          if (vRes.data['location_required'] == true) {
            _vendors = [];
          } else {
            _vendors = (vRes.data['data'] as List? ?? [])
                .map((j) => VendorModel.fromJson(j)).toList();
          }
          _vendorsLoaded = true;
        });
      } on TimeoutException {
        setState(() { _vendorsError = 'Request timed out. Check your connection.'; _vendorsLoaded = true; });
      } on DioException catch (e) {
        setState(() { _vendorsError = e.response?.data['message'] ?? 'Could not load vendors'; _vendorsLoaded = true; });
      } finally {
        setState(() => _vendorsLoading = false);
      }
    } catch (_) {}
    setState(() => _loading = false);
  }

  Future<void> _onLocationSet(Map<String, dynamic> result) async {
    final addr = result['address'] as String? ?? '';
    final lat  = (result['lat']  as num?)?.toDouble();
    final lng  = (result['lng']  as num?)?.toDouble();
    if (lat == null || lng == null) return;

    // Save as default address via API
    try {
      final saveRes = await ApiClient().post(ApiEndpoints.addresses, data: {
        'label': 'Home', 'address': addr,
        'latitude': lat, 'longitude': lng, 'is_default': true,
      });
      setState(() {
        _defaultAddress = AddressModel.fromJson(saveRes.data['address']);
        _deliveryAddr   = addr;
        _deliveryLat    = lat;
        _deliveryLng    = lng;
        _locationReady  = true;
      });
    } catch (_) {
      setState(() {
        _deliveryAddr  = addr;
        _deliveryLat   = lat;
        _deliveryLng   = lng;
        _locationReady = true;
      });
    }
    setState(() { _vendorsLoading = true; _vendorsLoaded = false; _vendorsError = null; });
    // Load categories + data, then show home (categories are shown on home)
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    // ── Show location onboarding if no default address with coords ──────────
    if (!_locationReady && !_loading) {
      return _LocationOnboardingScreen(onLocationSet: _onLocationSet);
    }
    if (!_locationReady && _loading) {
      return const Scaffold(
        backgroundColor: AppColors.white,
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: CustomScrollView(
        slivers: [
          // ── Orange header
          SliverAppBar(
            pinned: false, floating: true,
            backgroundColor: AppColors.primary,
            expandedHeight: 100,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppColors.primary,
                padding: const EdgeInsets.fromLTRB(16, 50, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(children: [
                      // Logo
                      Container(width: 28, height: 28, decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(7)),
                        child: Center(child: Text('NK', style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.w900, fontSize: 10)))),
                      const SizedBox(width: 8),
                      Text('NKsereke', style: AppTextStyles.subtitle.copyWith(color: AppColors.white)),
                      const Spacer(),
                      CartBadge(count: cart.totalItemCount, onTap: () => Navigator.pushNamed(context, '/cart')),
                    ]),
                    const SizedBox(height: 8),
                    Row(children: [
                      const Icon(Icons.place_outlined, size: 16, color: AppColors.white),
                      const SizedBox(width: 4),
                      Expanded(child: Text(_deliveryAddr.isNotEmpty ? _deliveryAddr : 'Set delivery location',
                        style: AppTextStyles.bodyMd.copyWith(color: AppColors.white, fontWeight: FontWeight.w600),
                        maxLines: 1, overflow: TextOverflow.ellipsis)),
                      const Icon(Icons.keyboard_arrow_down, size: 18, color: AppColors.white),
                    ]),
                  ],
                ),
              ),
            ),
          ),
          // ── Categories grid ── tap category → vendors filtered by that category
          SliverToBoxAdapter(child: SectionHeader(
            title: 'Categories',
            action: 'All Vendors',
            onAction: () => Navigator.pushNamed(context, '/vendors', arguments: {
              'lat': _deliveryLat, 'lng': _deliveryLng,
            }),
          )),
          if (_loading && _categories.isEmpty)
            const SliverToBoxAdapter(child: Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator(color: AppColors.primary))))
          else if (_categories.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.82,
                ),
                delegate: SliverChildBuilderDelegate((_, i) {
                  final c = _categories[i];
                  return GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/vendors', arguments: {
                      'category': c, 'lat': _deliveryLat, 'lng': _deliveryLng,
                    }),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Container(
                        width: 56, height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.chipBg,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: c.imageUrl.isNotEmpty
                            ? ClipRRect(borderRadius: BorderRadius.circular(13),
                                child: CachedNetworkImage(imageUrl: c.imageUrl, fit: BoxFit.cover,
                                  errorWidget: (_, __, ___) => Center(child: Text(
                                    c.name.isNotEmpty ? c.name[0].toUpperCase() : '?',
                                    style: AppTextStyles.h3.copyWith(color: AppColors.primary)))))
                            : Center(child: Text(
                                c.name.isNotEmpty ? c.name[0].toUpperCase() : '?',
                                style: AppTextStyles.h3.copyWith(color: AppColors.primary))),
                      ),
                      const SizedBox(height: 5),
                      Text(c.name,
                        style: AppTextStyles.caption2.copyWith(fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center, maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    ]),
                  );
                }, childCount: _categories.length),
              ),
            )
          else
            const SliverToBoxAdapter(child: SizedBox(height: 4)),
          // ── Vendors
          SliverToBoxAdapter(child: SectionHeader(title: 'Vendors Near You', action: 'See all',
              onAction: () => Navigator.pushNamed(context, '/vendors', arguments: {}))),
          if (_loading)
            const SliverToBoxAdapter(child: Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator(color: AppColors.primary))))
          else if (_vendors.isEmpty)
            const SliverToBoxAdapter(child: Center(child: Padding(padding: EdgeInsets.all(40),
                child: Text('No vendors found', style: AppTextStyles.body))))
          // Vendor states
          if (_vendorsLoading)
            const SliverToBoxAdapter(
              child: Center(child: Padding(padding: EdgeInsets.all(32),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  CircularProgressIndicator(color: AppColors.primary),
                  SizedBox(height: 12),
                  Text('Finding vendors near you...', style: AppTextStyles.caption),
                ]))))
          else if (_vendorsError != null)
            SliverToBoxAdapter(
              child: Center(child: Padding(padding: const EdgeInsets.all(32),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Text('⚠️', style: TextStyle(fontSize: 40)),
                  const SizedBox(height: 12),
                  Text('Could not load vendors', style: AppTextStyles.subtitle),
                  const SizedBox(height: 4),
                  Text(_vendorsError!, style: AppTextStyles.caption, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    NKButton(label: '↻ Retry', height: 40,
                        onTap: () => _loadData()),
                    const SizedBox(width: 8),
                    NKButton.outline(label: '📍 Change Location', height: 40,
                        onTap: () async {
                          final r = await Navigator.pushNamed(context, '/location');
                          if (r is Map<String,dynamic>) await _onLocationSet(r);
                        }),
                  ]),
                ]))))
          else if (_vendorsLoaded && _vendors.isEmpty)
            SliverToBoxAdapter(
              child: Center(child: Padding(padding: const EdgeInsets.all(32),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Text('🏪', style: TextStyle(fontSize: 52, color: Color(0x3F000000))),
                  const SizedBox(height: 12),
                  Text('No vendors in your area yet', style: AppTextStyles.subtitle),
                  const SizedBox(height: 8),
                  Text('We are expanding! Try a different location.',
                    style: AppTextStyles.caption, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  NKButton(label: '📍 Change Location', onTap: () async {
                    final r = await Navigator.pushNamed(context, '/location');
                    if (r is Map<String,dynamic>) await _onLocationSet(r);
                  }),
                ]))))
          else
            SliverList(delegate: SliverChildBuilderDelegate(
              (ctx, i) {
                if (_ads.isNotEmpty && _adFrequency > 0 && i > 0 && i % (_adFrequency + 1) == 0) {
                  final adIdx = (i ~/ (_adFrequency + 1) - 1) % _ads.length;
                  return AdCard(ad: _ads[adIdx]);
                }
                final adSlotsBefore = _ads.isNotEmpty && _adFrequency > 0 ? i ~/ (_adFrequency + 1) : 0;
                final vIdx = i - adSlotsBefore;
                if (vIdx >= _vendors.length) return const SizedBox.shrink();
                return VendorCard(
                  vendor: _vendors[vIdx],
                  onTap: () => Navigator.pushNamed(context, '/vendor-detail', arguments: {
                    'vendor': _vendors[vIdx], 'lat': _deliveryLat, 'lng': _deliveryLng,
                  }),
                );
              },
              childCount: _ads.isNotEmpty && _adFrequency > 0
                  ? _vendors.length + (_vendors.length ~/ _adFrequency)
                  : _vendors.length,
            )),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}

// ── Vendor List Screen ────────────────────────────────────────────────────────
class VendorListScreen extends StatefulWidget {
  const VendorListScreen({super.key});
  @override State<VendorListScreen> createState() => _VendorListScreenState();
}

class _VendorListScreenState extends State<VendorListScreen> {
  List<VendorModel> _vendors = [];
  bool _loading = true;
  CategoryModel? _category;
  double? _lat, _lng;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>? ?? {};
    _category = args['category'];
    _lat = (args['lat'] as num?)?.toDouble();
    _lng = (args['lng'] as num?)?.toDouble();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final params = <String, dynamic>{
        if (_lat != null) 'latitude':  _lat.toString(),
        if (_lng != null) 'longitude': _lng.toString(),
        if (_lat != null) 'radius_km': '10',
        if (_category != null) 'category_id': _category!.id.toString(),
        'include_closed': '0',
      };
      final res = await ApiClient().get(ApiEndpoints.vendors, params: params);
      setState(() {
        if (res.data['location_required'] == true) {
          _vendors = [];
        } else {
          _vendors = (res.data['data'] as List? ?? []).map((j) => VendorModel.fromJson(j)).toList();
        }
      });
    } catch (_) {}
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: NKAppBar(
        title: _category?.name ?? 'All Vendors',
        actions: [CartBadge(count: cart.totalItemCount, onTap: () => Navigator.pushNamed(context, '/cart'))],
      ),
      body: _loading
          ? const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              CircularProgressIndicator(color: AppColors.primary),
              SizedBox(height: 12),
              Text('Finding vendors near you...', style: AppTextStyles.caption),
            ]))
          : _vendors.isEmpty
              ? Center(child: Padding(padding: const EdgeInsets.all(32),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    const Text('🏪', style: TextStyle(fontSize: 52, color: Color(0x3F000000))),
                    const SizedBox(height: 12),
                    Text(_category != null
                        ? 'No ${_category!.name} vendors near you'
                        : 'No vendors in your area yet',
                      style: AppTextStyles.subtitle, textAlign: TextAlign.center),
                    const SizedBox(height: 8),
                    const Text('We are expanding! Try a different location.',
                        style: AppTextStyles.caption, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      NKButton(label: '📍 Change Location', height: 40,
                          onTap: () => Navigator.pop(context)),
                      const SizedBox(width: 8),
                      NKButton.outline(label: 'Go Back', height: 40,
                          onTap: () => Navigator.pop(context)),
                    ]),
                  ])))
              : RefreshIndicator(
                  onRefresh: _load, color: AppColors.primary,
                  child: ListView.builder(
                    itemCount: _vendors.length,
                    itemBuilder: (_, i) => VendorCard(
                      vendor: _vendors[i],
                      onTap: () => Navigator.pushNamed(context, '/vendor-detail', arguments: {
                        'vendor': _vendors[i], 'lat': _lat, 'lng': _lng,
                      }),
                    ),
                  ),
                ),
    );
  }
}

// ── Vendor Detail Screen ──────────────────────────────────────────────────────
class VendorDetailScreen extends StatefulWidget {
  const VendorDetailScreen({super.key});
  @override State<VendorDetailScreen> createState() => _VendorDetailScreenState();
}

class _VendorDetailScreenState extends State<VendorDetailScreen> {
  late VendorModel _vendor;
  List<ProductModel>  _products = [];
  List<CategoryModel> _prodCats = [];
  int? _filterCatId;
  bool _loading = true;

  double? _customerLat, _customerLng;
  Map<String,dynamic>? _reviewStats;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _vendor = args['vendor'] as VendorModel;
    _customerLat = (args['lat'] as num?)?.toDouble();
    _customerLng = (args['lng'] as num?)?.toDouble();
    _loadVendor();
  }

  Future<void> _loadVendor() async {
    setState(() { _loading = true; });
    try {
      final params = <String, dynamic>{
        if (_customerLat != null) 'latitude':  _customerLat.toString(),
        if (_customerLng != null) 'longitude': _customerLng.toString(),
      };
      // Fetch vendor detail, products, and live review stats in parallel
      final results = await Future.wait([
        ApiClient().get(ApiEndpoints.vendorDetail(_vendor.id), params: params),
        ApiClient().get(ApiEndpoints.vendorProducts(_vendor.id)),
        ApiClient().get(ApiEndpoints.vendorReviews(_vendor.id))
            .catchError((_) => Response(data: {'stats': null}, statusCode: 200,
                requestOptions: RequestOptions(path: ''))),
      ]);

      final vRes  = results[0];
      final pRes  = results[1];
      final rvRes = results[2];

      final vendorData = Map<String,dynamic>.from(vRes.data['vendor'] as Map);
      final cats = (vendorData['product_categories'] as List?)
          ?.map((j) => CategoryModel.fromJson(j as Map<String,dynamic>)).toList() ?? [];

      // Live review stats: prefer inline review_stats in vendor response,
      // fall back to separate reviews endpoint
      final Map<String,dynamic>? inlineStats =
          vendorData['review_stats'] as Map<String,dynamic>?;
      final Map<String,dynamic>? liveStats =
          inlineStats ?? rvRes.data['stats'] as Map<String,dynamic>?;

      // Patch vendor data with fresh rating
      if (liveStats != null) {
        vendorData['rating']        = liveStats['average'];
        vendorData['total_ratings'] = liveStats['total'];
      }

      setState(() {
        _vendor      = VendorModel.fromJson(vendorData);
        _reviewStats = liveStats;
        _prodCats    = cats;
        _products    = (pRes.data['data'] as List? ?? [])
            .map((j) => ProductModel.fromJson(j as Map<String,dynamic>)).toList();
      });
    } catch (e) {
      // Keep existing vendor data, just stop loading
    }
    setState(() => _loading = false);
  }
  List<ProductModel> get _filtered => _filterCatId == null
      ? _products
      : _products.where((p) => p.category == _prodCats.firstWhere((c) => c.id == _filterCatId, orElse: () => _prodCats.first).name).toList();

  double get _liveRating =>
      (_reviewStats?['average'] as num?)?.toDouble() ?? _vendor.rating;

  int get _liveTotalRatings =>
      (_reviewStats?['total'] as num?)?.toInt() ?? _vendor.totalRatings;

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    return Scaffold(
      backgroundColor: AppColors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 100, pinned: true,
            backgroundColor: AppColors.secondary,
            actions: [CartBadge(count: cart.totalItemCount, onTap: () => Navigator.pushNamed(context, '/cart'))],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(fit: StackFit.expand, children: [
                Container(decoration: const BoxDecoration(gradient: AppColors.vendorBannerGradient),
                  child: const Center(child: Text('🍽️', style: TextStyle(fontSize: 40)))),
                if (_vendor.bannerUrl != null)
                  CachedNetworkImage(imageUrl: _vendor.bannerUrl!, fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => const SizedBox.shrink()),
                Container(color: Colors.black.withOpacity(.2)),
              ]),
            ),
          ),
          // Vendor info
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.white,
              padding: const EdgeInsets.all(14),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                ClipRRect(borderRadius: BorderRadius.circular(13),
                  child: _vendor.logoUrl.isNotEmpty
                      ? CachedNetworkImage(imageUrl: _vendor.logoUrl, width: 52, height: 52, fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => _logoFallback())
                      : _logoFallback()),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(_vendor.name, style: AppTextStyles.h3),
                  const SizedBox(height: 6),
                  Wrap(spacing: 6, children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _vendor.isOpen ? AppColors.doneBg : AppColors.cancelBg,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: (_vendor.isOpen ? AppColors.doneText : AppColors.cancelText).withOpacity(.3)),
                      ),
                      child: Text(_vendor.isOpen ? 'Open' : 'Closed',
                        style: AppTextStyles.badgeSm.copyWith(color: _vendor.isOpen ? AppColors.doneText : AppColors.cancelText, fontSize: 10)),
                    ),
                    Row(mainAxisSize: MainAxisSize.min, children: [
                      const Icon(Icons.star_rounded, size: 14, color: AppColors.primary),
                      const SizedBox(width: 2),
                      Text(_liveRating.toStringAsFixed(1),
                        style: AppTextStyles.caption2.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
                      if (_liveTotalRatings > 0) ...[
                        const SizedBox(width: 3),
                        Text('(${_liveTotalRatings} review${_liveTotalRatings != 1 ? "s" : ""})',
                          style: AppTextStyles.caption2),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/vendor-reviews',
                              arguments: {'vendor': _vendor}),
                          child: Text('See reviews',
                            style: AppTextStyles.caption2.copyWith(
                              color: AppColors.primary, fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline)),
                        ),
                      ] else ...[
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/vendor-reviews',
                              arguments: {'vendor': _vendor}),
                          child: Text('No reviews yet',
                            style: AppTextStyles.caption2.copyWith(
                              color: AppColors.textLight, fontStyle: FontStyle.italic)),
                        ),
                      ],
                    ]),
                    if (_vendor.distanceKm != null)
                      Text('📍 ${_vendor.distanceLabel}', style: AppTextStyles.caption2),
                  ]),
                  if (_vendor.address.isNotEmpty)
                    Padding(padding: const EdgeInsets.only(top: 4),
                      child: Text(_vendor.address, style: AppTextStyles.caption2, maxLines: 1, overflow: TextOverflow.ellipsis)),
                ])),
              ]),
            ),
          ),
          // Category chips
          if (_prodCats.isNotEmpty)
            SliverToBoxAdapter(
              child: Container(
                color: AppColors.white,
                child: Column(children: [
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: SizedBox(
                      height: 36,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        children: [
                          _filterChip(null, 'All'),
                          ..._prodCats.map((c) => _filterChip(c.id, c.name)),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          // Products
          if (_loading)
            const SliverToBoxAdapter(child: Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator(color: AppColors.primary))))
          else if (_filtered.isEmpty)
            const SliverToBoxAdapter(child: Center(child: Padding(padding: EdgeInsets.all(40), child: Text('No products', style: AppTextStyles.body))))
          else
            SliverList(delegate: SliverChildBuilderDelegate(
              (_, i) {
                final p = _filtered[i];
                return ProductCard(
                  product: p,
                  cartQty: cart.quantityOf(_vendor.id, p.id),
                  onAdd: () => cart.addItem(_vendor.id, _vendor.name, p),
                  onIncrement: () => cart.increment(_vendor.id, p.id),
                  onDecrement: () => cart.decrement(_vendor.id, p.id),
                );
              },
              childCount: _filtered.length,
            )),
          // ── Reviews section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 4),
              child: NKCard(
                margin: EdgeInsets.zero,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('Reviews', style: AppTextStyles.subtitle),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/vendor-reviews',
                          arguments: {'vendor': _vendor}),
                      child: Text('See all', style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary, fontWeight: FontWeight.w700)),
                    ),
                  ]),
                  VendorRatingBar(vendor: _vendor),
                ]),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
      bottomNavigationBar: cart.totalItemCount > 0
          ? Container(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 20),
              color: AppColors.white,
              child: NKButton(
                label: '🛍️ View Cart (${cart.totalItemCount} items)',
                onTap: () => Navigator.pushNamed(context, '/cart'),
              ),
            )
          : null,
    );
  }

  Widget _logoFallback() => Container(width: 52, height: 52, color: AppColors.primary,
    child: Center(child: Text(_vendor.initials, style: AppTextStyles.h3.copyWith(color: AppColors.secondary))));

  Widget _filterChip(int? id, String label) {
    final isSel = _filterCatId == id;
    return GestureDetector(
      onTap: () => setState(() => _filterCatId = id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(right: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSel ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSel ? AppColors.primary : AppColors.border),
          boxShadow: isSel ? [BoxShadow(color: AppColors.primary.withOpacity(.3), blurRadius: 10, offset: const Offset(0, 3))] : null,
        ),
        child: Text(label,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
            color: isSel ? AppColors.white : AppColors.textLight)),
      ),
    );
  }
}

// ── Cart Screen ───────────────────────────────────────────────────────────────
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final vids = cart.carts.keys.toList();

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: const NKAppBar(title: 'My Cart'),
      body: vids.isEmpty
          ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Text('🛍️', style: TextStyle(fontSize: 64)),
              const SizedBox(height: 12),
              Text('Your cart is empty', style: AppTextStyles.h3),
              const SizedBox(height: 6),
              Text('Add items from a vendor', style: AppTextStyles.body.copyWith(color: AppColors.textLight)),
              const SizedBox(height: 24),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 60),
                child: NKButton(label: 'Browse Vendors', onTap: () => Navigator.pop(context))),
            ]))
          : Column(children: [
              Expanded(
                child: ListView.builder(
                  itemCount: vids.length,
                  itemBuilder: (_, vi) {
                    final vid   = vids[vi];
                    final items = cart.itemsFor(vid);
                    final sub   = cart.subtotalFor(vid);
                    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      // Vendor header
                      Container(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                        color: AppColors.chipBg,
                        child: Row(children: [
                          const Icon(Icons.store, size: 16, color: AppColors.secondary),
                          const SizedBox(width: 8),
                          Text(cart.vendorName(vid), style: AppTextStyles.subtitle.copyWith(fontSize: 14)),
                        ]),
                      ),
                      ...items.map((item) => Container(
                        color: AppColors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        child: Row(children: [
                          if (item.imageUrl != null)
                            ClipRRect(borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(imageUrl: item.imageUrl!, width: 44, height: 44, fit: BoxFit.cover,
                                errorWidget: (_, __, ___) => const SizedBox(width: 44, height: 44)))
                          else
                            Container(width: 44, height: 44, decoration: BoxDecoration(color: const Color(0xFFFFF5E6), borderRadius: BorderRadius.circular(10)),
                              child: const Center(child: Text('🍽️'))),
                          const SizedBox(width: 10),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(item.name, style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                            Text(fmtPrice(item.price), style: AppTextStyles.caption2),
                          ])),
                          Row(children: [
                            GestureDetector(onTap: () => cart.decrement(vid, item.productId),
                              child: Container(width: 28, height: 28, decoration: BoxDecoration(color: AppColors.chipBg, borderRadius: BorderRadius.circular(8)),
                                child: const Icon(Icons.remove, size: 16, color: AppColors.text))),
                            Padding(padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text('${item.quantity}', style: AppTextStyles.subtitle)),
                            GestureDetector(onTap: () => cart.increment(vid, item.productId),
                              child: Container(width: 28, height: 28, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
                                child: const Icon(Icons.add, size: 16, color: AppColors.white))),
                          ]),
                        ]),
                      )),
                      Container(color: AppColors.white, padding: const EdgeInsets.fromLTRB(14, 6, 14, 0),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text('Subtotal', style: AppTextStyles.caption),
                          Text(fmtPrice(sub), style: AppTextStyles.price.copyWith(fontSize: 14)),
                        ])),
                      Padding(padding: const EdgeInsets.fromLTRB(14, 10, 14, 16),
                        child: NKButton(
                          label: 'Checkout ${cart.vendorName(vid)}  →',
                          onTap: () => Navigator.pushNamed(context, '/checkout', arguments: {'vendor_id': vid}),
                        )),
                      const Divider(height: 8),
                    ]);
                  },
                ),
              ),
            ]),
    );
  }
}

// ── Checkout Screen ───────────────────────────────────────────────────────────
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});
  @override State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late int _vendorId;
  String _payMethod = 'wallet';
  bool _loading = false;
  final _notes = TextEditingController();
  String _deliveryAddr = '';
  double? _distanceKm;
  CheckoutConfig? _config;

  @override
  void initState() { super.initState(); _loadConfig(); }

  Future<void> _loadConfig() async {
    _config = await getCheckoutConfig();
    if (mounted) setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>? ?? {};
    _vendorId   = args['vendor_id'] ?? 0;
    _distanceKm = (args['distance_km'] as num?)?.toDouble();
    _deliveryAddr = args['delivery_addr'] as String? ?? '';
  }

  Future<void> _place(CartProvider cart) async {
    final vc    = cart.carts[_vendorId];
    if (vc == null) return;
    if (_payMethod == 'wallet') {
      showDialog(context: context,
        builder: (_) => PinDialog(title: 'Confirm Payment', onConfirm: (pin) => _submit(cart, pin)));
    } else {
      // Initiate online payment via API, then open WebView
      setState(() => _loading = true);
      try {
        final cart = context.read<CartProvider>();
        final vc   = cart.carts[_vendorId]!;
        final sub  = cart.subtotalFor(_vendorId);
        final cfg  = _config;
        final dFee = cfg != null ? cfg.deliveryFeeFor(_distanceKm) : 500.0;
        final svc  = cfg != null ? cfg.serviceCharge(sub) : sub * .05;
        final totalAmt = sub + dFee + svc;

        final res = await ApiClient().post('/payments/order', data: {
          'vendor_id':      _vendorId,
          'amount':         totalAmt,
          'gateway':        _payMethod,     // 'paystack' | 'flutterwave'
          'items':          vc['items']?.map((i) => {'product_id': (i as dynamic).productId, 'quantity': i.quantity}).toList(),
          'delivery_address': _deliveryAddr,
        });

        final payUrl = res.data['data']?['authorization_url']
            ?? res.data['data']?['link']
            ?? res.data['authorization_url']
            ?? res.data['link']
            ?? res.data['payment_url'];

        setState(() => _loading = false);

        if (payUrl != null && mounted) {
          final paid = await Navigator.pushNamed(context, '/payment', arguments: {
            'url':   payUrl,
            'title': '${_payMethod == 'paystack' ? 'Paystack' : 'Flutterwave'} Payment',
          });
          if (paid == true && mounted) {
            // Payment confirmed → place order as paid
            await _submit(cart, '');
          }
        }
      } on DioException catch (e) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.response?.data['message'] ?? 'Could not initiate payment'),
          backgroundColor: AppColors.error));
      }
    }
  }

  Future<void> _submit(CartProvider cart, String pin) async {
    setState(() => _loading = true);
    try {
      // Sanitize cart: remove any items not belonging to this vendor
      cart.sanitizeVendorCart(_vendorId);

      final items = cart.itemsFor(_vendorId);
      if (items.isEmpty) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Cart is empty or contains invalid items'),
          backgroundColor: AppColors.error));
        setState(() => _loading = false);
        return;
      }

      // Always recompute totals precisely
      final sub    = cart.subtotalFor(_vendorId);
      final cfg    = _config;
      final dFee   = cfg != null ? cfg.deliveryFeeFor(_distanceKm) : 500.0;
      final svcPct = cfg?.serviceChargePct ?? 5.0;
      final svc    = (sub * svcPct / 100).roundToDouble();
      final total  = sub + dFee + svc;

      await ApiClient().post(ApiEndpoints.orders, data: {
        'vendor_id':      _vendorId,
        'items':          items.map((i) => {
          'product_id': i.productId,
          'quantity':   i.quantity,
        }).toList(),
        'delivery_address':   _deliveryAddr.isNotEmpty ? _deliveryAddr : 'Lagos, Nigeria',
        'payment_method':     pin.isEmpty ? _payMethod : 'wallet',
        if (pin.isNotEmpty) 'pin': pin,
        'distance_km':        _distanceKm ?? 0,
      });

      cart.clearVendor(_vendorId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('🎉 Order placed! Total: \${fmtPrice(total)}'),
        backgroundColor: AppColors.success, duration: const Duration(seconds: 3)));
      Navigator.popUntil(context, (r) => r.isFirst);

    } on DioException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.response?.data['message'] ?? 'Order failed. Please try again.'),
        backgroundColor: AppColors.error));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart  = context.watch<CartProvider>();
    final vc    = cart.carts[_vendorId];
    if (vc == null) { WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.pop(context)); return const SizedBox.shrink(); }
    final items = cart.itemsFor(_vendorId);
    final sub   = cart.subtotalFor(_vendorId);
    final cfg   = _config;
    final dFee   = cfg != null ? cfg.deliveryFeeFor(_distanceKm) : 500.0;
    final svcPct = cfg?.serviceChargePct ?? 5.0;
    final svc    = (sub * svcPct / 100).roundToDouble();
    final total  = sub + dFee + svc;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: NKAppBar(title: 'Checkout — ${vc['name']}'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(children: [
          // Address
          NKCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('DELIVERY ADDRESS', style: AppTextStyles.sectionLabel),
            const SizedBox(height: 10),
            Row(children: [
              const Icon(Icons.place, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(child: Text(_deliveryAddr, style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w600))),
              Text('Change', style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
            ]),
          ])),
          // Summary
          NKCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('ORDER SUMMARY', style: AppTextStyles.sectionLabel),
            const SizedBox(height: 10),
            ...items.map((i) => Padding(padding: const EdgeInsets.only(bottom: 4),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(child: Text('${i.name} × ${i.quantity}', style: AppTextStyles.bodyMd)),
                Text(fmtPrice(i.subtotal), style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w600)),
              ]))),
            const Divider(height: 16),
            _priceRow('Subtotal', sub),
            _priceRow('Delivery Fee', dFee),
            _priceRow('Service Charge (5%)', svc),
            const Divider(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Total', style: AppTextStyles.subtitle),
              Text(fmtPrice(total), style: AppTextStyles.price.copyWith(fontSize: 16)),
            ]),
          ])),
          // Payment
          NKCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('PAYMENT METHOD', style: AppTextStyles.sectionLabel),
            const SizedBox(height: 10),
            ...[
              {'v': 'wallet',      'ic': '💰', 'lb': 'Wallet',      'sb': 'Pay from wallet balance (requires PIN)'},
              {'v': 'paystack',    'ic': '💳', 'lb': 'Paystack',    'sb': 'Card / bank transfer / USSD'},
              {'v': 'flutterwave', 'ic': '💸', 'lb': 'Flutterwave', 'sb': 'Multiple payment options'},
            ].map((p) => GestureDetector(
              onTap: () => setState(() => _payMethod = p['v']!),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.border, width: p['v'] == 'flutterwave' ? 0 : 1))),
                child: Row(children: [
                  Container(width: 34, height: 34, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(9)),
                    child: Center(child: Text(p['ic']!, style: const TextStyle(fontSize: 16)))),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(p['lb']!, style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w600)),
                    Text(p['sb']!, style: AppTextStyles.caption2),
                  ])),
                  // Radio
                  Container(
                    width: 18, height: 18, decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: _payMethod == p['v'] ? AppColors.primary : AppColors.border2, width: 2),
                    ),
                    child: _payMethod == p['v'] ? Center(child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle))) : null,
                  ),
                ]),
              ),
            )),
          ])),
          // Notes
          NKCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('NOTES (OPTIONAL)', style: AppTextStyles.sectionLabel),
            const SizedBox(height: 10),
            TextField(
              controller: _notes, maxLines: 2,
              style: AppTextStyles.body,
              decoration: const InputDecoration(
                hintText: 'Any special instructions?',
                filled: true, fillColor: AppColors.inputBg,
                contentPadding: EdgeInsets.all(12),
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
            ),
          ])),
          const SizedBox(height: 6),
          NKButton(
            label: '🔒  Place Order  —  ${fmtPrice(total)}',
            onTap: () => _place(cart),
            loading: _loading,
          ),
          const SizedBox(height: 20),
        ]),
      ),
    );
  }

  Widget _priceRow(String label, double amount) {
    return Padding(padding: const EdgeInsets.only(bottom: 4),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: AppTextStyles.caption),
        Text(fmtPrice(amount), style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w600, color: AppColors.text)),
      ]));
  }
}

// ── Orders Screen ─────────────────────────────────────────────────────────────
class CustomerOrdersScreen extends StatefulWidget {
  const CustomerOrdersScreen({super.key});
  @override State<CustomerOrdersScreen> createState() => _CustomerOrdersScreenState();
}

class _CustomerOrdersScreenState extends State<CustomerOrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabs;
  List<OrderModel> _orders = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _tabs = TabController(length: 4, vsync: this); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final res = await ApiClient().get(ApiEndpoints.orders);
      setState(() => _orders = (res.data['data'] as List).map((j) => OrderModel.fromJson(j)).toList());
    } catch (_) {}
    setState(() => _loading = false);
  }

  List<OrderModel> _filtered(String f) {
    if (f == 'all') return _orders;
    if (f == 'active') return _orders.where((o) => !['delivered','cancelled'].contains(o.status)).toList();
    return _orders.where((o) => o.status == f).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        title: Text('My Orders', style: AppTextStyles.subtitle.copyWith(color: AppColors.white)),
        actions: [
          IconButton(icon: const Icon(Icons.refresh, color: AppColors.white), onPressed: _load),
        ],
        bottom: TabBar(
          controller: _tabs,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.white,
          unselectedLabelColor: AppColors.white.withOpacity(.6),
          labelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w700),
          tabs: const [Tab(text: 'All'), Tab(text: 'Active'), Tab(text: 'Done'), Tab(text: 'Cancelled')],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : TabBarView(
              controller: _tabs,
              children: ['all','active','delivered','cancelled'].map((f) => RefreshIndicator(
                onRefresh: _load, color: AppColors.primary,
                child: _filtered(f).isEmpty
                    ? const Center(child: Text('No orders here', style: AppTextStyles.body))
                    : ListView.builder(
                        itemCount: _filtered(f).length,
                        itemBuilder: (_, i) {
                          final o = _filtered(f)[i];
                          return NKCard(
                            onTap: () => Navigator.pushNamed(context, '/order-detail', arguments: o),
                            // Show Write Review button for delivered orders
                            trailing: o.status == 'delivered' ? IconButton(
                              icon: const Icon(Icons.star_border, color: AppColors.primary),
                              tooltip: 'Write Review',
                              onPressed: () => Navigator.pushNamed(context, '/write-review', arguments: o),
                            ) : null,
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Text('#${o.reference}', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700, color: AppColors.secondary, letterSpacing: .3)),
                                StatusBadge(status: o.status),
                              ]),
                              const SizedBox(height: 8),
                              Row(children: [const Text('🏪', style: TextStyle(fontSize: 14)), const SizedBox(width: 6),
                                Text(o.vendor['name'] ?? '', style: AppTextStyles.subtitle.copyWith(fontSize: 14))]),
                              const SizedBox(height: 6),
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Text('${o.itemsCount} item${o.itemsCount != 1 ? 's' : ''}', style: AppTextStyles.caption),
                                Text(fmtPrice(o.total), style: AppTextStyles.price),
                              ]),
                              const SizedBox(height: 4),
                              Text(o.date.length > 16 ? o.date.substring(0, 16) : o.date, style: AppTextStyles.caption2),
                              if (o.status == 'delivered')
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: SizedBox(width: double.infinity,
                                    child: OutlinedButton.icon(
                                      icon: const Icon(Icons.star_rounded, size: 15, color: AppColors.primary),
                                      label: const Text('Write Review',
                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(color: AppColors.primary),
                                        padding: const EdgeInsets.symmetric(vertical: 7),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                      onPressed: () => Navigator.pushNamed(context, '/write-review', arguments: o),
                                    )),
                                ),
                            ]),
                          );
                        },
                      ),
              )).toList(),
            ),
    );
  }
}

// ── Wallet Screen ─────────────────────────────────────────────────────────────
class CustomerWalletScreen extends StatefulWidget {
  const CustomerWalletScreen({super.key});
  @override State<CustomerWalletScreen> createState() => _CustomerWalletScreenState();
}

class _CustomerWalletScreenState extends State<CustomerWalletScreen> {
  double _balance = 0;
  List<WalletTransaction> _txns = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final _walletResults = await Future.wait([
        ApiClient().get(ApiEndpoints.walletBalance),
        ApiClient().get(ApiEndpoints.walletTxns),
      ]);
      final bRes = _walletResults[0];
      final tRes = _walletResults[1];
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
            pinned: true, expandedHeight: 170,
            backgroundColor: AppColors.secondary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: AppColors.navyGradient),
                padding: const EdgeInsets.fromLTRB(16, 56, 16, 16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Wallet', style: AppTextStyles.subtitle.copyWith(color: AppColors.white)),
                    const SizedBox(height: 4),
                    Text('Available Balance', style: AppTextStyles.caption.copyWith(color: AppColors.white.withOpacity(.7))),
                    const SizedBox(height: 4),
                    Text(_loading ? '...' : fmtPrice(_balance), style: AppTextStyles.priceLg),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: 140,
                      child: NKButton(label: '+ Fund Wallet', height: 38, onTap: () {}),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: SectionHeader(title: 'Transactions')),
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

// ── Account Screen ────────────────────────────────────────────────────────────
class CustomerAccountScreen extends StatefulWidget {
  const CustomerAccountScreen({super.key});
  @override State<CustomerAccountScreen> createState() => _CustomerAccountScreenState();
}

class _CustomerAccountScreenState extends State<CustomerAccountScreen> {
  UserModel? _user;
  double _walletBal = 0;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    try {
      final _acctResults = await Future.wait([
        ApiClient().get(ApiEndpoints.profile),
        ApiClient().get(ApiEndpoints.walletBalance),
      ]);
      final pRes = _acctResults[0];
      final wRes = _acctResults[1];
      setState(() {
        _user = UserModel.fromJson(pRes.data['user']);
        _walletBal = (wRes.data['balance'] ?? 0).toDouble();
      });
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
                CircleAvatar(radius: 34, backgroundColor: AppColors.secondary,
                  backgroundImage: _user?.avatarUrl.isNotEmpty == true && !(_user!.avatarUrl.contains('ui-avatars'))
                      ? NetworkImage(_user!.avatarUrl) : null,
                  child: _user == null || _user!.avatarUrl.contains('ui-avatars')
                      ? Text(_user?.initials ?? 'U', style: AppTextStyles.h2.copyWith(color: AppColors.white)) : null),
                const SizedBox(height: 10),
                Text(_user?.name ?? '', style: AppTextStyles.subtitle.copyWith(color: AppColors.white)),
                Text(_user?.email ?? '', style: AppTextStyles.caption.copyWith(color: AppColors.white.withOpacity(.85))),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                  decoration: BoxDecoration(color: AppColors.white.withOpacity(.2), borderRadius: BorderRadius.circular(14)),
                  child: Text(fmtPrice(_walletBal), style: AppTextStyles.subtitle.copyWith(color: AppColors.white)),
                ),
              ]),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Column(children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: NKButton(label: '+ Fund Wallet', onTap: () => Navigator.pushNamed(context, '/fund-wallet').then((_) => _load())),
            ),
            const SizedBox(height: 10),
            _menuSection([
              _MI('👤', 'Edit Profile',    () => Navigator.pushNamed(context, '/edit-profile').then((_) => _load())),
              _MI('📍', 'Saved Addresses', () => Navigator.pushNamed(context, '/addresses')),
              _MI('🗺️', 'Change Location', () => Navigator.pushNamed(context, '/location')),
              _MI('🔒', 'Change Password', () => Navigator.pushNamed(context, '/change-password')),
              _MI('🔑', 'Transaction PIN', () => Navigator.pushNamed(context, '/set-pin')),
            ]),
            const SizedBox(height: 10),
            _menuSection([
              _MI('💬', 'Support',         () => Navigator.pushNamed(context, '/support')),
              _MI('🔔', 'Notifications',   () => Navigator.pushNamed(context, '/notifications')),
              _MI('🎁', 'Refer & Earn — Code: \${_user?.referralCode ?? ""}', () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Code: \${_user?.referralCode ?? ""}'),
                  backgroundColor: AppColors.success, duration: const Duration(seconds: 2)));
              }),
            ]),
            const SizedBox(height: 10),
            Container(color: AppColors.white, child: ListTile(
              leading: Container(width: 34, height: 34, decoration: BoxDecoration(color: AppColors.cancelBg, borderRadius: BorderRadius.circular(10)),
                child: const Center(child: Text('🚪', style: TextStyle(fontSize: 16)))),
              title: Text('Logout', style: AppTextStyles.bodyMd.copyWith(color: AppColors.error, fontWeight: FontWeight.w600)),
              trailing: const Icon(Icons.chevron_right, color: AppColors.error),
              onTap: _logout,
            )),
            const SizedBox(height: 30),
          ]),
        ),
      ]),
    );
  }

  Widget _menuSection(List<_MI> items) {
    return Container(
      color: AppColors.white,
      child: Column(children: items.asMap().entries.map((e) {
        final i = e.key; final item = e.value;
        return Column(children: [
          ListTile(
            leading: Container(width: 34, height: 34, decoration: BoxDecoration(color: AppColors.chipBg, borderRadius: BorderRadius.circular(10)),
              child: Center(child: Text(item.icon, style: const TextStyle(fontSize: 14)))),
            title: Text(item.label, style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: const Icon(Icons.chevron_right, color: AppColors.textHint),
            onTap: item.onTap,
          ),
          if (i < items.length - 1) const Divider(height: 1, indent: 62),
        ]);
      }).toList()),
    );
  }
}

class _MI {
  final String icon, label;
  final VoidCallback onTap;
  const _MI(this.icon, this.label, this.onTap);
}

// ── Location Onboarding Screen ────────────────────────────────────────────────
class _LocationOnboardingScreen extends StatefulWidget {
  final Future<void> Function(Map<String,dynamic>) onLocationSet;
  const _LocationOnboardingScreen({required this.onLocationSet});
  @override State<_LocationOnboardingScreen> createState() => _LocationOnboardingScreenState();
}

class _LocationOnboardingScreenState extends State<_LocationOnboardingScreen> {
  bool _loading = false;

  Future<void> _openLocationPicker() async {
    final result = await Navigator.pushNamed(context, '/location');
    if (result is Map<String,dynamic> && result['lat'] != null) {
      setState(() => _loading = true);
      await widget.onLocationSet(result);
      setState(() => _loading = false);
    }
  }

  Future<void> _useGps() async {
    setState(() => _loading = true);
    try {
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) perm = await Geolocator.requestPermission();
      if (perm == LocationPermission.deniedForever) throw Exception('Permission denied forever');
      final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
      // Reverse geocode
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?lat=\${pos.latitude}&lon=\${pos.longitude}&format=json&accept-language=en');
      final res = await http.get(url, headers: {'User-Agent': 'NKsereke/1.0'});
      final data = jsonDecode(res.body);
      final parts = (data['display_name'] as String? ?? '').split(',');
      final addr  = parts.take(4).join(',').trim();
      await widget.onLocationSet({'address': addr, 'lat': pos.latitude, 'lng': pos.longitude});
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString().contains('denied')
          ? 'Location permission denied. Please search manually.'
          : 'GPS error. Please search your address.'),
        backgroundColor: AppColors.error));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(child: Column(children: [
        Container(
          width: double.infinity, padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          color: AppColors.primary,
          child: Column(children: [
            Container(width: 56, height: 56, decoration: BoxDecoration(
                color: AppColors.secondary, borderRadius: BorderRadius.circular(16)),
              child: Center(child: Text('NK', style: AppTextStyles.h2.copyWith(
                  color: AppColors.primary, fontWeight: FontWeight.w900)))),
            const SizedBox(height: 12),
            Text('Set Your Location', style: AppTextStyles.h2.copyWith(color: AppColors.white)),
            const SizedBox(height: 4),
            Text('We need your address to show nearby vendors',
              style: AppTextStyles.caption.copyWith(color: AppColors.white.withOpacity(.85)),
              textAlign: TextAlign.center),
          ]),
        ),
        Expanded(child: _loading
          ? const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              CircularProgressIndicator(color: AppColors.primary),
              SizedBox(height: 16),
              Text('Setting up your location...', style: AppTextStyles.body),
            ]))
          : Padding(
              padding: const EdgeInsets.all(24),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text('📍', style: TextStyle(fontSize: 64)),
                const SizedBox(height: 16),
                Text('Where should we deliver?', style: AppTextStyles.h3, textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text('Your location helps us show vendors within your delivery radius and calculate accurate distances.',
                  style: AppTextStyles.body.copyWith(color: AppColors.textLight), textAlign: TextAlign.center),
                const SizedBox(height: 32),
                NKButton(label: '📍 Use my current GPS location', onTap: _useGps),
                const SizedBox(height: 12),
                NKButton.outline(label: '🔍 Search my address', onTap: _openLocationPicker),
              ]),
            )),
      ])),
    );
  }
}
