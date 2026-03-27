import 'dart:convert';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  bool? status;
  String? message;
  LoginData? data;

  LoginModel({this.status, this.message, this.data});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new LoginData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class LoginData {
  int? id;
  String? name;
  String? firstname;
  String? lastname;
  String? email;
  String? phoneNumber;
  String? profilePicture;
  String? country;
  bool? emailVerified;
  String? role;
  bool? isVendor;
  bool? isRider;
  bool? isStaff;
  bool? isAdmin;
  String? referralCode;
  String? referrerId;
  String? referralCount;
  bool? hasPin;
  String? isActive;
  String? createdAt;
  String? lastLogin;
  Wallet? wallet;
  BankAccount? bankAccount;
  List<dynamic>? favorites;
  List<ContactAddress>? contactAddress;
  Vendor? vendor;
  String? token;
  String? tokenType;
  int? expiresIn;

  LoginData({
    this.id,
    this.name,
    this.firstname,
    this.lastname,
    this.email,
    this.phoneNumber,
    this.profilePicture,
    this.bankAccount,
    this.country,
    this.emailVerified,
    this.role,
    this.isVendor,
    this.isRider,
    this.isStaff,
    this.isAdmin,
    this.referralCode,
    this.referrerId,
    this.referralCount,
    this.hasPin,
    this.isActive,
    this.createdAt,
    this.lastLogin,
    this.wallet,
    this.favorites,
    this.contactAddress,
    this.vendor,
    this.token,
    this.tokenType,
    this.expiresIn,
  });

  LoginData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    profilePicture = json['profile_picture'];
    country = json['country'];
    emailVerified = json['email_verified'];
    role = json['role'];
    isVendor = json['is_vendor'];
    isRider = json['is_rider'];
    isStaff = json['is_staff'];
    isAdmin = json['is_admin'];
    referralCode = json['referral_code'];
    referrerId = json['referrer_id']?.toString();
    referralCount = json['referral_count']?.toString();
    hasPin = json['has_pin'];
    isActive = json['is_active']?.toString();
    createdAt = json['created_at'];
    lastLogin = json['last_login'];
    wallet = json['wallet'] != null ? Wallet.fromJson(json['wallet']) : null;
    bankAccount =
    json['bank_account'] != null
        ? BankAccount.fromJson(json['bank_account'])
        : null;

    // Fixed: Handle favorites correctly
    if (json['favorites'] != null) {
      favorites = List<dynamic>.from(json['favorites']);
    }

    if (json['contact_address'] != null) {
      contactAddress = <ContactAddress>[];
      json['contact_address'].forEach((v) {
        contactAddress!.add(ContactAddress.fromJson(v));
      });
    }

    vendor = json['vendor'] != null ? Vendor.fromJson(json['vendor']) : null;
    token = json['token'];
    tokenType = json['token_type'];
    expiresIn = json['expires_in'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['email'] = this.email;
    data['phone_number'] = this.phoneNumber;
    data['profile_picture'] = this.profilePicture;
    data['country'] = this.country;
    data['email_verified'] = this.emailVerified;
    data['role'] = this.role;
    data['is_vendor'] = this.isVendor;
    data['is_rider'] = this.isRider;
    data['is_staff'] = this.isStaff;
    data['is_admin'] = this.isAdmin;
    data['referral_code'] = this.referralCode;
    data['referrer_id'] = this.referrerId;
    data['referral_count'] = this.referralCount;
    data['has_pin'] = this.hasPin;
    data['is_active'] = this.isActive;
    data['created_at'] = this.createdAt;
    data['last_login'] = this.lastLogin;
    if (this.wallet != null) {
      data['wallet'] = this.wallet!.toJson();
    }
    data['favorites'] = this.favorites;
    if (this.contactAddress != null) {
      data['contact_address'] = this.contactAddress!
          .map((v) => v.toJson())
          .toList();
    }
    if (this.vendor != null) {
      data['vendor'] = this.vendor!.toJson();
    }
    data['token'] = this.token;
    data['token_type'] = this.tokenType;
    data['expires_in'] = this.expiresIn;
    return data;
  }
}

class Wallet {
  int? id;
  String? balance;

  Wallet({this.id, this.balance});

  Wallet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    balance = json['balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['balance'] = this.balance;
    return data;
  }
}

class BankAccount {
  final int bankId;
  final String bankName;
  final String bankCode;
  final String accountNumber;
  final String accountName;

  BankAccount({
    required this.bankId,
    required this.bankName,
    required this.bankCode,
    required this.accountNumber,
    required this.accountName,
  });

