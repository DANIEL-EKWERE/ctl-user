import 'dart:io';
import 'package:get/get.dart';
import '../../../data/models/models.dart';
import '../../../data/services/api_client.dart';
import '../../../data/services/push_notification_service.dart';
import '../../auth/auth_controller.dart';

class NotificationsController extends GetxController {
  static NotificationsController get to => Get.find();

  final _api = ApiClient.instance;

  final notifications = <AppNotification>[].obs;
  final isLoading = false.obs;

  String? get token => AuthController.to.customerToken;

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  @override
  void onInit() {
    super.onInit();
    load();
    _registerPushToken();
  }

  Future<void> load() async {
    if (token == null) return;
    isLoading.value = true;
    final res = await _api.getNotifications(token!);
    isLoading.value = false;
    if (res['success'] == true) {
      final body = res['data'] as Map<String, dynamic>;
      notifications.value =
          ((body['data'] ?? body['notifications'] ?? []) as List)
              .map((n) => AppNotification.fromJson(n))
              .toList();
    }
  }

  Future<void> markRead(String notificationId) async {
    if (token == null) return;
    // Optimistic update
    notifications.value = notifications
        .map((n) => n.id == notificationId ? n.copyWith(isRead: true) : n)
        .toList();
    await _api.markNotificationRead(notificationId, token!);
  }

  Future<void> markAllRead() async {
    if (token == null) return;
    // Optimistic update — flip all to read immediately
    notifications.value =
        notifications.map((n) => n.copyWith(isRead: true)).toList();
    await _api.markAllNotificationsRead(token!);
  }

  Future<void> _registerPushToken() async {
    if (token == null) return;
    final fcmToken = await PushNotificationService.instance.init();
    if (fcmToken == null) return;
    final platform = Platform.isIOS ? 'ios' : 'android';
    await _api.savePushToken(fcmToken, platform, token!);
  }
}
