// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import '../../../data/models/models.dart';
// import '../../../data/services/api_client.dart';
// import '../../../data/services/location_service.dart';
// import '../../../data/services/storage_service.dart';
// import '../../auth/auth_controller.dart';
// import 'dart:developer' as myLog;

// class CustomerHomeController extends GetxController {
//   static CustomerHomeController get to => Get.find();

//   final _api = ApiClient.instance;
//   final _storage = StorageService.instance;
//   final _locSvc = LocationService.instance;

//   final currentTab = 0.obs;

//   // Location
//   final delivAddr = RxnString();
//   final delivLat = RxnDouble();
//   final delivLng = RxnDouble();
//   final locationReady = false.obs;
//   final gpsLoading = false.obs;

//   // Categories
//   final categories = <Category>[].obs;

//   // Vendors
//   final vendors = <Vendor>[].obs;
//   final vendorsLoading = false.obs;
//   final vendorsLoaded = false.obs;
//   final vendorsError = RxnString();
//   final vendorSearch = ''.obs;

//   // Vendor detail
//   final vendorDetail = Rxn<Vendor>();
//   final products = <Product>[].obs;
//   final prodFilter = RxnInt();
//   final reviewStats = Rxn<ReviewStats>();
//   final vendorLoading = false.obs;
//   final selectedCatId = RxnInt();
//   final selectedCatName = RxnString();

//   // Orders
//   final orders = <Order>[].obs;
//   final ordersLoading = false.obs;
//   final orderDetail = Rxn<Order>();
//   final orderFilter = 'all'.obs;

//   // Wallet
//   final walletBalance = 0.0.obs;
//   final walletTxns = <WalletTransaction>[].obs;
//   final walletLoading = false.obs;

//   // Account
//   final notifications = <AppNotification>[].obs;
//   final addresses = <DeliveryAddress>[].obs;
//   final addressesLoading = false.obs;
//   RxBool gpsLocationInProgress = false.obs;

//   // Checkout
//   double? checkoutServiceChargePct;
//   double checkoutDefaultDeliveryFee = 500;
//   List<Map<String, dynamic>> checkoutDeliveryBands = [];
//   bool checkoutCfgLoaded = false;

//   String? get token => AuthController.to.customerToken;

//   @override
//   void onInit() {
//     super.onInit();
//     _restoreLocation();
//     loadCategories();
//   }

//   // ── Location ─────────────────────────────────────────────────────────────────

//   Future<void> _restoreLocation() async {
//     final loc = await _storage.getDeliveryLocation();
//     if (loc != null) {
//       delivAddr.value = loc['addr'];
//       delivLat.value = loc['lat'];
//       delivLng.value = loc['lng'];
//       locationReady.value = true;
//       loadVendors();
//     }
//   }

//   /// Called after selecting a search result or using GPS.
//   /// Saves to storage, saves as default address to API, loads vendors.
//   Future<void> setLocation(
//     String addr,
//     double lat,
//     double lng, {
//     String? city,
//     String? state,
//   }) async {
//     delivAddr.value = addr;
//     delivLat.value = lat;
//     delivLng.value = lng;
//     locationReady.value = true;
//     await _storage.setDeliveryLocation(addr, lat, lng);

//     // Persist as default address on server so checkout can use it
//     await _saveLocationAsAddress(addr, lat, lng, city: city, state: state);

//     loadVendors();
//   }

//   Future<void> _saveLocationAsAddress(
//     String addr,
//     double lat,
//     double lng, {
//     String? city,
//     String? state,
//   }) async {
//     if (token == null) return;
//     try {
//       final res = await _api.saveAddress({
//         'label': 'Home',
//         'address': addr,
//         'city': city ?? '',
//         'state': state ?? '',
//         'latitude': lat,
//         'longitude': lng,
//         'is_default': true,
//       }, token!);
//       if (res['success'] == true) {
//         // Reload addresses so checkout sees the new default
//         await loadAddresses();
//       }
//     } catch (_) {
//       // Fallback: inject a local-only address so checkout doesn't fail
//       addresses.value = [
//         DeliveryAddress(
//           id: null,
//           label: 'Home',
//           address: addr,
//           city: city,
//           state: state,
//           latitude: lat,
//           longitude: lng,
//           isDefault: true,
//         ),
//         ...addresses.where((a) => !a.isDefault),
//       ];
//     }
//   }

