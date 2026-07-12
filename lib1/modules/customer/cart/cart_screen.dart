import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_utils.dart';
import '../../../data/models/models.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/app_widgets.dart';
import 'cart_controller.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = CartController.to;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.navy,
        title: const Text('My Cart', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20), onPressed: Get.back),
        actions: [
          Obx(() => cart.isEmpty ? const SizedBox.shrink()
              : TextButton(
                  onPressed: () => _confirmClear(context, cart),
                  child: const Text('Clear All', style: TextStyle(color: Colors.white70, fontSize: 13)))),
        ],
      ),
      body: Obx(() {
        if (cart.isEmpty) {
          return const EmptyState(
            icon: Icons.shopping_bag_outlined,
            title: 'Your cart is empty',
            subtitle: 'Add items from vendors to get started',
          );
        }
        return ListView(
          padding: const EdgeInsets.all(14),
          children: cart.cart.entries.map((e) => _VendorCartCard(vc: e.value)).toList(),
        );
      }),
    );
  }

  void _confirmClear(BuildContext ctx, CartController cart) {
    showDialog(context: ctx, builder: (_) => AlertDialog(
      title: const Text('Clear cart?', style: TextStyle(fontWeight: FontWeight.w700)),
      content: const Text('All items will be removed.'),
      actions: [
        TextButton(onPressed: Get.back, child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () { cart.clearAll(); Get.back(); },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
          child: const Text('Clear'),
        ),
      ],
    ));
  }
}

class _VendorCartCard extends StatelessWidget {
  final VendorCart vc;
  const _VendorCartCard({required this.vc});

  @override
  Widget build(BuildContext context) {
    final cart = CartController.to;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [const BoxShadow(color: Color(0x0A000000), blurRadius: 4)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Vendor header
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
          child: Row(children: [
            Container(width: 28, height: 28,
              decoration: BoxDecoration(color: AppColors.chipBg, borderRadius: BorderRadius.circular(8)),
              child: const Center(child: Text('🏪', style: TextStyle(fontSize: 14)))),
            const SizedBox(width: 8),
            Expanded(child: Text(vc.vendorName,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.navy),
                overflow: TextOverflow.ellipsis)),
            Text('${vc.totalItems} ${vc.totalItems == 1 ? 'item' : 'items'}',
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ]),
        ),
        const Divider(height: 1),
        // Items
        ...vc.items.map((item) => _ItemRow(item: item, cart: cart)),
        const Divider(height: 1),
        // Subtotal
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Subtotal', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            Text(AppUtils.formatNaira(vc.subtotal),
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.orange)),
          ]),
        ),
        // Checkout button
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
          child: AppButton(
            label: 'Checkout ${vc.vendorName} →',
            height: 46,
            onTap: () => Get.toNamed(AppRoutes.checkout,
                arguments: {'vendorId': vc.vendorId, 'vendorName': vc.vendorName}),
          ),
        ),
        // Clear vendor
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: Center(child: GestureDetector(
            onTap: () => cart.clearVendor(vc.vendorId),
            child: const Text('Clear Selection',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.orange)),
          )),
        ),
      ]),
    );
  }
}

class _ItemRow extends StatelessWidget {
  final CartItem item;
  final CartController cart;
  const _ItemRow({required this.item, required this.cart});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
    child: Row(children: [
      item.imageUrl != null && item.imageUrl!.isNotEmpty
          ? AppNetworkImage(url: item.imageUrl, width: 44, height: 44, borderRadius: BorderRadius.circular(10))
          : Container(width: 44, height: 44,
              decoration: BoxDecoration(color: const Color(0xFFFFF5E6), borderRadius: BorderRadius.circular(10)),
              child: const Center(child: Text('🍽️', style: TextStyle(fontSize: 18)))),
      const SizedBox(width: 10),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(item.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.navy),
            overflow: TextOverflow.ellipsis),
        Text(AppUtils.formatNaira(item.price),
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ])),
      QtyRow(
        qty: item.quantity,
        onDecrement: () => cart.decrement(item.vendorId, item.productId),
        onIncrement: () => cart.increment(item.vendorId, item.productId),
      ),
    ]),
  );
}