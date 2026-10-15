import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/utils/toast.dart';
import '../../../data/models/models.dart';
import '../../../data/services/api_client.dart';
import '../../auth/auth_controller.dart';

class RiderController extends GetxController {
  static RiderController get to => Get.find();

  final _api = ApiClient.instance;

  final currentTab = 0.obs;

  final dashboard    = Rxn<RiderDashboard>();
  final availOrders  = <Order>[].obs;
  final myDeliveries = <Order>[].obs;
  final orderDetail  = Rxn<Order>();

  final walletBalance  = 0.0.obs;
  final walletTxns     = <WalletTransaction>[].obs;
  final bankAccounts   = <BankAccount>[].obs;
  final availableBanks = <BankOption>[].obs;

  final loading     = false.obs;
  final error       = RxnString();
  final isAvailable = false.obs;
  final togglingAvailability = false.obs;

  /// Onboarding record from `rider/info` (vehicle, guarantor, documents, status).
  final riderInfo = Rxn<Map<String, dynamic>>();

  static const requiredFields = {
    'vehicle_type': 'Vehicle type',
    'plate_number': 'Plate number',
    'license_number': 'License number',
    'home_address': 'Home address',
    'guarantor_name': 'Guarantor name',
    'guarantor_phone': 'Guarantor phone',
  };

  static const requiredDocuments = {
    'means_of_id': 'Means of ID',
    'drivers_license': "Driver's license",
    'vehicle_document': 'Vehicle document',
    'guarantor_form': 'Guarantor form',
  };

  /// Labels of onboarding items the rider still has to provide.
  List<String> get missingOnboardingItems {
    final info = riderInfo.value;
    if (info == null) return [];
    final docs = info['documents'] is Map ? info['documents'] as Map : const {};
    return [
      for (final e in requiredFields.entries)
        if ((info[e.key]?.toString() ?? '').trim().isEmpty) e.value,
      for (final e in requiredDocuments.entries)
        if (docs[e.key] == null) e.value,
    ];
  }

  String get approvalStatus =>
      (riderInfo.value?['status'] ?? dashboard.value?.approvalStatus ?? '')
          .toString()
          .toLowerCase();

  bool get isApproved =>
      approvalStatus == 'approved' ||
      approvalStatus == 'active' ||
      riderInfo.value?['approved_at'] != null;

  /// True only when the API reports a status and it isn't an approved one,
  /// so riders aren't blocked if the backend omits the field.
  bool get awaitingApproval => approvalStatus.isNotEmpty && !isApproved;

  Timer? _locationTimer;

  String? get token => AuthController.to.riderToken;

  @override
  void onInit() {
    super.onInit();
    loadDashboard();
  }

  @override
  void onClose() {
    _locationTimer?.cancel();
    super.onClose();
  }

  Future<void> loadDashboard() async {
    if (token == null) return;
    loading.value = true;
    final results = await Future.wait([
      _api.getRiderDashboard(token!),
      _api.getAvailableOrders(token!, radiusKm: 10),
      _api.getMyDeliveries(token!),
      _api.getRiderInfo(token!),
    ]);
    loading.value = false;

    if (results[3]['success'] == true) {
      final body = results[3]['data'] as Map<String, dynamic>;
      final r = body['rider'] ?? body['data'] ?? body;
      if (r is Map<String, dynamic>) riderInfo.value = r;
    }

    if (results[0]['success'] == true) {
      final d = RiderDashboard.fromJson(results[0]['data']);
      dashboard.value = d;
      isAvailable.value = d.isAvailable;
      if (d.isAvailable) {
        _startLocationUpdates();
      } else {
        _stopLocationUpdates();
      }
    }
    if (results[1]['success'] == true) {
      final body = results[1]['data'] as Map<String, dynamic>;
      availOrders.value = ((body['data'] ?? body['orders'] ?? []) as List)
          .map((o) => Order.fromJson(o)).toList();
    }
    if (results[2]['success'] == true) {
      final body = results[2]['data'] as Map<String, dynamic>;
      myDeliveries.value = ((body['data'] ?? body['orders'] ?? []) as List)
          .map((o) => Order.fromJson(o)).toList();
    }
  }

  Future<void> loadAvailableOrders() async {
    final res = await _api.getAvailableOrders(token!, radiusKm: 10);
    if (res['success'] == true) {
      final body = res['data'] as Map<String, dynamic>;
      availOrders.value = ((body['data'] ?? body['orders'] ?? []) as List)
          .map((o) => Order.fromJson(o)).toList();
    }
  }

  Future<void> loadMyDeliveries() async {
    final res = await _api.getMyDeliveries(token!);
    if (res['success'] == true) {
      final body = res['data'] as Map<String, dynamic>;
      myDeliveries.value = ((body['data'] ?? body['orders'] ?? []) as List)
          .map((o) => Order.fromJson(o)).toList();
    }
  }

  Future<void> loadRiderInfo() async {
    if (token == null) return;
    final res = await _api.getRiderInfo(token!);
    if (res['success'] == true) {
      final body = res['data'] as Map<String, dynamic>;
      final r = body['rider'] ?? body['data'] ?? body;
      if (r is Map<String, dynamic>) riderInfo.value = r;
    }
  }