//   Future<Position> determinePosition() async {
//     gpsLocationInProgress.value = true;
//     bool serviceEnabled;
//     LocationPermission permission;

//     // Test if location services are enabled.
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       // Location services are not enabled don't continue
//       // accessing the position and request users of the
//       // App to enable the location services.
//       gpsLocationInProgress.value = false;
//       return Future.error('Location services are disabled.');
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         gpsLocationInProgress.value = false;
//         // Permissions are denied, next time you could try
//         // requesting permissions again (this is also where
//         // Android's shouldShowRequestPermissionRationale
//         // returned true. According to Android guidelines
//         // your App should show an explanatory UI now.
//         return Future.error('Location permissions are denied');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       gpsLocationInProgress.value = false;
//       // Permissions are denied forever, handle appropriately.
//       return Future.error(
//         'Location permissions are permanently denied, we cannot request permissions.',
//       );
//     }

//     // When we reach here, permissions are granted and we can
//     // continue accessing the position of the device.
//     final position = await Geolocator.getCurrentPosition();
//     gpsLocationInProgress.value = false;
//     return position;
//   }

//   /// Use device GPS to set location
//   Future<String?> useGpsLocation() async {
//     gpsLoading.value = true;
//     try {
//       final result = await _locSvc.getCurrentLocation();
//       if (result == null) {
//         gpsLoading.value = false;
//         return 'Could not get GPS location. Please check permissions.';
//       }
//       await setLocation(
//         result.address,
//         result.lat,
//         result.lng,
//         city: result.city,
//         state: result.state,
//       );
//       gpsLoading.value = false;
//       return null; // success
//     } catch (e) {
//       gpsLoading.value = false;
//       return 'GPS error: ${e.toString()}';
//     }
//   }

//   // ── Categories ───────────────────────────────────────────────────────────────

//   Future<void> loadCategories() async {
//     if (token == null) return;
//     final res = await _api.getCategories(token!);
//     if (res['success'] == true) {
//       final body = res['data'] as Map<String, dynamic>;
//       categories.value = ((body['categories'] ?? body['data']) as List? ?? [])
//           .map((c) => Category.fromJson(c))
//           .toList();
//     }
//   }

//   // ── Vendors ──────────────────────────────────────────────────────────────────

//   Future<void> loadVendors({int? catId}) async {
//     if (delivLat.value == null || delivLng.value == null) return;
//     vendorsLoading.value = true;
//     vendorsError.value = null;
//     final query = <String, String>{
//       'latitude': delivLat.value
//           .toString(), //'6.5244', //delivLat.value.toString(),
//       'longitude': delivLng.value
//           .toString(), //'3.3792', //delivLng.value.toString(),
//       'radius_km': '10',
//       'include_closed': '0',
//       if (catId != null) 'category_id': catId.toString(),
//     };
//     final res = await _api.getVendors(token: token, query: query);
//     myLog.log('Vendor API response: $res');
//     vendorsLoading.value = false;
//     vendorsLoaded.value = true;
//     if (res['success'] == true) {
//       final body = res['data'] as Map<String, dynamic>;
//       final all = (body['data'] ?? body['vendors'] ?? []) as List;
//       vendors.value = all
//           .where((v) => v['__type'] != 'advertisement')
//           .map((v) => Vendor.fromJson(v))
//           .toList();
//     } else {
//       vendorsError.value = res['message'] ?? 'Could not load vendors';
//       vendors.value = [];
//     }
//   }

//   // ── Vendor Detail ─────────────────────────────────────────────────────────────

