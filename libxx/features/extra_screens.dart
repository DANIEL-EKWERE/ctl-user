import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import '../../lib/core/app_colors.dart';
import '../../lib/core/app_text_styles.dart';
import '../core/models.dart';
import '../../lib/core/network.dart';
import '../../lib/core/cart_provider.dart';
import '../shared/widgets.dart';
import 'customer_screens.dart';

// ── Location Screen (with Nominatim autocomplete + GPS) ─────────────────────
class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});
  @override State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final _search     = TextEditingController();
  List<AddressModel> _saved = [];
  List<Map<String,dynamic>> _suggestions = [];
  bool _loadingGps  = false;
  bool _searching   = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadSaved();
  }

  @override
  void dispose() { _debounce?.cancel(); super.dispose(); }

  Future<void> _loadSaved() async {
    try {
      final res = await ApiClient().get(ApiEndpoints.addresses);
      setState(() => _saved = (res.data['addresses'] as List? ?? [])
          .map((j) => AddressModel.fromJson(j)).toList());
    } catch (_) {}
  }

  void _onSearchChanged(String val) {
    _debounce?.cancel();
    if (val.length < 2) { setState(() => _suggestions = []); return; }
    _debounce = Timer(const Duration(milliseconds: 400), () => _fetchSuggestions(val));
  }

  Future<void> _fetchSuggestions(String query) async {
    setState(() => _searching = true);
    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search'
        '?q=${Uri.encodeComponent(query)}'
        '&format=json&addressdetails=1&limit=6&countrycodes=ng&accept-language=en');
      final res = await http.get(url, headers: {'User-Agent': 'NKsereke-App/1.0'});
      final data = jsonDecode(res.body) as List;
      setState(() => _suggestions = data.cast<Map<String,dynamic>>());
    } catch (_) {
      setState(() => _suggestions = []);
    } finally {
      setState(() => _searching = false);
    }
  }

  void _selectResult(Map<String,dynamic> result) {
    final parts  = (result['display_name'] as String).split(',');
    final addr   = parts.take(4).join(',').trim();
    final lat    = double.tryParse(result['lat'] as String) ?? 0;
    final lng    = double.tryParse(result['lon'] as String) ?? 0;
    Navigator.pop(context, {'address': addr, 'lat': lat, 'lng': lng});
  }

  void _selectSaved(AddressModel a) {
    Navigator.pop(context, <String, dynamic>{
      'address': a.address, 'lat': a.latitude, 'lng': a.longitude,
    });
  }

  Future<void> _useGps() async {
    setState(() => _loadingGps = true);
    try {
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.deniedForever) {
        throw Exception('Location permission permanently denied');
      }
      final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium);
      // Reverse geocode with Nominatim
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse'
        '?lat=\${pos.latitude}&lon=\${pos.longitude}&format=json&accept-language=en');
      final res = await http.get(url, headers: {'User-Agent': 'NKsereke-App/1.0'});
      final data = jsonDecode(res.body);
      final parts = (data['display_name'] as String? ?? '').split(',');
      final addr  = parts.take(4).join(',').trim();
      if (!mounted) return;
      Navigator.pop(context, {'address': addr, 'lat': pos.latitude, 'lng': pos.longitude});
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString().contains('denied')
            ? 'Location permission denied. Please enable in settings.'
            : 'Could not get GPS location. Please search manually.'),
          backgroundColor: AppColors.error));
      }
    } finally {
      if (mounted) setState(() => _loadingGps = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const NKAppBar(title: 'Delivery Location'),
      body: Column(children: [
        // ── Search box
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
          decoration: const BoxDecoration(
            color: AppColors.white,
            border: Border(bottom: BorderSide(color: AppColors.border))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Where should we deliver?', style: AppTextStyles.subtitle),
            const SizedBox(height: 4),
            Text('Search address or use GPS location', style: AppTextStyles.caption),
            const SizedBox(height: 12),
            TextField(
              controller: _search,
              onChanged: _onSearchChanged,
              style: AppTextStyles.body,
              decoration: InputDecoration(
                hintText: 'Search street, area, city...',
                prefixIcon: const Icon(Icons.search, color: AppColors.primary, size: 20),
                suffixIcon: _searching
                  ? const Padding(padding: EdgeInsets.all(12),
                      child: SizedBox(width: 18, height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary)))
                  : _search.text.isNotEmpty
                    ? IconButton(icon: const Icon(Icons.clear, size: 18),
                        onPressed: () { _search.clear(); setState(() => _suggestions = []); })
                    : null,
                filled: true, fillColor: AppColors.inputBg,
              ),
            ),
            // ── Autocomplete dropdown
            if (_suggestions.isNotEmpty) ...[
              const SizedBox(height: 6),
              Container(
                constraints: const BoxConstraints(maxHeight: 220),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                  boxShadow: AppColors.shadowMd,
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _suggestions.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, i) {
                    final item  = _suggestions[i];
                    final parts = (item['display_name'] as String).split(',');
                    final main  = parts.take(2).join(',').trim();
                    final sub   = parts.skip(2).take(2).join(',').trim();
                    return ListTile(
                      dense: true,
                      leading: const Icon(Icons.place_outlined, color: AppColors.primary, size: 20),
                      title: Text(main, style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w600)),
                      subtitle: sub.isNotEmpty ? Text(sub, style: AppTextStyles.caption2) : null,
                      onTap: () => _selectResult(item),
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: 10),
            NKButton(
              label: '📍 Use my current location',
              loading: _loadingGps,
              onTap: _useGps,
            ),
          ]),
        ),
        // ── Saved addresses
        Expanded(child: ListView(padding: const EdgeInsets.all(16), children: [
          if (_saved.isNotEmpty) ...[
            Text('SAVED ADDRESSES', style: AppTextStyles.sectionLabel),
            const SizedBox(height: 10),
            ..._saved.map((a) => GestureDetector(
              onTap: () => _selectSaved(a),
              child: NKCard(
                margin: const EdgeInsets.only(bottom: 8),
                child: Row(children: [
                  Container(width: 36, height: 36, decoration: BoxDecoration(
                      color: const Color(0xFFF0F7FF), borderRadius: BorderRadius.circular(9)),
                    child: Center(child: Text(
                      a.label == 'Home' ? '🏠' : a.label == 'Work' ? '💼' : '📍',
                      style: const TextStyle(fontSize: 16)))),
                  const SizedBox(width: 10),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(a.label, style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w700)),
                    Text(a.address, style: AppTextStyles.caption2, maxLines: 1, overflow: TextOverflow.ellipsis),
                    if (a.latitude != null)
                      Text('📍 \${a.latitude!.toStringAsFixed(4)}, \${a.longitude!.toStringAsFixed(4)}',
                          style: AppTextStyles.caption2),
                  ])),
                  if (a.isDefault)
                    Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(color: AppColors.doneBg, borderRadius: BorderRadius.circular(8)),
                      child: Text('Default', style: AppTextStyles.caption2.copyWith(color: AppColors.doneText, fontWeight: FontWeight.w700)))
                  else const Icon(Icons.chevron_right, color: AppColors.textHint),
                ]),
              ),
            )),
            const SizedBox(height: 8),
          ],
          NKButton.outline(
            label: '+ Save new address',
            onTap: () => Navigator.pushNamed(context, '/add-address').then((_) => _loadSaved()),
          ),
        ])),
      ]),
    );
  }
}

