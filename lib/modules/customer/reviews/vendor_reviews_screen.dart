import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/models.dart';
import '../../../routes/app_routes.dart';
import '../home/customer_home_controller.dart';
import 'dart:developer' as myLog;

// ─── Vendor Reviews Screen ────────────────────────────────────────────────────
class VendorReviewsScreen extends StatefulWidget {
  const VendorReviewsScreen({super.key});

  @override
  State<VendorReviewsScreen> createState() => _VendorReviewsScreenState();
}

class _VendorReviewsScreenState extends State<VendorReviewsScreen> {
  late final CustomerHomeController ctrl;
  late final int vendorId;
  late final Vendor vendor;

  @override
  void initState() {
    super.initState();
    ctrl = CustomerHomeController.to;
    vendorId = Get.arguments['id'] as int;
    vendor = Get.arguments['vendor'] as Vendor;
    myLog.log(vendor.name);
    ctrl.loadVendorReviews(vendorId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(left: 32),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => Get.toNamed(
                AppRoutes.writeReview,
                arguments: {'vendorId': vendor.id, 'vendorName': vendor.name},
              ),
              icon: const Icon(Icons.edit_rounded, size: 18),
              label: const Text('Write a Review'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orange,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Reviews'),
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
        if (ctrl.reviewsLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.orange),
          );
        }

        final reviews = ctrl.vendorReviews;
        final stats = ctrl.reviewStats.value;

        if (reviews.isEmpty) {
          return _EmptyReviews(vendorId: vendorId, vendor: vendor);
        }

        return RefreshIndicator(
          color: AppColors.orange,
          onRefresh: () => ctrl.loadVendorReviews(vendorId),
          child: CustomScrollView(
            slivers: [
              if (stats != null)
                SliverToBoxAdapter(child: _ReviewStatsBanner(stats: stats)),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 60),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) =>
                        // i == reviews.length - 1
                        //     ? SizedBox(
                        //         width: double.infinity,
                        //         child: ElevatedButton.icon(
                        //           onPressed: () => Get.toNamed(
                        //             AppRoutes.writeReview,
                        //             arguments: {
                        //               'vendorId': vendor.id,
                        //               'vendorName': vendor.name,
                        //             },
                        //           ),
                        //           icon: const Icon(Icons.edit_rounded, size: 18),
                        //           label: const Text('Write a Review'),
                        //           style: ElevatedButton.styleFrom(
                        //             backgroundColor: AppColors.orange,
                        //             foregroundColor: Colors.white,
                        //             minimumSize: const Size(double.infinity, 50),
                        //             shape: RoundedRectangleBorder(
                        //               borderRadius: BorderRadius.circular(14),
                        //             ),
                        //             textStyle: const TextStyle(
                        //               fontSize: 15,
                        //               fontWeight: FontWeight.w700,
                        //             ),
                        //           ),
                        //         ),
                        //       )
                        //     :
                        _ReviewCard(review: reviews[i]),
                    childCount: reviews.length,
                  ),
                ),
              ),
              // SizedBox(
              //   width: double.infinity,
              //   child: ElevatedButton.icon(
              //     onPressed: () => Get.toNamed(
              //       AppRoutes.writeReview,
              //       arguments: {
              //         'vendorId': vendor.id,
              //         'vendorName': vendor.name,
              //       },
              //     ),
              //     icon: const Icon(Icons.edit_rounded, size: 18),
              //     label: const Text('Write a Review'),
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: AppColors.orange,
              //       foregroundColor: Colors.white,
              //       minimumSize: const Size(double.infinity, 50),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(14),
              //       ),
              //       textStyle: const TextStyle(
              //         fontSize: 15,
              //         fontWeight: FontWeight.w700,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        );
      }),
    );
  }
}

// ─── Empty State ──────────────────────────────────────────────────────────────
class _EmptyReviews extends StatelessWidget {
  final int vendorId;
  final Vendor vendor;

  const _EmptyReviews({required this.vendorId, required this.vendor});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppColors.orange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.star_outline_rounded,
                size: 44,
                color: AppColors.orange,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No Reviews Yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Be the first to share your experience\nwith this vendor.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Get.toNamed(
                  AppRoutes.writeReview,
                  arguments: {'vendorId': vendor.id, 'vendorName': vendor.name},
                ),
                icon: const Icon(Icons.edit_rounded, size: 18),
                label: const Text('Write a Review'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Stats Banner ─────────────────────────────────────────────────────────────
class _ReviewStatsBanner extends StatelessWidget {
  final ReviewStats stats;
  const _ReviewStatsBanner({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Big average
          Column(
            children: [
              Text(
                stats.average.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  color: AppColors.navy,
                  height: 1,
                ),
              ),
              const SizedBox(height: 4),
              _StarRow(rating: stats.average, size: 16),
              const SizedBox(height: 4),
              Text(
                '${stats.total} ratings',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(width: 24),
          // Distribution bars
          Expanded(
            child: Column(
              children: List.generate(5, (i) {
                final star = 5 - i;
                final total = stats.distribution.values.fold(
                  0,
                  (a, b) => a + b,
                );
                final count = stats.distribution[star] ?? 0;
                final pct = total > 0 ? count / total : 0.0;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Text(
                        '$star',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.star_rounded,
                        size: 11,
                        color: AppColors.orange,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: pct,
                            minHeight: 6,
                            backgroundColor: AppColors.bg,
                            valueColor: const AlwaysStoppedAnimation(
                              AppColors.orange,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      SizedBox(
                        width: 22,
                        child: Text(
                          '$count',
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.textLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Review Card ──────────────────────────────────────────────────────────────
class _ReviewCard extends StatelessWidget {
  final Review review;
  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.navy.withOpacity(0.1),
                child: Text(
                  (review.customerName?.isNotEmpty == true)
                      ? review.customerName![0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppColors.navy,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.customerName ?? 'Anonymous',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    // if (review.comment != null)
                    //   Text(
                    //     //_formatDate(review.createdAt!),
                    //     review.comment!,
                    //     style: const TextStyle(
                    //       fontSize: 10,
                    //       color: AppColors.textLight,
                    //     ),
                    //   ),
                    if (review.createdAt != null)
                      Text(
                        _formatDate(review.createdAt!),
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.textLight,
                        ),
                      ),
                  ],
                ),
              ),
              _StarRow(rating: review.rating.toDouble(), size: 13),
            ],
          ),
          if (review.review != null && review.review!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              review.review!,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(String raw) {
    try {
      final dt = DateTime.parse(raw);
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
    } catch (_) {
      return raw;
    }
  }
}

// ─── Star Row ─────────────────────────────────────────────────────────────────
class _StarRow extends StatelessWidget {
  final double rating;
  final double size;
  const _StarRow({required this.rating, required this.size});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final filled = i < rating.floor();
        final half = !filled && (i < rating);
        return Icon(
          filled
              ? Icons.star_rounded
              : half
              ? Icons.star_half_rounded
              : Icons.star_outline_rounded,
          size: size,
          color: AppColors.orange,
        );
      }),
    );
  }
}
