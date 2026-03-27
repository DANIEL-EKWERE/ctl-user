import 'dart:convert';

NearbyVendors nearbyVendorslFromJson(String str) =>
    NearbyVendors.fromJson(json.decode(str));

String nearbyVendorsToJson(NearbyVendors data) => json.encode(data.toJson());


class NearbyVendors {
  final bool? status;
  final String? message;
  final List<Vendor>? data;

  NearbyVendors({this.status, this.message, this.data});

  factory NearbyVendors.fromJson(Map<String, dynamic> json) {
    return NearbyVendors(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? (json['data'] as List).map((v) => Vendor.fromJson(v)).toList()
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
// VENDOR
// ─────────────────────────────────────────────

class Vendor {
  final int? id;
  final String? businessName;
  final String? businessAddress;
  final double? distanceKm; // double to support decimal distances
  final String? phoneNumber;
  final String? businessTypeId;
  final String? email;
  final String? rcNumber;
  final String? taxNumber;
  final String? businessDescription;
  final String? bvn;
  final String? meansOfIdentification;
  final String? identificationUrl;
  final bool? isVerified;
  final bool? isActive;
  final bool? isRegistered;
  final String? fulfilmentType;
  final String? logo;
  final String? banner;
  final dynamic businessDocuments;
  final List<VendorLocation>? locations;
  final Plan? plan;
  final Category? category;
  final List<dynamic>? vehicles;
  final String? createdAt;

  Vendor({
    this.id,
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
    this.createdAt,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      id: json['id'],
      businessName: json['business_name'],
      businessAddress: json['business_address'],
      distanceKm: (json['distance_km'] as num?)?.toDouble(),
      phoneNumber: json['phone_number'],
      businessTypeId: json['business_type_id']?.toString(),
      email: json['email'],
      rcNumber: json['rc_number'],
      taxNumber: json['tax_number'],
      businessDescription: json['business_description'],
      bvn: json['bvn'],
      meansOfIdentification: json['means_of_identification'],
      identificationUrl: json['identification_url'],
      isVerified: json['is_verified'],
      isActive: json['is_active'],
      isRegistered: json['is_registered'],
      fulfilmentType: json['fulfilment_type'],
      logo: json['logo'],
      banner: json['banner'],
      businessDocuments: json['business_documents'],
      locations: json['locations'] != null
          ? (json['locations'] as List)
              .map((v) => VendorLocation.fromJson(v))
              .toList()
          : null,
      plan: json['plan'] != null ? Plan.fromJson(json['plan']) : null,
      category:
          json['category'] != null ? Category.fromJson(json['category']) : null,
      vehicles: json['vehicles'] != null
          ? List<dynamic>.from(json['vehicles'])
          : null,
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'business_name': businessName,
        'business_address': businessAddress,
        'distance_km': distanceKm,
        'phone_number': phoneNumber,
        'business_type_id': businessTypeId,
        'email': email,
        'rc_number': rcNumber,
        'tax_number': taxNumber,
        'business_description': businessDescription,
        'bvn': bvn,
        'means_of_identification': meansOfIdentification,
        'identification_url': identificationUrl,
        'is_verified': isVerified,
        'is_active': isActive,
        'is_registered': isRegistered,
        'fulfilment_type': fulfilmentType,
        'logo': logo,
        'banner': banner,
        'business_documents': businessDocuments,
        'locations': locations?.map((v) => v.toJson()).toList(),
        'plan': plan?.toJson(),
        'category': category?.toJson(),
        'vehicles': vehicles,
        'created_at': createdAt,
      };
}

// ─────────────────────────────────────────────
// VENDOR LOCATION
// ─────────────────────────────────────────────

class VendorLocation {
  final int? id;
  final String? phoneNumber;
  final String? contactAddress;
  final double? lat; // parsed from string to double for map usage
  final double? lon;
  final Country? country;
  final State? state;
  final Lga? lga;
  final bool? isActive;
  final bool? isPrimary;
  final String? createdAt;

  VendorLocation({
    this.id,
    this.phoneNumber,
    this.contactAddress,
    this.lat,
    this.lon,
    this.country,
    this.state,
    this.lga,
    this.isActive,
    this.isPrimary,
    this.createdAt,
  });

  factory VendorLocation.fromJson(Map<String, dynamic> json) {
    return VendorLocation(
      id: json['id'],
      phoneNumber: json['phone_number'],
      contactAddress: json['contact_address'],
      lat: double.tryParse(json['lat']?.toString() ?? ''),
      lon: double.tryParse(json['lon']?.toString() ?? ''),
      country:
          json['country'] != null ? Country.fromJson(json['country']) : null,
      state: json['state'] != null ? State.fromJson(json['state']) : null,
      lga: json['lga'] != null ? Lga.fromJson(json['lga']) : null,
      isActive: json['is_active'],
      isPrimary: json['is_primary'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'phone_number': phoneNumber,
        'contact_address': contactAddress,
        'lat': lat?.toString(),
        'lon': lon?.toString(),
        'country': country?.toJson(),
        'state': state?.toJson(),
        'lga': lga?.toJson(),
        'is_active': isActive,
        'is_primary': isPrimary,
        'created_at': createdAt,
      };
}

// ─────────────────────────────────────────────
// COUNTRY
// ─────────────────────────────────────────────

class Country {
  final int? id;
  final String? name;
  final String? code;

  Country({this.id, this.name, this.code});

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json['id'],
        name: json['name'],
        code: json['code'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'code': code,
      };
}

// ─────────────────────────────────────────────
// STATE
// ─────────────────────────────────────────────

class State {
  final int? id;
  final String? name;
  final String? countryId;

  State({this.id, this.name, this.countryId});

  factory State.fromJson(Map<String, dynamic> json) => State(
        id: json['id'],
        name: json['name'],
        countryId: json['country_id']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'country_id': countryId,
      };
}

// ─────────────────────────────────────────────
// LGA
// ─────────────────────────────────────────────

class Lga {
  final int? id;
  final String? name;

  Lga({this.id, this.name});

  factory Lga.fromJson(Map<String, dynamic> json) => Lga(
        id: json['id'],
        name: json['name'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}

// ─────────────────────────────────────────────
// PLAN
// ─────────────────────────────────────────────

class Plan {
  final int? id;
  final String? name;
  final String? description;
  final String? imageUrl;
  final List<PlanFeature>? features;
  final String? createdAt;

  Plan({
    this.id,
    this.name,
    this.description,
    this.imageUrl,
    this.features,
    this.createdAt,
  });

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        imageUrl: json['image_url'],
        features: json['features'] != null
            ? (json['features'] as List)
                .map((v) => PlanFeature.fromJson(v))
                .toList()
            : null,
        createdAt: json['created_at'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'image_url': imageUrl,
        'features': features?.map((v) => v.toJson()).toList(),
        'created_at': createdAt,
      };
}

// ─────────────────────────────────────────────
// PLAN FEATURE
// ─────────────────────────────────────────────

class PlanFeature {
  final int? id;
  final String? name;
  final String? type;
  final String? value;
  final String? createdAt;

  PlanFeature({this.id, this.name, this.type, this.value, this.createdAt});

  factory PlanFeature.fromJson(Map<String, dynamic> json) => PlanFeature(
        id: json['id'],
        name: json['name'],
        type: json['type'],
        value: json['value'],
        createdAt: json['created_at'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'value': value,
        'created_at': createdAt,
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