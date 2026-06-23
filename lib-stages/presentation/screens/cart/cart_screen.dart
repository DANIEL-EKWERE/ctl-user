import '../../widgets/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/controllers/cart_controller.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/app_theme.dart';
import '../../widgets/common/app_widgets.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartCtrl = Get.find<CartController>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Orders'),
        automaticallyImplyLeading: false,
        actions: [
          Obx(
            () => cartCtrl.items.isEmpty
                ? const SizedBox.shrink()
                : TextButton(
                    onPressed: () => _confirmClear(context, cartCtrl),
                    child: const Text(
                      'Clear Cart',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ),
          ),
        ],
      ),
      body: Obx(() {
        if (cartCtrl.items.isEmpty) {
          return const EmptyState(
            icon: Icons.shopping_bag_outlined,
            title: 'Your cart is empty',
            subtitle: 'Add items from vendors to get started',
            actionLabel: 'Explore vendors',
          );
        }
        final grouped = cartCtrl.groupedByVendor;
        return Column(
          children: [
            // Tabs
            Container(
              color: AppColors.white,
              child: Row(
                children: [
                  _Tab(
                    label: 'My Cart',
                    selected: true,
                    count: cartCtrl.totalItemCount,
                  ),
                  const _Tab(label: 'Ongoing'),
                  const _Tab(label: 'Completed'),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: grouped.keys.length,
                itemBuilder: (_, i) {
                  final vendorId = grouped.keys.elementAt(i);
                  final items = grouped[vendorId]!;
                  return _VendorCartCard(
                    vendorId: vendorId,
                    items: items,
                    cartCtrl: cartCtrl,
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  void _confirmClear(BuildContext ctx, CartController cartCtrl) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: const Text(
          'Clear cart?',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content: const Text('All items will be removed.'),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              cartCtrl.clearAll();
              Get.back();
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool selected;
  final int? count;
  const _Tab({required this.label, this.selected = false, this.count});
  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: selected ? AppColors.textPrimary : AppColors.white,
        border: Border(
          bottom: BorderSide(
            color: selected ? AppColors.textPrimary : AppColors.border,
            width: 2,
          ),
        ),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: selected ? AppColors.white : AppColors.textSecondary,
          ),
        ),
      ),
    ),
  );
}

class _VendorCartCard extends StatefulWidget {
  final int vendorId;
  final List<CartItem> items;
  final CartController cartCtrl;
  const _VendorCartCard({
    required this.vendorId,
    required this.items,
    required this.cartCtrl,
  });
  @override
  State<_VendorCartCard> createState() => _VendorCartCardState();
}

class _VendorCartCardState extends State<_VendorCartCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final vendorName = widget.items.first.vendorName;
    final subtotal = widget.cartCtrl.subtotalForVendor(widget.vendorId);
    final totalItems = widget.items.fold(0, (s, i) => s + i.quantity);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CustomImageView(
                  imagePath: widget.items.first.imageUrl,
                  width: 48,
                  height: 48,
                  radius: BorderRadius.circular(24),
                ), //borderRadius: BorderRadius.circular(24)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vendorName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '$totalItems ${totalItems == 1 ? 'Item' : 'Items'} • N${subtotal.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _expanded = !_expanded),
                  child: Row(
                    children: [
                      Text(
                        _expanded ? 'Hide' : 'View',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Icon(
                        _expanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        size: 18,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: widget.items
                    .map(
                      (item) =>
                          _CartItemRow(item: item, cartCtrl: widget.cartCtrl),
                    )
                    .toList(),
              ),
            ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Icon(
                  Icons.delivery_dining_outlined,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 6),
                const Expanded(
                  child: Text(
                    'Delivering to Lagos',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: AppButton(
              label: 'Checkout',
              height: 46,
              onTap: () => Get.toNamed(
                AppRoutes.checkout,
                arguments: {
                  'vendorId': widget.vendorId,
                  'vendorName': vendorName,
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Center(
              child: GestureDetector(
                onTap: () => widget.cartCtrl.clearVendorCart(widget.vendorId),
                child: const Text(
                  'Clear Selection',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartItemRow extends StatelessWidget {
  final CartItem item;
  final CartController cartCtrl;
  const _CartItemRow({required this.item, required this.cartCtrl});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.productName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'N${item.price.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () => cartCtrl.decrement(item.productId, item.vendorId),
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.remove_rounded, size: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                '${item.quantity}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => cartCtrl.increment(item.productId, item.vendorId),
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.add_rounded,
                  size: 14,
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
