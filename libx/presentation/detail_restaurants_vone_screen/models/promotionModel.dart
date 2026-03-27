import 'dart:convert';

Promotion promotionFromJson(String jsonString) => Promotion.fromJson(json.decode(jsonString));

String promotionToJson(Promotion data) => json.encode(data.toJson());


class Promotion {
  final bool? status;
  final String? message;
  final List<PromotionItem>? data;

  Promotion({this.status, this.message, this.data});

  factory Promotion.fromJson(Map<String, dynamic> json) {
    return Promotion(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? (json['data'] as List)
              .map((v) => PromotionItem.fromJson(v))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.map((v) => v.toJson()).toList(),
      };
}

// ─────────────────────────────────────────────
// PROMOTION ITEM (formerly Data)
// ─────────────────────────────────────────────

class PromotionItem {
  final int? id;
  final String? title;
  final double? discount;     // parsed from string to double for calculations
  final String? discountLabel;
  final String? type;
  final String? typeLabel;
  final DateTime? startsAt;   // parsed to DateTime for easy date comparisons
  final DateTime? endsAt;
  final String? imageUrl;
  final String? status;
  final List<dynamic>? vendorProducts; // use a VendorProduct class when API is defined

  PromotionItem({
    this.id,
    this.title,
    this.discount,
    this.discountLabel,
    this.type,
    this.typeLabel,
    this.startsAt,
    this.endsAt,
    this.imageUrl,
    this.status,
    this.vendorProducts,
  });

  factory PromotionItem.fromJson(Map<String, dynamic> json) {
    return PromotionItem(
      id: json['id'],
      title: json['title'],
      discount: double.tryParse(json['discount']?.toString() ?? ''),
      discountLabel: json['discount_label'],
      type: json['type'],
      typeLabel: json['type_label'],
      startsAt: json['starts_at'] != null
          ? DateTime.tryParse(json['starts_at'])
          : null,
      endsAt: json['ends_at'] != null
          ? DateTime.tryParse(json['ends_at'])
          : null,
      imageUrl: json['image_url'],
      status: json['status'],
      vendorProducts: json['vendor_products'] != null
          ? List<dynamic>.from(json['vendor_products'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'discount': discount?.toString(),
        'discount_label': discountLabel,
        'type': type,
        'type_label': typeLabel,
        'starts_at': startsAt?.toIso8601String(),
        'ends_at': endsAt?.toIso8601String(),
        'image_url': imageUrl,
        'status': status,
        'vendor_products': vendorProducts,
      };

  /// Convenience getter — true if promotion is currently active
  bool get isActive {
    final now = DateTime.now();
    if (startsAt == null || endsAt == null) return false;
    return now.isAfter(startsAt!) && now.isBefore(endsAt!);
  }
}