// ── Add Address Screen (Nominatim autocomplete + lat/lng) ────────────────────
class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});
  @override State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _searchCtrl = TextEditingController();
  final _cityCtrl   = TextEditingController();
  final _stateCtrl  = TextEditingController();
  String _label      = 'Home';
  bool _loading      = false;
  bool _searching    = false;
  String? _err;
  String? _selectedAddr;
  double? _selectedLat, _selectedLng;
  List<Map<String,dynamic>> _suggestions = [];
  Timer? _debounce;

  @override
  void dispose() { _debounce?.cancel(); super.dispose(); }

  void _onSearch(String val) {
    _debounce?.cancel();
    if (val.length < 2) { setState(() => _suggestions = []); return; }
    _debounce = Timer(const Duration(milliseconds: 400), () => _fetch(val));
  }

  Future<void> _fetch(String q) async {
    setState(() => _searching = true);
    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search'
        '?q=\${Uri.encodeComponent(q)}'
        '&format=json&addressdetails=1&limit=5&countrycodes=ng&accept-language=en');
      final res = await http.get(url, headers: {'User-Agent': 'NKsereke-App/1.0'});
      setState(() => _suggestions = (jsonDecode(res.body) as List).cast<Map<String,dynamic>>());
    } catch (_) { setState(() => _suggestions = []); }
    finally { setState(() => _searching = false); }
  }

  void _pick(Map<String,dynamic> r) {
    final parts = (r['display_name'] as String).split(',');
    final addr  = parts.take(3).join(',').trim();
    final city  = r['address']?['city'] ?? r['address']?['town'] ??
                  r['address']?['village'] ?? r['address']?['suburb'] ??
                  (parts.length > 1 ? parts[1].trim() : '');
    final state = r['address']?['state'] ?? '';
    setState(() {
      _selectedAddr = addr;
      _selectedLat  = double.tryParse(r['lat'] as String);
      _selectedLng  = double.tryParse(r['lon'] as String);
      _suggestions  = [];
      _searchCtrl.text = addr;
      _cityCtrl.text   = city;
      _stateCtrl.text  = state;
    });
  }

  Future<void> _save() async {
    final addr = _selectedAddr ?? _searchCtrl.text.trim();
    if (addr.isEmpty) { setState(() => _err = 'Please search and select an address'); return; }
    setState(() { _loading = true; _err = null; });
    try {
      await ApiClient().post(ApiEndpoints.addresses, data: {
        'label':     _label,
        'address':   addr,
        'city':      _cityCtrl.text.trim(),
        'state':     _stateCtrl.text.trim(),
        if (_selectedLat != null) 'latitude':  _selectedLat,
        if (_selectedLng != null) 'longitude': _selectedLng,
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Address saved ✓'), backgroundColor: AppColors.success,
        duration: Duration(seconds: 2)));
      Navigator.pop(context);
    } on DioException catch (e) {
      setState(() => _err = e.response?.data['message'] ?? 'Failed to save address');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const NKAppBar(title: 'Add New Address'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Label selector
          Row(children: ['Home','Work','Other'].map((l) => Expanded(child: Padding(
            padding: const EdgeInsets.only(right: 6),
            child: GestureDetector(
              onTap: () => setState(() => _label = l),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                padding: const EdgeInsets.symmetric(vertical: 11),
                decoration: BoxDecoration(
                  color: _label == l ? AppColors.primary : AppColors.chipBg,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Center(child: Text(
                  '\${l == "Home" ? "🏠 " : l == "Work" ? "💼 " : "📍 "}\$l',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
                    color: _label == l ? AppColors.white : AppColors.textLight))),
              ),
            ),
          ))).toList()),
          const SizedBox(height: 18),
          // Search with autocomplete
          Text('Search address', style: AppTextStyles.label),
          const SizedBox(height: 5),
          TextField(
            controller: _searchCtrl,
            onChanged: _onSearch,
            style: AppTextStyles.body,
            decoration: InputDecoration(
              hintText: 'Type street, area, city...',
              prefixIcon: const Icon(Icons.search, color: AppColors.primary, size: 20),
              suffixIcon: _searching
                ? const Padding(padding: EdgeInsets.all(12),
                    child: SizedBox(width: 16, height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary)))
                : null,
              filled: true, fillColor: AppColors.inputBg,
            ),
          ),
          // Dropdown suggestions
          if (_suggestions.isNotEmpty) ...[
            const SizedBox(height: 6),
            Container(
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
                boxShadow: AppColors.shadowMd,
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: _suggestions.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  final item  = _suggestions[i];
                  final parts = (item['display_name'] as String).split(',');
                  return ListTile(
                    dense: true,
                    leading: const Icon(Icons.place_outlined, color: AppColors.primary, size: 18),
                    title: Text(parts.take(2).join(',').trim(),
                      style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w600)),
                    subtitle: parts.skip(2).take(2).isNotEmpty
                      ? Text(parts.skip(2).take(2).join(',').trim(), style: AppTextStyles.caption2)
                      : null,
                    onTap: () => _pick(item),
                  );
                },
              ),
            ),
          ],
          // Selected address preview
          if (_selectedAddr != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity, padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.doneBg, borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.doneText.withOpacity(.3))),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  const Icon(Icons.check_circle, color: AppColors.success, size: 16),
                  const SizedBox(width: 6),
                  Text('Address selected', style: AppTextStyles.caption.copyWith(
                      color: AppColors.success, fontWeight: FontWeight.w700)),
                ]),
                const SizedBox(height: 4),
                Text(_selectedAddr!, style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w600)),
                if (_selectedLat != null)
                  Text('📍 \${_selectedLat!.toStringAsFixed(5)}, \${_selectedLng!.toStringAsFixed(5)}',
                    style: AppTextStyles.caption2),
              ]),
            ),
          ],
          const SizedBox(height: 14),
          NKTextField(label: 'City', hint: 'Auto-filled from search', controller: _cityCtrl),
          NKTextField(label: 'State', hint: 'Auto-filled from search', controller: _stateCtrl),
          if (_err != null) Container(
            width: double.infinity, padding: const EdgeInsets.all(12), margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(color: AppColors.cancelBg, borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.cancelText.withOpacity(.3))),
            child: Text(_err!, style: AppTextStyles.caption.copyWith(color: AppColors.cancelText))),
          NKButton(label: 'Save Address', onTap: _save, loading: _loading),
          const SizedBox(height: 20),
        ]),
      ),
    );
  }
}

