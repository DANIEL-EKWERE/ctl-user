// ─────────────────────────────────────────────────────────────────────────────
// All data models
// ─────────────────────────────────────────────────────────────────────────────

class UserModel {
  final int id;
  final String name, email, phone, role;
  final String avatarUrl, referralCode;
  final bool isEmailVerified;
  final double walletBalance;
  final bool isRider;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.isRider = false,
    this.avatarUrl = '',
    this.referralCode = '',
    this.isEmailVerified = false,
    this.walletBalance = 0,
  });

  String get initials => name.isNotEmpty
      ? name
            .split(' ')
            .take(2)
            .map((w) => w.isEmpty ? '' : w[0])
            .join()
            .toUpperCase()
      : 'U';

  factory UserModel.fromJson(Map<String, dynamic> j) => UserModel(
    id: j['id'] ?? 0,
    name: j['name'] ?? '',
    email: j['email'] ?? '',
    phone: j['phone'] ?? '',
    isRider: j['role'] == 'rider' ? true : false,
    role: j['role'] ?? 'customer',
    avatarUrl: j['avatar_url'] ?? '',
    referralCode: j['referral_code'] ?? '',
    isEmailVerified: j['is_email_verified'] ?? false,
    walletBalance: (j['wallet_balance'] as num?)?.toDouble() ?? 0,
  );
}

class AddressModel {
  final int id;
  final String label, address;
  final String? city, state;
  final double? latitude, longitude;
  final bool isDefault;

  const AddressModel({
    required this.id,
    required this.label,
    required this.address,
    this.city,
    this.state,
    this.latitude,
    this.longitude,
    this.isDefault = false,
  });

  factory AddressModel.fromJson(Map<String, dynamic> j) => AddressModel(
    id: j['id'] ?? 0,
    label: j['label'] ?? 'Home',
    address: j['address'] ?? '',
    city: j['city'],
    state: j['state'],
    latitude: (j['latitude'] as num?)?.toDouble(),
    longitude: (j['longitude'] as num?)?.toDouble(),
    isDefault: j['is_default'] ?? false,
  );

  factory AddressModel.empty() =>
      const AddressModel(id: 0, label: '', address: '', isDefault: false);
}

class CategoryModel {
  final int id;
  final String name, slug;
  final String? imageUrl;
  const CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    this.imageUrl,
  });
  factory CategoryModel.fromJson(Map<String, dynamic> j) => CategoryModel(
    id: j['id'] ?? 0,
    name: j['name'] ?? '',
    slug: j['slug'] ?? '',
    imageUrl: j['image_url'],
  );
}

class VendorModel {
  final int id;
  final String name, slug, logoUrl, address;
  final String? bannerUrl, city, state, category, phone, description;
  final double rating;
  final int totalRatings;
  final bool isOpen;
  final double? distanceKm;

  const VendorModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.logoUrl,
    required this.address,
    this.bannerUrl,
    this.city,
    this.state,
    this.category,
    this.phone,
    this.description,
    required this.rating,
    required this.totalRatings,
    required this.isOpen,
    this.distanceKm,
  });

  String get initials => name.isNotEmpty
      ? name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase()
      : 'V';
  String get distanceLabel {
    if (distanceKm == null) return '';
    return distanceKm! < 1
        ? '${(distanceKm! * 1000).round()}m'
        : '${distanceKm!.toStringAsFixed(1)}km';
  }

  factory VendorModel.fromJson(Map<String, dynamic> j) {
    final stats = j['review_stats'] as Map<String, dynamic>?;
    return VendorModel(
      id: j['id'] ?? 0,
      name: j['business_name'] ?? j['name'] ?? '',
      slug: j['slug'] ?? '',
      logoUrl: j['logo_url'] ?? '',
      bannerUrl: j['banner_url'],
      address: j['address'] ?? '',
      city: j['city'],
      state: j['state'],
      category: j['category'],
      phone: j['phone'],
      description: j['description'],
      rating: stats != null
          ? (stats['average'] as num?)?.toDouble() ??
                (j['rating'] as num?)?.toDouble() ??
                0
          : (j['rating'] as num?)?.toDouble() ?? 0,
      totalRatings: stats != null
          ? (stats['total'] as num?)?.toInt() ??
                (j['total_ratings'] as num?)?.toInt() ??
                0
          : (j['total_ratings'] as num?)?.toInt() ?? 0,
      isOpen: j['is_open'] ?? false,
      distanceKm: (j['distance_km'] as num?)?.toDouble(),
    );
  }
}

class ProductModel {
  final int id;
  final int? vendorId;
  final String name, slug, imageUrl;
  final double price, effectivePrice;
  final double? discountPrice;
  final String? discountType, category, description;
  final bool isInStock;

