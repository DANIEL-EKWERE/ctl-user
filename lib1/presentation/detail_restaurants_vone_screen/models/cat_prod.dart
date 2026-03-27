import 'dart:convert';

CategoriesAndProduct categoriesAndProductFromJson(String str) =>
    CategoriesAndProduct.fromJson(json.decode(str));

String categoriesAndProductToJson(CategoriesAndProduct data) =>
    json.encode(data.toJson());


class CategoriesAndProduct {
  bool? status;
  String? message;
  List<CateProdItem>? data;

  CategoriesAndProduct({this.status, this.message, this.data});

  CategoriesAndProduct.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CateProdItem>[];
      json['data'].forEach((v) {
        data!.add(new CateProdItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CateProdItem {
  int? id;
  String? type;
  String? name;
  String? description;
  String? imageUrl;
  String? sort;
  List<CatProductItems>? products;
  String? createdAt;

  CateProdItem(
      {this.id,
      this.type,
      this.name,
      this.description,
      this.imageUrl,
      this.sort,
      this.products,
      this.createdAt});

  CateProdItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    name = json['name'];
    description = json['description'];
    imageUrl = json['image_url'];
    sort = json['sort'];
    if (json['products'] != null) {
      products = <CatProductItems>[];
      json['products'].forEach((v) {
        products!.add(new CatProductItems.fromJson(v));
      });
    }
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['name'] = this.name;
    data['description'] = this.description;
    data['image_url'] = this.imageUrl;
    data['sort'] = this.sort;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = this.createdAt;
    return data;
  }
}

class CatProductItems {
  int? id;
  Product? product;
  Category? category;
  Pack? pack;
  String? packId;
  String? price;
  String? cost;
  String? stock;
  String? sku;
  String? finalPrice;
  String? description;
  String? imageUrl;
  String? status;
  String? createdAt;
  String? updatedAt;

  CatProductItems(
      {this.id,
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
      this.updatedAt});

  CatProductItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product =
        json['product'] != null ? new Product.fromJson(json['product']) : null;
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    pack = json['pack'] != null ? new Pack.fromJson(json['pack']) : null;
    packId = json['pack_id'];
    price = json['price'];
    cost = json['cost'];
    stock = json['stock'];
    sku = json['sku'];
    finalPrice = json['final_price'];
    description = json['description'];
    imageUrl = json['image_url'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    if (this.pack != null) {
      data['pack'] = this.pack!.toJson();
    }
    data['pack_id'] = this.packId;
    data['price'] = this.price;
    data['cost'] = this.cost;
    data['stock'] = this.stock;
    data['sku'] = this.sku;
    data['final_price'] = this.finalPrice;
    data['description'] = this.description;
    data['image_url'] = this.imageUrl;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Product {
  int? id;
  String? name;
  String? description;
  bool? status;
  String? createdAt;
  String? updatedAt;

  Product(
      {this.id,
      this.name,
      this.description,
      this.status,
      this.createdAt,
      this.updatedAt});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Category {
  int? id;
  String? type;
  String? name;
  String? description;
  Null? imageUrl;
  String? sort;
  String? createdAt;

  Category(
      {this.id,
      this.type,
      this.name,
      this.description,
      this.imageUrl,
      this.sort,
      this.createdAt});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    name = json['name'];
    description = json['description'];
    imageUrl = json['image_url'];
    sort = json['sort'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['name'] = this.name;
    data['description'] = this.description;
    data['image_url'] = this.imageUrl;
    data['sort'] = this.sort;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class Pack {
  int? id;
  String? vendorId;
  String? companyId;
  String? name;
  String? price;
  String? createdAt;
  String? updatedAt;

  Pack(
      {this.id,
      this.vendorId,
      this.companyId,
      this.name,
      this.price,
      this.createdAt,
      this.updatedAt});

  Pack.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorId = json['vendor_id'];
    companyId = json['company_id'];
    name = json['name'];
    price = json['price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vendor_id'] = this.vendorId;
    data['company_id'] = this.companyId;
    data['name'] = this.name;
    data['price'] = this.price;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
