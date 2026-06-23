// import 'dart:developer' as myLog;
// import 'dart:convert';
// import 'dart:async';
// import 'package:http/http.dart' as http;
// import '../../../core/constants/app_constants.dart';

// class ApiClient {
//   static ApiClient? _instance;
//   static ApiClient get instance => _instance ??= ApiClient._();
//   ApiClient._();

//   final _base = AppConstants.baseUrl;
//   final _timeout = AppConstants.timeout;

//   Map<String, String> _headers({String? token}) => {
//     'Content-Type': 'application/json',
//     'Accept': 'application/json',
//     if (token != null) 'Authorization': 'Bearer $token',
//   };

//   Future<Map<String, dynamic>> _handleResponse(http.Response res) async {
//     try {
//       final body = jsonDecode(res.body) as Map<String, dynamic>;
//       if (res.statusCode >= 200 && res.statusCode < 300) {
//         return {'success': true, 'data': body, 'statusCode': res.statusCode};
//       }
//       return {
//         'success': false,
//         'message': body['message'] ?? 'Something went wrong',
//         'statusCode': res.statusCode,
//         'errors': body['errors'],
//       };
//     } catch (_) {
//       return {
//         'success': false,
//         'message': 'Failed to parse response',
//         'statusCode': res.statusCode,
//       };
//     }
//   }

//   Future<Map<String, dynamic>> get(
//     String path, {
//     String? token,
//     Map<String, String>? query,
//   }) async {
//     var url = Uri.parse('$_base/$path');
//     if (query != null) url = url.replace(queryParameters: query);
//     try {
//       final res = await http
//           .get(url, headers: _headers(token: token))
//           .timeout(_timeout);
//       return _handleResponse(res);
//     } on TimeoutException {
//       return {'success': false, 'message': 'Request timed out'};
//     } catch (e) {
//       return {'success': false, 'message': e.toString()};
//     }
//   }

//   Future<Map<String, dynamic>> post(
//     String path, {
//     String? token,
//     Map<String, dynamic>? body,
//   }) async {
//     final url = Uri.parse('$_base/$path');
//     myLog.log(
//       'POST $url with body: ${body != null ? jsonEncode(body) : 'null'} and token: $token',
//     );
//     try {
//       final res = await http
//           .post(
//             url,
//             headers: _headers(token: token),
//             body: body != null ? jsonEncode(body) : null,
//           )
//           .timeout(_timeout);
//       myLog.log('Response from $url: ${res.statusCode} - ${res.body}');
//       return _handleResponse(res);
//     } on TimeoutException {
//       return {'success': false, 'message': 'Request timed out'};
//     } catch (e) {
//       return {'success': false, 'message': e.toString()};
//     }
//   }

//   // ─── Auth ────────────────────────────────────────────────────────────────
//   Future<Map<String, dynamic>> login(String email, String password) =>
//       post('auth/login', body: {'email': email, 'password': password});

//   Future<Map<String, dynamic>> register(Map<String, dynamic> data) =>
//       post('auth/register', body: data);

//   Future<Map<String, dynamic>> verifyEmail(int userId, String otp, String code) =>
//       post('auth/verify-email', body: {'user_id': userId, 'otp': otp, 'code': code});

//   Future<Map<String, dynamic>> resendOtp(int userId, String email) =>
//       post('auth/resend-otp', body: {'user_id': userId, 'email': email});

//   Future<Map<String, dynamic>> forgotPassword(String email) =>
//       post('auth/forgot-password', body: {'email': email});

//   Future<Map<String, dynamic>> resetPassword(Map<String, dynamic> data) =>
//       post('auth/reset-password', body: data);

//   Future<Map<String, dynamic>> changePassword(
//     Map<String, dynamic> data,
//     String token,
//   ) => post('auth/change-password', token: token, body: data);

//   Future<Map<String, dynamic>> updateProfile(
//     Map<String, dynamic> data,
//     String token,
//   ) => post('auth/profile', token: token, body: data);