//   Future<void> loadVendorDetail(int id) async {
//     vendorDetail.value = null;
//     products.value = [];
//     prodFilter.value = null;
//     reviewStats.value = null;
//     vendorLoading.value = true;

//     final results = await Future.wait([
//       _api.getVendorDetail(id, token!),
//       _api.getVendorProducts(id, token!),
//       _api.getVendorReviews(id, token: token),
//     ]);

//     if (results[0]['success'] == true) {
//       final body = results[0]['data'] as Map<String, dynamic>;
//       vendorDetail.value = Vendor.fromJson(body['vendor'] ?? body);
//     }
//     if (results[1]['success'] == true) {
//       final body = results[1]['data'] as Map<String, dynamic>;
//       products.value = ((body['data'] ?? body['products'] ?? []) as List)
//           .map((p) => Product.fromJson(p))
//           .toList();
//     }
//     if (results[2]['success'] == true) {
//       final body = results[2]['data'] as Map<String, dynamic>;
//       if (body['stats'] != null) {
//         reviewStats.value = ReviewStats.fromJson(body['stats']);
//       }
//     }
//     vendorLoading.value = false;
//   }

//   // ── Orders ───────────────────────────────────────────────────────────────────

//   Future<void> loadOrders() async {
//     ordersLoading.value = true;
//     final res = await _api.getOrders(token!);
//     ordersLoading.value = false;
//     if (res['success'] == true) {
//       final body = res['data'] as Map<String, dynamic>;
//       orders.value = ((body['data'] ?? body['orders'] ?? []) as List)
//           .map((o) => Order.fromJson(o))
//           .toList();
//     }
//   }

//   Future<void> loadOrderDetail(int id) async {
//     orderDetail.value = null;
//     final res = await _api.getOrderDetail(id, token!);
//     if (res['success'] == true) {
//       final body = res['data'] as Map<String, dynamic>;
//       orderDetail.value = Order.fromJson(body['order'] ?? body['data'] ?? body);
//     }
//   }

//   // ── Wallet ───────────────────────────────────────────────────────────────────

//   Future<void> loadWallet() async {
//     walletLoading.value = true;
//     final results = await Future.wait([
//       _api.getWalletBalance(token!),
//       _api.getWalletTransactions(token!),
//     ]);
//     walletLoading.value = false;
//     if (results[0]['success'] == true) {
//       final body = results[0]['data'] as Map<String, dynamic>;
//       walletBalance.value =
//           double.tryParse(
//             (body['balance'] ?? body['data']?['balance'] ?? 0).toString(),
//           ) ??
//           0;
//     }
//     if (results[1]['success'] == true) {
//       final body = results[1]['data'] as Map<String, dynamic>;
//       walletTxns.value = ((body['data'] ?? body['transactions'] ?? []) as List)
//           .map((t) => WalletTransaction.fromJson(t))
//           .toList();
//     }
//   }

//   // ── Addresses ────────────────────────────────────────────────────────────────

//   Future<void> loadAddresses() async {
//     if (token == null) return;
//     addressesLoading.value = true;
//     final res = await _api.getAddresses(token!);
//     addressesLoading.value = false;
//     if (res['success'] == true) {
//       final body = res['data'] as Map<String, dynamic>;
//       addresses.value = ((body['data'] ?? body['addresses'] ?? []) as List)
//           .map((a) => DeliveryAddress.fromJson(a))
//           .toList();
//     }
//   }

//   /// Returns the best address to use at checkout:
//   /// 1. Saved default from API
//   /// 2. Any saved address
//   /// 3. Synthetic from current GPS location
//   DeliveryAddress? get checkoutAddress {
//     if (addresses.isNotEmpty) {
//       return addresses.firstWhereOrNull((a) => a.isDefault) ?? addresses.first;
//     }
//     // Fallback: build from current location state
//     if (delivLat.value != null && delivLng.value != null) {
//       return DeliveryAddress(
//         id: null,
//         label: 'Current Location',
//         address: delivAddr.value ?? 'Current location',
//         latitude: delivLat.value,
//         longitude: delivLng.value,
//         isDefault: true,
//       );
//     }
//     return null;
//   }

