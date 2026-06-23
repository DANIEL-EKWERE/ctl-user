import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'storage_service.dart';

class ApiClient {
  static const String _baseUrl = 'https://nksereke.elianaeliohotels.com/api';
  static const Duration _timeout = Duration(seconds: 30);

  static ApiClient? _instance;
  static ApiClient get instance => _instance ??= ApiClient._();
  ApiClient._();

  // ─── Headers ───────────────────────────────────────────────────────────────

  Future<Map<String, String>> _authHeaders() async {
    final token = await StorageService.instance.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  Map<String, String> get _publicHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // ─── Logging ────────────────────────────────────────────────────────────────

  void _log(String msg) {
    if (kDebugMode) debugPrint('[NKsereke API] $msg');
  }

  // ─── Request wrapper ────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> _handleResponse(http.Response res) async {
    _log('${res.statusCode} ${res.request?.url}');
    try {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return {'success': true, 'data': body, 'statusCode': res.statusCode};
      } else {
        return {
          'success': false,
          'message': body['message'] ?? 'Something went wrong',
          'statusCode': res.statusCode,
          'errors': body['errors'],
        };
      }
    } catch (_) {
      return {
        'success': false,
        'message': 'Failed to parse response',
        'statusCode': res.statusCode,
      };
    }
  }

  Future<Map<String, dynamic>> _post(
    String path,
    Map<String, dynamic> body, {
    bool auth = false,
  }) async {
    final url = Uri.parse('$_baseUrl/$path');
    _log('POST $url');
    try {
      final headers = auth ? await _authHeaders() : _publicHeaders;
      final res = await http
          .post(url, headers: headers, body: jsonEncode(body))
          .timeout(_timeout);
      return _handleResponse(res);
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> _get(
    String path, {
    bool auth = true,
    Map<String, String>? query,
  }) async {
    var url = Uri.parse('$_baseUrl/$path');
    if (query != null) url = url.replace(queryParameters: query);
    _log('GET $url');
    try {
      final headers = auth ? await _authHeaders() : _publicHeaders;
      final res = await http.get(url, headers: headers).timeout(_timeout);
      _log('response $res');
      return _handleResponse(res);
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // ─── AUTH ────────────────────────────────────────────────────────────────────

  /// POST /auth/register
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
    String role = 'customer',
  }) => _post('auth/register', {
    'name': name,
    'email': email,
    'phone': phone,
    'password': password,
    'password_confirmation': passwordConfirmation,
    'role': role,
  });

  /// POST /auth/verify-email
  Future<Map<String, dynamic>> verifyEmail({
    required int userId,
    required String otp,
  }) => _post('auth/verify-email', {'user_id': userId, 'otp': otp});

  /// POST /auth/resend-otp
  Future<Map<String, dynamic>> resendOtp({
    required int userId,
    required String email,
  }) => _post('auth/resend-otp', {'user_id': userId, 'email': email});

  /// POST /auth/login
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) => _post('auth/login', {'email': email, 'password': password});

  /// POST /auth/forgot-password
  Future<Map<String, dynamic>> forgotPassword({required String email}) =>
      _post('auth/forgot-password', {'email': email});

  /// POST /auth/reset-password
  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String otp,
    required String password,
    required String passwordConfirmation,
  }) => _post('auth/reset-password', {
    'email': email,
    'otp': otp,
    'password': password,
    'password_confirmation': passwordConfirmation,
  });

  // ─── CUSTOMER – Vendors ──────────────────────────────────────────────────────

  /// GET /customer/vendors
  Future<Map<String, dynamic>> getVendors({
    int page = 1,
    String? category,
    String? search,
  }) => _get(
    'browse/vendors?',
    query: {
      'latitude': '6.5244',
      'longitude': '3.3792',
      'radius_km': '10',
      'include_closed': '0',
      if (category != null) 'category_id': category,
      if (search != null) 'search': search,
    },
  );

  /// GET /customer/vendors/:id
  Future<Map<String, dynamic>> getVendorDetail(int vendorId) => _get(
    'browse/vendors/$vendorId?',
    query: {'latitude': '6.5244', 'longitude': '3.3792'},
  );

  /// GET /customer/vendors/:id/products
  Future<Map<String, dynamic>> getVendorProducts(int vendorId) =>
      _get('browse/vendors/$vendorId}/products?category_id=&search=');

  // ─── CUSTOMER – Categories ───────────────────────────────────────────────────

  /// GET /customer/categories
  Future<Map<String, dynamic>> getCategories() => _get('customer/categories');

  // ─── CUSTOMER – Cart ─────────────────────────────────────────────────────────

  /// GET /customer/cart
  Future<Map<String, dynamic>> getCart() => _get('customer/cart');

  /// POST /customer/cart/add
  Future<Map<String, dynamic>> addToCart({
    required int productId,
    required int quantity,
    int? vendorId,
  }) => _post('customer/cart/add', {
    'product_id': productId,
    'quantity': quantity,
    if (vendorId != null) 'vendor_id': vendorId,
  }, auth: true);

  /// POST /customer/cart/update
  Future<Map<String, dynamic>> updateCartItem({
    required int cartItemId,
    required int quantity,
  }) => _post('customer/cart/update', {
    'cart_item_id': cartItemId,
    'quantity': quantity,
  }, auth: true);

  /// POST /customer/cart/remove
  Future<Map<String, dynamic>> removeFromCart({required int cartItemId}) =>
      _post('customer/cart/remove', {'cart_item_id': cartItemId}, auth: true);

  /// POST /customer/cart/clear
  Future<Map<String, dynamic>> clearCart() =>
      _post('customer/cart/clear', {}, auth: true);

  // ─── CUSTOMER – Addresses ────────────────────────────────────────────────────

  /// GET /customer/addresses
  Future<Map<String, dynamic>> getAddresses() => _get('customer/addresses',
  auth: true,
  );

  /// POST /customer/addresses
  Future<Map<String, dynamic>> addAddress({
    required String label,
    required String address,
    required double latitude,
    required double longitude,
  }) => _post('customer/addresses', {
    'label': label,
    'address': address,
    'latitude': latitude,
    'longitude': longitude,
  }, auth: true);

  // ─── CUSTOMER – Orders ───────────────────────────────────────────────────────

  /// GET /customer/orders
  Future<Map<String, dynamic>> getOrders({String? status, int page = 1}) =>
      _get(
        'customer/orders',
        query: {'page': page.toString(), if (status != null) 'status': status},
      );

  /// GET /customer/orders/:id
  Future<Map<String, dynamic>> getOrderDetail(int orderId) =>
      _get('customer/orders/$orderId');

  /// POST /customer/orders
  Future<Map<String, dynamic>> placeOrder({
    required int vendorId,
    required int addressId,
    required String paymentMethod,
    required List<Map<String, dynamic>> items,
    String? note,
  }) => _post('customer/orders', {
    'vendor_id': vendorId,
    'address_id': addressId,
    'payment_method': paymentMethod,
    'items': items,
    if (note != null) 'note': note,
  }, auth: true);

  /// POST /customer/orders/:id/cancel
  Future<Map<String, dynamic>> cancelOrder(int orderId) =>
      _post('customer/orders/$orderId/cancel', {}, auth: true);

  /// POST /customer/orders/:id/rate
  Future<Map<String, dynamic>> rateOrder({
    required int orderId,
    required int rating,
    String? comment,
  }) => _post('customer/orders/$orderId/rate', {
    'rating': rating,
    if (comment != null) 'comment': comment,
  }, auth: true);

  // ─── CUSTOMER – Profile ──────────────────────────────────────────────────────

  /// GET /customer/profile
  Future<Map<String, dynamic>> getProfile() => _get('customer/profile');

  /// POST /customer/profile/update
  Future<Map<String, dynamic>> updateProfile({String? name, String? phone}) =>
      _post('customer/profile/update', {
        if (name != null) 'name': name,
        if (phone != null) 'phone': phone,
      }, auth: true);

  // ─── RIDER ──────────────────────────────────────────────────────────────────

  /// GET /rider/profile
  Future<Map<String, dynamic>> getRiderProfile() => _get('rider/profile');

  /// POST /rider/location/update
  Future<Map<String, dynamic>> updateRiderLocation({
    required double latitude,
    required double longitude,
  }) => _post('rider/location/update', {
    'latitude': latitude,
    'longitude': longitude,
  }, auth: true);

  /// GET /rider/orders/available
  Future<Map<String, dynamic>> getAvailableOrders({int radiusKm = 10}) =>
      _get('rider/orders/available', query: {'radius_km': radiusKm.toString()});

  /// POST /rider/orders/:id/accept
  Future<Map<String, dynamic>> acceptOrder(int orderId) =>
      _post('rider/orders/$orderId/accept', {}, auth: true);

  /// POST /rider/orders/:id/reject
  Future<Map<String, dynamic>> rejectOrder(int orderId, {String? reason}) =>
      _post('rider/orders/$orderId/reject', {
        if (reason != null) 'reason': reason,
      }, auth: true);

  /// POST /rider/orders/:id/deliver
  Future<Map<String, dynamic>> markDelivered(int orderId) =>
      _post('rider/orders/$orderId/deliver', {}, auth: true);

  /// GET /rider/orders
  Future<Map<String, dynamic>> getRiderOrders({String? status, int page = 1}) =>
      _get(
        'rider/orders',
        query: {
          'page': page.toString(),
          if (status != null && status.isNotEmpty) 'status': status,
        },
      );

  /// GET /rider/wallet/balance
  Future<Map<String, dynamic>> getRiderWallet() => _get('rider/wallet/balance');

  /// GET /rider/wallet/transactions
  Future<Map<String, dynamic>> getRiderTransactions() =>
      _get('rider/wallet/transactions');
}
