import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'constants.dart';
import 'package:flutter/material.dart';
import 'models.dart';



// ─────────────────────────────────────────────────────────────────────────────
// API Endpoints
// ─────────────────────────────────────────────────────────────────────────────
class Ep {
  // Auth
  static const register      = '/auth/register';
  static const verifyEmail   = '/auth/verify-email';
  static const resendOtp     = '/auth/resend-otp';
  static const login         = '/auth/login';
  static const logout        = '/auth/logout';
  static const forgotPass    = '/auth/forgot-password';
  static const verifyCode    = '/auth/verify-reset-code';
  static const resetPass     = '/auth/reset-password';
  static const profile       = '/auth/profile';
  static const changePass    = '/auth/change-password';
  static const setPin        = '/auth/set-pin';
  // Browse
  static const categories    = '/browse/categories';
  static const vendors       = '/browse/vendors';
  static const checkoutCfg   = '/browse/checkout-config';
  static const ads           = '/browse/advertisements';
  static String vendorDetail(int id)   => '/browse/vendors/$id';
  static String vendorProducts(int id) => '/browse/vendors/$id/products';
  static String vendorReviews(int id)  => '/browse/vendors/$id/reviews';
  // Customer
  static const addresses     = '/customer/addresses';
  static String address(int id)     => '/customer/addresses/$id';
  static String setDefault(int id)  => '/customer/addresses/$id/set-default';
  static const orders        = '/customer/orders';
  static String orderDetail(int id) => '/customer/orders/$id';
  static String cancelOrder(int id) => '/customer/orders/$id/cancel';
  static String writeReview(int ordId) => '/customer/orders/$ordId/review';
  static const walletBal     = '/customer/wallet/balance';
  static const walletTxns    = '/customer/wallet/transactions';
  // Notifications
  static const notifications = '/notifications';
  static const markAllRead   = '/notifications/read-all';
  // Support
  static const support       = '/support/tickets';
  // Payments
  static const fundWallet    = '/payments/fund-wallet';
  static const orderPay      = '/payments/order';
  // Rider
  static const riderDash     = '/rider/dashboard';
  static const riderToggle   = '/rider/toggle-availability';
  static const riderLocation = '/rider/location';
  static const riderAvail    = '/rider/orders/available';
  static const riderOrders   = '/rider/orders';
  static const riderWalBal   = '/rider/wallet/balance';
  static const riderWalTxns  = '/rider/wallet/transactions';
  static String acceptOrder(int id)  => '/rider/orders/$id/accept';
  static String rejectOrder(int id)  => '/rider/orders/$id/reject';
  static String deliverOrder(int id) => '/rider/orders/$id/deliver';
}

// ─────────────────────────────────────────────────────────────────────────────
// API Client (Singleton)
// ─────────────────────────────────────────────────────────────────────────────
class Api {
  static final Api _i = Api._();
  factory Api() => _i;
  Api._();

  static const _storage = FlutterSecureStorage();
  static const _key = 'nk_auth_token';

  late final Dio _dio = Dio(BaseOptions(
    baseUrl: kBase,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 30),
    headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
  ))..interceptors.add(InterceptorsWrapper(
    onRequest: (opts, handler) async {
      final t = await getToken();
      if (t != null) opts.headers['Authorization'] = 'Bearer $t';
      handler.next(opts);
    },
    onError: (e, handler) {
      debugPrint('API Error: ${e.response?.statusCode} ${e.requestOptions.path}');
      handler.next(e);
    },
  ));

  Future<Response> get(String path, {Map<String,dynamic>? params}) =>
      _dio.get(path, queryParameters: params);
  Future<Response> post(String path, {dynamic data}) =>
      _dio.post(path, data: data);
  Future<Response> put(String path, {dynamic data}) =>
      _dio.put(path, data: data);
  Future<Response> patch(String path, {dynamic data}) =>
      _dio.patch(path, data: data);
  Future<Response> delete(String path) => _dio.delete(path);

  Future<void> saveToken(String t) => _storage.write(key: _key, value: t);
  Future<String?> getToken()       => _storage.read(key: _key);
  Future<void> clearToken()        => _storage.delete(key: _key);
}

// ─────────────────────────────────────────────────────────────────────────────
// Cart
// ─────────────────────────────────────────────────────────────────────────────

class CartItem {
  final int    productId, vendorId;
  final String name;
  final double price;
  int          quantity;
  final String? imageUrl;

  CartItem({required this.productId, required this.vendorId, required this.name,
    required this.price, this.quantity = 1, this.imageUrl});

  double get subtotal => price * quantity;
}

class CartProvider extends ChangeNotifier {
  final Map<int, Map<String,dynamic>> _carts = {};

  Map<int, Map<String,dynamic>> get carts => Map.unmodifiable(_carts);

  int get totalItemCount => _carts.values
      .expand((v) => v['items'] as List<CartItem>)
      .fold(0, (s, i) => s + i.quantity);

  List<CartItem> itemsFor(int vid) =>
      (_carts[vid]?['items'] as List<CartItem>?) ?? [];

  String vendorName(int vid) => _carts[vid]?['name'] as String? ?? '';

  double subtotalFor(int vid) =>
      itemsFor(vid).fold(0.0, (s, i) => s + i.price * i.quantity);

  int quantityOf(int vid, int pid) =>
      itemsFor(vid).where((i) => i.productId == pid).firstOrNull?.quantity ?? 0;

  void addItem(int vid, String vName, ProductModel p) {
    if (p.vendorId != null && p.vendorId != vid) return; // guard
    _carts.putIfAbsent(vid, () => {'name': vName, 'items': <CartItem>[]});
    final items = _carts[vid]!['items'] as List<CartItem>;
    final ex = items.where((i) => i.productId == p.id).firstOrNull;
    if (ex != null) { ex.quantity++; } else {
      items.add(CartItem(productId: p.id, vendorId: vid, name: p.name,
        price: p.effectivePrice, imageUrl: p.imageUrl.isNotEmpty ? p.imageUrl : null));
    }
    notifyListeners();
  }

  void increment(int vid, int pid) {
    itemsFor(vid).where((i) => i.productId == pid).firstOrNull?.quantity++;
    notifyListeners();
  }

  void decrement(int vid, int pid) {
    final items = itemsFor(vid);
    final item  = items.where((i) => i.productId == pid).firstOrNull;
    if (item == null) return;
    if (item.quantity <= 1) items.removeWhere((i) => i.productId == pid);
    else item.quantity--;
    if (items.isEmpty) _carts.remove(vid);
    notifyListeners();
  }

  void clearVendor(int vid) { _carts.remove(vid); notifyListeners(); }

  void sanitize(int vid) {
    itemsFor(vid).removeWhere((i) => i.vendorId != vid);
    if (itemsFor(vid).isEmpty) _carts.remove(vid);
    notifyListeners();
  }
}