  const ProductModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.imageUrl,
    required this.price,
    required this.effectivePrice,
    this.vendorId,
    this.discountPrice,
    this.discountType,
    this.category,
    this.description,
    this.isInStock = true,
  });

  bool get hasDiscount =>
      discountPrice != null && discountPrice! > 0 && discountPrice! < price;

  factory ProductModel.fromJson(Map<String, dynamic> j) => ProductModel(
    id: j['id'] ?? 0,
    vendorId: j['vendor_id'] as int?,
    name: j['name'] ?? '',
    slug: j['slug'] ?? '',
    imageUrl: j['image_url'] ?? '',
    price: (j['price'] ?? 0).toDouble(),
    effectivePrice: (j['effective_price'] ?? j['price'] ?? 0).toDouble(),
    discountPrice: (j['discount_price'] as num?)?.toDouble(),
    discountType: j['discount_type'],
    category: j['category'],
    description: j['description'],
    isInStock: j['is_in_stock'] ?? true,
  );
}

class OrderModel {
  final int id;
  final String reference, status;
  final double subtotal, deliveryFee, serviceCharge, total;
  final String? paymentMethod, deliveryAddress, notes;
  final bool isPaid;
  final Map<String, dynamic> vendor;
  final List<Map<String, dynamic>> items;
  final Map<String, dynamic>? rider;
  final int itemsCount;
  final String date;

  const OrderModel({
    required this.id,
    required this.reference,
    required this.status,
    required this.subtotal,
    required this.deliveryFee,
    required this.serviceCharge,
    required this.total,
    this.paymentMethod,
    this.deliveryAddress,
    this.notes,
    this.isPaid = false,
    required this.vendor,
    required this.items,
    this.rider,
    required this.itemsCount,
    required this.date,
  });

  factory OrderModel.fromJson(Map<String, dynamic> j) => OrderModel(
    id: j['id'] ?? 0,
    reference: j['reference'] ?? '',
    status: j['status'] ?? 'pending',
    subtotal: (j['subtotal'] as num?)?.toDouble() ?? 0,
    deliveryFee: (j['delivery_fee'] as num?)?.toDouble() ?? 0,
    serviceCharge: (j['service_charge'] as num?)?.toDouble() ?? 0,
    total: (j['total'] as num?)?.toDouble() ?? 0,
    paymentMethod: j['payment_method'],
    deliveryAddress: j['delivery_address'],
    notes: j['notes'],
    isPaid: j['is_paid'] ?? false,
    vendor: Map<String, dynamic>.from(j['vendor'] ?? {}),
    items: (j['items'] as List?)?.cast<Map<String, dynamic>>() ?? [],
    rider: j['rider'] != null ? Map<String, dynamic>.from(j['rider']) : null,
    itemsCount: j['items_count'] ?? (j['items'] as List?)?.length ?? 0,
    date: j['date'] ?? j['created_at'] ?? '',
  );
}

class WalletTransaction {
  final int id;
  final String type, category, description;
  final double amount, balanceAfter;
  final String status, date;

  const WalletTransaction({
    required this.id,
    required this.type,
    required this.category,
    required this.description,
    required this.amount,
    required this.balanceAfter,
    required this.status,
    required this.date,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> j) =>
      WalletTransaction(
        id: j['id'] ?? 0,
        type: j['type'] ?? 'debit',
        category: j['category'] ?? '',
        description: j['description'] ?? '',
        amount: (j['amount'] as num?)?.toDouble() ?? 0,
        balanceAfter: (j['balance_after'] as num?)?.toDouble() ?? 0,
        status: j['status'] ?? 'success',
        date: j['date'] ?? j['created_at'] ?? '',
      );
}

class NotificationModel {
  final String id;
  final Map<String, dynamic> data;
  final String? readAt, createdAt;

  const NotificationModel({
    required this.id,
    required this.data,
    this.readAt,
    this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> j) =>
      NotificationModel(
        id: j['id'] ?? '',
        data: Map<String, dynamic>.from(j['data'] ?? {}),
        readAt: j['read_at'],
        createdAt: j['created_at'],
      );

  bool get isRead => readAt != null;
  String get title => data['title'] ?? data['message'] ?? 'Notification';
  String get type => data['type'] ?? 'general';
}

class SupportTicket {
  final int id;
  final String ticketNo, subject, status, priority, category, message, date;
  final List<Map<String, dynamic>> replies;

  const SupportTicket({
    required this.id,
    required this.ticketNo,
    required this.subject,
    required this.status,
    required this.priority,
    required this.category,
    required this.message,
    required this.date,
    this.replies = const [],
  });

  factory SupportTicket.fromJson(Map<String, dynamic> j) => SupportTicket(
    id: j['id'] ?? 0,
    ticketNo: j['ticket_no'] ?? '',
    subject: j['subject'] ?? '',
    status: j['status'] ?? 'open',
    priority: j['priority'] ?? 'medium',
    category: j['category'] ?? 'general',
    message: j['message'] ?? '',
    date: j['created_at'] ?? '',
    replies: (j['replies'] as List?)?.cast<Map<String, dynamic>>() ?? [],
  );
}
