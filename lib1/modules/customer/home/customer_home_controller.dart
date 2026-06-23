// import 'package:get/get.dart';
// import '../../../data/models/models.dart';
// import '../../../data/services/api_client.dart';
// import '../../../data/services/storage_service.dart';
// import '../../auth/auth_controller.dart';
// import 'package:geolocator/geolocator.dart';
// import 'dart:developer' as myLog;

// class CustomerHomeController extends GetxController {
//   static CustomerHomeController get to => Get.find();

//   final _api = ApiClient.instance;
//   final _storage = StorageService.instance;

//   final currentTab = 0.obs;

//   // Location
//   final delivAddr = RxnString();
//   final delivLat = RxnDouble();
//   final delivLng = RxnDouble();
//   final locationReady = false.obs;

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

//   // Checkout
//   double? checkoutServiceChargePct;
//   double checkoutDefaultDeliveryFee = 500;
//   List<Map<String, dynamic>> checkoutDeliveryBands = [];
//   bool checkoutCfgLoaded = false;
//   RxBool gpsLocationInProgress = false.obs;

//   String? get token => AuthController.to.customerToken;

//   @override
//   void onInit() {
//     super.onInit();
//     _restoreLocation();
//     loadCategories();
//   }

//   /// Determine the current position of the device.
//   ///
//   /// When the location services are not enabled or permissions
//   /// are denied the `Future` will return an error.
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

//   Future<void> _restoreLocation() async {
//     final loc = await _storage.getDeliveryLocation();
//     myLog.log('Restored location: $loc');
//     if (loc != null) {
//       delivAddr.value = loc['addr'];
//       delivLat.value = loc['lat'];
//       delivLng.value = loc['lng'];
//       locationReady.value = true;
//       loadVendors();
//     }
//   }

//   void setLocation(String addr, double lat, double lng) async {
//     delivAddr.value = addr;
//     delivLat.value = lat;
//     delivLng.value = lng;
//     locationReady.value = true;
//     await _storage.setDeliveryLocation(addr, lat, lng);
//     loadVendors();
//   }

//   Future<void> loadCategories() async {
//     if (token == null) return;
//     final res = await _api.getCategories(token!);
//     if (res['success'] == true) {
//       final body = res['data'] as Map<String, dynamic>;
//       myLog.log('Loaded categories: ${body['data'] ?? body['categories']}');
//       categories.value = ((body['categories'] ?? body['data']) as List? ?? [])
//           .map((c) => Category.fromJson(c))
//           .toList();
//     }
//   }

//   Future<void> loadVendors({int? catId}) async {
//     if (delivLat.value == null || delivLng.value == null) return;
//     vendorsLoading.value = true;
//     vendorsError.value = null;
//     final query = <String, String>{
//       'latitude': delivLat.value.toString(),
//       'longitude': delivLng.value.toString(),
//       if (catId != null) 'category_id': catId.toString(),
//     };
//     final res = await _api.getVendors(token: token, query: query);
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

//     final vRes = results[0];
//     final pRes = results[1];
//     final rvRes = results[2];

//     if (vRes['success'] == true) {
//       final body = vRes['data'] as Map<String, dynamic>;
//       vendorDetail.value = Vendor.fromJson(body['vendor'] ?? body);
//     }
//     // Check if the request was successful
//     if (pRes['success'] == true) {
//       // First, cast pRes['data'] as a Map to access keys inside it
//       final responseMap = pRes['data'] as Map<String, dynamic>;

//       // Now, extract the actual list of products.
//       // We use your logic: try 'data', then 'products', default to an empty list.
//       final productsListRaw =
//           (responseMap['data'] ?? responseMap['products'] ?? [])
//               as List<dynamic>;

//       // Now that we have a List<dynamic>, we can map it to our Product model.
//       products.value = productsListRaw
//           .map(
//             (productMap) =>
//                 Product.fromJson(productMap as Map<String, dynamic>),
//           )
//           .toList();
//     }
//     if (rvRes['success'] == true) {
//       final body = rvRes['data'] as Map<String, dynamic>;
//       if (body['stats'] != null)
//         reviewStats.value = ReviewStats.fromJson(body['stats']);
//     }
//     vendorLoading.value = false;
//   }

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