//   // ── Notifications ─────────────────────────────────────────────────────────────

//   Future<void> loadNotifications() async {
//     final res = await _api.getNotifications(token!);
//     if (res['success'] == true) {
//       final body = res['data'] as Map<String, dynamic>;
//       notifications.value =
//           ((body['data'] ?? body['notifications'] ?? []) as List)
//               .map((n) => AppNotification.fromJson(n))
//               .toList();
//     }
//   }

//   // ── Checkout Config ───────────────────────────────────────────────────────────

//   Future<void> loadCheckoutConfig() async {
//     if (checkoutCfgLoaded) return;
//     final res = await _api.getCheckoutConfig(token: token);
//     if (res['success'] == true) {
//       final body = res['data'] as Map<String, dynamic>;
//       final cfg = body['data'] ?? body['config'] ?? body;
//       checkoutServiceChargePct =
//           (cfg['service_charge_pct'] as num?)?.toDouble() ?? 5;
//       checkoutDefaultDeliveryFee =
//           (cfg['default_delivery_fee'] as num?)?.toDouble() ?? 500;
//       checkoutDeliveryBands =
//           (cfg['delivery_fee_bands'] as List?)
//               ?.map((b) => Map<String, dynamic>.from(b))
//               .toList() ??
//           [];
//       checkoutCfgLoaded = true;
//     }
//   }

//   double calcDeliveryFee(double? distKm) {
//     if (distKm == null) return checkoutDefaultDeliveryFee;
//     for (final b in checkoutDeliveryBands) {
//       final min = (b['min_km'] as num?)?.toDouble() ?? 0;
//       final max = (b['max_km'] as num?)?.toDouble() ?? 999;
//       final price = double.tryParse((b['price'] ?? 0).toString()) ?? 0;
//       if (distKm >= min && distKm <= max) return price;
//     }
//     return checkoutDefaultDeliveryFee;
//   }

//   double calcServiceCharge(double subtotal) {
//     final pct = checkoutServiceChargePct ?? 5;
//     return subtotal * pct / 100;
//   }

//   // ── Filters ──────────────────────────────────────────────────────────────────

//   List<Order> get filteredOrders {
//     if (orderFilter.value == 'all') return orders;
//     return orders.where((o) => o.status == orderFilter.value).toList();
//   }

//   List<Vendor> get filteredVendors {
//     if (vendorSearch.value.isEmpty) return vendors;
//     return vendors
//         .where(
//           (v) =>
//               v.name.toLowerCase().contains(vendorSearch.value.toLowerCase()),
//         )
//         .toList();
//   }

//   List<Product> get filteredProducts {
//     if (prodFilter.value == null || vendorDetail.value == null) return products;
//     final cat = vendorDetail.value!.productCategories.firstWhereOrNull(
//       (c) => c.id == prodFilter.value,
//     );
//     if (cat == null) return products;
//     return products.where((p) => p.category == cat.name).toList();
//   }

//   void switchTab(int i) {
//     currentTab.value = i;
//     if (i == 1) loadOrders();
//     if (i == 2) loadWallet();
//   }
// }

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/theme/app_theme.dart';
import 'package:get/get.dart';
import '../../../core/utils/toast.dart';
import '../../../data/models/models.dart';
import '../../../data/services/api_client.dart';
import '../../../data/services/location_service.dart';
import '../../../data/services/storage_service.dart';
import '../../auth/auth_controller.dart';
import 'dart:developer' as myLog;

class CustomerHomeController extends GetxController {
  static CustomerHomeController get to => Get.find();

  final _api = ApiClient.instance;
  final _storage = StorageService.instance;
  final _locSvc = LocationService.instance;

  final currentTab = 0.obs;

  // Location
  final delivAddr = RxnString();
  final delivLat = RxnDouble();
  final delivLng = RxnDouble();
  final locationReady = false.obs;
  final gpsLoading = false.obs;

