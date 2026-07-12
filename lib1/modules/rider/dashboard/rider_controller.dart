import 'package:get/get.dart';
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

  final walletBalance = 0.0.obs;
  final walletTxns    = <WalletTransaction>[].obs;

  final loading = false.obs;
  final error   = RxnString();

  String? get token => AuthController.to.riderToken;

  @override
  void onInit() {
    super.onInit();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    if (token == null) return;
    loading.value = true;
    final results = await Future.wait([
      _api.getRiderDashboard(token!),
      _api.getAvailableOrders(token!, radiusKm: 10),
      _api.getMyDeliveries(token!),
    ]);
    loading.value = false;

    if (results[0]['success'] == true) {
      dashboard.value = RiderDashboard.fromJson(results[0]['data']);
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

  Future<bool> acceptOrder(int id) async {
    final res = await _api.acceptOrder(id, token!);
    if (res['success'] == true) {
      await loadDashboard();
      Get.snackbar('', '✅ Order accepted!', snackPosition: SnackPosition.BOTTOM);
      return true;
    }
    Get.snackbar('Error', res['message'] ?? 'Failed', snackPosition: SnackPosition.BOTTOM);
    return false;
  }

  Future<bool> rejectOrder(int id, {String? reason}) async {
    final res = await _api.rejectOrder(id, token!, reason: reason);
    if (res['success'] == true) {
      await loadAvailableOrders();
      return true;
    }
    Get.snackbar('Error', res['message'] ?? 'Failed', snackPosition: SnackPosition.BOTTOM);
    return false;
  }

  Future<bool> markDelivered(int id) async {
    final res = await _api.markDelivered(id, token!);
    if (res['success'] == true) {
      Get.snackbar('', '✅ Delivered! Earnings credited 💰', snackPosition: SnackPosition.BOTTOM);
      await loadMyDeliveries();
      return true;
    }
    Get.snackbar('Error', res['message'] ?? 'Failed', snackPosition: SnackPosition.BOTTOM);
    return false;
  }

  Future<void> loadWallet() async {
    final results = await Future.wait([
      _api.getRiderWalletBalance(token!),
      _api.getRiderWalletTransactions(token!),
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
  }

  void switchTab(int i) {
    currentTab.value = i;
    if (i == 0) loadDashboard();
    if (i == 2) loadWallet();
  }
}