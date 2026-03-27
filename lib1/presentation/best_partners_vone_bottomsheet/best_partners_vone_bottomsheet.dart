// Redesigned: Chewdeck-style Category Vendors Screen (was BestPartnersVoneBottomsheet)
import 'package:ctluser/presentation/login_three_screen/controller/login_three_controller.dart';
import 'package:ctluser/presentation/login_three_screen/models/model.dart';
import 'package:ctluser/presentation/login_three_screen/models/vendors_by_category.dart';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'controller/best_partners_vone_controller.dart';

// ignore_for_file: must_be_immutable
class BestPartnersVoneBottomsheet extends StatelessWidget {
  BestPartnersVoneBottomsheet(this.controller, this.name, {Key? key})
      : super(key: key);

  BestPartnersVoneController controller;
  String name;
  LoginThreeController controllerx = Get.find<LoginThreeController>();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF5F5F5),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            children: [
              _buildHandle(),
              _buildHeader(context),
              _buildFilterChips(),
              const SizedBox(height: 8),
              _buildAllVendorsLabel(),
              Expanded(
                child: _buildVendorList(scrollController),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHandle() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, color: Color(0xFF1B1B1B), size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1B1B1B),
              ),
            ),
          ),
          // Location chip
          Row(
            children: [
              const Icon(Icons.location_on, color: Color(0xFF1B5E20), size: 14),
              const SizedBox(width: 4),
              Text(
                "CBC Towers, 10/...",
                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              ),
              const Icon(Icons.keyboard_arrow_down, size: 16, color: Color(0xFF1B1B1B)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ["My Favorites", "Deliver Now", "Schedule Only"];
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: filters.map((f) {
            final isFirst = f == filters.first;
            return Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
              decoration: BoxDecoration(
                color: isFirst ? const Color(0xFFE8F5E9) : Colors.white,
                border: Border.all(
                  color: isFirst ? const Color(0xFF1B5E20) : const Color(0xFFDDDDDD),
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                f,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isFirst ? const Color(0xFF1B5E20) : const Color(0xFF1B1B1B),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildAllVendorsLabel() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "All Vendors",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1B1B1B)),
        ),
      ),
    );
  }

  Widget _buildVendorList(ScrollController scrollController) {
    final vendors = controllerx.vendorData ?? [];
    if (vendors.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.storefront_outlined, size: 52, color: Colors.grey[300]),
            const SizedBox(height: 12),
            Text(
              "No vendors available in this category",
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      itemCount: vendors.length,
      itemBuilder: (context, index) {
        final vendor = vendors[index];
        return GestureDetector(
          onTap: () => Get.toNamed(
            AppRoutes.detailRestaurantsVoneScreen,
            arguments: vendor as Vendor,
          ),
          child: _buildVendorCard(vendor),
        );
      },
    );
  }

  Widget _buildVendorCard(Vendor? vendor) {
    final bool isOpen = vendor?.isActive ?? true;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner with favourite + promo badge
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: CustomImageView(
                  imagePath: vendor?.banner ?? ImageConstant.imgImportImage,
                  height: 170,
                  width: double.maxFinite,
                  fit: BoxFit.cover,
                ),
              ),
              // Favourite
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: const Icon(Icons.favorite_border, size: 18, color: Color(0xFF1B1B1B)),
                ),
              ),
              // Promo label if closed/unavailable
              if (!isOpen)
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Text(
                      "Unavailable",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange.shade800,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          // Info row
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
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1B1B1B),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Color(0xFFFFC107), size: 14),
                        const SizedBox(width: 3),
                        const Text("4.3", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        Text(" (516)", style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text("🛵", style: TextStyle(fontSize: 11)),
                    ),
                    const SizedBox(width: 6),
                    Text("From ₦650", style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                    const SizedBox(width: 8),
                    Container(width: 3, height: 3, decoration: const BoxDecoration(color: Color(0xFFBBBBBB), shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Text(
                      isOpen ? "Open" : "Closed",
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