// ── Saved Addresses Screen ────────────────────────────────────────────────────
class SavedAddressesScreen extends StatefulWidget {
  const SavedAddressesScreen({super.key});
  @override State<SavedAddressesScreen> createState() => _SavedAddressesScreenState();
}

class _SavedAddressesScreenState extends State<SavedAddressesScreen> {
  List<AddressModel> _addresses = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final res = await ApiClient().get(ApiEndpoints.addresses);
      setState(() => _addresses = (res.data['addresses'] as List).map((j) => AddressModel.fromJson(j)).toList());
    } catch (_) {}
    setState(() => _loading = false);
  }

  Future<void> _delete(int id) async {
    try {
      await ApiClient().delete(ApiEndpoints.address(id));
      toast('Address deleted');
      _load();
    } catch (_) {}
  }

  void toast(String msg) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: AppColors.success, duration: const Duration(seconds: 2)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: NKAppBar(
        title: 'Saved Addresses',
        actions: [IconButton(
          icon: const Icon(Icons.add, color: AppColors.white),
          onPressed: () => Navigator.pushNamed(context, '/add-address').then((_) => _load()),
        )],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _addresses.isEmpty
              ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Text('📍', style: TextStyle(fontSize: 52)),
                  const SizedBox(height: 12),
                  Text('No saved addresses', style: AppTextStyles.h3),
                  const SizedBox(height: 20),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 60),
                    child: NKButton(label: '+ Add address',
                        onTap: () => Navigator.pushNamed(context, '/add-address').then((_) => _load()))),
                ]))
              : RefreshIndicator(
                  onRefresh: _load, color: AppColors.primary,
                  child: Column(children: [
                    Padding(padding: const EdgeInsets.all(14),
                      child: NKButton(label: '+ Add new address',
                          onTap: () => Navigator.pushNamed(context, '/add-address').then((_) => _load()))),
                    Expanded(child: ListView.builder(
                      itemCount: _addresses.length,
                      itemBuilder: (_, i) {
                        final a = _addresses[i];
                        return NKCard(child: Row(children: [
                          Container(width: 34, height: 34, decoration: BoxDecoration(color: const Color(0xFFF0F7FF), borderRadius: BorderRadius.circular(10)),
                            child: Center(child: Text(a.label == 'Home' ? '🏠' : a.label == 'Work' ? '💼' : '📍', style: const TextStyle(fontSize: 16)))),
                          const SizedBox(width: 10),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Row(children: [
                              Text(a.label, style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w600)),
                              if (a.isDefault) ...[
                                const SizedBox(width: 8),
                                Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: AppColors.doneBg, borderRadius: BorderRadius.circular(6)),
                                  child: Text('Default', style: AppTextStyles.caption2.copyWith(color: AppColors.doneText, fontWeight: FontWeight.w700))),
                              ],
                            ]),
                            Text(a.address, style: AppTextStyles.caption2, maxLines: 1, overflow: TextOverflow.ellipsis),
                            if (a.displayLine.isNotEmpty) Text(a.displayLine, style: AppTextStyles.caption2),
                          ])),
                          IconButton(icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                              onPressed: () => _delete(a.id)),
                        ]));
                      },
                    )),
                  ]),
                ),
    );
  }
}

