import 'dart:convert';

ProductByCategory productByCategoryFromJson(String str) =>
    ProductByCategory.fromJson(json.decode(str));

String productByCategoryToJson(ProductByCategory data) =>
    json.encode(data.toJson());

class ProductByCategory {
  final bool? status;
  final String? message;
  final List<ProductItem>? data;

  ProductByCategory({this.status, this.message, this.data});

  factory ProductByCategory.fromJson(Map<String, dynamic> json) {
    return ProductByCategory(
      status: json['status'],
      message: json['message'],
      data:
          json['data'] != null
              ? (json['data'] as List)
                  .map((v) => ProductItem.fromJson(v))
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
// PRODUCT ITEM (formerly Data)
// ─────────────────────────────────────────────

class ProductItem {
  final int? id;
  final Product? product;
  final Category? category;
  final Pack? pack;
  final String? packId;
  final double? price; // parsed from string to double
  final double? cost; // parsed from string to double
  final int? stock; // parsed from string to int
  final String? sku;
  final double? finalPrice; // parsed from string to double
  final String? description;
  final String? imageUrl;
  final String? status;
  final String? createdAt;
  final String? updatedAt;

  ProductItem({
    this.id,
    this.product,
    this.category,
    this.pack,
    this.packId,
    this.price,
    this.cost,
    this.stock,
    this.sku,
    this.finalPrice,
    this.description,
    this.imageUrl,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductItem.fromJson(Map<String, dynamic> json) {
    return ProductItem(
      id: json['id'],
      product:
          json['product'] != null ? Product.fromJson(json['product']) : null,
      category:
          json['category'] != null ? Category.fromJson(json['category']) : null,
      pack: json['pack'] != null ? Pack.fromJson(json['pack']) : null,
      packId: json['pack_id']?.toString(),
      price: double.tryParse(json['price']?.toString() ?? ''),
      cost: double.tryParse(json['cost']?.toString() ?? ''),
      stock: int.tryParse(json['stock']?.toString() ?? ''),
      sku: json['sku'],
      finalPrice: double.tryParse(json['final_price']?.toString() ?? ''),
      description: json['description'],
      imageUrl: json['image_url'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'product': product?.toJson(),
    'category': category?.toJson(),
    'pack': pack?.toJson(),
    'pack_id': packId,
    'price': price?.toString(),
    'cost': cost?.toString(),
    'stock': stock?.toString(),
    'sku': sku,
    'final_price': finalPrice?.toString(),
    'description': description,
    'image_url': imageUrl,
    'status': status,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}

// ─────────────────────────────────────────────
// PRODUCT
// ─────────────────────────────────────────────

class Product {
  final int? id;
  final String? name;
  final String? description;
  final bool? status;
  final String? createdAt;
  final String? updatedAt;

  Product({
    this.id,
    this.name,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    status: json['status'],
    createdAt: json['created_at'],
    updatedAt: json['updated_at'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'status': status,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}

// ─────────────────────────────────────────────
// CATEGORY
// ─────────────────────────────────────────────

class Category {
  final int? id;
  final String? type;
  final String? name;
  final String? description;
  final String? imageUrl;
  final String? sort;
  final String? createdAt;

  Category({
    this.id,
    this.type,
    this.name,
    this.description,
    this.imageUrl,
    this.sort,
    this.createdAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json['id'],
    type: json['type'],
    name: json['name'],
    description: json['description'],
    imageUrl: json['image_url'],
    sort: json['sort'],
    createdAt: json['created_at'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'name': name,
    'description': description,
    'image_url': imageUrl,
    'sort': sort,
    'created_at': createdAt,
  };
}

// ─────────────────────────────────────────────
// PACK
// ─────────────────────────────────────────────

class Pack {
  final int? id;
  final String? vendorId;
  final String? companyId;
  final String? name;
  final double? price; // parsed from string to double
  final String? createdAt;
  final String? updatedAt;

  Pack({
    this.id,
    this.vendorId,
    this.companyId,
    this.name,
    this.price,
    this.createdAt,
    this.updatedAt,
  });

  factory Pack.fromJson(Map<String, dynamic> json) => Pack(
    id: json['id'],
    vendorId: json['vendor_id']?.toString(),
    companyId: json['company_id']?.toString(),
    name: json['name'],
    price: double.tryParse(json['price']?.toString() ?? ''),
    createdAt: json['created_at'],
    updatedAt: json['updated_at'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'vendor_id': vendorId,
    'company_id': companyId,
    'name': name,
    'price': price?.toString(),
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}
