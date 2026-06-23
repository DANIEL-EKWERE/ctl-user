import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_utils.dart';
import '../../../widgets/app_widgets.dart';
import 'notifications_controller.dart';
import 'dart:developer' as myLog;

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = NotificationsController.to;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: OrangeTopBar(
        title: 'Notifications',
        actions: [
          Obx(() {
            final hasUnread = ctrl.notifications.any((n) => !n.isRead);
            if (!hasUnread) return const SizedBox.shrink();
            return TextButton(
              onPressed:
                  // () async {
                  //   final _fcm = FirebaseMessaging.instance;
                  //   final token = await _fcm.getToken();
                  //   myLog.log('FCM token: $token');
                  //   print('Mark all read');
                  //   print('FCM token: $token');
                  //   //fz61RDuaRv2BWpydsEY9Qu:APA91bGuLtKoS6wLXD7h8hXXfDceCoYm25OdP5YnGuroY7pQW8SMS2I_la0F__khdQoEy4RFFbxgnFYJU4WZOWgFIqPWYcUCYy9Bk6X18bwTHmB8Lr8S_ws
                  // },
                  ctrl.markAllRead,
              child: const Text(
                'Mark all read',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }),
        ],
      ),
      body: Obx(() {
        if (ctrl.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.orange),
          );
        }
        final list = ctrl.notifications;
        if (list.isEmpty) {
          return const EmptyState(
            icon: Icons.notifications_none_outlined,
            title: 'No notifications yet',
          );
        }
        return RefreshIndicator(
          onRefresh: ctrl.load,
          color: AppColors.orange,
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, i) {
              final n = list[i];
              return GestureDetector(
                onTap: () {
                  if (!n.isRead) ctrl.markRead(n.id);
                  if (n.route != null && n.route!.isNotEmpty) {
                    Get.toNamed(n.route!);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: n.isRead ? Colors.white : const Color(0xFFFFF5E6),
                    border: const Border(
                      bottom: BorderSide(color: AppColors.border),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        margin: const EdgeInsets.only(top: 4, right: 10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              n.isRead ? Colors.transparent : AppColors.orange,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              n.title,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.navy,
                              ),
                            ),
                            if (n.body != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                n.body!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                            if (n.createdAt != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                AppUtils.timeAgo(n.createdAt),
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textLight,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
