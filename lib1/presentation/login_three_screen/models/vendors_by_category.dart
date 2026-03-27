import 'dart:convert';

VendorsByCategory vendorsByCategoryFromJson(String str) =>
    VendorsByCategory.fromJson(json.decode(str));

String vendorsByCategoryToJson(VendorsByCategory data) =>
    json.encode(data.toJson());

class VendorsByCategory {
  bool? status;
  String? message;
  List<VendorsByCategoryItem>? data;

  VendorsByCategory({this.status, this.message, this.data});

  VendorsByCategory.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <VendorsByCategoryItem>[];
      json['data'].forEach((v) {
        data!.add(new VendorsByCategoryItem.fromJson(v));
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

class VendorsByCategoryItem {
  int? id;
  String? businessName;
  String? businessAddress;
  int? distanceKm;
  String? phoneNumber;
  String? businessTypeId;
  String? email;
  String? rcNumber;
  String? taxNumber;
  String? businessDescription;
  String? bvn;
  String? meansOfIdentification;
  String? identificationUrl;
  bool? isVerified;
  bool? isActive;
  bool? isRegistered;
  String? fulfilmentType;
  String? logo;
  String? banner;
  String? businessDocuments;
  List<Locations>? locations;
  Plan? plan;
  Category? category;
  List<Vehicle>? vehicles;
  String? createdAt;

  VendorsByCategoryItem(
      {this.id,
      this.businessName,
      this.businessAddress,
      this.distanceKm,
      this.phoneNumber,
      this.businessTypeId,
      this.email,
      this.rcNumber,
      this.taxNumber,
      this.businessDescription,
      this.bvn,
      this.meansOfIdentification,
      this.identificationUrl,
      this.isVerified,
      this.isActive,
      this.isRegistered,
      this.fulfilmentType,
      this.logo,
      this.banner,
      this.businessDocuments,
      this.locations,
      this.plan,
      this.category,
      this.vehicles,
      this.createdAt});

  VendorsByCategoryItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    businessName = json['business_name'];
    businessAddress = json['business_address'];
    distanceKm = json['distance_km'];
    phoneNumber = json['phone_number'];
    businessTypeId = json['business_type_id'];
    email = json['email'];
    rcNumber = json['rc_number'];
    taxNumber = json['tax_number'];
    businessDescription = json['business_description'];
    bvn = json['bvn'];
    meansOfIdentification = json['means_of_identification'];
    identificationUrl = json['identification_url'];
    isVerified = json['is_verified'];
    isActive = json['is_active'];
    isRegistered = json['is_registered'];
    fulfilmentType = json['fulfilment_type'];
    logo = json['logo'];
    banner = json['banner'];
    businessDocuments = json['business_documents'];
    if (json['locations'] != null) {
      locations = <Locations>[];
      json['locations'].forEach((v) {
        locations!.add(new Locations.fromJson(v));
      });
    }
    plan = json['plan'] != null ? new Plan.fromJson(json['plan']) : null;
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    if (json['vehicles'] != null) {
      vehicles = <Vehicle>[];
      json['vehicles'].forEach((v) {
        vehicles!.add(new Vehicle.fromJson(v));
      });
    }
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['business_name'] = this.businessName;
    data['business_address'] = this.businessAddress;
    data['distance_km'] = this.distanceKm;
    data['phone_number'] = this.phoneNumber;
    data['business_type_id'] = this.businessTypeId;
    data['email'] = this.email;
    data['rc_number'] = this.rcNumber;
    data['tax_number'] = this.taxNumber;
    data['business_description'] = this.businessDescription;
    data['bvn'] = this.bvn;
    data['means_of_identification'] = this.meansOfIdentification;
    data['identification_url'] = this.identificationUrl;
    data['is_verified'] = this.isVerified;
    data['is_active'] = this.isActive;
    data['is_registered'] = this.isRegistered;
    data['fulfilment_type'] = this.fulfilmentType;
    data['logo'] = this.logo;
    data['banner'] = this.banner;
    data['business_documents'] = this.businessDocuments;
    if (this.locations != null) {
      data['locations'] = this.locations!.map((v) => v.toJson()).toList();
    }
    if (this.plan != null) {
      data['plan'] = this.plan!.toJson();
    }
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    if (this.vehicles != null) {
      data['vehicles'] = this.vehicles!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = this.createdAt;
    return data;
  }
}

class Locations {
  int? id;
  String? phoneNumber;
  String? contactAddress;
  String? lat;
  String? lon;
  Country? country;
  State? state;
  Lga? lga;
  bool? isActive;
  bool? isPrimary;
  String? createdAt;

  Locations(
      {this.id,
      this.phoneNumber,
      this.contactAddress,
      this.lat,
      this.lon,
      this.country,
      this.state,
      this.lga,
      this.isActive,
      this.isPrimary,
      this.createdAt});

  Locations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phoneNumber = json['phone_number'];
    contactAddress = json['contact_address'];
    lat = json['lat'];
    lon = json['lon'];
    country =
        json['country'] != null ? new Country.fromJson(json['country']) : null;
    state = json['state'] != null ? new State.fromJson(json['state']) : null;
    lga = json['lga'] != null ? new Lga.fromJson(json['lga']) : null;
    isActive = json['is_active'];
    isPrimary = json['is_primary'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['phone_number'] = this.phoneNumber;
    data['contact_address'] = this.contactAddress;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    if (this.country != null) {
      data['country'] = this.country!.toJson();
    }
    if (this.state != null) {
      data['state'] = this.state!.toJson();
    }
    if (this.lga != null) {
      data['lga'] = this.lga!.toJson();
    }
    data['is_active'] = this.isActive;
    data['is_primary'] = this.isPrimary;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class Country {
  int? id;
  String? name;
  String? code;

  Country({this.id, this.name, this.code});

  Country.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    return data;
  }
}

class State {
  int? id;
  String? name;
  String? countryId;

  State({this.id, this.name, this.countryId});

  State.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    countryId = json['country_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['country_id'] = this.countryId;
    return data;
  }
}

class Lga {
  int? id;
  String? name;

  Lga({this.id, this.name});

  Lga.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Plan {
  int? id;
  String? name;
  String? description;
  String? imageUrl;
  List<Features>? features;
  String? createdAt;

  Plan(
      {this.id,
      this.name,
      this.description,
      this.imageUrl,
      this.features,
      this.createdAt});

  Plan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    imageUrl = json['image_url'];
    if (json['features'] != null) {
      features = <Features>[];
      json['features'].forEach((v) {
        features!.add(new Features.fromJson(v));
      });
    }
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['image_url'] = this.imageUrl;
    if (this.features != null) {
      data['features'] = this.features!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = this.createdAt;
    return data;
  }
}

class Features {
  int? id;
  String? name;
  String? type;
  String? value;
  String? createdAt;

  Features({this.id, this.name, this.type, this.value, this.createdAt});

  Features.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    value = json['value'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    data['value'] = this.value;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class Category {
  int? id;
  String? type;
  String? name;
  String? description;
  String? imageUrl;
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

class Vehicle {
  int? id;
  String? type;
  String? model;
  String? plateNumber;
  String? createdAt;

  Vehicle({this.id, this.type, this.model, this.plateNumber, this.createdAt});

  Vehicle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    model = json['model'];
    plateNumber = json['plate_number'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['model'] = this.model;
    data['plate_number'] = this.plateNumber;
    data['created_at'] = this.createdAt;
    return data;
  }
}
