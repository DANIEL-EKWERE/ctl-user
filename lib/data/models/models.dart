import '../../../core/utils/app_utils.dart';

// ─── User ────────────────────────────────────────────────────────────────────
class AppUser {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? role;
  final String? referralCode;
  final String? profilePicture;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.role,
    this.referralCode,
    this.profilePicture,
  });

  factory AppUser.fromJson(Map<String, dynamic> j) => AppUser(
    id: j['id'] ?? 0,
    name: j['name'] ?? '',
    email: j['email'] ?? '',
    phone: j['phone']?.toString(),
    role: j['role'],
    referralCode: j['referral_code'],
    profilePicture: j['profile_picture'],
  );

  String get initials => name.isNotEmpty
      ? name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase()
      : 'NK';

  AppUser copyWith({String? name, String? phone}) => AppUser(
    id: id,
    name: name ?? this.name,
    email: email,
    phone: phone ?? this.phone,
    role: role,
    referralCode: referralCode,
    profilePicture: profilePicture,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'role': role,
    'referral_code': referralCode,
    'profile_picture': profilePicture,
  };
}

// ─── Category ────────────────────────────────────────────────────────────────
class Category {
  final int id;
  final String name;
  final String? imageUrl;

  Category({required this.id, required this.name, this.imageUrl});

  factory Category.fromJson(Map<String, dynamic> j) => Category(
    id: j['id'] ?? 0,
    name: j['name'] ?? '',
    imageUrl: j['image_url'],
  );
}

// ─── Vendor ──────────────────────────────────────────────────────────────────
class Vendor {
  final int id;
  final String name;
  final String? address;
  final String? logoUrl;
  final String? bannerUrl;
  final double? rating;
  final int? totalRatings;
  final double? distanceKm;
  final bool isOpen;
  final String? fulfilmentType;
  final List<ProductCategory> productCategories;

  Vendor({
    required this.id,
    required this.name,
    this.address,
    this.logoUrl,
    this.bannerUrl,
    this.rating,
    this.totalRatings,
    this.distanceKm,
    this.isOpen = false,
    this.fulfilmentType,
    this.productCategories = const [],
  });

  factory Vendor.fromJson(Map<String, dynamic> j) => Vendor(
    id: j['id'] ?? 0,
    name: j['name'] ?? j['business_name'] ?? '',
    address: j['address'] ?? j['business_address'],
    logoUrl: j['logo_url'] ?? j['logo'],
    bannerUrl: j['banner_url'] ?? j['banner'],
    rating: (j['rating'] as num?)?.toDouble(),
    totalRatings: j['total_ratings'] as int?,
    distanceKm: (j['distance_km'] as num?)?.toDouble(),
    isOpen: j['is_open'] == true,
    fulfilmentType: j['fulfilment_type'],
    productCategories:
        (j['product_categories'] as List?)
            ?.map((c) => ProductCategory.fromJson(c))
            .toList() ??
        [],
  );

  String get initials => name.isNotEmpty
      ? name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase()
      : 'NK';
}

class ProductCategory {
  final int id;
  final String name;
  ProductCategory({required this.id, required this.name});
  factory ProductCategory.fromJson(Map<String, dynamic> j) =>
      ProductCategory(id: j['id'] ?? 0, name: j['name'] ?? '');
}

// ─── Product ─────────────────────────────────────────────────────────────────
class Product {
  final int id;
  final String name;
  final String? description;
  final double price;
  final double effectivePrice;
  final double? discountPrice;
  final String? imageUrl;
  final String? category;
  final dynamic vendorId;
  final bool isAvailable;

  Product({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.effectivePrice,
    this.discountPrice,
    this.imageUrl,
    this.category,
    this.vendorId,
    this.isAvailable = true,
  });

  factory Product.fromJson(Map<String, dynamic> j) {
    final price = AppUtils.parsePrice(j['price'] ?? 0);
    final effPrice = AppUtils.parsePrice(
      j['effective_price'] ?? j['price'] ?? 0,
    );
    return Product(
      id: j['id'] ?? 0,
      name: j['name'] ?? '',
      description: j['description'],
      price: price,
      effectivePrice: effPrice,
      discountPrice: j['discount_price'] != null
          ? AppUtils.parsePrice(j['discount_price'])
          : null,
      imageUrl: j['image_url'],
      category: j['category'],
      vendorId: j['vendor_id'] as dynamic,
      isAvailable: j['status'] != false,
    );
  }
}

// ─── Cart ────────────────────────────────────────────────────────────────────
class CartItem {
  final int productId;
  final int vendorId;
  final String name;
  final double price;
  final String? imageUrl;
  int quantity;