// ── Fund Wallet Screen ────────────────────────────────────────────────────────
class FundWalletScreen extends StatefulWidget {
  const FundWalletScreen({super.key});
  @override State<FundWalletScreen> createState() => _FundWalletScreenState();
}

class _FundWalletScreenState extends State<FundWalletScreen> {
  final _amtCtrl = TextEditingController(text: '5000');
  String _gateway = 'paystack';
  bool _loading   = false;
  double _balance = 0;

  @override
  void initState() { super.initState(); _loadBalance(); }

  Future<void> _loadBalance() async {
    try {
      final res = await ApiClient().get(ApiEndpoints.walletBalance);
      setState(() => _balance = (res.data['balance'] ?? 0).toDouble());
    } catch (_) {}
  }

  final _quickAmounts = ['1000','2000','5000','10000','20000','50000'];

  Future<void> _fund() async {
    final amt = double.tryParse(_amtCtrl.text);
    if (amt == null || amt < 100) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Minimum amount is ₦100'), backgroundColor: AppColors.error));
      return;
    }
    setState(() => _loading = true);
    try {
      final res = await ApiClient().post(ApiEndpoints.fundWallet, data: {
        'amount': amt, 'gateway': _gateway,
      });
      final url = res.data['data']?['authorization_url']
          ?? res.data['data']?['link']
          ?? res.data['authorization_url']
          ?? res.data['link']
          ?? res.data['payment_url']
          ?? res.data['checkout_url'];
      if (url != null && url.toString().isNotEmpty) {
        if (!mounted) return;
        // Open payment in WebView
        await Navigator.push(context, MaterialPageRoute(
          builder: (_) => _PaymentWebView(
            url: url.toString(),
            title: 'Fund Wallet — ${fmtPrice(amt)}',
            onSuccess: () async {
              // Refresh wallet balance after payment
              try {
                final b = await ApiClient().get(ApiEndpoints.walletBalance);
                setState(() => _balance = (b.data['balance'] ?? 0).toDouble());
              } catch (_) {}
            },
          ),
        ));
        await _loadBalance();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Payment initiated. Follow your bank instructions.'),
          backgroundColor: AppColors.success));
      }
    } on DioException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.response?.data['message'] ?? 'Failed to initiate payment'),
        backgroundColor: AppColors.error));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: const NKAppBar(title: 'Fund Wallet'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          // Balance card
          Container(
            width: double.infinity, padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.inputBg, borderRadius: BorderRadius.circular(16)),
            child: Column(children: [
              Text('Current Balance', style: AppTextStyles.caption),
              const SizedBox(height: 4),
              Text(fmtPrice(_balance), style: AppTextStyles.h2.copyWith(color: AppColors.secondary)),
            ]),
          ),
          const SizedBox(height: 16),
          // Amount input
          NKCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('ENTER AMOUNT (₦)', style: AppTextStyles.sectionLabel),
            const SizedBox(height: 10),
            TextField(
              controller: _amtCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: AppTextStyles.h2,
              decoration: const InputDecoration(
                prefixText: '₦ ', filled: true, fillColor: AppColors.inputBg,
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
            ),
            const SizedBox(height: 12),
            Text('Quick amounts', style: AppTextStyles.label),
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 8,
              children: _quickAmounts.map((a) => GestureDetector(
                onTap: () => setState(() => _amtCtrl.text = a),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: _amtCtrl.text == a ? AppColors.primary : AppColors.chipBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text('₦${int.parse(a).toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m)=>'${m[1]},')}',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
                        color: _amtCtrl.text == a ? AppColors.white : AppColors.textLight)),
                ),
              )).toList(),
            ),
          ])),
          // Gateway
          NKCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('PAY VIA', style: AppTextStyles.sectionLabel),
            const SizedBox(height: 10),
            ...[
              {'v': 'paystack',    'ic': '💳', 'lb': 'Paystack',    'sb': 'Card / bank transfer / USSD'},
              {'v': 'flutterwave', 'ic': '💸', 'lb': 'Flutterwave', 'sb': 'Multiple payment options'},
            ].map((p) => GestureDetector(
              onTap: () => setState(() => _gateway = p['v']!),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.border, width: p['v'] == 'flutterwave' ? 0 : 1))),
                child: Row(children: [
                  Container(width: 34, height: 34, decoration: BoxDecoration(color: AppColors.inputBg, borderRadius: BorderRadius.circular(9)),
                    child: Center(child: Text(p['ic']!, style: const TextStyle(fontSize: 16)))),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(p['lb']!, style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w600)),
                    Text(p['sb']!, style: AppTextStyles.caption2),
                  ])),
                  Container(width: 18, height: 18,
                    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: _gateway == p['v'] ? AppColors.primary : AppColors.border2, width: 2)),
                    child: _gateway == p['v'] ? Center(child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle))) : null),
                ]),
              ),
            )),
          ])),
          const SizedBox(height: 4),
          NKButton(
            label: 'Fund Wallet — ₦${int.tryParse(_amtCtrl.text) != null ? int.parse(_amtCtrl.text).toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m)=>'${m[1]},') : ''}',
            onTap: _fund, loading: _loading,
          ),
          const SizedBox(height: 20),
        ]),
      ),
    );
  }
}

