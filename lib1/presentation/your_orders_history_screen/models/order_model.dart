import 'dart:convert';

Order orderFromJson(String str) => Order.fromJson(json.decode(str));

String orderToJson(Order data) => json.encode(data.toJson());

class Order {
  bool? status;
  String? message;
  List<OrderItem>? data;

  Order({this.status, this.message, this.data});

  Order.fromJson(Map<String, dynamic> json) {
    status = json['status'] as bool?;
    message = json['message'] as String?;
    if (json['data'] != null) {
      data =
          (json['data'] as List<dynamic>)
              .map((v) => OrderItem.fromJson(v as Map<String, dynamic>))
              .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderItem {
  int? id;
  String? reference;
  String? status;
  String? packageType;
  bool? isPaid;
  String? total;
  String? serviceCharge;
  String? shippingFee;
  String? vat;
  Customer? customer;
  Address? address;
  String? remark;
  Vendor? vendor;
 // String? rider; //TODO: to change to a class
  List<Items>? items;
 // List<String>? histories; //TODO: to change to a class
  String? createdAt;

  OrderItem({
    this.id,
    this.reference,
    this.status,
    this.packageType,
    this.isPaid,
    this.total,
    this.serviceCharge,
    this.shippingFee,
    this.vat,
    this.customer,
    this.address,
    this.remark,
    this.vendor,
  //  this.rider,
    this.items,
   // this.histories,
    this.createdAt,
  });

  OrderItem.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    reference = json['reference'] as String?;
    status = json['status'] as String?;
    packageType = json['package_type'] as String?;
    isPaid = json['is_paid'] as bool?;
    total = json['total'] as String?;
    serviceCharge = json['service_charge'] as String?;
    shippingFee = json['shipping_fee'] as String?;
    vat = json['vat'] as String?;
    customer =
        json['customer'] != null
            ? Customer.fromJson(json['customer'] as Map<String, dynamic>)
            : null;
    address =
        json['address'] != null
            ? Address.fromJson(json['address'] as Map<String, dynamic>)
            : null;
    remark = json['remark'] as String?;
    vendor =
        json['vendor'] != null
            ? Vendor.fromJson(json['vendor'] as Map<String, dynamic>)
            : null;
   // rider = json['rider'] as String?;
    if (json['items'] != null) {
      items =
          (json['items'] as List<dynamic>)
              .map((v) => Items.fromJson(v as Map<String, dynamic>))
              .toList();
    }
    // if (json['histories'] != null) {
    //   histories =
    //       (json['histories'] as List<dynamic>).map((v) => v as String).toList();
  //  }
    createdAt = json['created_at'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['reference'] = this.reference;
    data['status'] = this.status;
    data['package_type'] = this.packageType;
    data['is_paid'] = this.isPaid;
    data['total'] = this.total;
    data['service_charge'] = this.serviceCharge;
    data['shipping_fee'] = this.shippingFee;
    data['vat'] = this.vat;
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    data['remark'] = this.remark;
    if (this.vendor != null) {
      data['vendor'] = this.vendor!.toJson();
    }
   // data['rider'] = this.rider;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    // if (this.histories != null) {
    //   data['histories'] = this.histories;
    // }
    data['created_at'] = this.createdAt;
    return data;
  }
}

class Customer {
  int? id;
  String? name;
  String? firstname;
  String? lastname;
  String? email;
  String? phoneNumber;
  String? profilePicture;
  String? country;

  Customer({
    this.id,
    this.name,
    this.firstname,
    this.lastname,
    this.email,
    this.phoneNumber,
    this.profilePicture,
    this.country,
  });

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    name = json['name'] as String?;
    firstname = json['firstname'] as String?;
    lastname = json['lastname'] as String?;
    email = json['email'] as String?;
    phoneNumber = json['phone_number'] as String?;
    profilePicture = json['profile_picture'] as String?;
    country = json['country'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['name'] = this.name;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['email'] = this.email;
    data['phone_number'] = this.phoneNumber;
    data['profile_picture'] = this.profilePicture;
    data['country'] = this.country;
    return data;
  }
}

class Address {
  int? id;
  String? country;
  String? state;
  String? lga;
  String? contactAddress;
  String? phoneNumber;
  String? lat;
  String? lon;
  String? isDefault;
  String? createdAt;

  Address({
    this.id,
    this.country,
    this.state,
    this.lga,
    this.contactAddress,
    this.phoneNumber,
    this.lat,
    this.lon,
    this.isDefault,
    this.createdAt,
  });

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    country = json['country'] as String?;
    state = json['state'] as String?;
    lga = json['lga'] as String?;
    contactAddress = json['contact_address'] as String?;
    phoneNumber = json['phone_number'] as String?;
    lat = json['lat'] as String?;
    lon = json['lon'] as String?;
    isDefault = json['is_default'] as String?;
    createdAt = json['created_at'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['country'] = this.country;
    data['state'] = this.state;
    data['lga'] = this.lga;
    data['contact_address'] = this.contactAddress;
    data['phone_number'] = this.phoneNumber;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['is_default'] = this.isDefault;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class Vendor {
  int? id;
  String? businessName;
  String? businessAddress;
  String? distanceKm;
  String? phoneNumber;
  String? businessTypeId;
  String? email;
  String? fulfilmentType;
  String? logo;
  String? banner;
  String? createdAt;

  Vendor({
    this.id,
    this.businessName,
    this.businessAddress,
    this.distanceKm,
    this.phoneNumber,
    this.businessTypeId,
    this.email,
    this.fulfilmentType,
    this.logo,
    this.banner,
    this.createdAt,
  });

  Vendor.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    businessName = json['business_name'] as String?;
    businessAddress = json['business_address'] as String?;
    distanceKm = json['distance_km'] as String?;
    phoneNumber = json['phone_number'] as String?;
    businessTypeId = json['business_type_id'] as String?;
    email = json['email'] as String?;
    fulfilmentType = json['fulfilment_type'] as String?;
    logo = json['logo'] as String?;
    banner = json['banner'] as String?;
    createdAt = json['created_at'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['business_name'] = this.businessName;
    data['business_address'] = this.businessAddress;
    data['distance_km'] = this.distanceKm;
    data['phone_number'] = this.phoneNumber;
    data['business_type_id'] = this.businessTypeId;
    data['email'] = this.email;
    data['fulfilment_type'] = this.fulfilmentType;
    data['logo'] = this.logo;
    data['banner'] = this.banner;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class Items {
  Product? product;
  String? productId;
  String? quantity;
  String? price;
  String? total;

  Items({this.product, this.productId, this.quantity, this.price, this.total});

  Items.fromJson(Map<String, dynamic> json) {
    product =
        json['product'] != null
            ? Product.fromJson(json['product'] as Map<String, dynamic>)
            : null;
    productId = json['product_id'] as String?;
    quantity = json['quantity'] as String?;
    price = json['price'] as String?;
    total = json['total'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    data['product_id'] = this.productId;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['total'] = this.total;
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

  Product({
    this.id,
    this.name,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    name = json['name'] as String?;
    description = json['description'] as String?;
    status = json['status'] as bool?;
    createdAt = json['created_at'] as String?;
    updatedAt = json['updated_at'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