  Future<void> toggleAvailability() async {
    if (togglingAvailability.value) return;
    // Explain why a rider can't go online instead of a silent failure.
    if (!isAvailable.value && riderInfo.value != null) {
      if (missingOnboardingItems.isNotEmpty) {
        showToast(
          'Complete your rider profile before going online.',
          isError: true,
        );
        return;
      }
      if (awaitingApproval) {
        showToast(
          'Your account is awaiting approval. You can go online once approved.',
          isError: true,
        );
        return;
      }
    }
    togglingAvailability.value = true;
    final res = await _api.toggleAvailability(token!);
    togglingAvailability.value = false;
    if (res['success'] == true) {
      final body = res['data'] as Map<String, dynamic>;
      final nowAvailable = body['is_available'] == true || body['is_available'] == 1;
      isAvailable.value = nowAvailable;
      if (nowAvailable) {
        _startLocationUpdates();
        showToast('You are now online');
      } else {
        _stopLocationUpdates();
        showToast('You are now offline');
      }
    } else {
      showToast(res['message'] ?? 'Failed', isError: true);
    }
  }

  void _startLocationUpdates() {
    _locationTimer?.cancel();
    _pushLocation();
    _locationTimer = Timer.periodic(const Duration(seconds: 60), (_) => _pushLocation());
  }

  void _stopLocationUpdates() {
    _locationTimer?.cancel();
    _locationTimer = null;
  }

  Future<void> _pushLocation() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) return;
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      ).timeout(const Duration(seconds: 10));
      await _api.updateRiderLocation({
        'latitude': pos.latitude,
        'longitude': pos.longitude,
      }, token!);
    } catch (_) {}
  }

  Future<bool> acceptOrder(int id) async {
    final res = await _api.acceptOrder(id, token!);
    if (res['success'] == true) {
      await loadDashboard();
      showToast('Order accepted!');
      return true;
    }
    showToast(res['message'] ?? 'Failed', isError: true);
    return false;
  }

  Future<bool> rejectOrder(int id, {String? reason}) async {
    final res = await _api.rejectOrder(id, token!, reason: reason);
    if (res['success'] == true) {
      await loadAvailableOrders();
      return true;
    }
    showToast(res['message'] ?? 'Failed', isError: true);
    return false;
  }

  Future<bool> markDelivered(int id) async {
    final res = await _api.markDelivered(id, token!);
    if (res['success'] == true) {
      showToast('Delivered! Earnings credited.');
      await loadMyDeliveries();
      return true;
    }
    showToast(res['message'] ?? 'Failed', isError: true);
    return false;
  }

  Future<void> loadWallet() async {
    final results = await Future.wait([
      _api.getRiderWalletBalance(token!),
      _api.getRiderWalletTransactions(token!),
      _api.listBankAccounts(token!),
    ]);
    if (results[0]['success'] == true) {
      final body = results[0]['data'] as Map<String, dynamic>;
      walletBalance.value = double.tryParse((body['balance'] ?? 0).toString()) ?? 0;
    }
    if (results[1]['success'] == true) {
      final body = results[1]['data'] as Map<String, dynamic>;
      walletTxns.value = ((body['data'] ?? body['transactions'] ?? []) as List)
          .map((t) => WalletTransaction.fromJson(t)).toList();
    }
    if (results[2]['success'] == true) {
      final body = results[2]['data'] as Map<String, dynamic>;
      debugPrint('Bank accounts response: $body');
      final raw = body['data'] ?? body['bank_accounts'] ?? body['accounts'] ?? body['raw_list'] ?? [];
      bankAccounts.value = (raw as List)
          .map((b) => BankAccount.fromJson(b as Map<String, dynamic>)).toList();
      debugPrint('Bank accounts loaded: ${bankAccounts.length}');
    }
  }

  Future<void> loadBanks() async {
    if (availableBanks.isNotEmpty) return;
    final res = await _api.listBanks(token!);
    debugPrint('loadBanks response: $res');
    if (res['success'] == true) {
      final body = res['data'] as Map<String, dynamic>;
      final raw = body['data'] ?? body['banks'] ?? body['raw_list'] ?? [];
      availableBanks.value = (raw as List)
          .map((b) => BankOption.fromJson(b as Map<String, dynamic>)).toList();
      debugPrint('Banks loaded: ${availableBanks.length}');
    } else {
      showToast(res['message'] ?? 'Failed to load banks', isError: true);
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

  /// No update endpoint exists, so save the corrected account first and
  /// only then remove the old one — the rider is never left without one.
  Future<bool> updateBankAccount(
    BankAccount old,
    Map<String, dynamic> data,
  ) async {
    final add = await _api.addBankAccount(data, token!);
    if (add['success'] != true) {
      showToast(add['message'] ?? 'Could not save changes', isError: true);
      return false;
    }
    final del = await _api.deleteBankAccount(old.id, token!);
    await loadWallet();
    if (del['success'] != true) {
      showToast(
        'New details saved, but the old account could not be removed: '
        '${del['message'] ?? 'unknown error'}',
        isError: true,
      );
      return true;
    }
    showToast('Bank account updated');
    return true;
  }

  Future<bool> deleteBankAccount(BankAccount account) async {
    final res = await _api.deleteBankAccount(account.id, token!);
    if (res['success'] == true) {
      await loadWallet();
      showToast('Bank account removed');
      return true;
    }
    showToast(res['message'] ?? 'Failed to remove account', isError: true);
    return false;
  }

  Future<bool> setTransactionPin(String pin) async {
    final res = await _api.setTransactionPin({
      'pin': pin,
      'pin_confirmation': pin,
    }, token!);
    if (res['success'] == true) {
      showToast('Transaction PIN set successfully');
      return true;
    }
    showToast(res['message'] ?? 'Failed', isError: true);
    return false;
  }

  Future<bool> withdrawEarnings({
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

  int get acceptedOrdersCount =>
      myDeliveries.where((o) => AppUtils.isOngoingOrder(o.status)).length;

  int get completedOrdersCount =>
      myDeliveries.where((o) => o.status == 'delivered').length;

  void switchTab(int i) {
    currentTab.value = i;
    if (i == 0) loadDashboard();
    if (i == 2) loadWallet();
  }
}