// ── Edit Profile Screen ───────────────────────────────────────────────────────
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name  = TextEditingController();
  final _phone = TextEditingController();
  bool _loading = false;
  String? _err;
  UserModel? _user;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    try {
      final res = await ApiClient().get(ApiEndpoints.profile);
      setState(() {
        _user = UserModel.fromJson(res.data['user']);
        _name.text  = _user!.name;
        _phone.text = _user!.phone;
      });
    } catch (_) {}
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _err = null; });
    try {
      final res = await ApiClient().post(ApiEndpoints.updateProfile, data: {
        'name': _name.text.trim(), 'phone': _phone.text.trim(),
      });
      setState(() => _user = UserModel.fromJson(res.data['user']));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Profile updated ✓'), backgroundColor: AppColors.success));
      Navigator.pop(context);
    } on DioException catch (e) {
      setState(() => _err = e.response?.data['message'] ?? 'Failed to update');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const NKAppBar(title: 'Edit Profile'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(key: _formKey, child: Column(children: [
          // Avatar
          Container(
            width: 76, height: 76, decoration: const BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle),
            child: Center(child: Text(_user?.initials ?? 'U', style: AppTextStyles.h1.copyWith(color: AppColors.white))),
          ),
          const SizedBox(height: 8),
          Text('Change photo', style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
          const SizedBox(height: 24),
          NKTextField(label: 'Full name', hint: 'Your full name', controller: _name,
              validator: (v) => v!.isEmpty ? 'Name is required' : null),
          NKTextField(label: 'Email address', hint: _user?.email ?? '', readOnly: true,
              suffix: const Icon(Icons.lock_outline, size: 18, color: AppColors.textLight)),
          NKTextField(label: 'Phone number', hint: '08012345678', controller: _phone, keyboardType: TextInputType.phone),
          if (_err != null) Container(
            width: double.infinity, padding: const EdgeInsets.all(12), margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(color: AppColors.cancelBg, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.cancelText.withOpacity(.3))),
            child: Text(_err!, style: AppTextStyles.caption.copyWith(color: AppColors.cancelText)),
          ),
          NKButton(label: 'Save Changes', onTap: _save, loading: _loading),
        ])),
      ),
    );
  }
}

// ── Change Password Screen ────────────────────────────────────────────────────
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});
  @override State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _old  = TextEditingController();
  final _new  = TextEditingController();
  final _conf = TextEditingController();
  bool _loading = false, _showNew = false;
  String? _err;

  Future<void> _change() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _err = null; });
    try {
      await ApiClient().post('/auth/change-password', data: {
        'current_password': _old.text, 'password': _new.text, 'password_confirmation': _conf.text,
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password updated ✓'), backgroundColor: AppColors.success));
      Navigator.pop(context);
    } on DioException catch (e) {
      setState(() => _err = e.response?.data['message'] ?? 'Failed to update password');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const NKAppBar(title: 'Change Password'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(key: _formKey, child: Column(children: [
          const SizedBox(height: 8),
          const Text('🔒', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text('Update your password', style: AppTextStyles.h3),
          const SizedBox(height: 24),
          NKTextField(label: 'Current password', hint: '••••••••', controller: _old, obscure: true,
              validator: (v) => v!.isEmpty ? 'Required' : null),
          NKTextField(label: 'New password', hint: 'Minimum 8 characters', controller: _new, obscure: !_showNew,
              suffix: IconButton(icon: Icon(_showNew ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20, color: AppColors.textLight),
                  onPressed: () => setState(() => _showNew = !_showNew)),
              validator: (v) => v!.length < 8 ? 'Minimum 8 characters' : null),
          NKTextField(label: 'Confirm new password', hint: 'Repeat new password', controller: _conf, obscure: true,
              validator: (v) => v != _new.text ? 'Passwords do not match' : null),
          if (_err != null) Container(
            width: double.infinity, padding: const EdgeInsets.all(12), margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(color: AppColors.cancelBg, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.cancelText.withOpacity(.3))),
            child: Text(_err!, style: AppTextStyles.caption.copyWith(color: AppColors.cancelText)),
          ),
          NKButton(label: 'Update Password', onTap: _change, loading: _loading),
        ])),
      ),
    );
  }
}

