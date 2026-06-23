import 'dart:convert';
import 'package:get/get.dart';
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

  Future<void> login() async {
    error.value = null;
    isLoading.value = true;
    final res = await _api.login(emailCtrl.value.trim(), passCtrl.value.trim());
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
    print('Verifying email with OTP: $otp');
    if (pendingUserId == null) return;
    error.value = null;
    isLoading.value = true;
    final res = await _api.verifyEmail(pendingUserId!, otp);
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
    Get.snackbar('', 'OTP resent to ${pendingEmail!}');
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
      'email': forgotEmail.value.trim(),
      'otp': forgotCode.value.trim(),
      'password': forgotNewPass.value,
      'password_confirmation': forgotConfPass.value,
    });
    isLoading.value = false;
    if (res['success'] != true) {
      error.value = res['message'];
      return;
    }
    Get.snackbar('', 'Password reset! Please login.');
    Get.offAllNamed(AppRoutes.login);
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