//   Future<Map<String, dynamic>> setPin(
//     String pin,
//     String pinConfirmation,
//     String token,
//   ) => post(
//     'auth/set-pin',
//     token: token,
//     body: {'pin': pin, 'pin_confirmation': pinConfirmation},
//   );

//   // ─── Browse (Customer) ──────────────────────────────────────────────────
//   Future<Map<String, dynamic>> getCategories(String token) =>
//       get('browse/categories', token: token);

//   Future<Map<String, dynamic>> getVendors({
//     String? token,
//     Map<String, String>? query,
//   }) => get('browse/vendors', token: token, query: query);

//   Future<Map<String, dynamic>> getVendorDetail(int id, String token) =>
//       get('browse/vendors/$id', token: token);

//   Future<Map<String, dynamic>> getVendorProducts(int id, String token) =>
//       get('browse/vendors/$id/products', token: token);

//   Future<Map<String, dynamic>> getVendorReviews(int id, {String? token}) =>
//       get('browse/vendors/$id/reviews', token: token);

//   Future<Map<String, dynamic>> getCheckoutConfig({String? token}) =>
//       get('browse/checkout-config', token: token);

//   Future<Map<String, dynamic>> getAdvertisements() =>
//       get('browse/advertisements');

//   // ─── Customer ───────────────────────────────────────────────────────────
//   Future<Map<String, dynamic>> getProfile(String token) =>
//       get('customer/profile', token: token);

//   Future<Map<String, dynamic>> getOrders(String token) =>
//       get('customer/orders', token: token);

//   Future<Map<String, dynamic>> getOrderDetail(int id, String token) =>
//       get('customer/orders/$id', token: token);

//   Future<Map<String, dynamic>> placeOrder(
//     Map<String, dynamic> data,
//     String token,
//   ) => post('customer/orders', token: token, body: data);

//   Future<Map<String, dynamic>> getWalletBalance(String token) =>
//       get('customer/wallet/balance', token: token);

//   Future<Map<String, dynamic>> getWalletTransactions(String token) =>
//       get('customer/wallet/transactions', token: token);

//   Future<Map<String, dynamic>> fundWallet(
//     Map<String, dynamic> data,
//     String token,
//   ) => post('payments/fund-wallet', token: token, body: data);

//   Future<Map<String, dynamic>> getAddresses(String token) =>
//       get('customer/addresses', token: token);

//   Future<Map<String, dynamic>> saveAddress(
//     Map<String, dynamic> data,
//     String token,
//   ) => post('customer/addresses', token: token, body: data);

//   Future<Map<String, dynamic>> setDefaultAddress(
//     String addressId,
//     String token,
//   ) => post('customer/addresses/$addressId/set-default', token: token);

//   Future<Map<String, dynamic>> getNotifications(String token) =>
//       get('customer/notifications', token: token);

//   Future<Map<String, dynamic>> sendSupport(
//     Map<String, dynamic> data,
//     String token,
//   ) => post('customer/support', token: token, body: data);

//   Future<Map<String, dynamic>> submitReview(
//     Map<String, dynamic> data,
//     String token,
//   ) => post('customer/reviews', token: token, body: data);

//   // ─── Rider ──────────────────────────────────────────────────────────────
//   Future<Map<String, dynamic>> getRiderDashboard(String token) =>
//       get('rider/dashboard', token: token);

//   Future<Map<String, dynamic>> getAvailableOrders(
//     String token, {
//     double? radiusKm,
//   }) => get(
//     'rider/orders/available',
//     token: token,
//     query: radiusKm != null ? {'radius_km': radiusKm.toString()} : null,
//   );

//   Future<Map<String, dynamic>> getMyDeliveries(
//     String token, {
//     String? status,
//   }) => get(
//     'rider/orders',
//     token: token,
//     query: status != null ? {'status': status} : null,
//   );

//   Future<Map<String, dynamic>> acceptOrder(int id, String token) =>
//       post('rider/orders/$id/accept', token: token);

//   Future<Map<String, dynamic>> rejectOrder(
//     int id,
//     String token, {
//     String? reason,
//   }) => post(
//     'rider/orders/$id/reject',
//     token: token,
//     body: {'reason': reason ?? ''},
//   );

