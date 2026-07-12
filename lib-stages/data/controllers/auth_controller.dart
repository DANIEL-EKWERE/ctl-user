import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';
import '../../utils/api_client.dart';
import '../../utils/storage_service.dart';
import 'cart_controller.dart';

class AuthController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // ─── Register ──────────────────────────────────────────────────────────────

  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    String role = 'customer',
  }) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final res = await ApiClient.instance.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
        passwordConfirmation: password,
        role: role,
      );
      if (res['success'] == true) {
        final data = res['data'] as Map<String, dynamic>;
        final inner = (data['data'] ?? data) as Map<String, dynamic>;
        final userId = inner['user_id'];
        await StorageService.instance.saveOtpEmail(email);
        if (userId != null) {
          await StorageService.instance.saveOtpUserId(userId as int);
        }
        Get.snackbar('Success', 'OTP sent to your email',
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color(0xFFD4EDDA),
            colorText: const Color(0xFF155724));
        Get.toNamed(AppRoutes.otp);
      } else {
        errorMessage.value = res['message']?.toString() ?? 'Registration failed';
        Get.snackbar('Error', errorMessage.value,
            snackPosition: SnackPosition.TOP);
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', 'Something went wrong. Please try again.',
          snackPosition: SnackPosition.TOP);
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Verify OTP ────────────────────────────────────────────────────────────

  Future<void> verifyOtp({required int userId, required String otp}) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final res =
          await ApiClient.instance.verifyEmail(userId: userId, otp: otp);
      if (res['success'] == true) {
        final data = res['data'] as Map<String, dynamic>;
        final inner = (data['data'] ?? data) as Map<String, dynamic>;
        final token = inner['token']?.toString();
        if (token != null && token.isNotEmpty) {
          await StorageService.instance.saveToken(token);
          await _saveUserFromData(data);
        }
        Get.offAllNamed(AppRoutes.home);
      } else {
        errorMessage.value =
            res['message']?.toString() ?? 'OTP verification failed';
        Get.snackbar('Error', errorMessage.value,
            snackPosition: SnackPosition.TOP);
      }
    } catch (e) {
      Get.snackbar('Error', 'Verification failed. Try again.',
          snackPosition: SnackPosition.TOP);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp({
    required int userId,
    required String email,
  }) async {
    isLoading.value = true;
    try {
      final res =
          await ApiClient.instance.resendOtp(userId: userId, email: email);
      Get.snackbar(
        res['success'] == true ? 'Sent' : 'Error',
        res['success'] == true
            ? 'OTP resent to $email'
            : (res['message']?.toString() ?? 'Failed to resend'),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Login ─────────────────────────────────────────────────────────────────

  Future<void> login({
    required String email,
    required String password,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final res =
          await ApiClient.instance.login(email: email, password: password);
      if (res['success'] == true) {
        final data = res['data'] as Map<String, dynamic>;
        final inner = (data['data'] ?? data) as Map<String, dynamic>;
        final token = inner['token']?.toString();
        if (token != null && token.isNotEmpty) {
          await StorageService.instance.saveToken(token);
          await _saveUserFromData(data);
        }
        final role = await StorageService.instance.getUserRole();
        Get.offAllNamed(
            role == 'rider' ? AppRoutes.riderHome : AppRoutes.home);
      } else {
        errorMessage.value =
            res['message']?.toString() ?? 'Invalid credentials';
        Get.snackbar('Login Failed', errorMessage.value,
            snackPosition: SnackPosition.TOP);
      }
    } catch (e) {
      Get.snackbar('Error', 'Login failed. Check your connection.',
          snackPosition: SnackPosition.TOP);
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Forgot Password ───────────────────────────────────────────────────────

  Future<void> forgotPassword({required String email}) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final res = await ApiClient.instance.forgotPassword(email: email);
      if (res['success'] == true) {
        await StorageService.instance.saveOtpEmail(email);
        Get.snackbar('Sent', 'Check your email for the reset code',
            snackPosition: SnackPosition.TOP);
        Get.toNamed(AppRoutes.resetPassword);
      } else {
        errorMessage.value = res['message']?.toString() ?? 'Failed';
        Get.snackbar('Error', errorMessage.value,
            snackPosition: SnackPosition.TOP);
      }
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Reset Password ────────────────────────────────────────────────────────

  Future<void> resetPassword({
    required String otp,
    required String password,
  }) async {
    isLoading.value = true;
    try {
      final email = await StorageService.instance.getOtpEmail();
      final res = await ApiClient.instance.resetPassword(
        email: email,
        otp: otp,
        password: password,
        passwordConfirmation: password,
      );
      if (res['success'] == true) {
        Get.snackbar('Done', 'Password reset successfully',
            snackPosition: SnackPosition.TOP);
        Get.offAllNamed(AppRoutes.login);
      } else {
        Get.snackbar('Error', res['message']?.toString() ?? 'Reset failed',
            snackPosition: SnackPosition.TOP);
      }
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Logout ────────────────────────────────────────────────────────────────

  Future<void> logout() async {
    await StorageService.instance.clearAll();
    try {
      Get.find<CartController>().clearAll();
    } catch (_) {}
    Get.offAllNamed(AppRoutes.login);
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  Future<void> _saveUserFromData(Map<String, dynamic> data) async {
    final inner = (data['data'] ?? data) as Map<String, dynamic>;
    final user = (inner['user'] ?? inner) as Map<String, dynamic>;
    final name = user['name']?.toString() ?? '';
    final email = user['email']?.toString() ?? '';
    final phone = user['phone']?.toString() ?? '';
    final role = user['role']?.toString() ?? 'customer';
    final id = user['id']?.toString() ?? '';
    if (name.isNotEmpty) await StorageService.instance.saveUserName(name);
    if (email.isNotEmpty) await StorageService.instance.saveUserEmail(email);
    if (phone.isNotEmpty) await StorageService.instance.saveUserPhone(phone);
    await StorageService.instance.saveUserRole(role);
    if (id.isNotEmpty) await StorageService.instance.saveUserId(id);
  }
}