  // Categories
  final categories = <Category>[].obs;

  // Vendors
  final vendors = <Vendor>[].obs;
  final vendorsLoading = false.obs;
  final vendorsLoaded = false.obs;
  final vendorsError = RxnString();
  final vendorSearch = ''.obs;

  // Vendor detail
  final vendorDetail = Rxn<Vendor>();
  final products = <Product>[].obs;
  final prodFilter = RxnInt();
  final reviewStats = Rxn<ReviewStats>();
  final vendorReviews = <Review>[].obs;
  final reviewsLoading = false.obs;
  final vendorLoading = false.obs;
  final selectedCatId = RxnInt();
  final selectedCatName = RxnString();

  // Orders
  final orders = <Order>[].obs;
  final ordersLoading = false.obs;
  final orderDetail = Rxn<Order>();
  final orderFilter = 'all'.obs;

  // Wallet
  final walletBalance = 0.0.obs;
  final walletTxns = <WalletTransaction>[].obs;
  final walletLoading = false.obs;
  final bankAccounts = <BankAccount>[].obs;
  final availableBanks = <BankOption>[].obs;

  // Account
  final addresses = <DeliveryAddress>[].obs;
  final addressesLoading = false.obs;
  RxBool gpsLocationInProgress = false.obs;

  // Checkout
  double? checkoutServiceChargePct;
  double checkoutDefaultDeliveryFee = 500;
  List<Map<String, dynamic>> checkoutDeliveryBands = [];
  bool checkoutCfgLoaded = false;

  String? get token => AuthController.to.customerToken;

  @override
  void onInit() {
    super.onInit();
    _restoreLocation();
    loadCategories();
  }

  // ── Location ─────────────────────────────────────────────────────────────────

  Future<void> _restoreLocation() async {
    final loc = await _storage.getDeliveryLocation();
    if (loc != null) {
      delivAddr.value = loc['addr'];
      delivLat.value = loc['lat'];
      delivLng.value = loc['lng'];
      locationReady.value = true;
      loadVendors();
    }
  }

  /// Called after selecting a search result or using GPS.
  /// Saves to storage, saves as default address to API, loads vendors.
  Future<void> setLocation(
    String addr,
    double lat,
    double lng, {
    String? city,
    String? state,
  }) async {
    delivAddr.value = addr;
    delivLat.value = lat;
    delivLng.value = lng;
    locationReady.value = true;
    await _storage.setDeliveryLocation(addr, lat, lng);

    // Persist as default address on server so checkout can use it
    await _saveLocationAsAddress(addr, lat, lng, city: city, state: state);

    loadVendors();
  }

  Future<void> _saveLocationAsAddress(
    String addr,
    double lat,
    double lng, {
    String? city,
    String? state,
  }) async {
    if (token == null) return;
    try {
      final res = await _api.saveAddress({
        'label': 'Home',
        'address': addr,
        'city': city ?? '',
        'state': state ?? '',
        'latitude': lat,
        'longitude': lng,
        'is_default': true,
      }, token!);
      if (res['success'] == true) {
        // Reload addresses so checkout sees the new default
        await loadAddresses();
      }
    } catch (_) {
      // Fallback: inject a local-only address so checkout doesn't fail
      addresses.value = [
        DeliveryAddress(
          id: null,
          label: 'Home',
          address: addr,
          city: city,
          state: state,
          latitude: lat,
          longitude: lng,
          isDefault: true,
        ),
        ...addresses.where((a) => !a.isDefault),
      ];
    }
  }

  Future<Position> determinePosition() async {
    gpsLocationInProgress.value = true;
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      gpsLocationInProgress.value = false;
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        gpsLocationInProgress.value = false;
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      gpsLocationInProgress.value = false;
      // Permissions are denied forever, handle appropriately.
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    final position = await Geolocator.getCurrentPosition();
    gpsLocationInProgress.value = false;
    return position;
  }