  factory BankAccount.fromJson(Map<String, dynamic> json) {
    return BankAccount(
      bankId: json['bank_id'] ?? 0,
      bankName: json['bank_name'] ?? '',
      bankCode: json['bank_code'] ?? '',
      accountNumber: json['account_number'] ?? '',
      accountName: json['account_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bank_id': bankId,
      'bank_name': bankName,
      'bank_code': bankCode,
      'account_number': accountNumber,
      'account_name': accountName,
    };
  }
}

class ContactAddress {
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

  ContactAddress({
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

  ContactAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    country = json['country'];
    state = json['state'];
    lga = json['lga'];
    contactAddress = json['contact_address'];
    phoneNumber = json['phone_number'];
    lat = json['lat'];
    lon = json['lon'];
    isDefault = json['is_default'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
  Category? category;
  Plan? plan;
  List<dynamic>? vehicles;
  String? createdAt;

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
    this.category,
    this.plan,
    this.vehicles,
    this.createdAt,
  });

  Vendor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    businessName = json['business_name'];
    businessAddress = json['business_address'];
    distanceKm = json['distance_km']?.toString();
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
        locations!.add(Locations.fromJson(v));
      });
    }

    category = json['category'] != null
        ? Category.fromJson(json['category'])
        : null;
    plan = json['plan'] != null ? Plan.fromJson(json['plan']) : null;

    // Fixed: Handle vehicles correctly
    if (json['vehicles'] != null) {
      vehicles = List<dynamic>.from(json['vehicles']);
    }

    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    if (this.plan != null) {
      data['plan'] = this.plan!.toJson();
    }
    data['vehicles'] = this.vehicles;
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
  LocationCountry? country; // Changed from String? to object
  LocationState? state; // Changed from String? to object
  LocationLga? lga; // Changed from String? to object
  bool? isActive;
  bool? isPrimary;
  String? createdAt;

  Locations({
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

  Locations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phoneNumber = json['phone_number'];
    contactAddress = json['contact_address'];
    lat = json['lat'];
    lon = json['lon'];

    // Handle country as object or string
    if (json['country'] != null) {
      if (json['country'] is Map) {
        country = LocationCountry.fromJson(json['country']);
      }
    }

    // Handle state as object or string
    if (json['state'] != null) {
      if (json['state'] is Map) {
        state = LocationState.fromJson(json['state']);
      }
    }

    // Handle lga as object or string
    if (json['lga'] != null) {
      if (json['lga'] is Map) {
        lga = LocationLga.fromJson(json['lga']);
      }
    }

    isActive = json['is_active'];
    isPrimary = json['is_primary'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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

// Add these new classes at the end of your file
class LocationCountry {
  int? id;
  String? name;
  String? code;

  LocationCountry({this.id, this.name, this.code});

  LocationCountry.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    return data;
  }
}

class LocationState {
  int? id;
  String? name;
  String? countryId;

  LocationState({this.id, this.name, this.countryId});

  LocationState.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    countryId = json['country_id']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['country_id'] = this.countryId;
    return data;
  }
}

class LocationLga {
  int? id;
  String? name;

  LocationLga({this.id, this.name});

  LocationLga.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
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

  Category({
    this.id,
    this.type,
    this.name,
    this.description,
    this.imageUrl,
    this.sort,
    this.createdAt,
  });

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

class Plan {
  int? id;
  String? name;
  String? description;
  String? imageUrl;
  String? createdAt;

  Plan({this.id, this.name, this.description, this.imageUrl, this.createdAt});

  Plan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    imageUrl = json['image_url'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['image_url'] = this.imageUrl;
    data['created_at'] = this.createdAt;
    return data;
  }
}



/// my data for ekweredaniel8@gmail.com
//{
//     "status": true,
//     "message": "An OTP has been sent to your email address. It expires after 15 minutes.",
//     "data": {
//         "id": 2,
//         "name": "Daniel Ekwere",
//         "firstname": "Daniel",
//         "lastname": "Ekwere",
//         "email": "ekweredaniel8@gmail.com",
//         "phone_number": "07043194111",
//         "email_verified": false,
//         "role": "customer",
//         "referral_code": "pOXWRjrOoj",
//         "referrer_id": null,
//         "referral_count": null,
//         "has_pin": false,
//         "is_active": null,
//         "created_at": "2025-05-28 09:12:59",
//         "last_login": "2025-05-28 09:12:59",
//         "wallet": {
//             "id": 2,
//             "balance": "0.00"
//         },
//         "favorites": []
//     }
// }