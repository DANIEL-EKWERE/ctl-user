import 'dart:developer' as myLog;
import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../../core/utils/toast.dart';
import '../../data/models/models.dart';
import '../../data/services/api_client.dart';
import '../../data/services/storage_service.dart';
import '../../routes/app_routes.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  final _api = ApiClient.instance;
  final _storage = StorageService.instance;

  final isLoading = false.obs;
  final error = RxnString();

  // Login form
  final emailCtrl = ''.obs;
  final passCtrl = ''.obs;
  String role = 'customer'; // customer | rider

  // Signup form
  final signupName = ''.obs;
  final signupEmail = ''.obs;
  final signupPhone = ''.obs;
  final signupPass = ''.obs;
  final signupPassConf = ''.obs;
  final signupRole = 'customer'.obs;

  // OTP
  int? pendingUserId;
  String? pendingEmail;

  // Forgot password
  final forgotStep = 1.obs;
  final forgotEmail = ''.obs;
  final forgotCode = ''.obs;
  final forgotNewPass = ''.obs;
  final forgotConfPass = ''.obs;
  int? _forgotUserId;

  // Logged-in state
  AppUser? customerUser;
  AppUser? riderUser;
  String? customerToken;
  String? riderToken;

  @override
  void onInit() {
    super.onInit();
    _restoreSession();
  }

  Future<void> _restoreSession() async {
    customerToken = await _storage.getCustomerToken();
    riderToken = await _storage.getRiderToken();
    final cu = await _storage.getCustomerUser();
    final ru = await _storage.getRiderUser();
    if (cu != null) customerUser = AppUser.fromJson(jsonDecode(cu));
    if (ru != null) riderUser = AppUser.fromJson(jsonDecode(ru));
  }

  Future<Map<String, String>> _gatherDeviceInfo() async {
    final platform = Platform.isIOS ? 'ios' : 'android';

    // User-agent: build a descriptor from device info
    String userAgent = '';
    try {
      final di = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final info = await di.androidInfo;
        userAgent =
            '${info.manufacturer} ${info.model} / Android ${info.version.release}';
      } else if (Platform.isIOS) {
        final info = await di.iosInfo;
        userAgent = '${info.utsname.machine} / iOS ${info.systemVersion}';
      }
    } catch (_) {}

    // FCM device token
    String deviceToken = '';
    try {
      deviceToken = await FirebaseMessaging.instance.getToken() ?? '';
    } catch (_) {}

    // Location — use last known to avoid blocking the login UI
    String lat = '', lng = '';
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        final pos = await Geolocator.getLastKnownPosition();
        if (pos != null) {
          lat = pos.latitude.toString();
          lng = pos.longitude.toString();
        }
      }
    } catch (_) {}

    // Local IP address
    String ip = '';
    try {
      final interfaces = await NetworkInterface.list(
        type: InternetAddressType.IPv4,
      );
      if (interfaces.isNotEmpty && interfaces.first.addresses.isNotEmpty) {
        ip = interfaces.first.addresses.first.address;
      }
    } catch (_) {}

    return {
      'platform': platform,
      'user_agent': userAgent,
      'device_token': deviceToken,
      'latitude': lat,
      'longitude': lng,
      'ip_address': ip,
    };
  }

  Future<void> login() async {
    error.value = null;
    isLoading.value = true;
    final deviceInfo = await _gatherDeviceInfo();
    final loginBody = {
      'email': emailCtrl.value.trim(),
      'password': passCtrl.value.trim(),
      ...deviceInfo,
    };
    var res = await _api.login(loginBody);
    // Retry once — server can intermittently reject the first request
    if (res['success'] != true) {
      await Future.delayed(const Duration(milliseconds: 800));
      res = await _api.login(loginBody);
    }
    isLoading.value = false;
    if (res['success'] != true) {
      error.value = res['message'];
      return;
    }

    final body = res['data'] as Map<String, dynamic>;
    final token = body['token'] as String?;
    final user = body['user'] != null ? AppUser.fromJson(body['user']) : null;
    if (token == null || user == null) {
      error.value = 'Login failed';
      return;
    }

    if (user.role == 'rider') {
      riderToken = token;
      riderUser = user;
      await _storage.setRiderToken(token);
      await _storage.setRiderUser(jsonEncode(body['user']));
      await _storage.setRole('rider');
      Get.offAllNamed(AppRoutes.riderShell);
    } else {
      customerToken = token;
      customerUser = user;
      await _storage.setCustomerToken(token);
      await _storage.setCustomerUser(jsonEncode(body['user']));
      await _storage.setRole('customer');
      Get.offAllNamed(AppRoutes.customerShell);
    }
  }

  Future<void> register() async {
    error.value = null;
    if (signupPass.value != signupPassConf.value) {
      error.value = 'Passwords do not match';
      return;
    }
    isLoading.value = true;
    final res = await _api.register({
      'name': signupName.value.trim(),
      'email': signupEmail.value.trim(),
      'phone': signupPhone.value.trim(),
      'password': signupPass.value,
      'password_confirmation': signupPassConf.value,
      'role': signupRole.value,
    });
    isLoading.value = false;
    if (res['success'] != true) {
      error.value = res['message'];
      return;
    }
    final body = res['data'] as Map<String, dynamic>;
    pendingUserId = body['user_id'];
    pendingEmail = signupEmail.value.trim();
    Get.toNamed(AppRoutes.verifyEmail);
  }

  Future<void> verifyEmail(String otp) async {
    myLog.log('Verifying email with OTP: $otp in function verifyEmail');
    if (pendingUserId == null) return;
    error.value = null;
    isLoading.value = true;
    final res = await _api.verifyEmail(pendingUserId!, otp, otp);
    isLoading.value = false;
    if (res['success'] != true) {
      error.value = res['message'];
      return;
    }
    final body = res['data'] as Map<String, dynamic>;
    final token = body['token'] as String?;
    final user = body['user'] != null ? AppUser.fromJson(body['user']) : null;
    if (token != null && user != null) {
      if (user.role == 'rider') {
        riderToken = token;
        riderUser = user;
        await _storage.setRiderToken(token);
        await _storage.setRiderUser(jsonEncode(body['user']));
        Get.offAllNamed(AppRoutes.riderShell);
      } else {
        customerToken = token;
        customerUser = user;
        await _storage.setCustomerToken(token);
        await _storage.setCustomerUser(jsonEncode(body['user']));
        Get.offAllNamed(AppRoutes.customerShell);
      }
    }
  }

  Future<void> resendOtp() async {
    if (pendingUserId == null || pendingEmail == null) return;
    isLoading.value = true;
    await _api.resendOtp(pendingUserId!, pendingEmail!);
    isLoading.value = false;
    showToast('OTP resent to ${pendingEmail!}');
  }

  Future<void> forgotPassword() async {
    error.value = null;
    isLoading.value = true;
    final res = await _api.forgotPassword(forgotEmail.value.trim());
    isLoading.value = false;
    if (res['success'] != true) {
      error.value = res['message'];
      return;
    }
    final data = res['data'];
    final rawId = data is Map ? data['user_id'] : res['user_id'];
    _forgotUserId = int.tryParse(rawId?.toString() ?? '');
    myLog.log('forgotUserId captured: $_forgotUserId');
    forgotStep.value = 2;
  }

  Future<void> resetPassword() async {
    if (forgotNewPass.value != forgotConfPass.value) {
      error.value = 'Passwords do not match';
      return;
    }
    error.value = null;
    isLoading.value = true;
    final res = await _api.resetPassword({
      'user_id': _forgotUserId,
      'email': forgotEmail.value.trim(),
      'code': forgotCode.value.trim(),
      'password': forgotNewPass.value,
      'password_confirmation': forgotConfPass.value,
    });
    isLoading.value = false;
    if (res['success'] != true) {
      error.value = res['message'];
      return;
    }
    showToast('Password reset! Please login.');
    Get.offAllNamed(AppRoutes.login);
  }

  Future<void> updateCustomerProfile(String name, String phone) async {
    final updated = customerUser?.copyWith(name: name, phone: phone);
    if (updated == null) return;
    customerUser = updated;
    await _storage.setCustomerUser(jsonEncode(updated.toJson()));
  }

  Future<void> updateRiderProfile(String name, String phone) async {
    final updated = riderUser?.copyWith(name: name, phone: phone);
    if (updated == null) return;
    riderUser = updated;
    await _storage.setRiderUser(jsonEncode(updated.toJson()));
  }

  Future<void> logout() async {
    await _storage.clearAll();
    customerToken = null;
    riderToken = null;
    customerUser = null;
    riderUser = null;
    Get.offAllNamed(AppRoutes.login);
  }
}
