// Redesigned: Chewdeck-style Home/Explore Page
import 'package:ctluser/presentation/login_three_screen/models/category_model.dart';
import 'package:ctluser/presentation/login_three_screen/models/model.dart' hide State;
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import 'controller/login_three_controller.dart';
import 'models/login_three_initial_model.dart';
import 'models/login_three_one_item_model.dart';
import 'widgets/login_three_one_item_widget.dart';

// ignore_for_file: must_be_immutable
class LoginThreeInitialPage extends StatefulWidget {
  LoginThreeInitialPage({Key? key}) : super(key: key);

  @override
  State<LoginThreeInitialPage> createState() => _LoginThreeInitialPageState();
}

class _LoginThreeInitialPageState extends State<LoginThreeInitialPage> {
  LoginThreeController controller = Get.put(LoginThreeController());

  @override
  void initState() {
    super.initState();
    controller.fetchNearByVendor();
    controller.fetchCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF1B5E20)))
            : CustomScrollView(
                slivers: [
                  _buildSliverAppBar(),
                  SliverToBoxAdapter(child: _buildFiltersRow()),
                  SliverToBoxAdapter(child: _buildPromoBanner()),
                  SliverToBoxAdapter(child: _buildCategorySection()),
                  SliverToBoxAdapter(child: _buildExploreHeader()),
                  _buildVendorList(),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              ),
      ),
    );
  }

  // ── App Bar ──────────────────────────────────────────────────────────────────

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0.5,
      leadingWidth: 180,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
        child: Row(
          children: [
            const Icon(Icons.location_on, color: Color(0xFF1B5E20), size: 18),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                "CBC Towers, 10/...",
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1B1B1B),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, size: 18, color: Color(0xFF1B1B1B)),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF1B5E20),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: const [
                Icon(Icons.tune, color: Colors.white, size: 16),
                SizedBox(width: 6),
                Text(
                  "Filter",
                  style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Filter chips (Chowpass / Open now / Discounts / Ratings) ────────────────

  Widget _buildFiltersRow() {
    final filters = ["Chowpass", "Open now", "Discounts", "Ratings"];
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: filters.map((f) {
            return Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFDDDDDD)),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                f,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1B1B1B)),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ── Promo banner ─────────────────────────────────────────────────────────────

  Widget _buildPromoBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      height: 90,
      decoration: BoxDecoration(
        color: const Color(0xFFFFC107),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: RichText(
                text: const TextSpan(
                  children: [
                    WidgetSpan(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        child: Text("20% Off", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                      ),
                    ),
                    TextSpan(
                      text: " on Plato's\nShawarma & Hot Grills!",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1B1B1B),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
            child: Container(
              width: 90,
              color: const Color(0xFFFFB300),
              child: const Icon(Icons.fastfood, size: 40, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // ── Category grid ─────────────────────────────────────────────────────────────

  Widget _buildCategorySection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Category", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1B1B1B))),
              Text("See all", style: TextStyle(fontSize: 13, color: Colors.grey[600])),
            ],
          ),
          const SizedBox(height: 14),
          Obx(
            () => controller.isLoading1.value
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF1B5E20)))
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        controller.industryTypeItem?.length ?? 0,
                        (index) {
                          IndustryTypeItem model = controller.industryTypeItem![index];
                          return GestureDetector(
                            onTap: () => controller.fetchVendorByCategory(
                              model.id.toString(),
                              model.name.toString(),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: LoginThreeOneItemWidget(model, index),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // ── Explore header ────────────────────────────────────────────────────────────

  Widget _buildExploreHeader() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        "Explore",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF1B1B1B)),
      ),
    );
  }

  // ── Vendor list ───────────────────────────────────────────────────────────────

  Widget _buildVendorList() {
    return Obx(
      () => SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            Vendor? vendor = controller.vendorData?[index];
            return GestureDetector(
              onTap: () => Get.toNamed(
                AppRoutes.detailRestaurantsVoneScreen,
                arguments: vendor,
              ),
              child: _buildVendorCard(vendor),
            );
          },
          childCount: controller.vendorData?.length ?? 0,
        ),
      ),
    );
  }

  // ── Vendor card (Chewdeck style) ──────────────────────────────────────────────

  Widget _buildVendorCard(Vendor? vendor) {
    final bool isOpen = vendor?.isActive ?? true;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner image
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: CustomImageView(
                  imagePath: vendor?.banner ?? ImageConstant.imgImportImage,
                  height: 160,
                  width: double.maxFinite,
                  fit: BoxFit.cover,
                ),
              ),
              // Favourite icon
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: const Icon(Icons.favorite_border, size: 18, color: Color(0xFF1B1B1B)),
                ),
              ),
              // Status tag if closed
              if (!isOpen)
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Closed",
                      style: TextStyle(fontSize: 11, color: Colors.orange.shade800, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
            ],
          ),
          // Vendor info
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        vendor?.businessName ?? "Vendor",
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1B1B1B)),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Color(0xFFFFC107), size: 14),
                        const SizedBox(width: 3),
                        Text(
                          "4.3",
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1B1B1B)),
                        ),
                        Text(
                          " (516)",
                          style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    // Chowpass icon placeholder
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        "🛵",
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "From ₦2,000",
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 8),
                    Container(width: 3, height: 3, decoration: const BoxDecoration(color: Color(0xFFBBBBBB), shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Text(
                      isOpen ? "Open" : "Unavailable",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isOpen ? const Color(0xFF2E7D32) : Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(width: 3, height: 3, decoration: const BoxDecoration(color: Color(0xFFBBBBBB), shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Text(
                      "${vendor?.distanceKm ?? 0} km",
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