  /// Use device GPS to set location
  Future<String?> useGpsLocation() async {
    gpsLoading.value = true;
    try {
      final result = await _locSvc.getCurrentLocation();
      if (result == null) {
        gpsLoading.value = false;
        return 'Could not get GPS location. Please check permissions.';
      }
      await setLocation(
        result.address,
        result.lat,
        result.lng,
        city: result.city,
        state: result.state,
      );
      gpsLoading.value = false;
      return null; // success
    } catch (e) {
      gpsLoading.value = false;
      return 'GPS error: ${e.toString()}';
    }
  }

  // ── Categories ───────────────────────────────────────────────────────────────

  Future<void> loadCategories() async {
    if (token == null) return;
    final res = await _api.getCategories(token!);
    if (res['success'] == true) {
      final body = res['data'] as Map<String, dynamic>;
      categories.value = ((body['categories'] ?? body['data']) as List? ?? [])
          .map((c) => Category.fromJson(c))
          .toList();
    }
  }

  // ── Vendors ──────────────────────────────────────────────────────────────────

  Future<void> loadVendors({int? catId}) async {
    if (delivLat.value == null || delivLng.value == null) return;
    vendorsLoading.value = true;
    vendorsError.value = null;
    final query = <String, String>{
      'latitude': delivLat.value
          .toString(), //'6.5244', //delivLat.value.toString(),
      'longitude': delivLng.value
          .toString(), //'3.3792', //delivLng.value.toString(),
      'radius_km': '10',
      'include_closed': '0',
      if (catId != null) 'category_id': catId.toString(),
    };
    final res = await _api.getVendors(token: token, query: query);
    myLog.log('Vendor API response: $res');
    vendorsLoading.value = false;
    vendorsLoaded.value = true;
    if (res['success'] == true) {
      final body = res['data'] as Map<String, dynamic>;
      final all = (body['data'] ?? body['vendors'] ?? []) as List;
      vendors.value = all
          .where((v) => v['__type'] != 'advertisement')
          .map((v) => Vendor.fromJson(v))
          .toList();
    } else {
      vendorsError.value = res['message'] ?? 'Could not load vendors';
      vendors.value = [];
    }
  }

  // ── Vendor Detail ─────────────────────────────────────────────────────────────

  Future<void> loadVendorDetail(int id) async {
    vendorDetail.value = null;
    products.value = [];
    prodFilter.value = null;
    reviewStats.value = null;
    vendorReviews.value = [];
    vendorLoading.value = true;

    final results = await Future.wait([
      _api.getVendorDetail(id, token!),
      _api.getVendorProducts(id, token!),
      _api.getVendorReviews(id, token: token),
    ]);

    if (results[0]['success'] == true) {
      final body = results[0]['data'] as Map<String, dynamic>;
      vendorDetail.value = Vendor.fromJson(body['vendor'] ?? body);
    }
    if (results[1]['success'] == true) {
      final body = results[1]['data'] as Map<String, dynamic>;
      products.value = ((body['data'] ?? body['products'] ?? []) as List)
          .map((p) => Product.fromJson(p))
          .toList();
    }
    if (results[2]['success'] == true) {
      final body = results[2]['data'] as Map<String, dynamic>;
      if (body['stats'] != null) {
        reviewStats.value = ReviewStats.fromJson(body['stats']);
      }
      final rawReviews = body['reviews'] ?? body['data'] ?? [];
      if (rawReviews is List) {
        vendorReviews.value = rawReviews
            .map((r) => Review.fromJson(r))
            .toList();
      }
    }
    vendorLoading.value = false;
  }

  Future<void> loadVendorReviews(int vendorId) async {
    reviewsLoading.value = true;
    final res = await _api.getVendorReviews(vendorId, token: token);
    reviewsLoading.value = false;
    if (res['success'] == true) {
      final body = res['data'] as Map<String, dynamic>;
      if (body['stats'] != null) {
        reviewStats.value = ReviewStats.fromJson(body['stats']);
      }
      final rawReviews = body['reviews'] ?? body['data'] ?? [];
      if (rawReviews is List) {
        vendorReviews.value = rawReviews
            .map((r) => Review.fromJson(r))
            .toList();
      }
    }
  }

