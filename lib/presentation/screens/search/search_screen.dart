import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/api_client.dart';
import '../../widgets/common/app_widgets.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchCtrl = TextEditingController();
  List<dynamic> _vendors = [];
  bool _loading = false;
  bool _searched = false;
  String _selectedCat = 'All';

  final _categories = [
    'All',
    'Restaurants',
    'Shops',
    'Pharmacies',
    'Markets',
    'Events',
  ];

  @override
  void initState() {
    super.initState();
    // If launched with category arg
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args['category'] != null) {
      _selectedCat = args['category'] as String;
      _search(_selectedCat == 'All' ? '' : _selectedCat);
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _search(String q) async {
    setState(() {
      _loading = true;
      _searched = true;
    });
    final res = await ApiClient.instance.getVendors(
      search: q.isEmpty ? null : q,
      category: _selectedCat == 'All' ? null : _selectedCat,
    );
    if (res['success'] == true) {
      final d = res['data'] as Map<String, dynamic>;
      final inner = (d['data'] ?? d) as Map<String, dynamic>;
      _vendors = (inner['vendors'] ?? inner['data'] ?? []) as List;
    } else {
      _vendors = [];
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 16,
        title: Container(
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.grey50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: TextField(
            controller: _searchCtrl,
            onSubmitted: _search,
            textAlignVertical: TextAlignVertical.center,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Search restaurants, dishes...',
              hintStyle: const TextStyle(
                  fontSize: 14, color: AppColors.textHint),
              prefixIcon: const Icon(Icons.search_outlined,
                  color: AppColors.grey400, size: 20),
              suffixIcon: _searchCtrl.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close_rounded,
                          size: 18, color: AppColors.grey400),
                      onPressed: () {
                        _searchCtrl.clear();
                        setState(() {
                          _vendors = [];
                          _searched = false;
                        });
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10),
              isDense: true,
            ),
            onChanged: (v) => setState(() {}),
          ),
        ),
      ),
      body: Column(children: [
        // Category filter chips
        SizedBox(
          height: 48,
          child: ListView.separated(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final cat = _categories[i];
              return AppTag(
                label: cat,
                selected: _selectedCat == cat,
                onTap: () {
                  setState(() => _selectedCat = cat);
                  _search(_searchCtrl.text);
                },
              );
            },
          ),
        ),

        // Results
        Expanded(
          child: _loading
              ? const Center(
                  child: CircularProgressIndicator(
                      color: AppColors.primary))
              : !_searched
                  ? _buildSuggestions()
                  : _vendors.isEmpty
                      ? const EmptyState(
                          icon: Icons.search_off_outlined,
                          title: 'No results found',
                          subtitle:
                              'Try a different search term or category')
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _vendors.length,
                          itemBuilder: (_, i) =>
                              _VendorCard(vendor: _vendors[i]),
                        ),
        ),
      ]),
    );
  }

  Widget _buildSuggestions() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Popular Categories',
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.4,
            children: [
              _CatCard('Restaurants', Icons.restaurant_rounded,
                  const Color(0xFFFFF3E0)),
              _CatCard(
                  'Shops', Icons.store_rounded, const Color(0xFFE8F5E9)),
              _CatCard('Pharmacies', Icons.local_pharmacy_rounded,
                  const Color(0xFFE3F2FD)),
              _CatCard('Markets', Icons.shopping_basket_rounded,
                  const Color(0xFFF3E5F5)),
              _CatCard('Events', Icons.event_rounded,
                  const Color(0xFFFCE4EC)),
              _CatCard(
                  'More', Icons.more_horiz_rounded, AppColors.grey100),
            ],
          ),
        ],
      ),
    );
  }
}

class _CatCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  const _CatCard(this.label, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.search,
          arguments: {'category': label}),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(width: 10),
          Text(label,
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }
}

class _VendorCard extends StatelessWidget {
  final dynamic vendor;
  const _VendorCard({required this.vendor});

  @override
  Widget build(BuildContext context) {
    final name = vendor['name']?.toString() ?? '';
    final banner = vendor['banner']?.toString();
    final logo = vendor['logo']?.toString();
    final rating =
        double.tryParse(vendor['rating']?.toString() ?? '0') ?? 0;
    final ratingCount =
        int.tryParse(vendor['rating_count']?.toString() ?? '0') ?? 0;
    final deliveryFee =
        vendor['delivery_fee']?.toString() ?? '400';
    final isOpen = vendor['is_open'] as bool? ?? true;
    final prepTime = vendor['preparation_time']?.toString() ?? '30';

    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.vendorDetail, arguments: vendor),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner
            Stack(children: [
              AppNetworkImage(
                url: banner,
                height: 130,
                width: double.infinity,
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16)),
              ),
              if (!isOpen)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16)),
                    ),
                    child: const Center(
                      child: Text('Closed',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16)),
                    ),
                  ),
                ),
              if (isOpen)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('Open',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
            ]),

            // Details
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(children: [
                AppNetworkImage(
                  url: logo,
                  width: 48,
                  height: 48,
                  borderRadius: BorderRadius.circular(24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name,
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        Row(children: [
                          if (rating > 0) ...[
                            RatingBadge(
                                rating: rating, count: ratingCount),
                            const SizedBox(width: 12),
                          ],
                          const Icon(Icons.timer_outlined,
                              size: 13,
                              color: AppColors.textSecondary),
                          const SizedBox(width: 3),
                          Text('$prepTime min',
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary)),
                          const SizedBox(width: 12),
                          const Icon(Icons.delivery_dining_outlined,
                              size: 13,
                              color: AppColors.textSecondary),
                          const SizedBox(width: 3),
                          Text('N$deliveryFee',
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary)),
                        ]),
                      ]),
                ),
                const Icon(Icons.favorite_border_rounded,
                    color: AppColors.grey400, size: 20),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
