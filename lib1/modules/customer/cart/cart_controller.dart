import 'package:get/get.dart';
import '../../../data/models/models.dart';


class CartController extends GetxController {
  static CartController get to => Get.find();

  // vendorId -> VendorCart
  final RxMap<int, VendorCart> _cart = <int, VendorCart>{}.obs;

  Map<int, VendorCart> get cart => _cart;
  int get totalItems => _cart.values.fold(0, (s, v) => s + v.totalItems);
  bool get isEmpty => _cart.isEmpty;

  VendorCart? vendorCart(int vendorId) => _cart[vendorId];

  int itemQty(int vendorId, int productId) =>
      _cart[vendorId]?.items.firstWhereOrNull((i) => i.productId == productId)?.quantity ?? 0;

  void addItem(int vendorId, String vendorName, Product product) {
    if (!_cart.containsKey(vendorId)) {
      _cart[vendorId] = VendorCart(vendorId: vendorId, vendorName: vendorName, items: []);
    }
    final items = _cart[vendorId]!.items;
    final existing = items.firstWhereOrNull((i) => i.productId == product.id);
    if (existing != null) {
      existing.quantity++;
    } else {
      items.add(CartItem(
        productId: product.id,
        vendorId: vendorId,
        name: product.name,
        price: product.effectivePrice,
        imageUrl: product.imageUrl,
      ));
    }
    _cart.refresh();
    Get.snackbar('Added', '${product.name} added ✓',
        snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 1));
  }

  void increment(int vendorId, int productId) {
    final item = _cart[vendorId]?.items.firstWhereOrNull((i) => i.productId == productId);
    if (item != null) { item.quantity++; _cart.refresh(); }
  }

  void decrement(int vendorId, int productId) {
    final cart = _cart[vendorId];
    if (cart == null) return;
    final item = cart.items.firstWhereOrNull((i) => i.productId == productId);
    if (item == null) return;
    item.quantity--;
    if (item.quantity <= 0) cart.items.removeWhere((i) => i.productId == productId);
    if (cart.items.isEmpty) _cart.remove(vendorId);
    _cart.refresh();
  }

  void clearVendor(int vendorId) { _cart.remove(vendorId); _cart.refresh(); }
  void clearAll() { _cart.clear(); }
}