  CartItem({
    required this.productId,
    required this.vendorId,
    required this.name,
    required this.price,
    this.imageUrl,
    this.quantity = 1,
  });
}

class VendorCart {
  final int vendorId;
  final String vendorName;
  final List<CartItem> items;

  VendorCart({
    required this.vendorId,
    required this.vendorName,
    required this.items,
  });

  double get subtotal => items.fold(0, (s, i) => s + i.price * i.quantity);
  int get totalItems => items.fold(0, (s, i) => s + i.quantity);
}

// ─── Order ───────────────────────────────────────────────────────────────────
// class Order {
//   final int id;
//   final String reference;
//   final String status;
//   final double total;
//   final double? deliveryFee;
//   final double? serviceCharge;
//   final double? subTotal;
//   final bool isPaid;
//   final String? packageType;
//   final String? remark;
//   final OrderAddress? address;
//   final OrderVendor? vendor;
//   final OrderRider? rider;
//   final OrderCustomer? customer;
//   final List<OrderItem> items;
//   final List<OrderHistory> histories;
//   final String? createdAt;

//   Order({
//     required this.id,
//     required this.reference,
//     required this.status,
//     required this.total,
//    //required
//     this.subTotal,
//     this.deliveryFee,
//     this.serviceCharge,
//     required this.isPaid,
//     this.packageType,
//     this.remark,
//     this.address,
//     this.vendor,

//     this.rider,
//     this.customer,
//     this.items = const [],
//     this.histories = const [],
//     this.createdAt,
//   });

//   factory Order.fromJson(Map<String, dynamic> j) => Order(
//     id: j['id'] ?? 0,
//     reference: j['reference'] ?? '',
//     status: j['status'] ?? '',
//     total: AppUtils.parsePrice(j['total'] ?? 0),
//     deliveryFee: j['delivery_fee'] != null
//         ? AppUtils.parsePrice(j['delivery_fee'])
//         : null,
//     serviceCharge: j['service_charge'] != null
//         ? AppUtils.parsePrice(j['service_charge'])
//         : null,
//     isPaid: j['is_paid'] == true,
//     packageType: j['package_type'],
//     remark: j['remark'],
//     address: j['address'] != null ? OrderAddress.fromJson(j['address']) : null,
//     vendor: j['vendor'] != null ? OrderVendor.fromJson(j['vendor']) : null,
//     rider: j['rider'] != null ? OrderRider.fromJson(j['rider']) : null,
//     customer: j['customer'] != null
//         ? OrderCustomer.fromJson(j['customer'])
//         : null,
//     items:
//         (j['items'] as List?)?.map((i) => OrderItem.fromJson(i)).toList() ?? [],
//     histories:
//         (j['histories'] as List?)
//             ?.map((h) => OrderHistory.fromJson(h))
//             .toList() ??
//         [],
//     createdAt: j['created_at'],
//   );

//   bool get isOngoing => AppUtils.isOngoingOrder(status);
// }

// class OrderAddress {
//   final String contactAddress;
//   final String? state;
//   final String? lga;
//   final double? lat;
//   final double? lng;
//   final String? phone;

//   OrderAddress({
//     required this.contactAddress,
//     this.state,
//     this.lga,
//     this.lat,
//     this.lng,
//     this.phone,
//   });

//   factory OrderAddress.fromJson(Map<String, dynamic> j) => OrderAddress(
//     contactAddress: j['contact_address'] ?? '',
//     state: j['state'],
//     lga: j['lga'],
//     lat: double.tryParse(j['lat']?.toString() ?? ''),
//     lng: double.tryParse(j['lon']?.toString() ?? ''),
//     phone: j['phone_number'],
//   );
// }

// class OrderVendor {
//   final int id;
//   final String name;
//   final String? address;
//   final String? logo;
//   final String? phone;

//   OrderVendor({
//     required this.id,
//     required this.name,
//     this.address,
//     this.logo,
//     this.phone,
//   });

//   factory OrderVendor.fromJson(Map<String, dynamic> j) => OrderVendor(
//     id: j['id'] ?? 0,
//     name: j['business_name'] ?? j['name'] ?? '',
//     address: j['business_address'] ?? j['address'],
//     logo: j['logo'],
//     phone: j['phone_number'],
//   );
// }

// class OrderRider {
//   final int id;
//   final String name;
//   final String? phone;

//   OrderRider({required this.id, required this.name, this.phone});

