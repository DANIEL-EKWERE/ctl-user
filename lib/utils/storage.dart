import 'dart:convert';
import 'dart:io';
import 'dart:convert' as json;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

// DataBase get database => Get.find();
DataBase dataBase = Get.put(DataBase());

class DataBase extends GetxController {
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  String _transactionPin = '';

  String _confirmTransactionPin = '';

  String _recommended_by = '';

  String _reqMessage = '';

  String _isSeeen = '';

  Color? _color;

  bool _isLoading = false;

  bool _isSeen = false;

  bool _isSet = false;

  String _isSett = '';

  String _token = '';

  String _location = '';

  String _state = '';

  String _userName = '';

  String _userId = '';

  String _profileId = '';

  String _acctName = '';

  String _acctNumber = '';

  String _bankName = '';

  String _businessBrandName = '';

  String _brmId = '';

  String _brmCode = '';

  String _categoryId = '';

  String _brmPhone = '';

  String _brmAddress = '';

  String _address = '';

  String _brmName = '';

  String _dateAssigned = '';

  String _businessType = '';

  String _profileImage = '';

  String _phone = '';

  String _email = '';

  String _first_name = '';

  String _last_name = '';

  String get recommended_by => _recommended_by;

  String get category_id => _categoryId;

  String get token => _token;

  bool get isSeen => _isSeen;

  String get address => _address;

  String get isSett => _isSett;

  String get isSeeen => _isSeeen;

  String get brm => _brmId;

  String get brmCode => _brmCode;

  String get brmName => _brmName;

  bool get isSet => _isSet;

  String get brmAddress => _brmAddress;

  String get brmPhone => _brmPhone;

  String get dateAssigned => _dateAssigned;

  String get location => _location;

  String get state => _state;

  String get userName => _userName;

  String get userId => _userId;

  String get profileId => _profileId;

  String get acctNumber => _acctNumber;

  String get acctName => _acctName;

  String get bankName => _bankName;

  String get businessBrandName => _businessBrandName;

  String get businessType => _businessType;

  String get profileImage => _profileImage;

  String get phone => _phone;

  String get email => _email;

  String get first_name => _first_name;

  String get last_name => _last_name;

  bool get isLoading => _isLoading;

  Color? get color => _color;

  String get reqMessage => _reqMessage;

  String get transactionPin => _transactionPin;

  String get confirmTransactionPin => _confirmTransactionPin;

  // logOut()async{
  //   final SharedPreferences _pref = await SharedPreferences.getInstance();
  //   await _pref.clear();

  // }

  saveToken(String token) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString('token', token);

