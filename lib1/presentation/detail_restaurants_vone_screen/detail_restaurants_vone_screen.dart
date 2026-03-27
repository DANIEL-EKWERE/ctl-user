// Redesigned: Chewdeck-style Vendor Detail Screen
import 'package:ctluser/presentation/detail_restaurants_review_vone_screen/controller/detail_restaurants_review_vone_controller.dart';
import 'package:ctluser/presentation/detail_restaurants_review_vone_screen/models/listtoday16fort_item_model.dart';
import 'package:ctluser/presentation/detail_restaurants_review_vone_screen/widgets/listtoday16fort_item_widget.dart';
import 'package:ctluser/presentation/login_three_screen/models/model.dart' hide State;
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'controller/detail_restaurants_vone_controller.dart';
import 'detail_tab_page.dart';

// ignore_for_file: must_be_immutable

DetailRestaurantsReviewVoneController controller1 =
    Get.put(DetailRestaurantsReviewVoneController());
DetailRestaurantsVoneController controller =
    Get.put(DetailRestaurantsVoneController());

class DetailRestaurantsVoneScreen extends StatefulWidget {
  const DetailRestaurantsVoneScreen({Key? key}) : super(key: key);

  @override
  State<DetailRestaurantsVoneScreen> createState() =>
      _DetailRestaurantsVoneScreenState();
}

class _DetailRestaurantsVoneScreenState
    extends State<DetailRestaurantsVoneScreen> {
  Vendor? vendorData = Get.arguments as Vendor?;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SizedBox(
          width: double.maxFinite,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              _buildSliverHeader(),
            ],
            body: Column(
              children: [
                _buildInfoCard(),
                _buildTabBar(),
                Expanded(
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: controller.tabviewController,
                    children: [
                      DetailTabPage(vendorData),
                      _buildReviewsTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Sliver header (banner image + top nav) ───────────────────────────────────

  Widget _buildSliverHeader() {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: false,
      backgroundColor: Colors.white,
      leading: GestureDetector(
        onTap: () => Get.back(),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: const Icon(Icons.arrow_back, color: Color(0xFF1B1B1B), size: 20),
        ),
      ),
      actions: [
        _iconCircle(Icons.share_outlined),
        _iconCircle(Icons.favorite_border),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: _iconCircle(Icons.search),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: CustomImageView(
          imagePath: vendorData?.banner ?? ImageConstant.imgImportImage168x374,
          height: 200,
          width: double.maxFinite,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _iconCircle(IconData icon) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 8, right: 4),
      padding: const EdgeInsets.all(7),
      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      child: Icon(icon, size: 18, color: const Color(0xFF1B1B1B)),
    );
  }

  // ── Info card (name, open status, stats, promo) ──────────────────────────────

  Widget _buildInfoCard() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name + take-away tag
          Row(
            children: [
              Expanded(
                child: Text(
                  vendorData?.businessName ?? "Vendor",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1B1B1B),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  "Take Away",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFD32F2F),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Open status + address
          Row(
            children: [
              const Text(
                "Open",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(width: 6),
              Container(width: 3, height: 3, decoration: const BoxDecoration(color: Color(0xFFBBBBBB), shape: BoxShape.circle)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  vendorData?.locations?.first.contactAddress ?? "Address unavailable",
                  style: const TextStyle(fontSize: 12, color: Color(0xFF777777)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 12),

          // Stats row: rating · prep time · delivery fee · delivery type
          Row(
            children: [
              // Rating chip
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B5E20),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.star, color: Colors.white, size: 12),
                    SizedBox(width: 3),
                    Text("4.5", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(width: 3, height: 3, decoration: const BoxDecoration(color: Color(0xFFBBBBBB), shape: BoxShape.circle)),
              const SizedBox(width: 10),
              const Icon(Icons.access_time, size: 16, color: Color(0xFF555555)),
              const SizedBox(width: 4),
              const Text("25 - 35 min", style: TextStyle(fontSize: 12, color: Color(0xFF555555))),
              const SizedBox(width: 10),
              Container(width: 3, height: 3, decoration: const BoxDecoration(color: Color(0xFFBBBBBB), shape: BoxShape.circle)),
              const SizedBox(width: 10),
              const Icon(Icons.local_shipping_outlined, size: 16, color: Color(0xFF555555)),
              const SizedBox(width: 4),
              const Text("₦400", style: TextStyle(fontSize: 12, color: Color(0xFF555555))),
              const Spacer(),
              Text(
                "Instant & Schedule",
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Chowpass promo banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFEDE7F6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Color(0xFF6A1B9A),
                    shape: BoxShape.circle,
                  ),
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
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  // ── Tab bar ──────────────────────────────────────────────────────────────────

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: controller.tabviewController,
        labelPadding: const EdgeInsets.symmetric(horizontal: 16),
        labelColor: const Color(0xFF1B5E20),
        labelStyle: const TextStyle(
          fontSize: 13,
          fontFamily: 'DM Sans',
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelColor: const Color(0xFF777777),
        unselectedLabelStyle: const TextStyle(
          fontSize: 13,
          fontFamily: 'DM Sans',
          fontWeight: FontWeight.w500,
        ),
        indicatorColor: const Color(0xFF1B5E20),
        indicatorWeight: 2.5,
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: const [
          Tab(text: "Delivery"),
          Tab(text: "Reviews"),
        ],
      ),
    );
  }

  // ── Reviews tab ──────────────────────────────────────────────────────────────

  Widget _buildReviewsTab() {
    return Obx(
      () => ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
        physics: const BouncingScrollPhysics(),
        separatorBuilder: (context, index) => const Divider(height: 24, color: Color(0xFFEEEEEE)),
        itemCount: controller1
            .detailRestaurantsReviewVoneModelObj
            .value
            .listtoday16fortItemList
            .value
            .length,
        itemBuilder: (context, index) {
          Listtoday16fortItemModel model = controller1
              .detailRestaurantsReviewVoneModelObj
              .value
              .listtoday16fortItemList
              .value[index];
          return Listtoday16fortItemWidget(model);
        },
      ),
    );
  }
}