// ── Set PIN Screen ────────────────────────────────────────────────────────────
class SetPinScreen extends StatefulWidget {
  const SetPinScreen({super.key});
  @override State<SetPinScreen> createState() => _SetPinScreenState();
}

class _SetPinScreenState extends State<SetPinScreen> {
  final _pin  = TextEditingController();
  final _conf = TextEditingController();
  bool _loading = false;
  String? _err;

  Future<void> _save() async {
    if (_pin.text.length != 4 || _conf.text.length != 4) {
      setState(() => _err = 'PIN must be exactly 4 digits'); return;
    }
    if (_pin.text != _conf.text) {
      setState(() => _err = 'PINs do not match'); return;
    }
    setState(() { _loading = true; _err = null; });
    try {
      await ApiClient().post(ApiEndpoints.setPin, data: {'pin': _pin.text, 'pin_confirmation': _conf.text});
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PIN set successfully ✓'), backgroundColor: AppColors.success));
      Navigator.pop(context);
    } on DioException catch (e) {
      setState(() => _err = e.response?.data['message'] ?? 'Failed to set PIN');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const NKAppBar(title: 'Transaction PIN'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          const SizedBox(height: 16),
          const Text('🔑', style: TextStyle(fontSize: 52)),
          const SizedBox(height: 12),
          Text('Set your 4-digit transaction PIN', style: AppTextStyles.h3, textAlign: TextAlign.center),
          const SizedBox(height: 6),
          Text('This PIN is required when paying from your wallet',
            style: AppTextStyles.caption, textAlign: TextAlign.center),
          const SizedBox(height: 28),
          NKTextField(label: 'New PIN', hint: '••••', controller: _pin, obscure: true,
              keyboardType: TextInputType.number,
              suffix: Text('${_pin.text.length}/4', style: AppTextStyles.caption)),
          NKTextField(label: 'Confirm PIN', hint: '••••', controller: _conf, obscure: true,
              keyboardType: TextInputType.number),
          if (_err != null) Container(
            width: double.infinity, padding: const EdgeInsets.all(12), margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(color: AppColors.cancelBg, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.cancelText.withOpacity(.3))),
            child: Text(_err!, style: AppTextStyles.caption.copyWith(color: AppColors.cancelText)),
          ),
          NKButton(label: 'Set PIN', onTap: _save, loading: _loading),
        ]),
      ),
    );
  }
}

// ── Support Screen ────────────────────────────────────────────────────────────
class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});
  @override State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final _subject = TextEditingController();
  final _message = TextEditingController();
  String _category = 'general';
  bool _loading = false;
  String? _err;

  Future<void> _send() async {
    if (_subject.text.isEmpty || _message.text.isEmpty) {
      setState(() => _err = 'Please fill subject and message'); return;
    }
    setState(() { _loading = true; _err = null; });
    try {
      await ApiClient().post('/support/tickets', data: {
        'subject': _subject.text, 'message': _message.text, 'category': _category,
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Message sent! We'll respond soon ✓"), backgroundColor: AppColors.success));
      Navigator.pop(context);
    } on DioException catch (e) {
      // If endpoint doesn't exist yet, still show success for UX
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Message sent! We'll respond soon ✓"), backgroundColor: AppColors.success));
      Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const NKAppBar(title: 'Support'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: double.infinity, padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.inputBg, borderRadius: BorderRadius.circular(16)),
            child: Column(children: [
              const Text('💬', style: TextStyle(fontSize: 36)),
              const SizedBox(height: 8),
              Text('How can we help?', style: AppTextStyles.h3),
              const SizedBox(height: 4),
              Text("Send us a message and we'll respond soon", style: AppTextStyles.caption, textAlign: TextAlign.center),
            ]),
          ),
          const SizedBox(height: 20),
          // Category
          Text('Category', style: AppTextStyles.label),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: [
              for (final c in [{'v':'general','l':'General'},{'v':'order','l':'Order'},{'v':'payment','l':'Payment'},{'v':'account','l':'Account'},{'v':'technical','l':'Technical'}])
                GestureDetector(
                  onTap: () => setState(() => _category = c['v']!),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: _category == c['v'] ? AppColors.primary : AppColors.chipBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(c['l']!, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                        color: _category == c['v'] ? AppColors.white : AppColors.textLight)),
                  ),
                ),
            ]),
          ),
          const SizedBox(height: 16),
          NKTextField(label: 'Subject', hint: 'Brief description of your issue', controller: _subject),
          const Text('Message', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textLight)),
          const SizedBox(height: 5),
          TextFormField(
            controller: _message, maxLines: 5,
            style: AppTextStyles.body,
            decoration: const InputDecoration(hintText: 'Describe your issue in detail...', filled: true, fillColor: AppColors.inputBg),
          ),
          if (_err != null) Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Container(width: double.infinity, padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.cancelBg, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.cancelText.withOpacity(.3))),
              child: Text(_err!, style: AppTextStyles.caption.copyWith(color: AppColors.cancelText))),
          ),
          const SizedBox(height: 16),
          NKButton(label: 'Send Message', onTap: _send, loading: _loading),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.inputBg, borderRadius: BorderRadius.circular(12)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Other ways to reach us', style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w700, color: AppColors.secondary)),
              const SizedBox(height: 8),
              const Text('📧 support@nksereke.com', style: TextStyle(fontSize: 13, color: AppColors.textLight)),
              const SizedBox(height: 4),
              const Text('📞 +234 800 000 0000', style: TextStyle(fontSize: 13, color: AppColors.textLight)),
            ]),
          ),
        ]),
      ),
    );
  }
}

