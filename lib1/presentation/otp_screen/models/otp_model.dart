import 'dart:convert';

EmailVerificationModel emailVerificationModelFromJson(String str) =>
    EmailVerificationModel.fromJson(json.decode(str));

String emailVerificationModelToJson(EmailVerificationModel data) =>
    json.encode(data.toJson());

class EmailVerificationModel {
  bool? status;
  String? message;
  Data? data;

  EmailVerificationModel({this.status, this.message, this.data});

  EmailVerificationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? slug;
  String? name;
  String? firstname;
  String? lastname;
  String? email;
  String? phoneNumber;
  String? profilePicture;
  String? country;
  String? role;
  String? emailVerifiedAt; // Changed to String (from validate-otp)
  bool? emailVerified; // Keep this for validate-email
  String? referralCode;
  dynamic referrerId;
  String? referralCount;
  String? isActive; // Changed to String to handle "1" or "0"
  String? pin;
  bool? hasPin; // Keep this for validate-email
  String? rememberPinToken;
  String? pinTokenExpiry;
  String? pinResetToken;
  String? pinResetExpiry;
  String? lastLogin;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  // Additional fields from validate-email
  bool? isVendor;
  bool? isRider;
  bool? isStaff;
  bool? isAdmin;
  Wallet? wallet;
  List<dynamic>? favorites;
  List<dynamic>? contactAddress;

  Data({
    this.id,
    this.slug,
    this.name,
    this.firstname,
    this.lastname,
    this.email,
    this.phoneNumber,
    this.profilePicture,
    this.country,
    this.role,
    this.emailVerifiedAt,
    this.emailVerified,
    this.referralCode,
    this.referrerId,
    this.referralCount,
    this.isActive,
    this.pin,
    this.hasPin,
    this.rememberPinToken,
    this.pinTokenExpiry,
    this.pinResetToken,
    this.pinResetExpiry,
    this.lastLogin,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.isVendor,
    this.isRider,
    this.isStaff,
    this.isAdmin,
    this.wallet,
    this.favorites,
    this.contactAddress,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    name = json['name'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    profilePicture = json['profile_picture'];
    country = json['country'];
    role = json['role'];

    // Handle both email_verified_at (String) and email_verified (bool)
    emailVerifiedAt = json['email_verified_at'];
    emailVerified = json['email_verified'];

    referralCode = json['referral_code'];
    referrerId = json['referrer_id'];
    referralCount = json['referral_count'];

    // Handle is_active as String ("1" or "0")
    isActive = json['is_active']?.toString();

    pin = json['pin'];
    hasPin = json['has_pin'];
    rememberPinToken = json['remember_pin_token'];
    pinTokenExpiry = json['pin_token_expiry'];
    pinResetToken = json['pin_reset_token'];
    pinResetExpiry = json['pin_reset_expiry'];
    lastLogin = json['last_login'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];

    // Additional fields
    isVendor = json['is_vendor'];
    isRider = json['is_rider'];
    isStaff = json['is_staff'];
    isAdmin = json['is_admin'];
    wallet = json['wallet'] != null ? Wallet.fromJson(json['wallet']) : null;
    favorites = json['favorites'];
    contactAddress = json['contact_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['slug'] = slug;
    data['name'] = name;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['email'] = email;
    data['phone_number'] = phoneNumber;
    data['profile_picture'] = profilePicture;
    data['country'] = country;
    data['role'] = role;
    data['email_verified_at'] = emailVerifiedAt;
    data['email_verified'] = emailVerified;
    data['referral_code'] = referralCode;
    data['referrer_id'] = referrerId;
    data['referral_count'] = referralCount;
    data['is_active'] = isActive;
    data['pin'] = pin;
    data['has_pin'] = hasPin;
    data['remember_pin_token'] = rememberPinToken;
    data['pin_token_expiry'] = pinTokenExpiry;
    data['pin_reset_token'] = pinResetToken;
    data['pin_reset_expiry'] = pinResetExpiry;
    data['last_login'] = lastLogin;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['is_vendor'] = isVendor;
    data['is_rider'] = isRider;
    data['is_staff'] = isStaff;
    data['is_admin'] = isAdmin;
    if (wallet != null) {
      data['wallet'] = wallet!.toJson();
    }
    data['favorites'] = favorites;
    data['contact_address'] = contactAddress;
    return data;
  }

  // Helper methods for boolean checks
  bool get isEmailVerified => emailVerifiedAt != null || emailVerified == true;
  bool get isUserActive => isActive == "1" || isActive == "true";
  bool get userHasPin => pin != null && pin!.isNotEmpty || hasPin == true;
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
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['balance'] = balance;
    return data;
  }
}