//   Future<void> loadAddresses() async {
//     final res = await _api.getAddresses(token!);
//     if (res['success'] == true) {
//       final body = res['data'] as Map<String, dynamic>;
//       addresses.value = ((body['data'] ?? body['addresses'] ?? []) as List)
//           .map((a) => DeliveryAddress.fromJson(a))
//           .toList();
//     }
//   }

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
//       final price = (b['price'] as num?)?.toDouble() ?? 0;
//       if (distKm >= min && distKm <= max) return price;
//     }
//     return checkoutDefaultDeliveryFee;
//   }

//   double calcServiceCharge(double subtotal) {
//     final pct = checkoutServiceChargePct ?? 5;
//     return subtotal * pct / 100;
//   }

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


import 'package:get/get.dart';
import '../../../data/models/models.dart';
import '../../../data/services/api_client.dart';
import '../../../data/services/location_service.dart';
import '../../../data/services/storage_service.dart';
import '../../auth/auth_controller.dart';
import 'package:geolocator/geolocator.dart';

class CustomerHomeController extends GetxController {
  static CustomerHomeController get to => Get.find();

  final _api      = ApiClient.instance;
  final _storage  = StorageService.instance;
  final _locSvc   = LocationService.instance;
    RxBool gpsLocationInProgress = false.obs;

  final currentTab = 0.obs;

  // Location
  final delivAddr     = RxnString();
  final delivLat      = RxnDouble();
  final delivLng      = RxnDouble();
  final locationReady = false.obs;
  final gpsLoading    = false.obs;

  // Categories
  final categories = <Category>[].obs;

  // Vendors
  final vendors        = <Vendor>[].obs;
  final vendorsLoading = false.obs;
  final vendorsLoaded  = false.obs;
  final vendorsError   = RxnString();
  final vendorSearch   = ''.obs;

  // Vendor detail
  final vendorDetail    = Rxn<Vendor>();
  final products        = <Product>[].obs;
  final prodFilter      = RxnInt();
  final reviewStats     = Rxn<ReviewStats>();
  final vendorLoading   = false.obs;
  final selectedCatId   = RxnInt();
  final selectedCatName = RxnString();

  // Orders
  final orders        = <Order>[].obs;
  final ordersLoading = false.obs;
  final orderDetail   = Rxn<Order>();
  final orderFilter   = 'all'.obs;

  // Wallet
  final walletBalance = 0.0.obs;
  final walletTxns    = <WalletTransaction>[].obs;
  final walletLoading = false.obs;

  // Account
  final notifications = <AppNotification>[].obs;
  final addresses     = <DeliveryAddress>[].obs;
  final addressesLoading = false.obs;

