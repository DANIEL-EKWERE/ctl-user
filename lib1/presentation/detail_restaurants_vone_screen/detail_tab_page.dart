// Redesigned: Chewdeck-style Detail Tab Page (product list with category tabs + Add+ button)
import 'package:ctluser/presentation/detail_restaurants_vone_screen/models/cat_prod.dart';
import 'package:ctluser/presentation/detail_restaurants_vone_screen/models/model.dart';
import 'package:ctluser/presentation/detail_restaurants_vone_screen/models/promotionModel.dart';
import 'package:ctluser/presentation/login_three_screen/models/model.dart' hide State;
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import '../../core/app_export.dart';
import 'controller/detail_restaurants_vone_controller.dart';
import 'models/detail_tab_model.dart';
import 'models/listnamemarket_item_model.dart';
import 'models/sectionlisthotc_item_model.dart';
import 'widgets/listnamemarket_item_widget.dart';
import 'widgets/sectionlisthotc_item_widget.dart';

// ignore_for_file: must_be_immutable
class DetailTabPage extends StatefulWidget {
  DetailTabPage(this.vendorData, {Key? key}) : super(key: key);
  Vendor? vendorData;

  @override
  State<DetailTabPage> createState() => _DetailTabPageState();
}

class _DetailTabPageState extends State<DetailTabPage> {
  DetailRestaurantsVoneController controller =
      Get.put(DetailRestaurantsVoneController());

  int _selectedCatIndex = 0;

  @override
  void initState() {
    super.initState();
    controller.fetchCategoriesAndProducts(
      widget.vendorData?.locations?.first.id.toString() ?? "",
      widget.vendorData?.category?.id.toString() ?? "",
    );
    controller.fetchPromotion();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoading.value
          ? const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 60),
                child: CircularProgressIndicator(color: Color(0xFF1B5E20)),
              ),
            )
          : Column(
              children: [
                // Category tab chips (All / Main Menu / Value Munch / Sides…)
                _buildCategoryChips(),
                // Main scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPromoBanner(),
                        _buildPromoStrip(),
                        const SizedBox(height: 8),
                        _buildProductList(),
                        // Bottom padding so FAB doesn't cover last item
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  // ── Category chip tabs ────────────────────────────────────────────────────────

  Widget _buildCategoryChips() {
    return Obx(() {
      final cats = controller.cateProdItem ?? [];
      final labels = ["All", ...cats.map((c) => c.name ?? "").toList()];
      return Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: List.generate(labels.length, (i) {
              final selected = i == _selectedCatIndex;
              return GestureDetector(
                onTap: () => setState(() => _selectedCatIndex = i),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                  decoration: BoxDecoration(
                    color: selected ? const Color(0xFFE8F5E9) : Colors.white,
                    border: Border.all(
                      color: selected ? const Color(0xFF1B5E20) : const Color(0xFFDDDDDD),
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    labels[i],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: selected ? const Color(0xFF1B5E20) : const Color(0xFF1B1B1B),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      );
    });
  }

  // ── Chowpass promo banner ─────────────────────────────────────────────────────

  Widget _buildPromoBanner() {
    return Obx(() {
      if (controller.isLoading1.value || (controller.promotionItem ?? []).isEmpty) {
        return const SizedBox.shrink();
      }
      return Container(
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFEDE7F6),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(color: Color(0xFF6A1B9A), shape: BoxShape.circle),
              child: const Icon(Icons.star_outline, color: Colors.white, size: 14),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Free Delivery for 30 days!",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF4A148C)),
                  ),
                  Text(
                    "Start saving on every order with Chowpass",
                    style: TextStyle(fontSize: 11, color: Color(0xFF6A1B9A)),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF6A1B9A),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "Redeem Now",
                style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      );
    });
  }

  // ── Promotion strip (e.g. "Get Rice & Chicken for just 2k + Free delivery") ──

  Widget _buildPromoStrip() {
    return Obx(() {
      final promos = controller.promotionItem ?? [];
      if (promos.isEmpty) return const SizedBox.shrink();
      return Container(
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFE3F2FD),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF1565C0),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.bolt, color: Colors.white, size: 14),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                promos.first.title ?? "Special offer available!",
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0D47A1),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  // ── Product list (grouped by category) ───────────────────────────────────────

  Widget _buildProductList() {
    return Obx(() {
      final allItems = controller.cateProdItem ?? [];
      if (allItems.isEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Center(
            child: Column(
              children: [
                Icon(Icons.restaurant_menu, size: 48, color: Colors.grey[300]),
                const SizedBox(height: 12),
                Text(
                  "No products available",
                  style: TextStyle(color: Colors.grey[500], fontSize: 14),
                ),
              ],
            ),
          ),
        );
      }

      // Filter by selected category
      final filtered = _selectedCatIndex == 0
          ? allItems
          : [allItems[_selectedCatIndex - 1]];

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: filtered.map((cat) {
          final products = cat.products ?? [];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category group header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
                child: Text(
                  cat.name ?? "",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1B1B1B),
                  ),
                ),
              ),
              // Products
              ...products.map((product) => GestureDetector(
                    onTap: () => Get.toNamed(
                      AppRoutes.loginSixScreen,
                      arguments: {'product': product, 'vendor': widget.vendorData},
                    ),
                    child: _buildProductRow(product),
                  )),
            ],
          );
        }).toList(),
      );
    });
  }

  // ── Single product row (Chewdeck style) ──────────────────────────────────────

  Widget _buildProductRow(CatProductItems product) {
    final hasOriginalPrice = product.price != null &&
        product.finalPrice != null &&
        product.price.toString() != product.finalPrice.toString();

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 1),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.product?.name ?? "Product",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1B1B1B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.product?.description ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF777777)),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (hasOriginalPrice)
                        Text(
                          "From ₦${product.price}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFFAAAAAA),
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      if (hasOriginalPrice) const SizedBox(width: 6),
                      Text(
                        "From ₦${product.finalPrice}",
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1B1B1B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Product image + Add button
          Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CustomImageView(
                      imagePath: product.imageUrl ?? ImageConstant.imgImportImage80x80,
                      height: 90,
                      width: 90,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Gift/promo icon on image
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(Icons.card_giftcard_outlined, size: 12, color: Color(0xFF555555)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              // Add + button
              Container(
                width: 90,
                padding: const EdgeInsets.symmetric(vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFA5D6A7)),
                ),
                child: const Center(
                  child: Text(
                    "Add +",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1B5E20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