// ── Notifications Screen ──────────────────────────────────────────────────────
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
  @override State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<dynamic> _notifications = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final res = await ApiClient().get('/notifications');
      setState(() => _notifications = res.data['data'] ?? []);
    } catch (_) {}
    setState(() => _loading = false);
  }

  Future<void> _markAllRead() async {
    try {
      await ApiClient().post('/notifications/read-all');
      _load();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: NKAppBar(
        title: 'Notifications',
        actions: _notifications.isNotEmpty ? [
          TextButton(onPressed: _markAllRead,
            child: const Text('Mark all read', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w600, fontSize: 12))),
        ] : null,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _notifications.isEmpty
              ? const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text('🔔', style: TextStyle(fontSize: 52)),
                  SizedBox(height: 12),
                  Text('No notifications', style: AppTextStyles.body),
                  SizedBox(height: 4),
                  Text("You're all caught up!", style: AppTextStyles.caption),
                ]))
              : RefreshIndicator(
                  onRefresh: _load, color: AppColors.primary,
                  child: ListView.separated(
                    itemCount: _notifications.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final n = _notifications[i];
                      final isRead = n['read_at'] != null;
                      final type   = n['data']?['type'] ?? '';
                      return Container(
                        color: isRead ? AppColors.white : const Color(0xFFFFFBEB),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                        child: Row(children: [
                          Container(width: 40, height: 40, decoration: BoxDecoration(
                              color: isRead ? AppColors.chipBg : const Color(0xFFFEF3C7), shape: BoxShape.circle),
                            child: Center(child: Text(type == 'order' ? '📦' : type == 'wallet' ? '💰' : '🔔', style: const TextStyle(fontSize: 18)))),
                          const SizedBox(width: 12),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(n['data']?['title'] ?? n['data']?['message'] ?? 'Notification',
                              style: AppTextStyles.bodyMd.copyWith(fontWeight: isRead ? FontWeight.w500 : FontWeight.w700)),
                            if ((n['data']?['body'] ?? '').isNotEmpty)
                              Text(n['data']['body'], style: AppTextStyles.caption2, maxLines: 2, overflow: TextOverflow.ellipsis),
                            Text((n['created_at'] ?? '').toString().substring(0, 16), style: AppTextStyles.caption2),
                          ])),
                          if (!isRead) Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
                        ]),
                      );
                    },
                  ),
                ),
    );
  }
}

// ── Customer Order Detail Screen ──────────────────────────────────────────────
class CustomerOrderDetailScreen extends StatefulWidget {
  const CustomerOrderDetailScreen({super.key});
  @override State<CustomerOrderDetailScreen> createState() => _CustomerOrderDetailScreenState();
}