    return true;
  }

  Future<bool> saveTransactionPin(String transactionPin) async {
    SharedPreferences sharedPreferences = await _pref;
    if (await sharedPreferences.setString('transactionPin', transactionPin)) {
      return true;
    }

    return false;
  }

  saveRecommendedBy(String recommended_by) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString('recommended_by', recommended_by);

    return true;
  }

  saveVendorId(String vendorId) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString('vendorId', vendorId);

    return true;
  }

  saveCategoryId(String categoryId) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString('categoryId', categoryId);

    return true;
  }

  saveAddress(String address) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString('address', address);

    return true;
  }

  saveSeeen(String isSeeen) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString('isSeeen', isSeeen);

    return true;
  }

  saveIsSet(String isSett) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString('isSett', isSett);

    return true;
  }

  saveBrmName(String brmName) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString('brmName', brmName);

    return true;
  }

  saveBrmPhone(String? brmPhone) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString('brmPhone', brmPhone!);

    return true;
  }

  saveBrmAddress(String brmAddress) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString('brmAddress', brmAddress);

    return true;
  }

  saveBrmDateAssigned(String brmDateAssigned) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString('brmDateAssigned', brmDateAssigned);

    return true;
  }

  saveLocation(String location) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString('location', location);

    return true;
  }

  saveState(String state) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString('state', state);

    return true;
  }

  saveUserName(String userName) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString('userName', userName);

    return true;
  }

  saveUserId(String userId) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString('userId', userId);

    return true;
  }

  saveProfileId(String profileId) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString('profileId', profileId);

    return true;
  }

  saveAcctNumber(String acctNumber) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString('acctNumber', acctNumber);

    return true;
  }

  saveAcctName(String acctName) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString('acctName', acctName);

    return true;
  }

  saveMainCategory(String category) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString('category', category);

    return true;
  }

  saveBankName(String bankName) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString('bankName', bankName);

    return true;
  }

  saveBusinessBrandName(String businessBrandName) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString('businessBrandName', businessBrandName);

    _businessBrandName = businessBrandName;

    return true;
  }

  saveCompanyId(String companyId) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString('companyId', companyId);

    _businessBrandName = companyId;

    return true;
  }

  saveBusinessType(String businessType) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString('businessType', businessType);

    _businessType = businessType;

    return true;
  }

  saveProfileImage(File? image) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString('image', image as String);

    return true;
  }

  savePhoneNumber(String phone) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString('phone', phone);

    return true;
  }

  saveEmail(String email) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString('email', email);

    return true;
  }

  saveFirstName(String first_name) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString('first_name', first_name);

    return true;
  }

  saveLastName(String last_name) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString('last_name', last_name);

    return true;
  }

  saveFullName(String full_name) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString('full_name', last_name);

    return true;
  }

  updateStatus(bool status) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setBool('status', status);

    return true;
  }

  // Save Profile Photo
  Future<bool> saveBIo(String bio) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString('bio', bio);
    return true;
  }

  // Save Profile Photo
  Future<bool> saveProfilePhoto(String profilePhotoPath) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString('profilePhoto', profilePhotoPath);
    return true;
  }

  // Save Cover Photo
  Future<bool> saveCoverPhoto(String coverPhotoPath) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString('coverPhoto', coverPhotoPath);
    return true;
  }

  // Save payment method
  Future<bool> savePayment(String payment) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString('payment', payment);
    return true;
  }

  // Save plan
  Future<bool> savePlan(String payment) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString('plan', payment);
    return true;
  }

  saveRole(String role) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString('role', role);

    return true;
  }

  saveReferalCode(String refCode) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString('refCode', refCode);

    return true;
  }

  Future<void> saveSelectedProducts(List<String> products) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_products', products.join(', '));
  }

  saveReferalCount(String refCount) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString('refCount', refCount);

    return true;
  }

  saveRefererId(String referId) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString('referId', referId);

    return true;
  }

  // Get Profile Photo
  Future<String> getProfilePhoto() async {
    SharedPreferences sharedPreferences = await _pref;
    if (sharedPreferences.containsKey('profilePhoto')) {
      String profilePhotoPath = sharedPreferences.getString('profilePhoto')!;
      return profilePhotoPath;
    } else {
      return ''; // Return an empty string if no profile photo is saved
    }
  }

  // Get Profile Photo
  Future<String> getMainCategory() async {
    SharedPreferences sharedPreferences = await _pref;
    if (sharedPreferences.containsKey('category')) {
      String category = sharedPreferences.getString('category')!;
      return category;
    } else {
      return ''; // Return an empty string if no profile photo is saved
    }
  }

  // Get Profile Photo
  Future<String> getFullName() async {
    SharedPreferences sharedPreferences = await _pref;
    if (sharedPreferences.containsKey('full_name')) {
      String full_name = sharedPreferences.getString('full_name')!;
      return full_name;
    } else {
      return ''; // Return an empty string if no profile photo is saved
    }
  }

  Future<List<String>> loadSelectedProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final productsString = prefs.getString('selected_products') ?? '';
    if (productsString.trim().isEmpty) return [];
    return productsString.split(', ').toList();
  }

  // Get Cover Photo
  Future<String> getCoverPhoto() async {
    SharedPreferences sharedPreferences = await _pref;
    if (sharedPreferences.containsKey('coverPhoto')) {
      String coverPhotoPath = sharedPreferences.getString('coverPhoto')!;
      return coverPhotoPath;
    } else {
      return ''; // Return an empty string if no cover photo is saved
    }
  }

  // Get Cover Photo
  Future<String> getBio() async {
    SharedPreferences sharedPreferences = await _pref;
    if (sharedPreferences.containsKey('bio')) {
      String bio = sharedPreferences.getString('bio')!;
      return bio;
    } else {
      return ''; // Return an empty string if no cover photo is saved
    }
  }

  // Get vendor status
  Future<bool> getStatus() async {
    SharedPreferences sharedPreferences = await _pref;
    if (sharedPreferences.containsKey('status')) {
      bool status = sharedPreferences.getBool('status')!;
      return status;
    } else {
      return false; // Return an empty string if no cover photo is saved
    }
  }

  // static Future<void> saveNotifications(
  //     List<NotificationElement> notifications) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final notificationData = notifications.map((n) => n.toJson()).toList();
  //   prefs.setString('notifications', notificationData.toString());
  // }

  // static Future<List<NotificationElement>> loadNotifications() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final notificationData = prefs.getString('notifications');
  //   if (notificationData != null) {
  //     final List<dynamic> jsonList = jsonDecode(notificationData);
  //     return jsonList
  //         .map((json) => NotificationElement.fromJson(json))
  //         .toList();
  //   }
  //   return [];
  // }

  Future<String> getToken() async {
    SharedPreferences sharedPreferences = await _pref;

    if (sharedPreferences.containsKey('token')) {
      String data = sharedPreferences.getString('token')!;
      _token = data;

      return data;
    } else {
      _token = '';

      return '';
    }
  }

  Future<String> getAddress() async {
    SharedPreferences sharedPreferences = await _pref;

    if (sharedPreferences.containsKey('address')) {
      String data = sharedPreferences.getString('address')!;
      _address = data;

      return data;
    } else {
      _address = '';

      return '';
    }
  }

  Future<String> getCompanyId() async {
    SharedPreferences sharedPreferences = await _pref;

    if (sharedPreferences.containsKey('companyId')) {
      String data = sharedPreferences.getString('companyId')!;
      _brmId = data;

      return data;
    } else {
      _brmId = '';

      return '';
    }
  }

  Future<String> getVendorId() async {
    SharedPreferences sharedPreferences = await _pref;

    if (sharedPreferences.containsKey('vendorId')) {
      String data = sharedPreferences.getString('vendorId')!;
      _brmCode = data;

      return data;
    } else {
      _brmCode = '';

      return '';
    }
  }

  Future<String> getCategoryId() async {
    SharedPreferences sharedPreferences = await _pref;

    if (sharedPreferences.containsKey('categoryId')) {
      String data = sharedPreferences.getString('categoryId')!;
      _categoryId = data;

      return data;
    } else {
      _categoryId = '';

      return '';
    }
  }

  Future<String> getBrmPhone() async {
    SharedPreferences sharedPreferences = await _pref;

    if (sharedPreferences.containsKey('brmPhone')) {
      String data = sharedPreferences.getString('brmPhone')!;
      _brmPhone = data;

      return data;
    } else {
      _brmPhone = '';

      return '';
    }
  }

  Future<String> getBrmName() async {
    SharedPreferences sharedPreferences = await _pref;

    if (sharedPreferences.containsKey('brmName')) {
      String data = sharedPreferences.getString('brmName')!;
      _brmName = data;

      return data;
    } else {
      _brmName = '';

      return '';
    }
  }

  Future<String> getBrmAddress() async {
    SharedPreferences sharedPreferences = await _pref;

    if (sharedPreferences.containsKey('brmAddress')) {
      String data = sharedPreferences.getString('brmAddress')!;
      _brmAddress = data;

      return data;
    } else {
      _brmAddress = '';

      return '';
    }
  }

  Future<bool> getIsSeeen() async {
    SharedPreferences sharedPreferences = await _pref;

    if (sharedPreferences.containsKey('isSeeen')) {
      String data = sharedPreferences.getString('isSeeen')!;
      _isSeeen = data;

      return true;
    } else {
      _brmAddress = '';

      return false;
    }
  }

  Future<String> getIsSett() async {
    SharedPreferences sharedPreferences = await _pref;

    if (sharedPreferences.containsKey('isSett')) {
      String data = sharedPreferences.getString('isSett')!;
      _isSett = data;

      return _isSett;
    } else {
      _isSett = 'N/A';

      return _isSett;
    }
  }

  Future<String> getBrmDateAssigned() async {
    SharedPreferences sharedPreferences = await _pref;

    if (sharedPreferences.containsKey('brmDateAssigned')) {
      String data = sharedPreferences.getString('brmDateAssigned')!;
      _dateAssigned = data;

      return data;
    } else {
      _dateAssigned = '';

      return '';
    }
  }

  Future<String> getTransactionPin() async {
    SharedPreferences sharedPreferences = await _pref;

    if (sharedPreferences.containsKey('transactionPin')) {
      String data = sharedPreferences.getString('transactionPin')!;
      _token = data;

      return data;
    } else {
      _token = '';

      return '';
    }
  }

  Future<String> getPhone() async {
    SharedPreferences sharedPreferences = await _pref;

    if (sharedPreferences.containsKey('phone')) {
      String data = sharedPreferences.getString('phone')!;
      _phone = data;

      return data;
    } else {
      _phone = '';

      return '';
    }
  }

  Future<String> getPaymentMethod() async {
    SharedPreferences sharedPreferences = await _pref;

    if (sharedPreferences.containsKey('payment')) {
      String data = sharedPreferences.getString('payment')!;
      _phone = data;

      return data;
    } else {
      _phone = '';

      return '';
    }
  }

  Future<String> getplan() async {
    SharedPreferences sharedPreferences = await _pref;

    if (sharedPreferences.containsKey('plan')) {
      String data = sharedPreferences.getString('plan')!;
      _phone = data;

      return data;
    } else {
      _phone = '';

      return '';
    }
  }

  Future<String> getLocation() async {
    SharedPreferences sharedPreferences = await _pref;

    if (sharedPreferences.containsKey('location')) {
      String data = sharedPreferences.getString('location')!;
      _phone = data;

      return data;
    } else {
      _phone = '';

      return '';
    }
  }

  Future<String> getState() async {
    SharedPreferences sharedPreferences = await _pref;

    if (sharedPreferences.containsKey('state')) {
      String data = sharedPreferences.getString('state')!;
      _phone = data;

      return data;
    } else {
      _phone = '';

      return '';
    }
  }

  Future<String> getUserId() async {
    SharedPreferences sharedPreferences = await _pref;

    if (sharedPreferences.containsKey('userId')) {
      String data = sharedPreferences.getString('userId')!;
      _userId = data;

      return data;
    } else {
      _userId = '';

      return '';
    }
  }

  Future<String> getUserName() async {
    SharedPreferences sharedPreferences = await _pref;

    if (sharedPreferences.containsKey('userName')) {
      String data = sharedPreferences.getString('userName')!;
      _userName = data;

      return data;
    } else {
      _userName = '';

      return '';
    }
  }

  Future<String> getRecommendedBy() async {
    SharedPreferences sharedPreferences = await _pref;

    if (sharedPreferences.containsKey('recommended_by')) {
      String data = sharedPreferences.getString('recommended_by')!;
      _userName = data;

      return data;
    } else {
      _userName = '';

      return '';
    }
  }

  Future<String> getProfileId() async {
    SharedPreferences sharedPreferences = await _pref;

    if (sharedPreferences.containsKey('profileId')) {
      String data = sharedPreferences.getString('profileId')!;
      _profileId = data;

      return data;
    } else {
      _profileId = '';

      return '';
    }
  }

  Future<String> getAcctNumber() async {
    SharedPreferences sharedPreferences = await _pref;

    if (sharedPreferences.containsKey('acctNumber')) {
      String data = sharedPreferences.getString('acctNumber')!;
      _acctNumber = data;

      return data;
    } else {
      _acctNumber = '';

      return '';
    }
  }

  Future<String> getAcctName() async {
    SharedPreferences sharedPreferences = await _pref;

    if (sharedPreferences.containsKey('acctName')) {
      String data = sharedPreferences.getString('acctName')!;
      _acctName = data;

      return data;
    } else {
      _acctName = '';

      return '';
    }
  }

  Future<String> getBankName() async {
    SharedPreferences sharedPreferences = await _pref;

    if (sharedPreferences.containsKey('bankName')) {
      String data = sharedPreferences.getString('bankName')!;
      _bankName = data;

      return data;
    } else {
      _bankName = '';

      return '';
    }
  }

  Future<String> getBusinessBrandName() async {
    SharedPreferences sharedPreferences = await _pref;

    if (sharedPreferences.containsKey('businessBrandName')) {
      String businessBrandName = sharedPreferences.getString(
        'businessBrandName',
      )!;
      _businessBrandName = businessBrandName;

      return businessBrandName;
    } else {
      _businessBrandName = '';

      return '';
    }
  }

  Future<String> getBusinessType() async {
    SharedPreferences sharedPreferences = await _pref;

    if (sharedPreferences.containsKey('businessType')) {
      String businessType = sharedPreferences.getString('businessType')!;
      _businessType = businessType;

      return businessType;
    } else {
      _businessType = '';

      return '';
    }
  }

  Future<String> getProfileImage() async {
    SharedPreferences sharedPreferences = await _pref;

    if (sharedPreferences.containsKey('image')) {
      String data = sharedPreferences.getString('image')!;
      _profileImage = data;

      return data;
    } else {
      _profileImage = '';

      return '';
    }
  }

  Future<String> getEmail() async {
    SharedPreferences sharedPreferences = await _pref;

    if (sharedPreferences.containsKey('email')) {
      String data = sharedPreferences.getString('email')!;
      _email = data;

      return data;
    } else {
      _email = '';

      return '';
    }
  }

  Future<String> getFirstName() async {
    SharedPreferences sharedPreferences = await _pref;

    if (sharedPreferences.containsKey('first_name')) {
      String data = sharedPreferences.getString('first_name')!;
      _first_name = data;

      return data;
    } else {
      _first_name = '';

      return '';
    }
  }

  Future<String> getLastName() async {
    SharedPreferences sharedPreferences = await _pref;

    if (sharedPreferences.containsKey('last_name')) {
      String data = sharedPreferences.getString('last_name')!;
      _profileImage = data;

      return data;
    } else {
      _profileImage = '';

      return '';
    }
  }

  // ===================== VENDOR METHODS =====================

  // Save Vendor Data
  Future<bool> saveVendor(Map<String, dynamic> vendorData) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString('vendor', jsonEncode(vendorData));
    return true;
  }

  // Get Vendor Data
  Future<Map<String, dynamic>?> getVendor() async {
    SharedPreferences sharedPreferences = await _pref;
    if (sharedPreferences.containsKey('vendor')) {
      String? vendorString = sharedPreferences.getString('vendor');
      if (vendorString != null) {
        return jsonDecode(vendorString) as Map<String, dynamic>;
      }
    }
    return null;
  }

  // Save Vendor ID
  Future<bool> saveVendorIdField(int id) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setInt('vendor_id', id);
    return true;
  }

  // Get Vendor ID
  Future<int?> getVendorIdField() async {
    SharedPreferences sharedPreferences = await _pref;
    if (sharedPreferences.containsKey('vendor_id')) {
      return sharedPreferences.getInt('vendor_id');
    }
    return null;
  }

  // Save Business Name
  Future<bool> saveBusinessName(String businessName) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString('vendor_business_name', businessName);
    return true;
  }

  // Get Business Name
  Future<String?> getBusinessName() async {
    SharedPreferences sharedPreferences = await _pref;
    if (sharedPreferences.containsKey('vendor_business_name')) {
      return sharedPreferences.getString('vendor_business_name');
    }
    return null;
  }

  // Save Business Address
  Future<bool> saveBusinessAddress(String businessAddress) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString(
      'vendor_business_address',
      businessAddress,
    );
    return true;
  }

  // Get Business Address
  Future<String?> getBusinessAddress() async {
    SharedPreferences sharedPreferences = await _pref;
    if (sharedPreferences.containsKey('vendor_business_address')) {
      return sharedPreferences.getString('vendor_business_address');
    }
    return null;
  }

  // Save Distance KM
  Future<bool> saveDistanceKm(String distanceKm) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString('vendor_distance_km', distanceKm);
    return true;
  }

  // Get Distance KM
  Future<String?> getDistanceKm() async {
    SharedPreferences sharedPreferences = await _pref;
    if (sharedPreferences.containsKey('vendor_distance_km')) {
      return sharedPreferences.getString('vendor_distance_km');
    }
    return null;
  }

  // Save Vendor Phone Number
  Future<bool> saveVendorPhoneNumber(String phoneNumber) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString('vendor_phone_number', phoneNumber);
    return true;
  }

  // Get Vendor Phone Number
  Future<String?> getVendorPhoneNumber() async {
    SharedPreferences sharedPreferences = await _pref;
    if (sharedPreferences.containsKey('vendor_phone_number')) {
      return sharedPreferences.getString('vendor_phone_number');
    }
    return null;
  }

  // Save Business Type ID
  Future<bool> saveBusinessTypeId(String businessTypeId) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString(
      'vendor_business_type_id',
      businessTypeId,
    );
    return true;
  }

  // Get Business Type ID
  Future<String?> getBusinessTypeId() async {
    SharedPreferences sharedPreferences = await _pref;
    if (sharedPreferences.containsKey('vendor_business_type_id')) {
      return sharedPreferences.getString('vendor_business_type_id');
    }
    return null;
  }

  // Save Vendor Email
  Future<bool> saveVendorEmail(String email) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString('vendor_email', email);
    return true;
  }

  // Get Vendor Email
  Future<String?> getVendorEmail() async {
    SharedPreferences sharedPreferences = await _pref;
    if (sharedPreferences.containsKey('vendor_email')) {
      return sharedPreferences.getString('vendor_email');
    }
    return null;
  }

  // Save RC Number
  Future<bool> saveRcNumber(String rcNumber) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString('vendor_rc_number', rcNumber);
    return true;
  }

  // Get RC Number
  Future<String?> getRcNumber() async {
    SharedPreferences sharedPreferences = await _pref;
    if (sharedPreferences.containsKey('vendor_rc_number')) {
      return sharedPreferences.getString('vendor_rc_number');
    }
    return null;
  }

  // Save Tax Number
  Future<bool> saveTaxNumber(String taxNumber) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString('vendor_tax_number', taxNumber);
    return true;
  }

  // Get Tax Number
  Future<String?> getTaxNumber() async {
    SharedPreferences sharedPreferences = await _pref;
    if (sharedPreferences.containsKey('vendor_tax_number')) {
      return sharedPreferences.getString('vendor_tax_number');
    }
    return null;
  }

  // Save Business Description
  Future<bool> saveBusinessDescription(String businessDescription) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString(
      'vendor_business_description',
      businessDescription,
    );
    return true;
  }

  // Get Business Description
  Future<String?> getBusinessDescription() async {
    SharedPreferences sharedPreferences = await _pref;
    if (sharedPreferences.containsKey('vendor_business_description')) {
      return sharedPreferences.getString('vendor_business_description');
    }
    return null;
  }

  // Save BVN
  Future<bool> saveBvn(String bvn) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString('vendor_bvn', bvn);
    return true;
  }

  // Get BVN
  Future<String?> getBvn() async {
    SharedPreferences sharedPreferences = await _pref;
    if (sharedPreferences.containsKey('vendor_bvn')) {
      return sharedPreferences.getString('vendor_bvn');
    }
    return null;
  }

  // Save Means of Identification
  Future<bool> saveMeansOfIdentification(String meansOfIdentification) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString(
      'vendor_means_of_identification',
      meansOfIdentification,
    );
    return true;
  }

  // Get Means of Identification
  Future<String?> getMeansOfIdentification() async {
    SharedPreferences sharedPreferences = await _pref;
    if (sharedPreferences.containsKey('vendor_means_of_identification')) {
      return sharedPreferences.getString('vendor_means_of_identification');
    }
    return null;
  }

  // Save Identification URL
  Future<bool> saveIdentificationUrl(String identificationUrl) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString(
      'vendor_identification_url',
      identificationUrl,
    );
    return true;
  }

  // Get Identification URL
  Future<String?> getIdentificationUrl() async {
    SharedPreferences sharedPreferences = await _pref;
    if (sharedPreferences.containsKey('vendor_identification_url')) {
      return sharedPreferences.getString('vendor_identification_url');
    }
    return null;
  }

  // Save Is Verified
  Future<bool> saveIsVerified(bool isVerified) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setBool('vendor_is_verified', isVerified);
    return true;
  }

  // Get Is Verified
  Future<bool?> getIsVerified() async {
    SharedPreferences sharedPreferences = await _pref;
    if (sharedPreferences.containsKey('vendor_is_verified')) {
      return sharedPreferences.getBool('vendor_is_verified');
    }
    return null;
  }

  // Save Is Active
  Future<bool> saveIsActive(bool isActive) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setBool('vendor_is_active', isActive);
    return true;
  }

  // Get Is Active
  Future<bool?> getIsActive() async {
    SharedPreferences sharedPreferences = await _pref;
    if (sharedPreferences.containsKey('vendor_is_active')) {
      return sharedPreferences.getBool('vendor_is_active');
    }
    return null;
  }

  // Save Is Registered
  Future<bool> saveIsRegistered(bool isRegistered) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setBool('vendor_is_registered', isRegistered);
    return true;
  }

  // Get Is Registered
  Future<bool?> getIsRegistered() async {
    SharedPreferences sharedPreferences = await _pref;
    if (sharedPreferences.containsKey('vendor_is_registered')) {
      return sharedPreferences.getBool('vendor_is_registered');
    }
    return null;
  }

  // Save Fulfilment Type
  Future<bool> saveFulfilmentType(String fulfilmentType) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString('vendor_fulfilment_type', fulfilmentType);
    return true;
  }

  // Get Fulfilment Type
  Future<String?> getFulfilmentType() async {
    SharedPreferences sharedPreferences = await _pref;
    if (sharedPreferences.containsKey('vendor_fulfilment_type')) {
      return sharedPreferences.getString('vendor_fulfilment_type');
    }
    return null;
  }

  // Save Logo
  Future<bool> saveLogo(String logo) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString('vendor_logo', logo);
    return true;
  }

  // Get Logo
  Future<String?> getLogo() async {
    SharedPreferences sharedPreferences = await _pref;
    if (sharedPreferences.containsKey('vendor_logo')) {
      return sharedPreferences.getString('vendor_logo');
    }
    return null;
  }

  // Save Banner
  Future<bool> saveBanner(String banner) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString('vendor_banner', banner);
    return true;
  }

  // Get Banner
  Future<String?> getBanner() async {
    SharedPreferences sharedPreferences = await _pref;
    if (sharedPreferences.containsKey('vendor_banner')) {
      return sharedPreferences.getString('vendor_banner');
    }
    return null;
  }

  // Save Business Documents
  Future<bool> saveBusinessDocuments(String businessDocuments) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString(
      'vendor_business_documents',
      businessDocuments,
    );
    return true;
  }

  // Get Business Documents
  Future<String?> getBusinessDocuments() async {
    SharedPreferences sharedPreferences = await _pref;
    if (sharedPreferences.containsKey('vendor_business_documents')) {
      return sharedPreferences.getString('vendor_business_documents');
    }
    return null;
  }

  // Save Locations
  Future<bool> saveLocations(List<dynamic> locations) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString(
      'vendor_locations',
      jsonEncode(locations),
    );
    return true;
  }

  // Get Locations
  Future<List<dynamic>?> getLocations() async {
    SharedPreferences sharedPreferences = await _pref;
    if (sharedPreferences.containsKey('vendor_locations')) {
      String? locationsString = sharedPreferences.getString('vendor_locations');
      if (locationsString != null) {
        return jsonDecode(locationsString) as List<dynamic>;
      }
    }
    return null;
  }

  // Save Category
  Future<bool> saveVendorCategory(Map<String, dynamic> category) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString('vendor_category', jsonEncode(category));
    return true;
  }

  // Get Category
  Future<Map<String, dynamic>?> getVendorCategory() async {
    SharedPreferences sharedPreferences = await _pref;
    if (sharedPreferences.containsKey('vendor_category')) {
      String? categoryString = sharedPreferences.getString('vendor_category');
      if (categoryString != null) {
        return jsonDecode(categoryString) as Map<String, dynamic>;
      }
    }
    return null;
  }

  // Save Plan
  Future<bool> saveVendorPlan(Map<String, dynamic> plan) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString('vendor_plan', jsonEncode(plan));
    return true;
  }

  // Get Plan
  Future<Map<String, dynamic>?> getVendorPlan() async {
    SharedPreferences sharedPreferences = await _pref;
    if (sharedPreferences.containsKey('vendor_plan')) {
      String? planString = sharedPreferences.getString('vendor_plan');
      if (planString != null) {
        return jsonDecode(planString) as Map<String, dynamic>;
      }
    }
    return null;
  }

  // Save Vehicles
  Future<bool> saveVehicles(List<dynamic> vehicles) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString('vendor_vehicles', jsonEncode(vehicles));
    return true;
  }

  // Get Vehicles
  Future<List<dynamic>?> getVehicles() async {
    SharedPreferences sharedPreferences = await _pref;
    if (sharedPreferences.containsKey('vendor_vehicles')) {
      String? vehiclesString = sharedPreferences.getString('vendor_vehicles');
      if (vehiclesString != null) {
        return jsonDecode(vehiclesString) as List<dynamic>;
      }
    }
    return null;
  }

  // Save Created At
  Future<bool> saveVendorCreatedAt(String createdAt) async {
    SharedPreferences sharedPreferences = await _pref;
    await sharedPreferences.setString('vendor_created_at', createdAt);
    return true;
  }

  // Get Created At
  Future<String?> getVendorCreatedAt() async {
    SharedPreferences sharedPreferences = await _pref;
    if (sharedPreferences.containsKey('vendor_created_at')) {
      return sharedPreferences.getString('vendor_created_at');
    }
    return null;
  }

  // ===================== END VENDOR METHODS =====================

  Future updateUserP(BuildContext? context) async {
    _isLoading = true;

    final sharedPreferences = await _pref;
    sharedPreferences.clear();

    _isLoading = false;
    _reqMessage = 'Log Out Successfull';
    _color = _color = const Color.fromARGB(255, 15, 175, 20);

    // Navigator.of(context!)
    //     .pushNamedAndRemoveUntil("/OnboardingPage", (route) => false);

    return true;
  }

  Future logOut() async {
    // _isLoading = true;

    final sharedPreferences = await _pref;
    sharedPreferences.clear();

    // _isLoading = false;
    // _reqMessage = 'Log Out Successfull';
    // _color = _color = const Color.fromARGB(255, 15, 175, 20);

    // Navigator.of(context!)
    //     .pushNamedAndRemoveUntil("/OnboardingPage", (route) => false);

    // return true;
  }

  void status(status) {}
}
