import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _cToken   = 'c_token';
  static const _rToken   = 'r_token';
  static const _cUser    = 'c_user';
  static const _rUser    = 'r_user';
  static const _role     = 'role';
  static const _delivAddr = 'deliv_addr';
  static const _delivLat  = 'deliv_lat';
  static const _delivLng  = 'deliv_lng';

  static StorageService? _instance;
  static StorageService get instance => _instance ??= StorageService._();
  StorageService._();

  SharedPreferences? _prefs;
  Future<SharedPreferences> get _p async => _prefs ??= await SharedPreferences.getInstance();

  Future<void> setCustomerToken(String t) async => (await _p).setString(_cToken, t);
  Future<String?> getCustomerToken() async => (await _p).getString(_cToken);
  Future<void> clearCustomerToken() async => (await _p).remove(_cToken);

  Future<void> setRiderToken(String t) async => (await _p).setString(_rToken, t);
  Future<String?> getRiderToken() async => (await _p).getString(_rToken);
  Future<void> clearRiderToken() async => (await _p).remove(_rToken);

  Future<void> setCustomerUser(String json) async => (await _p).setString(_cUser, json);
  Future<String?> getCustomerUser() async => (await _p).getString(_cUser);

  Future<void> setRiderUser(String json) async => (await _p).setString(_rUser, json);
  Future<String?> getRiderUser() async => (await _p).getString(_rUser);

  Future<void> setRole(String r) async => (await _p).setString(_role, r);
  Future<String?> getRole() async => (await _p).getString(_role);

  Future<void> setDeliveryLocation(String addr, double lat, double lng) async {
    final p = await _p;
    p.setString(_delivAddr, addr);
    p.setDouble(_delivLat, lat);
    p.setDouble(_delivLng, lng);
  }

  Future<Map<String, dynamic>?> getDeliveryLocation() async {
    final p = await _p;
    final addr = p.getString(_delivAddr);
    final lat  = p.getDouble(_delivLat);
    final lng  = p.getDouble(_delivLng);
    if (addr == null || lat == null || lng == null) return null;
    return {'addr': addr, 'lat': lat, 'lng': lng};
  }

  Future<void> clearAll() async => (await _p).clear();
}