//   factory OrderRider.fromJson(Map<String, dynamic> j) => OrderRider(
//     id: j['id'] ?? 0,
//     name: j['name'] ?? '',
//     phone: j['phone'] ?? j['phone_number'],
//   );
// }

// class OrderCustomer {
//   final int id;
//   final String name;
//   final String? phone;
//   final String? email;

//   OrderCustomer({required this.id, required this.name, this.phone, this.email});

//   factory OrderCustomer.fromJson(Map<String, dynamic> j) => OrderCustomer(
//     id: j['id'] ?? 0,
//     name: j['name'] ?? '',
//     phone: j['phone_number']?.toString(),
//     email: j['email'],
//   );
// }

// class OrderItem {
//   final int productId;
//   final String productName;
//   final int quantity;
//   final double unitPrice;
//   final double subTotal;

//   OrderItem({
//     required this.productId,
//     required this.productName,
//     required this.quantity,
//     required this.unitPrice,
//     required this.subTotal,
//   });

//   factory OrderItem.fromJson(Map<String, dynamic> j) => OrderItem(
//     productId: int.tryParse(j['product_id']?.toString() ?? '') ?? 0,
//     productName: j['product']?['name'] ?? '',
//     quantity: int.tryParse(j['quantity']?.toString() ?? '') ?? 1,
//     unitPrice: AppUtils.parsePrice(j['unit_price'] ?? 0),
//     subTotal: AppUtils.parsePrice(j['sub_total'] ?? 0),
//   );
// }

// class OrderHistory {
//   final String status;
//   final String? changedBy;
//   final String? createdAt;

//   OrderHistory({required this.status, this.changedBy, this.createdAt});

//   factory OrderHistory.fromJson(Map<String, dynamic> j) => OrderHistory(
//     status: j['status'] ?? '',
//     changedBy: j['changed_by'],
//     createdAt: j['created_at'],
//   );
// }

class Order {
  final int id;
  final String reference;
  final String status;
  final String? statusLabel;
  final double total;
  final double? deliveryFee;
  final double? serviceCharge;
  final double? subTotal;
  final bool isPaid;
  final String? paymentMethod;
  final String? packageType;
  final String? notes;
  final String? deliveryAddress;
  final String? deliveryCity;
  final String? deliveryState;
  final OrderVendor? vendor;
  final OrderRider? rider;
  final OrderCustomer? customer;
  final List<OrderItem> items;
  final List<OrderHistory> histories;
  final String? createdAt;

  Order({
    required this.id,
    required this.reference,
    required this.status,
    this.statusLabel,
    required this.total,
    this.subTotal,
    this.deliveryFee,
    this.serviceCharge,
    required this.isPaid,
    this.paymentMethod,
    this.packageType,
    this.notes,
    this.deliveryAddress,
    this.deliveryCity,
    this.deliveryState,
    this.vendor,
    this.rider,
    this.customer,
    this.items = const [],
    this.histories = const [],
    this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> j) => Order(
    id: j['id'] ?? 0,
    reference: j['reference'] ?? '',
    status: j['status'] ?? '',
    statusLabel: j['status_label'],
    total: AppUtils.parsePrice(j['total'] ?? 0),
    subTotal: j['subtotal'] != null ? AppUtils.parsePrice(j['subtotal']) : null,
    deliveryFee: j['delivery_fee'] != null
        ? AppUtils.parsePrice(j['delivery_fee'])
        : null,
    serviceCharge: j['service_charge'] != null
        ? AppUtils.parsePrice(j['service_charge'])
        : null,
    isPaid: j['is_paid'] == true,
    paymentMethod: j['payment_method'],
    packageType: j['package_type'],
    notes: j['notes'],
    deliveryAddress: j['delivery_address'],
    deliveryCity: j['delivery_city'],
    deliveryState: j['delivery_state'],
    vendor: j['vendor'] != null ? OrderVendor.fromJson(j['vendor']) : null,
    rider: j['rider'] != null ? OrderRider.fromJson(j['rider']) : null,
    customer: j['customer'] != null
        ? OrderCustomer.fromJson(j['customer'])
        : null,
    items:
        (j['items'] as List?)?.map((i) => OrderItem.fromJson(i)).toList() ?? [],
    histories:
        (j['status_history'] as List?)
            ?.map((h) => OrderHistory.fromJson(h))
            .toList() ??
        [],
    createdAt: j['date'] ?? j['created_at'],
  );

  bool get isOngoing => AppUtils.isOngoingOrder(status);
}

class OrderItem {
  final String productName;
  final int quantity;
  final double unitPrice;
  final double subTotal;

  OrderItem({
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.subTotal,
  });

