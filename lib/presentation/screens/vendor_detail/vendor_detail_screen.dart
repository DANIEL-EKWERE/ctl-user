import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/controllers/cart_controller.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/api_client.dart';
import '../../widgets/common/app_widgets.dart';

class VendorDetailScreen extends StatefulWidget {
  const VendorDetailScreen({super.key});
  @override
  State<VendorDetailScreen> createState() => _VendorDetailScreenState();
}

class _VendorDetailScreenState extends State<VendorDetailScreen> with SingleTickerProviderStateMixin {
  late final Map<String, dynamic> vendor;
  List<dynamic> _products = [];
  List<dynamic> _categories = [];
  String _selectedCat = 'All';
  bool _loading = true;
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    vendor = Get.arguments as Map<String, dynamic>? ?? {};
    _tabCtrl = TabController(length: 2, vsync: this);
    _load();
  }

  Future<void> _load() async {
    final id = int.tryParse(vendor['id']?.toString() ?? '0') ?? 0;
    if (id == 0) { if (mounted) setState(() => _loading = false); return; }
    final res = await ApiClient.instance.getVendorProducts(id);
    if (res['success'] == true) {
      final data = res['data'];
      _products = (res['data']?['data'] ?? data['data'] ?? data['products'] ?? []) as List;
      // extract categories
      final catSet = <String>{'All'};
      for (final p in _products) {
        final cat = p['category']?['name']?.toString();
        if (cat != null) catSet.add(cat);
      }
      _categories = catSet.toList();
    }
    if (mounted) setState(() => _loading = false);
  }

  List<dynamic> get _filtered {
    if (_selectedCat == 'All') return _products;
    return _products.where((p) => p['category']?['name'] == _selectedCat).toList();
  }

  @override
  void dispose() { _tabCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final name = vendor['name']?.toString() ?? 'Vendor';
    final banner = vendor['banner']?.toString();
    final logo = vendor['logo']?.toString();
    final rating = double.tryParse(vendor['rating']?.toString() ?? '0') ?? 0;
    final deliveryFee = vendor['delivery_fee']?.toString() ?? '400';
    final prepTime = vendor['preparation_time']?.toString() ?? '25-35';
    final cartCtrl = Get.find<CartController>();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            backgroundColor: AppColors.white,
            expandedHeight: 200,
            pinned: true,
            leading: GestureDetector(
              onTap: Get.back,
              child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)]), child: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.textPrimary)),
            ),
            actions: [
              _iconAction(Icons.share_outlined),
              _iconAction(Icons.favorite_border_rounded),
              _iconAction(Icons.search_outlined),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(children: [
                AppNetworkImage(url: banner, height: 200, width: double.infinity),
                Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.3)]))),
              ]),
            ),
          ),
        ],
        body: Column(children: [
          // Vendor info card
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                AppNetworkImage(url: logo, width: 52, height: 52, borderRadius: BorderRadius.circular(12)),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  if (rating > 0) ...[const SizedBox(height: 2), RatingBadge(rating: rating)],
                ])),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                _InfoChip(Icons.timer_outlined, '$prepTime min', 'Prep time'),
                const SizedBox(width: 16),
                _InfoChip(Icons.delivery_dining_outlined, 'N$deliveryFee', 'Delivery'),
                const SizedBox(width: 16),
                _InfoChip(Icons.flash_on_rounded, 'Instant', 'Delivery Type'),
              ]),
            ]),
          ),
          // Category tabs
          if (_categories.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(children: _categories.map((cat) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: AppTag(
                  label: cat.toString(),
                  selected: _selectedCat == cat,
                  onTap: () => setState(() => _selectedCat = cat.toString()),
                ),
              )).toList()),
            ),
          const Divider(height: 1),
          // Products
          Expanded(child: _loading
            ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
            : _filtered.isEmpty
              ? const EmptyState(icon: Icons.restaurant_menu_outlined, title: 'No items yet')
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _filtered.length,
                  itemBuilder: (_, i) => _ProductTile(
                    product: _filtered[i],
                    vendor: vendor,
                    cartCtrl: cartCtrl,
                  ),
                ),
          ),
        ]),
      ),
      bottomNavigationBar: Obx(() {
        final count = cartCtrl.totalItemCount;
        if (count == 0) return const SizedBox.shrink();
        return SafeArea(child: Padding(
          padding: const EdgeInsets.all(16),
          child: AppButton(
            label: 'View Cart ($count items)',
            onTap: () => Get.toNamed(AppRoutes.cart),
            icon: Icons.shopping_bag_outlined,
          ),
        ));
      }),
    );
  }

  Widget _iconAction(IconData icon) {
    return Container(
      margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(color: AppColors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)]),
      child: Icon(icon, size: 20, color: AppColors.textPrimary),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _InfoChip(this.icon, this.value, this.label);
  @override
  Widget build(BuildContext context) => Column(children: [
    Row(children: [Icon(icon, size: 14, color: AppColors.textSecondary), const SizedBox(width: 4), Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))]),
    Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
  ]);
}

