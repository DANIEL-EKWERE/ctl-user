import 'package:ctluser/utils/api_client.dart';
import 'package:get/get.dart';
//import '../utils/api_client.dart';

class CartItem {
  final int productId;
  final String productName;
  final double price;
  final String? imageUrl;
  final int vendorId;
  final String vendorName;
  int quantity;
  int? cartItemId;

  CartItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.vendorId,
    required this.vendorName,
    this.imageUrl,
    this.quantity = 1,
    this.cartItemId,
  });

  double get subtotal => price * quantity;
}

class CartController extends GetxController {
  final RxList<CartItem> items = <CartItem>[].obs;
  final RxBool isLoading = false.obs;

  /// Grouped by vendor
  Map<int, List<CartItem>> get groupedByVendor {
    final map = <int, List<CartItem>>{};
    for (final item in items) {
      map.putIfAbsent(item.vendorId, () => []).add(item);
    }
    return map;
  }

  int get totalItemCount => items.fold(0, (sum, i) => sum + i.quantity);

  double get totalAmount => items.fold(0.0, (sum, i) => sum + i.subtotal);

  double subtotalForVendor(int vendorId) {
    return items
        .where((i) => i.vendorId == vendorId)
        .fold(0.0, (sum, i) => sum + i.subtotal);
  }

  void addItem(CartItem item) {
    final idx = items.indexWhere(
      (i) => i.productId == item.productId && i.vendorId == item.vendorId,
    );
    if (idx >= 0) {
      items[idx].quantity += item.quantity;
      items.refresh();
    } else {
      items.add(item);
    }
    _syncToApi(item.productId, item.quantity, item.vendorId);
  }

  void increment(int productId, int vendorId) {
    final idx = items.indexWhere(
      (i) => i.productId == productId && i.vendorId == vendorId,
    );
    if (idx >= 0) {
      items[idx].quantity++;
      items.refresh();
    }
  }

  void decrement(int productId, int vendorId) {
    final idx = items.indexWhere(
      (i) => i.productId == productId && i.vendorId == vendorId,
    );
    if (idx >= 0) {
      if (items[idx].quantity > 1) {
        items[idx].quantity--;
        items.refresh();
      } else {
        items.removeAt(idx);
      }
    }
  }

  void removeItem(int productId, int vendorId) {
    items.removeWhere(
      (i) => i.productId == productId && i.vendorId == vendorId,
    );
  }

  void clearVendorCart(int vendorId) {
    items.removeWhere((i) => i.vendorId == vendorId);
  }

  void clearAll() {
    items.clear();
  }

  int quantityOf(int productId, int vendorId) {
    final item = items.firstWhereOrNull(
      (i) => i.productId == productId && i.vendorId == vendorId,
    );
    return item?.quantity ?? 0;
  }

  Future<void> _syncToApi(int productId, int quantity, int vendorId) async {
    await ApiClient.instance.addToCart(
      productId: productId,
      quantity: quantity,
      vendorId: vendorId,
    );
  }
}
