import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class LocationResult {
  final double lat;
  final double lng;
  final String address;
  final String? city;
  final String? state;

  LocationResult({required this.lat, required this.lng, required this.address, this.city, this.state});
}

class NominatimResult {
  final String displayName;
  final String shortName;
  final double lat;
  final double lng;
  final String? city;
  final String? state;

  NominatimResult({
    required this.displayName,
    required this.shortName,
    required this.lat,
    required this.lng,
    this.city,
    this.state,
  });
}

class LocationService {
  static LocationService? _instance;
  static LocationService get instance => _instance ??= LocationService._();
  LocationService._();

  // ── GPS ──────────────────────────────────────────────────────────────────────
  Future<LocationResult?> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }
    if (permission == LocationPermission.deniedForever) return null;

    final pos = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, timeLimit: Duration(seconds: 15)),
    );

    // Reverse geocode with Nominatim
    return reverseGeocode(pos.latitude, pos.longitude);
  }

  Future<LocationResult?> reverseGeocode(double lat, double lng) async {
    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$lng&format=json&accept-language=en',
      );
      final res = await http.get(url, headers: {'User-Agent': 'NKsereke-App/1.0'})
          .timeout(const Duration(seconds: 10));
      if (res.statusCode != 200) return LocationResult(lat: lat, lng: lng, address: '$lat, $lng');
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final addr = data['address'] as Map<String, dynamic>? ?? {};
      final parts = (data['display_name'] as String? ?? '').split(',');
      final shortAddr = parts.take(4).join(',').trim();
      final city = addr['city'] ?? addr['town'] ?? addr['suburb'] ?? addr['village'];
      final state = addr['state'];
      return LocationResult(lat: lat, lng: lng, address: shortAddr, city: city, state: state);
    } catch (_) {
      return LocationResult(lat: lat, lng: lng, address: '${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}');
    }
  }

  // ── Search ───────────────────────────────────────────────────────────────────
  Future<List<NominatimResult>> searchAddress(String query) async {
    if (query.trim().length < 3) return [];
    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(query)}&format=json&limit=6&accept-language=en&countrycodes=ng',
      );
      final res = await http.get(url, headers: {'User-Agent': 'NKsereke-App/1.0'})
          .timeout(const Duration(seconds: 8));
      if (res.statusCode != 200) return [];
      final list = jsonDecode(res.body) as List;
      return list.map((item) {
        final parts = (item['display_name'] as String? ?? '').split(',');
        final shortName = parts.take(3).join(',').trim();
        final addr = item['address'] as Map<String, dynamic>? ?? {};
        return NominatimResult(
          displayName: item['display_name'] ?? '',
          shortName: shortName,
          lat: double.tryParse(item['lat']?.toString() ?? '') ?? 0,
          lng: double.tryParse(item['lon']?.toString() ?? '') ?? 0,
          city: addr['city'] ?? addr['town'] ?? addr['suburb'],
          state: addr['state'],
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }
}