class _ProductTile extends StatelessWidget {
  final dynamic product;
  final dynamic vendor;
  final CartController cartCtrl;
  const _ProductTile({required this.product, required this.vendor, required this.cartCtrl});

  @override
  Widget build(BuildContext context) {
    final name = product['name']?.toString() ?? '';
    final desc = product['description']?.toString() ?? '';
    final price = double.tryParse(product['price']?.toString() ?? '0') ?? 0;
    final image = product['image']?.toString();
    final productId = int.tryParse(product['id']?.toString() ?? '0') ?? 0;
    final vendorId = int.tryParse(vendor['id']?.toString() ?? '0') ?? 0;
    final vendorName = vendor['name']?.toString() ?? '';

    return GestureDetector(
      onTap: () => _showAddToCartSheet(context, name, desc, price, image, productId, vendorId, vendorName),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            if (desc.isNotEmpty) ...[const SizedBox(height: 4), Text(desc, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary), maxLines: 2, overflow: TextOverflow.ellipsis)],
            const SizedBox(height: 8),
            Text('N${price.toStringAsFixed(0)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          ])),
          const SizedBox(width: 12),
          Stack(children: [
            AppNetworkImage(url: image, width: 90, height: 90, borderRadius: BorderRadius.circular(12)),
            Positioned(right: 0, bottom: 0, child: GestureDetector(
              onTap: () => _showAddToCartSheet(context, name, desc, price, image, productId, vendorId, vendorName),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]),
                child: const Icon(Icons.add_rounded, size: 18, color: AppColors.primary),
              ),
            )),
          ]),
        ]),
      ),
    );
  }

  void _showAddToCartSheet(BuildContext ctx, String name, String desc, double price, String? image, int productId, int vendorId, String vendorName) {
    final qty = 1.obs;
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          // product image
          if (image != null && image.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              child: Stack(children: [
                Image.network(image, height: 200, width: double.infinity, fit: BoxFit.cover, errorBuilder: (_,__,___) => const SizedBox.shrink()),
                Positioned(top: 12, right: 12, child: GestureDetector(
                  onTap: Get.back,
                  child: Container(width: 32, height: 32, decoration: const BoxDecoration(color: AppColors.white, shape: BoxShape.circle), child: const Icon(Icons.close, size: 18)),
                )),
              ]),
            )
          else
            Align(alignment: Alignment.centerRight, child: Padding(padding: const EdgeInsets.fromLTRB(0, 12, 16, 0),
              child: GestureDetector(onTap: Get.back, child: Container(width: 32, height: 32, decoration: const BoxDecoration(color: AppColors.grey100, shape: BoxShape.circle), child: const Icon(Icons.close, size: 18))),
            )),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              if (desc.isNotEmpty) ...[const SizedBox(height: 6), Text(desc, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary))],
              const SizedBox(height: 12),
              Text('N${price.toStringAsFixed(0)}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              const SizedBox(height: 20),
              Row(children: [
                // qty stepper
                Container(
                  decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(12)),
                  child: Row(children: [
                    IconButton(icon: const Icon(Icons.remove_rounded, size: 20), onPressed: () { if (qty.value > 1) qty.value--; }),
                    Obx(() => Text('${qty.value}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
                    IconButton(icon: const Icon(Icons.add_rounded, size: 20), onPressed: () => qty.value++),
                  ]),
                ),
                const SizedBox(width: 12),
                Expanded(child: Obx(() => AppButton(
                  label: 'Add  N${(price * qty.value).toStringAsFixed(0)}',
                  onTap: () {
                    cartCtrl.addItem(CartItem(
                      productId: productId, productName: name, price: price,
                      vendorId: vendorId, vendorName: vendorName, imageUrl: image, quantity: qty.value,
                    ));
                    Get.back();
                    Get.snackbar('Added!', '$name added to cart', snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 2));
                  },
                ))),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }
}