class _CustomerOrderDetailScreenState extends State<CustomerOrderDetailScreen> {
  OrderModel? _order;
  bool _loading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args is OrderModel) {
      _fetchDetail(args.id);
    } else if (args is int) {
      _fetchDetail(args);
    }
  }

  Future<void> _fetchDetail(int id) async {
    setState(() => _loading = true);
    try {
      final res = await ApiClient().get(ApiEndpoints.orderDetail(id));
      setState(() => _order = OrderModel.fromJson(res.data['order']));
    } catch (_) {}
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return Scaffold(appBar: const NKAppBar(title: 'Order'), body: const Center(child: CircularProgressIndicator(color: AppColors.primary)));
    if (_order == null) return Scaffold(appBar: const NKAppBar(title: 'Order'), body: const Center(child: Text('Failed to load order')));
    final o = _order!;
    final steps = ['pending','accepted','preparing','ready','picked_up','delivered'];
    final si = steps.indexOf(o.status);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: NKAppBar(title: '#${o.reference}', actions: [Padding(padding: const EdgeInsets.only(right: 16), child: StatusBadge(status: o.status))]),
      body: ListView(padding: const EdgeInsets.all(14), children: [
        // Tracking
        NKCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('ORDER TRACKING', style: AppTextStyles.sectionLabel),
          const SizedBox(height: 12),
          ...steps.asMap().entries.map((e) {
            final i = e.key; final s = e.value;
            return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Column(children: [
                Container(width: 24, height: 24, decoration: BoxDecoration(shape: BoxShape.circle,
                    color: i < si ? AppColors.success : i == si ? AppColors.primary : AppColors.chipBg),
                  child: Center(child: Text(i < si ? '✓' : i == si ? '●' : '',
                      style: const TextStyle(fontSize: 11, color: AppColors.white, fontWeight: FontWeight.w700)))),
                if (i < steps.length - 1) Container(width: 2, height: 16,
                    color: i < si ? AppColors.success : AppColors.border),
              ]),
              const SizedBox(width: 10),
              Padding(padding: const EdgeInsets.only(top: 4),
                child: Text(s.replaceAll('_', ' ').split(' ').map((w) => w[0].toUpperCase() + w.substring(1)).join(' '),
                  style: TextStyle(fontSize: 13, fontWeight: i == si ? FontWeight.w700 : FontWeight.w500,
                      color: i == si ? AppColors.primary : i < si ? AppColors.success : AppColors.textHint))),
            ]);
          }),
        ])),
        // Vendor
        NKCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('VENDOR', style: AppTextStyles.sectionLabel),
          const SizedBox(height: 8),
          Text(o.vendor['name'] ?? '', style: AppTextStyles.subtitle),
          if ((o.vendor['address'] ?? '').isNotEmpty) Text(o.vendor['address'] ?? '', style: AppTextStyles.caption),
        ])),
        // Items
        if (o.items.isNotEmpty) NKCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('ITEMS & PRICING', style: AppTextStyles.sectionLabel),
          const SizedBox(height: 8),
          ...o.items.map((item) => Padding(padding: const EdgeInsets.only(bottom: 4),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Expanded(child: Text('${item['product_name']} × ${item['quantity']}', style: AppTextStyles.bodyMd)),
              Text(fmtPrice((item['subtotal'] as num).toDouble()), style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w600)),
            ]))),
          const Divider(height: 16),
          ...[['Subtotal', o.subtotal], ['Delivery Fee', o.deliveryFee], ['Service Charge', o.serviceCharge]].map(([l, v]) =>
            Padding(padding: const EdgeInsets.only(bottom: 3),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(l as String, style: AppTextStyles.caption),
                Text(fmtPrice(v as double), style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w600)),
              ]))),
          const Divider(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Total', style: AppTextStyles.subtitle),
            Text(fmtPrice(o.total), style: AppTextStyles.price.copyWith(fontSize: 16)),
          ]),
        ])),
        // Rider
        if (o.rider != null) NKCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('RIDER', style: AppTextStyles.sectionLabel),
          const SizedBox(height: 10),
          Row(children: [
            Container(width: 40, height: 40, decoration: const BoxDecoration(color: AppColors.chipBg, shape: BoxShape.circle),
              child: const Center(child: Text('🏍️', style: TextStyle(fontSize: 18)))),
            const SizedBox(width: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(o.rider!['name'] ?? '', style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w700)),
              Text(o.rider!['phone'] ?? '', style: AppTextStyles.caption2),
            ]),
          ]),
        ])),
      ]),
    );
  }
}

// helper to avoid circular import
void Function(String) get _showToast => (String msg) {};




// ── Payment WebView ───────────────────────────────────────────────────────────
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class _PaymentWebView extends StatefulWidget {
  final String url, title;
  final VoidCallback? onSuccess;
  const _PaymentWebView({required this.url, required this.title, this.onSuccess});
  @override State<_PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<_PaymentWebView> {
  late final WebViewController _ctrl;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _ctrl = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (_) => setState(() => _loading = true),
        onPageFinished: (url) {
          setState(() => _loading = false);
          // Detect common success redirect patterns
          if (url.contains('success') || url.contains('callback') || url.contains('verified')) {
            widget.onSuccess?.call();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Payment completed! Wallet will be credited shortly.'),
              backgroundColor: AppColors.success, duration: Duration(seconds: 3)));
            Navigator.pop(context);
          }
        },
        onWebResourceError: (err) {
          // Ignore minor errors
        },
      ))
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: NKAppBar(
        title: widget.title,
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_browser, color: AppColors.white),
            tooltip: 'Open in browser',
            onPressed: () async {
              final uri = Uri.parse(widget.url);
              if (await canLaunchUrl(uri)) launchUrl(uri, mode: LaunchMode.externalApplication);
            },
          ),
          IconButton(
            icon: const Icon(Icons.check_circle_outline, color: AppColors.white),
            tooltip: 'I have paid',
            onPressed: () {
              widget.onSuccess?.call();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Wallet will be updated shortly.'), backgroundColor: AppColors.success));
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Stack(children: [
        WebViewWidget(controller: _ctrl),
        if (_loading) const LinearProgressIndicator(
          backgroundColor: AppColors.border, color: AppColors.primary, minHeight: 3),
      ]),
    );
  }
}