//   Future<Map<String, dynamic>> markDelivered(int id, String token) =>
//       post('rider/orders/$id/deliver', token: token);

//   Future<Map<String, dynamic>> getRiderWalletBalance(String token) =>
//       get('rider/wallet/balance', token: token);

//   Future<Map<String, dynamic>> getRiderWalletTransactions(String token) =>
//       get('rider/wallet/transactions', token: token);
// }

import 'dart:developer' as myLog;
import 'dart:convert';
import 'dart:async';
import 'package:ctluser/modules/auth/login/login_screen.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/app_constants.dart';

class ApiClient {
  static ApiClient? _instance;
  static ApiClient get instance => _instance ??= ApiClient._();
  ApiClient._();

  final _base = AppConstants.baseUrl;
  final _timeout = AppConstants.timeout;

  Map<String, String> _headers({String? token}) => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
  };

  // Future<Map<String, dynamic>> _handleResponse(http.Response res) async {
  //   myLog.log(jsonDecode(res.body));
  //   try {
  //     final body = jsonDecode(res.body) as Map<String, dynamic>;
  //     myLog.log('---------: $body');
  //     if (res.statusCode >= 200 && res.statusCode < 300) {
  //       return {'success': true, 'data': body, 'statusCode': res.statusCode};
  //     }
  //     return {
  //       'success': false,
  //       'message': body['message'] ?? 'Something went wrong',
  //       'statusCode': res.statusCode,
  //       'errors': body['errors'],
  //     };
  //   } catch (_) {
  //     return {
  //       'success': false,
  //       'message': 'Failed to parse response',
  //       'statusCode': res.statusCode,
  //     };
  //   }
  // }

  Future<Map<String, dynamic>> _handleResponse(http.Response res) async {
    try {
      final dynamic decodedBody = jsonDecode(res.body);
      myLog.log('Decoded Response: $decodedBody');

      Map<String, dynamic> dataMap;

      // Handle the case where response is a List: ['string', {json}]
      if (decodedBody is List) {
        if (decodedBody.length > 1 && decodedBody[1] is Map) {
          dataMap = Map<String, dynamic>.from(decodedBody[1]);
        } else {
          // Fallback for unexpected list formats
          dataMap = {'raw_list': decodedBody};
        }
      }
      // Handle the standard Map case
      else if (decodedBody is Map) {
        dataMap = Map<String, dynamic>.from(decodedBody);
      } else {
        throw const FormatException('Unexpected JSON format');
      }

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return {'success': true, 'data': dataMap, 'statusCode': res.statusCode};
      }

      return {
        'success': false,
        'message':
            dataMap['message'] ?? dataMap['detail'] ?? 'Something went wrong',
        'statusCode': res.statusCode,
        'errors': dataMap['errors'],
      };
    } catch (e) {
      myLog.log('Parsing Error: $e');
      return {
        'success': false,
        'message': 'Failed to parse response',
        'statusCode': res.statusCode,
      };
    }
  }

  Future<Map<String, dynamic>> get(
    String path, {
    String? token,
    Map<String, String>? query,
  }) async {
    var url = Uri.parse('$_base/$path');
    if (query != null) url = url.replace(queryParameters: query);
    try {
      final res = await http
          .get(url, headers: _headers(token: token))
          .timeout(_timeout);
      if (res.statusCode == 401) {
        Get.to(() => LoginScreen());
        return _handleResponse(res);
      }
      return _handleResponse(res);
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> post(
    String path, {
    String? token,
    Map<String, dynamic>? body,
  }) async {
    final url = Uri.parse('$_base/$path');
    myLog.log(
      'POST $url with body: ${body != null ? jsonEncode(body) : 'null'} and token: $token',
    );
    try {
      final res = await http
          .post(
            url,
            headers: _headers(token: token),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(_timeout);
      myLog.log('Response from $url: ${res.statusCode} - ${res.body}');
      if (res.statusCode == 401) {
        Get.to(() => LoginScreen());
        return _handleResponse(res);
      }
      if (res is List<dynamic>) {}
      return _handleResponse(res);
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> patch(
    String path, {
    String? token,
    Map<String, dynamic>? body,
  }) async {
    final url = Uri.parse('$_base/$path');
    myLog.log(
      'PATCH $url with body: ${body != null ? jsonEncode(body) : 'null'} and token: $token',
    );
    try {
      final res = await http
          .patch(
            url,
            headers: _headers(token: token),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(_timeout);
      myLog.log('Response from $url: ${res.statusCode} - ${res.body}');
      if (res.statusCode == 401) {
        Get.to(() => LoginScreen());
        return _handleResponse(res);
      }
      return _handleResponse(res);
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // ─── Auth ────────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> login(Map<String, dynamic> body) =>
      post('auth/login', body: body);

  Future<Map<String, dynamic>> register(Map<String, dynamic> data) =>
      post('auth/register', body: data);

  Future<Map<String, dynamic>> verifyEmail(
    int userId,
    String otp,
    String code,
  ) => post(
    'auth/verify-email',
    body: {'user_id': userId, 'otp': otp, 'code': code},
  );

  Future<Map<String, dynamic>> resendOtp(int userId, String email) =>
      post('auth/resend-otp', body: {'user_id': userId, 'email': email});

  Future<Map<String, dynamic>> forgotPassword(String email) =>
      post('auth/forgot-password', body: {'email': email});

  Future<Map<String, dynamic>> resetPassword(Map<String, dynamic> data) =>
      post('auth/reset-password', body: data);

  Future<Map<String, dynamic>> changePassword(
    Map<String, dynamic> data,
    String token,
  ) => post('auth/change-password', token: token, body: data);

  Future<Map<String, dynamic>> updateProfile(
    Map<String, dynamic> data,
    String token,
  ) => post('auth/profile', token: token, body: data);

  Future<Map<String, dynamic>> setPin(
    String pin,
    String pinConfirmation,
    String token,
  ) => post(
    'auth/set-pin',
    token: token,
    body: {'pin': pin, 'pin_confirmation': pinConfirmation},
  );

  // ─── Browse (Customer) ──────────────────────────────────────────────────
  Future<Map<String, dynamic>> getCategories(String token) =>
      get('browse/categories', token: token);

  Future<Map<String, dynamic>> getVendors({
    String? token,
    Map<String, String>? query,
  }) => get('browse/vendors', token: token, query: query);

  Future<Map<String, dynamic>> getVendorDetail(int id, String token) =>
      get('browse/vendors/$id', token: token);

  Future<Map<String, dynamic>> getVendorProducts(int id, String token) =>
      get('browse/vendors/$id/products', token: token);

  Future<Map<String, dynamic>> getVendorReviews(int id, {String? token}) =>
      get('browse/vendors/$id/reviews', token: token);

  Future<Map<String, dynamic>> getCheckoutConfig({String? token}) =>
      get('browse/checkout-config', token: token);

  Future<Map<String, dynamic>> getAdvertisements() =>
      get('browse/advertisements');

  // ─── Customer ───────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> getProfile(String token) =>
      get('customer/profile', token: token);

  Future<Map<String, dynamic>> getOrders(String token) =>
      get('customer/orders', token: token);

  Future<Map<String, dynamic>> getOrderDetail(int id, String token) =>
      get('customer/orders/$id', token: token);

  Future<Map<String, dynamic>> placeOrder(
    Map<String, dynamic> data,
    String token,
  ) => post('customer/orders', token: token, body: data);

  Future<Map<String, dynamic>> getWalletBalance(String token) =>
      get('customer/wallet/balance', token: token);

  Future<Map<String, dynamic>> getWalletTransactions(String token) =>
      get('customer/wallet/transactions', token: token);

  Future<Map<String, dynamic>> fundWallet(
    Map<String, dynamic> data,
    String token,
  ) => post('payments/fund-wallet', token: token, body: data);

  Future<Map<String, dynamic>> getAddresses(String token) =>
      get('customer/addresses', token: token);

  Future<Map<String, dynamic>> saveAddress(
    Map<String, dynamic> data,
    String token,
  ) => post('customer/addresses', token: token, body: data);

  Future<Map<String, dynamic>> setDefaultAddress(
    String addressId,
    String token,
  ) => patch('customer/addresses/$addressId/set-default', token: token);

  Future<Map<String, dynamic>> getNotifications(String token) =>
      get('notifications', token: token);

  Future<Map<String, dynamic>> markAllNotificationsRead(String token) =>
      post('notifications/read-all', token: token);

  Future<Map<String, dynamic>> markNotificationRead(
    String notificationId,
    String token,
  ) => post('notifications/$notificationId/read', token: token);

  Future<Map<String, dynamic>> reportOrder(
    int orderId,
    Map<String, dynamic> data,
    String token,
  ) => post('orders/$orderId/report-abuse', token: token, body: data);

  Future<Map<String, dynamic>> savePushToken(
    String fcmToken,
    String platform,
    String token,
  ) => post(
    'notifications/token',
    token: token,
    body: {'token': fcmToken, 'platform': platform},
  );

  Future<Map<String, dynamic>> sendSupport(
    Map<String, dynamic> data,
    String token,
  ) => post('support/tickets', token: token, body: data);

  Future<Map<String, dynamic>> createSupportTicket(
    Map<String, dynamic> data,
    String token,
  ) => post('support/tickets', token: token, body: data);

  Future<Map<String, dynamic>> submitReview(
    int vendorId,
    Map<String, dynamic> data,
    String token,
  ) => post('customer/vendors/$vendorId/review', token: token, body: data);

  // ─── Rider ──────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> getRiderDashboard(String token) =>
      get('rider/dashboard', token: token);

  Future<Map<String, dynamic>> getAvailableOrders(
    String token, {
    double? radiusKm,
  }) => get(
    'rider/orders/available',
    token: token,
    query: radiusKm != null ? {'radius_km': radiusKm.toString()} : null,
  );

  Future<Map<String, dynamic>> getMyDeliveries(
    String token, {
    String? status,
  }) => get(
    'rider/orders',
    token: token,
    query: status != null ? {'status': status} : null,
  );

  Future<Map<String, dynamic>> acceptOrder(int id, String token) =>
      post('rider/orders/$id/accept', token: token);

  Future<Map<String, dynamic>> rejectOrder(
    int id,
    String token, {
    String? reason,
  }) => post(
    'rider/orders/$id/reject',
    token: token,
    body: {'reason': reason ?? ''},
  );

  Future<Map<String, dynamic>> markDelivered(int id, String token) =>
      post('rider/orders/$id/deliver', token: token);

  Future<Map<String, dynamic>> getRiderInfo(String token) =>
      get('rider/info', token: token);

  Future<Map<String, dynamic>> toggleAvailability(String token) =>
      post('rider/toggle-availability', token: token);

  Future<Map<String, dynamic>> updateRiderLocation(
    Map<String, dynamic> data,
    String token,
  ) => post('rider/location', token: token, body: data);

  Future<Map<String, dynamic>> getRiderWalletBalance(String token) =>
      get('rider/wallet/balance', token: token);

  Future<Map<String, dynamic>> getRiderWalletTransactions(String token) =>
      get('rider/wallet/transactions', token: token);

  Future<Map<String, dynamic>> listBanks(String token) =>
      get('payments/banks', token: token);

  Future<Map<String, dynamic>> listBankAccounts(String token) =>
      get('payments/bank-accounts', token: token);

  Future<Map<String, dynamic>> setTransactionPin(
    Map<String, dynamic> data,
    String token,
  ) => post('auth/set-pin', token: token, body: data);

  Future<Map<String, dynamic>> addBankAccount(
    Map<String, dynamic> data,
    String token,
  ) => post('payments/bank-accounts', token: token, body: data);

  Future<Map<String, dynamic>> withdrawEarnings(
    Map<String, dynamic> data,
    String token,
  ) => post('payments/withdraw', token: token, body: data);
}
