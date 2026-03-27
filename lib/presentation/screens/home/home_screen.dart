import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/controllers/cart_controller.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/api_client.dart';
import '../../../utils/storage_service.dart';
import '../../widgets/common/app_widgets.dart';
import '../cart/cart_screen.dart';
import '../orders/orders_screen.dart';
import '../profile/profile_screen.dart';
import '../search/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final _pages = [
    const _HomeTab(),
    const SearchScreen(),
    const CartScreen(),
    const Scaffold(body: Center(child: Text('Support'))),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final cartCtrl = Get.find<CartController>();
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  const Icon(Icons.shopping_bag_outlined),
                  if (cartCtrl.totalItemCount > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${cartCtrl.totalItemCount}',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              activeIcon: const Icon(Icons.shopping_bag_rounded),
              label: 'Orders',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              label: 'Support',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Home Tab ────────────────────────────────────────────────────────────────

class _HomeTab extends StatefulWidget {
  const _HomeTab();
  @override
  State<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<_HomeTab> {
  String _address = 'Your location';
  List<dynamic> _categories = [];
  List<dynamic> _vendors = [];
  bool _loading = true;

  final _categories_static = [
    {'name': 'Restaurants', 'icon': Icons.restaurant, 'color': 0xFFFFF3E0},
    {'name': 'Shops', 'icon': Icons.store, 'color': 0xFFE8F5E9},
    {'name': 'Pharmacies', 'icon': Icons.local_pharmacy, 'color': 0xFFE3F2FD},
    {'name': 'Bills', 'icon': Icons.receipt_long, 'color': 0xFFF3E5F5},
    {'name': 'Packages', 'icon': Icons.inventory_2, 'color': 0xFFFFEBEE},
    {'name': 'Markets', 'icon': Icons.shopping_cart, 'color': 0xFFE0F2F1},
    {'name': 'Events', 'icon': Icons.event, 'color': 0xFFFCE4EC},
    {'name': 'More', 'icon': Icons.more_horiz, 'color': 0xFFF5F5F5},
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    _address = await StorageService.instance.getAddress();
    if (_address.isEmpty) _address = 'Set your location';
    final vRes = await ApiClient.instance.getVendors();
    if (vRes['success'] == true) {
      final data = vRes['data'];
      _vendors = (vRes['data']['data'] as List?) ?? [];
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: _load,
        child: CustomScrollView(
          slivers: [
            // ── AppBar ──────────────────────────────────────────────────────
            SliverAppBar(
              backgroundColor: AppColors.white,
              floating: true,
              pinned: false,
              elevation: 0,
              titleSpacing: 0,
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on_rounded,
                              color: AppColors.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                _address.isNotEmpty
                                    ? _address
                                    : 'Set your location',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 20,
                              color: AppColors.textSecondary,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _FilterButton(),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Column(
                children: [
                  // ── Filter Tags ────────────────────────────────────────────────
                  _buildFilterTags(),

                  // ── Promo Banner ───────────────────────────────────────────────
                  _buildPromoBanner(),

                  // ── Categories Grid ────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: GridView.count(
                      crossAxisCount: 4,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 8,
                      childAspectRatio: 0.85,
                      children: _categories_static
                          .map(
                            (c) => _CategoryTile(
                              name: c['name'] as String,
                              icon: c['icon'] as IconData,
                              color: Color(c['color'] as int),
                              onTap: () => Get.toNamed(
                                AppRoutes.search,
                                arguments: {'category': c['name']},
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),

                  // ── Promo Card ─────────────────────────────────────────────────
                  _buildPromoCard(),

                  // ── Explore Section ────────────────────────────────────────────
                  if (_loading)
                    _buildShimmerRow()
                  else ...[
                    if (_vendors!.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                        child: SectionHeader(
                          title: 'Explore',
                          action: 'See all',
                          onAction: () => Get.toNamed(AppRoutes.search),
                        ),
                      ),
                      SizedBox(
                        height: 130,
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          scrollDirection: Axis.horizontal,
                          itemCount: _vendors!.length > 10
                              ? 10
                              : _vendors!.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 16),
                          itemBuilder: (_, i) =>
                              _ExploreVendorChip(vendor: _vendors![i]),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ],

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTags() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          for (final tag in [
            'Chowpass',
            'Open now',
            'Discounts',
            'Ratings',
            'Fast delivery',
          ])
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: AppTag(label: tag),
            ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        width: double.infinity,
        height: 110,
        decoration: BoxDecoration(
          color: const Color(0xFFFF8C00),
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFFFF8C00), Color(0xFFFFB74D)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: 12,
              top: 0,
              bottom: 0,
              child: Opacity(
                opacity: 0.2,
                child: Icon(
                  Icons.local_fire_department_rounded,
                  size: 80,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '20% Off',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFFF8C00),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Best deals on food\nnear you!',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
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

  Widget _buildPromoCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.purpleLight,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Get Free Delivery for 30 days!',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.purple,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Subscribe to premium',
                    style: TextStyle(fontSize: 12, color: AppColors.purple),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              //padding: const EdgeInsets.all(16),
              width: 200,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.purple,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                child: const Text(
                  'Redeem',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerRow() {
    return SizedBox(
      height: 130,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (_, __) => Column(
          children: [
            ShimmerBox(width: 70, height: 70, radius: 35),
            const SizedBox(height: 8),
            ShimmerBox(width: 60, height: 12),
            const SizedBox(height: 4),
            ShimmerBox(width: 50, height: 10),
          ],
        ),
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          children: [
            Text(
              'Filter',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
            SizedBox(width: 6),
            Icon(Icons.tune_rounded, color: AppColors.white, size: 16),
          ],
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _CategoryTile({
    required this.name,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, size: 28, color: AppColors.primary),
          ),
          const SizedBox(height: 6),
          Text(
            name,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _ExploreVendorChip extends StatelessWidget {
  final dynamic vendor;
  const _ExploreVendorChip({required this.vendor});

  @override
  Widget build(BuildContext context) {
    final name = vendor['business_name']?.toString() ?? 'Vendor';
    final logo = vendor['logo']?.toString();
    final rating = double.tryParse(vendor['rating']?.toString() ?? '0') ?? 0;
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.vendorDetail, arguments: vendor),
      child: SizedBox(
        width: 80,
        child: Column(
          children: [
            AppNetworkImage(
              url: logo,
              width: 70,
              height: 70,
              borderRadius: BorderRadius.circular(35),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            if (rating > 0) RatingBadge(rating: rating),
          ],
        ),
      ),
    );
  }
}
