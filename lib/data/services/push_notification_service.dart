import 'dart:developer' as myLog;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';

// Must be a top-level function — called when app is terminated/background
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // FCM automatically shows a notification in background/terminated state.
  // No action needed here unless you want to process data-only messages.
  myLog.log('Background message received: ${message.messageId}');
}

class PushNotificationService {
  PushNotificationService._();
  static final instance = PushNotificationService._();

  final _fcm = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();

  static const _channelId = 'nksereke_channel';
  static const _channelName = 'NKsereke Notifications';

  /// Call once after Firebase.initializeApp().
  /// Returns the FCM token, or null if permission was denied.
  Future<String?> init() async {
    // Request permissions (Android 13+ and iOS)
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      myLog.log('Push notification permission denied');
      return null;
    }

    // Set foreground presentation options for iOS
    await _fcm.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Set up flutter_local_notifications (used for foreground on Android)
    await _setupLocalNotifications();

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // Handle notification tap when app was in background (not terminated)
    FirebaseMessaging.onMessageOpenedApp.listen(_onNotificationTap);

    // Handle notification tap when app was terminated
    final initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) _onNotificationTap(initialMessage);

    // Listen for token refresh and log (caller should re-register with backend)
    _fcm.onTokenRefresh.listen((newToken) {
      myLog.log('FCM token refreshed: $newToken');
    });

    final token = await _fcm.getToken();
    myLog.log('FCM token: $token');
    return token;
  }

  Future<void> _setupLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (details) {
        _handleRoute(details.payload);
      },
    );

    // Create the Android notification channel
    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: 'NKsereke order and delivery updates',
      importance: Importance.high,
      playSound: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  void _onForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    _localNotifications.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: message.data['route'] as String?,
    );
  }

  void _onNotificationTap(RemoteMessage message) {
    _handleRoute(message.data['route'] as String?);
  }

  void _handleRoute(String? route) {
    if (route != null && route.isNotEmpty) {
      Get.toNamed(route);
    } else {
      // Default: open notifications screen
      Get.toNamed(AppRoutes.notifications);
    }
  }
}