  Future<bool> submitReview({
    required int vendorId,
    required int rating,
    required String comment,
  }) async {
    final res = await _api.submitReview(vendorId, {
      'rating': rating,
      'review': comment,
    }, token!);
    myLog.log('body response from outside if statement: $res');
    if (res['success'] == true) {
      // Refresh reviews if we have a current vendor loaded
      final v = vendorDetail.value;
      if (v != null) await loadVendorReviews(v.id);
      myLog.log('body response: $res');
      return true;
    }
    final msg = res['message'] ?? 'Failed to submit review';
    showToast(msg, isError: true);
    return false;
  }

  // ── Orders ───────────────────────────────────────────────────────────────────

  Future<void> loadOrders() async {
    ordersLoading.value = true;
    final res = await _api.getOrders(token!);
    ordersLoading.value = false;
    if (res['success'] == true) {
      final body = res['data'] as Map<String, dynamic>;
      orders.value = ((body['data'] ?? body['orders'] ?? []) as List)
          .map((o) => Order.fromJson(o))
          .toList();
    }
  }

  Future<void> loadOrderDetail(int id) async {
    orderDetail.value = null;
    final res = await _api.getOrderDetail(id, token!);
    if (res['success'] == true) {
      final body = res['data'] as Map<String, dynamic>;
      orderDetail.value = Order.fromJson(body['order'] ?? body['data'] ?? body);
    }
  }

  // ── Wallet ───────────────────────────────────────────────────────────────────

  Future<void> loadWallet() async {
    walletLoading.value = true;
    final results = await Future.wait([
      _api.getWalletBalance(token!),
      _api.getWalletTransactions(token!),
      _api.listBankAccounts(token!),
    ]);
    walletLoading.value = false;
    if (results[0]['success'] == true) {
      final body = results[0]['data'] as Map<String, dynamic>;
      walletBalance.value =
          double.tryParse(
            (body['balance'] ?? body['data']?['balance'] ?? 0).toString(),
          ) ??
          0;
    }
    if (results[1]['success'] == true) {
      final body = results[1]['data'] as Map<String, dynamic>;
      walletTxns.value = ((body['data'] ?? body['transactions'] ?? []) as List)
          .map((t) => WalletTransaction.fromJson(t))
          .toList();
    }
    if (results[2]['success'] == true) {
      final body = results[2]['data'] as Map<String, dynamic>;
      final raw = body['data'] ?? body['bank_accounts'] ?? body['accounts'] ?? body['raw_list'] ?? [];
      bankAccounts.value = (raw as List)
          .map((b) => BankAccount.fromJson(b as Map<String, dynamic>)).toList();
    }
  }

  Future<void> loadBanks() async {
    if (availableBanks.isNotEmpty) return;
    final res = await _api.listBanks(token!);
    if (res['success'] == true) {
      final body = res['data'] as Map<String, dynamic>;
      final raw = body['data'] ?? body['banks'] ?? body['raw_list'] ?? [];
      availableBanks.value = (raw as List)
          .map((b) => BankOption.fromJson(b as Map<String, dynamic>)).toList();
    }
  }

  Future<bool> addBankAccount(Map<String, dynamic> data) async {
    final res = await _api.addBankAccount(data, token!);
    if (res['success'] == true) {
      await loadWallet();
      showToast('Bank account added');
      return true;
    }
    showToast(res['message'] ?? 'Failed', isError: true);
    return false;
  }

  Future<bool> withdrawFromWallet({
    required double amount,
    required int bankAccountId,
    required String pin,
  }) async {
    final res = await _api.withdrawEarnings({
      'amount': amount,
      'bank_account_id': bankAccountId,
      'pin': pin,
      'gateway': 'paystack',
    }, token!);
    if (res['success'] == true) {
      await loadWallet();
      showToast('Withdrawal requested successfully');
      return true;
    }
    showToast(res['message'] ?? 'Failed', isError: true);
    return false;
  }