  factory OrderItem.fromJson(Map<String, dynamic> j) => OrderItem(
    productName: j['product_name'] ?? j['product']?['name'] ?? '',
    quantity: int.tryParse(j['quantity']?.toString() ?? '') ?? 1,
    unitPrice: AppUtils.parsePrice(j['unit_price'] ?? 0),
    subTotal: AppUtils.parsePrice(j['subtotal'] ?? j['sub_total'] ?? 0),
  );
}

class OrderHistory {
  final String status;
  final String? note;
  final String? createdAt;

  OrderHistory({required this.status, this.note, this.createdAt});

  factory OrderHistory.fromJson(Map<String, dynamic> j) => OrderHistory(
    status: j['status'] ?? '',
    note: j['note'] ?? j['changed_by'],
    createdAt: j['date'] ?? j['created_at'],
  );
}

class OrderVendor {
  final int id;
  final String name;
  final String? address;
  final String? logo;
  final String? phone;

  OrderVendor({
    required this.id,
    required this.name,
    this.address,
    this.logo,
    this.phone,
  });

  factory OrderVendor.fromJson(Map<String, dynamic> j) => OrderVendor(
    id: j['id'] ?? 0,
    name: j['name'] ?? j['business_name'] ?? '',
    address: j['address'] ?? j['business_address'],
    logo: j['logo'],
    phone: j['phone'] ?? j['phone_number'],
  );
}

class OrderRider {
  final int id;
  final String name;
  final String? phone;

  OrderRider({required this.id, required this.name, this.phone});

  factory OrderRider.fromJson(Map<String, dynamic> j) => OrderRider(
    id: j['id'] ?? 0,
    name: j['name'] ?? '',
    phone: j['phone'] ?? j['phone_number'],
  );
}

class OrderCustomer {
  final int id;
  final String name;
  final String? phone;
  final String? email;

  OrderCustomer({required this.id, required this.name, this.phone, this.email});

  factory OrderCustomer.fromJson(Map<String, dynamic> j) => OrderCustomer(
    id: j['id'] ?? 0,
    name: j['name'] ?? '',
    phone: j['phone_number']?.toString(),
    email: j['email'],
  );
}

// ─── Address ─────────────────────────────────────────────────────────────────
class DeliveryAddress {
  final int? id;
  final String label;
  final String address;
  final String? city;
  final String? state;
  final double? latitude;
  final double? longitude;
  final bool isDefault;

  DeliveryAddress({
    this.id,
    required this.label,
    required this.address,
    this.city,
    this.state,
    this.latitude,
    this.longitude,
    this.isDefault = false,
  });

  factory DeliveryAddress.fromJson(Map<String, dynamic> j) => DeliveryAddress(
    id: j['id'] as int?,
    label: j['label'] ?? 'Home',
    address: j['address'] ?? j['contact_address'] ?? '',
    city: j['city'],
    state: j['state'],
    latitude: double.tryParse(
      j['latitude']?.toString() ?? j['lat']?.toString() ?? '',
    ),
    longitude: double.tryParse(
      j['longitude']?.toString() ?? j['lon']?.toString() ?? '',
    ),
    isDefault: j['is_default'] == true || j['is_default'] == '1',
  );
}

// ─── Wallet ──────────────────────────────────────────────────────────────────
class WalletTransaction {
  final String type; // credit | debit
  final String? description;
  final String? category;
  final double amount;
  final double? balanceAfter;
  final String? date;

  WalletTransaction({
    required this.type,
    this.description,
    this.category,
    required this.amount,
    this.balanceAfter,
    this.date,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> j) =>
      WalletTransaction(
        type: j['type'] ?? 'credit',
        description: j['description'],
        category: j['category'],
        amount: AppUtils.parsePrice(j['amount'] ?? 0),
        balanceAfter: j['balance_after'] != null
            ? AppUtils.parsePrice(j['balance_after'])
            : null,
        date: j['date'] ?? j['created_at'],
      );
}

// ─── Review ──────────────────────────────────────────────────────────────────
class Review {
  final int id;
  final String? customerName;
  final String? review;
  final int rating;
  final String? comment;
  final String? createdAt;

  Review({
    required this.id,
    this.customerName,
    required this.rating,
    this.review,
    this.comment,
    this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> j) => Review(
    id: j['id'] ?? 0,
    customerName: j['customer']?['name'] ?? j['customer_name'],
    rating: j['rating'] ?? 0,
    comment: j['comment'],
    review: j['review'],
    createdAt: j['created_at'],
  );
}

class ReviewStats {
  final double average;
  final String total;
  final Map<int, int> distribution;

