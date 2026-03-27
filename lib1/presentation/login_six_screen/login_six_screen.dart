// Redesigned: Chewdeck-style Add to Cart Modal (was LoginSixScreen)
import 'package:ctluser/presentation/add_new_screen/controller/add_new_controller.dart';
import 'package:ctluser/presentation/add_new_screen/models/cartModel.dart';
import 'package:ctluser/presentation/detail_restaurants_vone_screen/models/cat_prod.dart';
import 'package:ctluser/presentation/detail_restaurants_vone_screen/models/model.dart';
import 'package:ctluser/presentation/login_three_screen/models/model.dart' hide State;
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'controller/login_six_controller.dart';

// ignore_for_file: must_be_immutable

LoginSixController controller = Get.put(LoginSixController());
AddNewController addNewController = Get.put(AddNewController());

class LoginSixScreen extends StatefulWidget {
  const LoginSixScreen({Key? key}) : super(key: key);

  @override
  State<LoginSixScreen> createState() => _LoginSixScreenState();
}

class _LoginSixScreenState extends State<LoginSixScreen> {
  CatProductItems productItem = Get.arguments['product'] as CatProductItems;
  Vendor? vendorData = Get.arguments['vendor'] as Vendor?;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Column(
        children: [
          // Dimmed top area — tap to dismiss
          Expanded(
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(color: Colors.transparent),
            ),
          ),
          // Bottom sheet panel
          _buildSheet(context),
        ],
      ),
    );
  }

  Widget _buildSheet(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDragHandle(),
          _buildCloseButton(),
          _buildProductImage(),
          _buildProductInfo(),
          const SizedBox(height: 24),
          _buildQuantityAndCTA(),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }

  // ── Drag handle ───────────────────────────────────────────────────────────────

  Widget _buildDragHandle() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 4),
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  // ── Close (X) button ─────────────────────────────────────────────────────────

  Widget _buildCloseButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Align(
        alignment: Alignment.centerRight,
        child: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Color(0xFFF0F0F0),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.close, size: 18, color: Color(0xFF1B1B1B)),
          ),
        ),
      ),
    );
  }

  // ── Product image (full-width, rounded) ──────────────────────────────────────

  Widget _buildProductImage() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      child: CustomImageView(
        imagePath: productItem.imageUrl ?? ImageConstant.imgPngwing1,
        height: 220,
        width: double.maxFinite,
        fit: BoxFit.cover,
      ),
    );
  }

  // ── Product name, description, price ─────────────────────────────────────────

  Widget _buildProductInfo() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            productItem.product?.name ?? "Product",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1B1B1B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            productItem.product?.description ?? "",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, color: Color(0xFF777777), height: 1.5),
          ),
          const SizedBox(height: 12),
          Obx(
            () {
              final qty = int.tryParse(controller.lblQuantity.value.text) ?? 1;
              final unitPrice = double.tryParse(productItem.finalPrice?.toString() ?? "0") ?? 0;
              final total = (qty * unitPrice).toStringAsFixed(0);
              return Text(
                "₦$total",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1B1B1B),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ── Quantity stepper + Add CTA ────────────────────────────────────────────────

  Widget _buildQuantityAndCTA() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Qty stepper
          Container(
            height: 48,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF1B5E20), width: 1.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // Minus
                GestureDetector(
                  onTap: () {
                    setState(() {});
                    controller.decrementQuantity();
                  },
                  child: Container(
                    width: 44,
                    alignment: Alignment.center,
                    child: const Icon(Icons.remove, size: 18, color: Color(0xFF1B5E20)),
                  ),
                ),
                // Count
                Obx(
                  () => Container(
                    width: 36,
                    alignment: Alignment.center,
                    child: Text(
                      controller.lblQuantity.value.text,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1B1B1B),
                      ),
                    ),
                  ),
                ),
                // Plus
                GestureDetector(
                  onTap: () {
                    setState(() {});
                    controller.incrementQuantity();
                  },
                  child: Container(
                    width: 44,
                    alignment: Alignment.center,
                    child: const Icon(Icons.add, size: 18, color: Color(0xFF1B5E20)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Add to order CTA
          Expanded(
            child: Obx(() {
              final qty = int.tryParse(controller.lblQuantity.value.text) ?? 1;
              final unitPrice = double.tryParse(productItem.finalPrice?.toString() ?? "0") ?? 0;
              final total = (qty * unitPrice).toStringAsFixed(0);
              return GestureDetector(
                onTap: () => _addToCart(qty, unitPrice),
                child: Container(
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B5E20),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "Add ₦$total",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ── Add to cart logic ─────────────────────────────────────────────────────────

  void _addToCart(int qty, double unitPrice) {
    addNewController.cartList.add(
      Cartmodel(
        date: DateTime.now().toString(),
        products: [
          Products(
            productId: productItem.product!.id,
            quantity: qty,
            price: (qty * unitPrice).toInt(),
            vendorId: 59,
            companyId: 3,
          ),
        ],
        packageType: productItem.pack != null ? productItem.pack!.name! : "None",
        vendorId: '59',
        companyId: '3',
        name: productItem.product!.name!,
        price: (qty * unitPrice).toString(),
        quantity: qty.toString(),
        image: productItem.imageUrl!,
        addressId: '1',
        remark: 'No remarks',
        serviceCharge: '0',
        shippingFee: '0',
        vat: '0',
      ),
    );
    Get.toNamed(
      AppRoutes.addNewScreen,
      arguments: {
        'product': productItem,
        'quantity': qty.toString(),
        'finalPrice': qty * unitPrice,
        'vendor': vendorData,
      },
    );
  }
}