  // Checkout
  double? checkoutServiceChargePct;
  double  checkoutDefaultDeliveryFee = 500;
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
      delivAddr.value     = loc['addr'];
      delivLat.value      = loc['lat'];
      delivLng.value      = loc['lng'];
      locationReady.value = true;
      loadVendors();
    }
  }

  /// Called after selecting a search result or using GPS.
  /// Saves to storage, saves as default address to API, loads vendors.
  Future<void> setLocation(String addr, double lat, double lng,
      {String? city, String? state}) async {
    delivAddr.value     = addr;
    delivLat.value      = lat;
    delivLng.value      = lng;
    locationReady.value = true;
    await _storage.setDeliveryLocation(addr, lat, lng);

    // Persist as default address on server so checkout can use it
    await _saveLocationAsAddress(addr, lat, lng, city: city, state: state);

    loadVendors();
  }

  Future<void> _saveLocationAsAddress(String addr, double lat, double lng,
      {String? city, String? state}) async {
    if (token == null) return;
    try {
      final res = await _api.saveAddress({
        'label':      'Home',
        'address':    addr,
        'city':       city ?? '',
        'state':      state ?? '',
        'latitude':   lat,
        'longitude':  lng,
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

    /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
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
      await setLocation(result.address, result.lat, result.lng,
          city: result.city, state: result.state);
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
    vendorsError.value   = null;
    final query = <String, String>{
      'lat': delivLat.value.toString(),
      'lng': delivLng.value.toString(),
      if (catId != null) 'category_id': catId.toString(),
    };
    final res = await _api.getVendors(token: token, query: query);
    vendorsLoading.value = false;
    vendorsLoaded.value  = true;
    if (res['success'] == true) {
      final body = res['data'] as Map<String, dynamic>;
      final all  = (body['data'] ?? body['vendors'] ?? []) as List;
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
    vendorDetail.value  = null;
    products.value      = [];
    prodFilter.value    = null;
    reviewStats.value   = null;
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
    }
    vendorLoading.value = false;
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
      orderDetail.value =
          Order.fromJson(body['order'] ?? body['data'] ?? body);
    }
  }

  // ── Wallet ───────────────────────────────────────────────────────────────────

  Future<void> loadWallet() async {
    walletLoading.value = true;
    final results = await Future.wait([
      _api.getWalletBalance(token!),
      _api.getWalletTransactions(token!),
    ]);
    walletLoading.value = false;
    if (results[0]['success'] == true) {
      final body = results[0]['data'] as Map<String, dynamic>;
      walletBalance.value = double.tryParse(
              (body['balance'] ?? body['data']?['balance'] ?? 0).toString()) ??
          0;
    }
    if (results[1]['success'] == true) {
      final body = results[1]['data'] as Map<String, dynamic>;
      walletTxns.value =
          ((body['data'] ?? body['transactions'] ?? []) as List)
              .map((t) => WalletTransaction.fromJson(t))
              .toList();
    }
  }

  // ── Addresses ────────────────────────────────────────────────────────────────

  Future<void> loadAddresses() async {
    if (token == null) return;
    addressesLoading.value = true;
    final res = await _api.getAddresses(token!);
    addressesLoading.value = false;
    if (res['success'] == true) {
      final body = res['data'] as Map<String, dynamic>;
      addresses.value =
          ((body['data'] ?? body['addresses'] ?? []) as List)
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

  // ── Notifications ─────────────────────────────────────────────────────────────

  Future<void> loadNotifications() async {
    final res = await _api.getNotifications(token!);
    if (res['success'] == true) {
      final body = res['data'] as Map<String, dynamic>;
      notifications.value =
          ((body['data'] ?? body['notifications'] ?? []) as List)
              .map((n) => AppNotification.fromJson(n))
              .toList();
    }
  }

  // ── Checkout Config ───────────────────────────────────────────────────────────

  Future<void> loadCheckoutConfig() async {
    if (checkoutCfgLoaded) return;
    final res = await _api.getCheckoutConfig(token: token);
    if (res['success'] == true) {
      final body = res['data'] as Map<String, dynamic>;
      final cfg  = body['data'] ?? body['config'] ?? body;
      checkoutServiceChargePct   = (cfg['service_charge_pct'] as num?)?.toDouble() ?? 5;
      checkoutDefaultDeliveryFee = (cfg['default_delivery_fee'] as num?)?.toDouble() ?? 500;
      checkoutDeliveryBands      = (cfg['delivery_fee_bands'] as List?)
              ?.map((b) => Map<String, dynamic>.from(b))
              .toList() ??
          [];
      checkoutCfgLoaded = true;
    }
  }

  double calcDeliveryFee(double? distKm) {
    if (distKm == null) return checkoutDefaultDeliveryFee;
    for (final b in checkoutDeliveryBands) {
      final min   = (b['min_km'] as num?)?.toDouble() ?? 0;
      final max   = (b['max_km'] as num?)?.toDouble() ?? 999;
      final price = (b['price'] as num?)?.toDouble() ?? 0;
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

  List<Vendor> get filteredVendors {
    if (vendorSearch.value.isEmpty) return vendors;
    return vendors
        .where((v) =>
            v.name.toLowerCase().contains(vendorSearch.value.toLowerCase()))
        .toList();
  }

  List<Product> get filteredProducts {
    if (prodFilter.value == null || vendorDetail.value == null) return products;
    final cat = vendorDetail.value!.productCategories
        .firstWhereOrNull((c) => c.id == prodFilter.value);
    if (cat == null) return products;
    return products.where((p) => p.category == cat.name).toList();
  }

  void switchTab(int i) {
    currentTab.value = i;
    if (i == 1) loadOrders();
    if (i == 2) loadWallet();
  }
}