  // ── Addresses ────────────────────────────────────────────────────────────────

  Future<void> loadAddresses() async {
    if (token == null) return;
    addressesLoading.value = true;
    final res = await _api.getAddresses(token!);
    addressesLoading.value = false;
    if (res['success'] == true) {
      final body = res['data'] as Map<String, dynamic>;
      addresses.value = ((body['data'] ?? body['addresses'] ?? []) as List)
          .map((a) => DeliveryAddress.fromJson(a))
          .toList();
    }
  }

  /// Returns the best address to use at checkout:
  /// 1. Saved default from API
  /// 2. Any saved address
  /// 3. Synthetic from current GPS location
  DeliveryAddress? get checkoutAddress {
    if (addresses.isNotEmpty) {
      return addresses.firstWhereOrNull((a) => a.isDefault) ?? addresses.first;
    }
    // Fallback: build from current location state
    if (delivLat.value != null && delivLng.value != null) {
      return DeliveryAddress(
        id: null,
        label: 'Current Location',
        address: delivAddr.value ?? 'Current location',
        latitude: delivLat.value,
        longitude: delivLng.value,
        isDefault: true,
      );
    }
    return null;
  }

  // ── Checkout Config ───────────────────────────────────────────────────────────

  Future<void> loadCheckoutConfig() async {
    if (checkoutCfgLoaded) return;
    final res = await _api.getCheckoutConfig(token: token);
    if (res['success'] == true) {
      final body = res['data'] as Map<String, dynamic>;
      final cfg = body['data'] ?? body['config'] ?? body;
      // API may return numbers as strings — parse safely
      checkoutServiceChargePct =
          double.tryParse((cfg['service_charge_pct'] ?? 5).toString()) ?? 5;
      checkoutDefaultDeliveryFee =
          double.tryParse((cfg['default_delivery_fee'] ?? 500).toString()) ?? 500;
      checkoutDeliveryBands =
          (cfg['delivery_fee_bands'] as List?)
              ?.map((b) => Map<String, dynamic>.from(b))
              .toList() ??
          [];
      checkoutCfgLoaded = true;
    }
  }

  double calcDeliveryFee(double? distKm) {
    if (distKm == null) return checkoutDefaultDeliveryFee;
    for (final b in checkoutDeliveryBands) {
      final min = double.tryParse((b['min_km'] ?? 0).toString()) ?? 0;
      final max = double.tryParse((b['max_km'] ?? 999).toString()) ?? 999;
      final price = double.tryParse((b['price'] ?? 0).toString()) ?? 0;
      if (distKm >= min && distKm <= max) return price;
    }
    return checkoutDefaultDeliveryFee;
  }

  double calcServiceCharge(double subtotal) {
    final pct = checkoutServiceChargePct ?? 5;
    return subtotal * pct / 100;
  }

  // ── Filters ──────────────────────────────────────────────────────────────────

  List<Order> get filteredOrders {
    if (orderFilter.value == 'all') return orders;
    return orders.where((o) => o.status == orderFilter.value).toList();
  }

  int get activeOrdersCount =>
      orders.where((o) => o.status == 'accepted').length;

  int get completedOrdersCount =>
      orders.where((o) => o.status == 'delivered').length;

  List<Vendor> get filteredVendors {
    if (vendorSearch.value.isEmpty) return vendors;
    return vendors
        .where(
          (v) =>
              v.name.toLowerCase().contains(vendorSearch.value.toLowerCase()),
        )
        .toList();
  }

  List<Product> get filteredProducts {
    if (prodFilter.value == null || vendorDetail.value == null) return products;
    final cat = vendorDetail.value!.productCategories.firstWhereOrNull(
      (c) => c.id == prodFilter.value,
    );
    if (cat == null) return products;
    return products.where((p) => p.category == cat.name).toList();
  }

  void switchTab(int i) {
    currentTab.value = i;
    if (i == 1) loadOrders();
    if (i == 2) loadWallet();
  }
}
