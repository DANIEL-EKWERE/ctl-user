import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_theme.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final order = Get.arguments as Map<String, dynamic>? ?? {};
    final id = order['id']?.toString() ?? '';
    final status = order['status']?.toString() ?? 'pending';
    final vendorName = order['vendor']?['name']?.toString() ?? 'Vendor';
    final riderName = order['rider']?['name']?.toString();

    final steps = [
      _TrackStep('Order Placed', Icons.check_circle_outline_rounded,
          'Your order has been received'),
      _TrackStep('Accepted', Icons.restaurant_outlined,
          'Restaurant confirmed your order'),
      _TrackStep('Preparing', Icons.outdoor_grill_outlined,
          'Your food is being prepared'),
      _TrackStep('Picked Up', Icons.delivery_dining_outlined,
          'Rider is on the way'),
      _TrackStep('Delivered', Icons.home_rounded, 'Enjoy your meal!'),
    ];
    final statusIndex = {
      'pending': 0,
      'accepted': 1,
      'processing': 2,
      'assigned': 3,
      'delivered': 4,
      'completed': 4,
    }[status] ?? 0;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(title: Text('Order #$id')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          // Status hero card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(steps[statusIndex].icon,
                    color: AppColors.white, size: 32),
              ),
              const SizedBox(height: 14),
              Text(
                _statusLabel(status),
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.white),
              ),
              const SizedBox(height: 4),
              Text(
                steps[statusIndex].subtitle,
                style: const TextStyle(
                    fontSize: 13, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ]),
          ),

          const SizedBox(height: 28),

          // Vendor info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.grey50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(children: [
              const Icon(Icons.store_outlined,
                  color: AppColors.primary, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('From',
                          style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary)),
                      Text(vendorName,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600)),
                    ]),
              ),
              if (riderName != null) ...[
                const VerticalDivider(width: 24),
                const Icon(Icons.delivery_dining_outlined,
                    color: AppColors.primary, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Rider',
                            style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary)),
                        Text(riderName,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600)),
                      ]),
                ),
              ],
            ]),
          ),

          const SizedBox(height: 28),

          // Timeline
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('Order Progress',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(height: 16),
          ...List.generate(steps.length, (i) {
            final done = i <= statusIndex;
            final active = i == statusIndex;
            final isLast = i == steps.length - 1;
            return _TimelineRow(
              step: steps[i],
              done: done,
              active: active,
              isLast: isLast,
            );
          }),
        ]),
      ),
    );
  }

  String _statusLabel(String s) {
    const map = {
      'pending': 'Order Placed',
      'accepted': 'Order Accepted',
      'processing': 'Preparing Your Food',
      'assigned': 'Rider On The Way',
      'delivered': 'Delivered!',
      'completed': 'Completed',
      'cancelled': 'Cancelled',
    };
    return map[s] ?? s[0].toUpperCase() + s.substring(1);
  }
}

class _TrackStep {
  final String title;
  final IconData icon;
  final String subtitle;
  const _TrackStep(this.title, this.icon, this.subtitle);
}

class _TimelineRow extends StatelessWidget {
  final _TrackStep step;
  final bool done;
  final bool active;
  final bool isLast;
  const _TimelineRow(
      {required this.step,
      required this.done,
      required this.active,
      required this.isLast});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: done ? AppColors.primary : AppColors.grey200,
                shape: BoxShape.circle,
                border: active
                    ? Border.all(color: AppColors.primary, width: 3)
                    : null,
              ),
              child: done
                  ? const Icon(Icons.check_rounded,
                      color: Colors.white, size: 16)
                  : null,
            ),
            if (!isLast)
              Expanded(
                child: Container(
                    width: 2,
                    color: done
                        ? AppColors.primary
                        : AppColors.grey200),
              ),
          ]),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20, top: 4),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(step.title,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: active
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: done
                                ? AppColors.textPrimary
                                : AppColors.textSecondary)),
                    if (active) ...[
                      const SizedBox(height: 2),
                      Text(step.subtitle,
                          style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary)),
                    ],
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