  ReviewStats({
    required this.average,
    required this.total,
    required this.distribution,
  });

  factory ReviewStats.fromJson(Map<String, dynamic> j) {
    final dynamic distData = j['distribution'];
    final Map<int, int> parsedDistribution = {};

    if (distData is Map) {
      for (final entry in distData.entries) {
        final key = int.tryParse(entry.key.toString()) ?? 0;
        final value = entry.value;
        final intValue = value is num
            ? value.toInt()
            : int.tryParse(value?.toString() ?? '') ?? 0;
        parsedDistribution[key] = intValue;
      }
    } else if (distData is List) {
      for (var i = 0; i < distData.length; i++) {
        final item = distData[i];
        if (item is num) {
          parsedDistribution[i + 1] = item.toInt();
        } else if (item is Map) {
          final rating = item['rating'] ?? item['key'] ?? item['star'] ?? i + 1;
          final count = item['count'] ?? item['value'] ?? item['qty'] ?? 0;
          final key = rating is num
              ? rating.toInt()
              : int.tryParse(rating?.toString() ?? '') ?? (i + 1);
          final val = count is num
              ? count.toInt()
              : int.tryParse(count?.toString() ?? '') ?? 0;
          parsedDistribution[key] = val;
        }
      }
    }

    return ReviewStats(
      average: (j['average'] as num?)?.toDouble() ?? 0,
      total: j['total']?.toString() ?? '0',
      distribution: parsedDistribution,
    );
  }
}

// ─── Rider Dashboard ─────────────────────────────────────────────────────────
class RiderDashboard {
  final int totalDeliveries;
  final double totalEarnings;
  final int pendingDeliveries;
  final bool isAvailable;

  RiderDashboard({
    required this.totalDeliveries,
    required this.totalEarnings,
    required this.pendingDeliveries,
    this.isAvailable = false,
  });

  factory RiderDashboard.fromJson(Map<String, dynamic> j) {
    final d = j['data'] ?? j;
    return RiderDashboard(
      totalDeliveries: d['total_deliveries'] ?? 0,
      totalEarnings: AppUtils.parsePrice(d['total_earnings'] ?? 0),
      pendingDeliveries: d['pending_deliveries'] ?? 0,
      isAvailable: d['is_available'] == true || d['is_available'] == 1,
    );
  }
}

// ─── Bank / Payment ──────────────────────────────────────────────────────────
class BankOption {
  final String name;
  final String code;
  BankOption({required this.name, required this.code});
  factory BankOption.fromJson(Map<String, dynamic> j) =>
      BankOption(name: j['name'] ?? '', code: j['code'] ?? '');
}

class BankAccount {
  final int id;
  final String bankName;
  final String bankCode;
  final String accountNumber;
  final String accountName;
  final bool isDefault;

  BankAccount({
    required this.id,
    required this.bankName,
    required this.bankCode,
    required this.accountNumber,
    required this.accountName,
    required this.isDefault,
  });

  factory BankAccount.fromJson(Map<String, dynamic> j) => BankAccount(
    id: j['id'] ?? 0,
    bankName: j['bank_name'] ?? '',
    bankCode: j['bank_code'] ?? '',
    accountNumber: j['account_number'] ?? '',
    accountName: j['account_name'] ?? '',
    isDefault: j['is_default'] == true || j['is_default'] == 1,
  );
}

// ─── Notification ────────────────────────────────────────────────────────────
class AppNotification {
  final String id; // Laravel notification IDs are UUIDs
  final String title;
  final String? body;
  final bool isRead;
  final String? createdAt;
  final String? route; // optional deep-link route from notification payload

  AppNotification({
    required this.id,
    required this.title,
    this.body,
    required this.isRead,
    this.createdAt,
    this.route,
  });

  AppNotification copyWith({bool? isRead}) => AppNotification(
        id: id,
        title: title,
        body: body,
        isRead: isRead ?? this.isRead,
        createdAt: createdAt,
        route: route,
      );

  factory AppNotification.fromJson(Map<String, dynamic> j) {
    // Laravel notifications nest payload inside a 'data' map
    final nested = j['data'] is Map<String, dynamic>
        ? j['data'] as Map<String, dynamic>
        : <String, dynamic>{};
    return AppNotification(
      id: j['id']?.toString() ?? '',
      title: nested['title'] ?? j['title'] ?? '',
      body: nested['body'] ?? nested['message'] ?? j['body'] ?? j['message'],
      isRead: j['read_at'] != null || j['is_read'] == true || j['is_read'] == 1,
      createdAt: j['created_at'],
      route: nested['route'] as String?,
    );
  }
}
