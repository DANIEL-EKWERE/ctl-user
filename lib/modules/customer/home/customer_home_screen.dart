// import 'dart:developer' as myLog;
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:get/get.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import '../../../core/theme/app_theme.dart';
// import '../../../core/utils/app_utils.dart';
// import '../../../data/models/models.dart';
// import '../../../data/services/location_service.dart';
// import '../../../routes/app_routes.dart';
// import '../../../widgets/app_widgets.dart';
// import '../../auth/auth_controller.dart';
// import '../cart/cart_controller.dart';
// import 'customer_home_controller.dart';
// import '../orders/orders_screen.dart';
// import '../wallet/wallet_screen.dart';
// import '../account/account_screen.dart';

// // ─── Customer Shell ───────────────────────────────────────────────────────────
// class CustomerShell extends StatelessWidget {
//   const CustomerShell({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final ctrl = Get.put(CustomerHomeController());
//     Get.put(CartController());

//     final tabs = [
//       const HomeTab(),
//       const OrdersScreen(),
//       const WalletScreen(),
//       const AccountScreen(),
//     ];

//     return Obx(() {
//       if (!ctrl.locationReady.value) return const LocationOnboardingScreen();
//       return Scaffold(
//         body: IndexedStack(index: ctrl.currentTab.value, children: tabs),
//         bottomNavigationBar: _BottomNav(ctrl: ctrl),
//       );
//     });
//   }
// }

// class _BottomNav extends StatelessWidget {
//   final CustomerHomeController ctrl;
//   const _BottomNav({required this.ctrl});

//   @override
//   Widget build(BuildContext context) {
//     final items = [
//       [Icons.home_outlined, Icons.home, 'Home'],
//       [Icons.receipt_long_outlined, Icons.receipt_long, 'Orders'],
//       [
//         Icons.account_balance_wallet_outlined,
//         Icons.account_balance_wallet,
//         'Wallet',
//       ],
//       [Icons.person_outline, Icons.person, 'Account'],
//     ];
//     return Container(
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         border: Border(top: BorderSide(color: AppColors.border, width: 1.5)),
//       ),
//       padding: const EdgeInsets.only(top: 8, bottom: 6),
//       child: Row(
//         children: List.generate(
//           items.length,
//           (i) => Expanded(
//             child: GestureDetector(
//               onTap: () => ctrl.switchTab(i),
//               child: Obx(() {
//                 final active = ctrl.currentTab.value == i;
//                 return Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(
//                       active
//                           ? items[i][1] as IconData
//                           : items[i][0] as IconData,
//                       size: 22,
//                       color: active
//                           ? AppColors.orange
//                           : AppColors.textSecondary,
//                     ),
//                     const SizedBox(height: 3),
//                     Text(
//                       items[i][2] as String,
//                       style: TextStyle(
//                         fontSize: 10,
//                         fontWeight: FontWeight.w600,
//                         color: active
//                             ? AppColors.orange
//                             : AppColors.textSecondary,
//                       ),
//                     ),
//                   ],
//                 );
//               }),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ─── Location Onboarding ─────────────────────────────────────────────────────
// class LocationOnboardingScreen extends StatefulWidget {
//   const LocationOnboardingScreen({super.key});
//   @override
//   State<LocationOnboardingScreen> createState() => _LocationOnboardingState();
// }

// class _LocationOnboardingState extends State<LocationOnboardingScreen> {
//   final ctrl = CustomerHomeController.to;
//   final _searchCtrl = TextEditingController();
//   final _focusNode = FocusNode();
//   List<dynamic> _suggestions = [];
//   bool _searching = false;
//   String? _error;
//   Timer? _debounce;

//   @override
//   void initState() {
//     super.initState();
//     _focusNode.addListener(_onFocusChange);
//     // Load saved addresses if not already loaded
//     if (ctrl.addresses.isEmpty) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         ctrl.loadAddresses();
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _searchCtrl.dispose();
//     _debounce?.cancel();
//     _focusNode.removeListener(_onFocusChange);
//     _focusNode.dispose();
//     super.dispose();
//   }

//   /// Shows saved addresses when the field is focused and empty.
//   /// Uses a small delay to handle the case where addresses are still loading.
//   void _onFocusChange() {
//     if (_focusNode.hasFocus) {
//       if (_searchCtrl.text.isEmpty) {
//         if (ctrl.addresses.isNotEmpty) {
//           // Addresses already loaded — show them immediately
//           setState(() => _suggestions = ctrl.addresses.take(5).toList());
//         } else {
//           // Addresses may still be loading — wait briefly then show if ready
//           Future.delayed(const Duration(milliseconds: 300), () {
//             if (mounted && _focusNode.hasFocus && _searchCtrl.text.isEmpty) {
//               setState(() => _suggestions = ctrl.addresses.take(5).toList());
//             }
//           });
//         }
//       }
//     } else {
//       // Delay dismiss so a tap on a suggestion isn't cancelled by focus loss
//       Future.delayed(const Duration(milliseconds: 150), () {
//         if (mounted && !_focusNode.hasFocus) {
//           setState(() => _suggestions = []);
//         }
//       });
//     }
//   }

//   void _onSearch(String q) {
//     _debounce?.cancel();

//     if (q.trim().isEmpty) {
//       // Field cleared while focused → fall back to saved addresses
//       if (_focusNode.hasFocus && ctrl.addresses.isNotEmpty) {
//         setState(() => _suggestions = ctrl.addresses.take(5).toList());
//       } else {
//         setState(() => _suggestions = []);
//       }
//       return;
//     }

//     if (q.trim().length < 3) {
//       setState(() => _suggestions = []);
//       return;
//     }

//     // Debounced Nominatim search
//     _debounce = Timer(const Duration(milliseconds: 300), () async {
//       setState(() => _searching = true);
//       final results = await LocationService.instance.searchAddress(q);
//       if (mounted) {
//         setState(() {
//           _suggestions = results;
//           _searching = false;
//         });
//       }
//     });
//   }

//   Future<void> _selectResult(dynamic r) async {
//     if (r is NominatimResult) {
//       _searchCtrl.text = r.shortName;
//       await ctrl.setLocation(
//         r.shortName,
//         r.lat,
//         r.lng,
//         city: r.city,
//         state: r.state,
//       );
//     } else if (r is DeliveryAddress) {
//       _searchCtrl.text = r.address;
//       await ctrl.setLocation(
//         r.address,
//         r.latitude!,
//         r.longitude!,
//         city: r.city,
//         state: r.state,
//       );
//     }
//     setState(() => _suggestions = []);
//     if (mounted) Navigator.of(context).pop();
//   }

//   Future<void> _useGps(BuildContext ctx, CustomerHomeController ctrl) async {
//     try {
//       final pos = await ctrl.determinePosition();

//       final placemarks = await placemarkFromCoordinates(
//         pos.latitude,
//         pos.longitude,
//       );

//       if (placemarks.isNotEmpty) {
//         final place = placemarks[1];

//         final addressParts = <String>[];
//         if (place.street != null && place.street!.isNotEmpty) {
//           addressParts.add(place.street!);
//         }
//         if (place.locality != null && place.locality!.isNotEmpty) {
//           addressParts.add(place.locality!);
//         }
//         if (place.administrativeArea != null &&
//             place.administrativeArea!.isNotEmpty) {
//           addressParts.add(place.administrativeArea!);
//         }
//         if (place.country != null && place.country!.isNotEmpty) {
//           addressParts.add(place.country!);
//         }

//         final address = addressParts.join(', ');

//         ctrl.setLocation(address, pos.latitude, pos.longitude);
//         ctrl.locationReady.value = true;
//         if (mounted) Navigator.of(ctx).pop();
//       } else {
//         Get.snackbar(
//           'Location Error',
//           'Could not find address for this location. Please select manually.',
//           backgroundColor: Colors.white,
//           colorText: AppColors.textPrimary,
//         );
//       }
//     } catch (e) {
//       myLog.log('Location error: $e');
//       Get.snackbar(
//         'Location Error',
//         'Failed to get GPS location. Please select your location manually.',
//         backgroundColor: Colors.white,
//         colorText: AppColors.textPrimary,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) => Scaffold(
//     backgroundColor: AppColors.white,
//     body: Column(
//       children: [
//         // ── Orange header ──
//         Container(
//           width: double.infinity,
//           color: AppColors.orange,
//           padding: EdgeInsets.only(
//             top: MediaQuery.of(context).padding.top + 16,
//             left: 20,
//             right: 20,
//             bottom: 24,
//           ),
//           child: Column(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 width: 70,
//                 height: 70,
//                 decoration: BoxDecoration(
//                   color: AppColors.navy,
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Center(
//                   child: Image.asset(
//                     'assets/images/logo.jpeg',
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 'Set Your Location',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 20,
//                   fontWeight: FontWeight.w800,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               const Text(
//                 'We need your address to show nearby vendors',
//                 style: TextStyle(color: Colors.white70, fontSize: 13),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//         ),

//         // ── Scrollable body ──
//         Expanded(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(24),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Center(
//                   child: Icon(
//                     Icons.location_on,
//                     size: 52,
//                     color: AppColors.orange,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 const Center(
//                   child: Text(
//                     'Where should we deliver?',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w700,
//                       color: AppColors.navy,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 6),
//                 const Center(
//                   child: Text(
//                     'Your location helps us show vendors within your delivery radius.',
//                     style: TextStyle(
//                       fontSize: 13,
//                       color: AppColors.textSecondary,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//                 const SizedBox(height: 24),

//                 // ── Search field ──
//                 TextField(
//                   controller: _searchCtrl,
//                   focusNode: _focusNode,
//                   onChanged: _onSearch,
//                   decoration: InputDecoration(
//                     prefixIcon: _searching
//                         ? const Padding(
//                             padding: EdgeInsets.all(12),
//                             child: SizedBox(
//                               width: 18,
//                               height: 18,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2,
//                                 color: AppColors.orange,
//                               ),
//                             ),
//                           )
//                         : const Icon(
//                             Icons.search,
//                             color: AppColors.textSecondary,
//                           ),
//                     hintText: 'Search your street, area or city...',
//                     filled: true,
//                     fillColor: AppColors.inputBg,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: const BorderSide(color: AppColors.border),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: const BorderSide(
//                         color: AppColors.orange,
//                         width: 1.5,
//                       ),
//                     ),
//                   ),
//                 ),

//                 // ── Suggestions dropdown ──
//                 if (_suggestions.isNotEmpty) ...[
//                   const SizedBox(height: 4),
//                   Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: AppColors.border),
//                       boxShadow: const [
//                         BoxShadow(
//                           color: Color(0x18000000),
//                           blurRadius: 8,
//                           offset: Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       children: _suggestions.asMap().entries.map((e) {
//                         final r = e.value;
//                         final isLast = e.key == _suggestions.length - 1;
//                         final isSaved = r is DeliveryAddress;

//                         return InkWell(
//                           borderRadius: BorderRadius.vertical(
//                             top: e.key == 0
//                                 ? const Radius.circular(12)
//                                 : Radius.zero,
//                             bottom: isLast
//                                 ? const Radius.circular(12)
//                                 : Radius.zero,
//                           ),
//                           onTap: () => _selectResult(r),
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 14,
//                               vertical: 12,
//                             ),
//                             decoration: BoxDecoration(
//                               border: isLast
//                                   ? null
//                                   : const Border(
//                                       bottom: BorderSide(
//                                         color: AppColors.border,
//                                       ),
//                                     ),
//                             ),
//                             child: Row(
//                               children: [
//                                 // Icon differs: bookmark for saved, pin for search
//                                 Icon(
//                                   isSaved
//                                       ? Icons.bookmark_outline
//                                       : Icons.location_on_outlined,
//                                   size: 16,
//                                   color: isSaved
//                                       ? AppColors.navy
//                                       : AppColors.orange,
//                                 ),
//                                 const SizedBox(width: 10),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         isSaved
//                                             ? (r as DeliveryAddress).address
//                                             : (r as NominatimResult).shortName,
//                                         style: const TextStyle(
//                                           fontSize: 13,
//                                           fontWeight: FontWeight.w600,
//                                           color: AppColors.navy,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 2),
//                                       if (isSaved)
//                                         const Text(
//                                           'Saved address',
//                                           style: TextStyle(
//                                             fontSize: 10,
//                                             color: AppColors.textSecondary,
//                                           ),
//                                         )
//                                       else if ((r as NominatimResult).city !=
//                                               null ||
//                                           r.state != null)
//                                         Text(
//                                           '${r.city ?? ''}, ${r.state ?? ''}',
//                                           style: const TextStyle(
//                                             fontSize: 11,
//                                             color: AppColors.textSecondary,
//                                           ),
//                                         ),
//                                     ],
//                                   ),
//                                 ),
//                                 // Arrow hint
//                                 const Icon(
//                                   Icons.north_west,
//                                   size: 12,
//                                   color: AppColors.textLight,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                 ],

//                 const SizedBox(height: 16),

//                 // ── GPS button ──
//                 Obx(
//                   () => AppButton(
//                     label: ctrl.gpsLoading.value
//                         ? 'Getting location...'
//                         : 'Use my current GPS location',
//                     loading: ctrl.gpsLocationInProgress.value,
//                     onTap: () => _useGps(context, ctrl),
//                   ),
//                 ),

//                 // ── Error message ──
//                 if (_error != null) ...[
//                   const SizedBox(height: 12),
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFFEF2F2),
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(color: const Color(0xFFFECACA)),
//                     ),
//                     child: Text(
//                       _error!,
//                       style: const TextStyle(
//                         color: AppColors.red,
//                         fontSize: 13,
//                       ),
//                     ),
//                   ),
//                 ],

//                 const SizedBox(height: 16),
//                 AppOutlineButton(
//                   label: 'Sign out',
//                   onTap: AuthController.to.logout,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }

// // ─── Home Tab ─────────────────────────────────────────────────────────────────
// class HomeTab extends StatelessWidget {
//   const HomeTab({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final ctrl = CustomerHomeController.to;
//     final cart = CartController.to;
//     return Scaffold(
//       body: Column(
//         children: [
//           _OrangeHeader(ctrl: ctrl, cart: cart),
//           Expanded(
//             child: RefreshIndicator(
//               onRefresh: () async {
//                 await ctrl.loadCategories();
//                 await ctrl.loadVendors();
//               },
//               child: ListView(
//                 padding: EdgeInsets.zero,
//                 children: [_categoriesSection(ctrl), _vendorsSection(ctrl)],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _categoriesSection(CustomerHomeController ctrl) => Obx(
//     () => Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.fromLTRB(14, 16, 14, 8),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 'Categories',
//                 style: TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w700,
//                   color: AppColors.navy,
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () => Get.toNamed(AppRoutes.vendors),
//                 child: const Text(
//                   'All Vendors',
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w700,
//                     color: AppColors.orange,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         if (ctrl.categories.isEmpty)
//           const Padding(
//             padding: EdgeInsets.all(16),
//             child: Center(
//               child: CircularProgressIndicator(
//                 color: AppColors.orange,
//                 strokeWidth: 2,
//               ),
//             ),
//           )
//         else
//           SizedBox(
//             height: 90,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               padding: const EdgeInsets.symmetric(horizontal: 14),
//               itemCount: ctrl.categories.length,
//               itemBuilder: (_, i) => _CategoryChip(cat: ctrl.categories[i]),
//             ),
//           ),
//       ],
//     ),
//   );

//   Widget _vendorsSection(CustomerHomeController ctrl) => Obx(
//     () => Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 'Vendors Near You',
//                 style: TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w700,
//                   color: AppColors.navy,
//                 ),
//               ),
//               if (ctrl.vendors.isNotEmpty)
//                 GestureDetector(
//                   onTap: () => Get.toNamed(AppRoutes.vendors),
//                   child: const Text(
//                     'See all',
//                     style: TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w700,
//                       color: AppColors.orange,
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//         if (ctrl.vendorsLoading.value)
//           const Padding(
//             padding: EdgeInsets.all(32),
//             child: Center(
//               child: CircularProgressIndicator(color: AppColors.orange),
//             ),
//           )
//         else if (ctrl.vendorsError.value != null)
//           _errorState(ctrl)
//         else if (ctrl.vendors.isEmpty && ctrl.vendorsLoaded.value)
//           SizedBox(
//             width: double.infinity,
//             child: EmptyState(
//               icon: Icons.store_outlined,
//               title: 'No vendors in your area yet',
//               subtitle: 'We are expanding! Try changing your location.',
//               buttonLabel: 'Change Location',
//               onButton: () => Get.to(() => const LocationOnboardingScreen()),
//             ),
//           )
//         else
//           ...ctrl.vendors.take(6).map((v) => VendorCard(vendor: v)),
//       ],
//     ),
//   );

//   Widget _errorState(CustomerHomeController ctrl) => Padding(
//     padding: const EdgeInsets.all(24),
//     child: Column(
//       children: [
//         const Icon(
//           Icons.warning_amber_rounded,
//           size: 40,
//           color: AppColors.textSecondary,
//         ),
//         const SizedBox(height: 12),
//         Text(
//           ctrl.vendorsError.value!,
//           textAlign: TextAlign.center,
//           style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
//         ),
//         const SizedBox(height: 12),
//         SizedBox(
//           width: 140,
//           child: AppButton(
//             label: 'Try Again',
//             height: 40,
//             onTap: () => ctrl.loadVendors(),
//           ),
//         ),
//       ],
//     ),
//   );
// }

// // ─── Orange Header ────────────────────────────────────────────────────────────
// class _OrangeHeader extends StatelessWidget {
//   final CustomerHomeController ctrl;
//   final CartController cart;
//   const _OrangeHeader({required this.ctrl, required this.cart});

//   @override
//   Widget build(BuildContext context) => Container(
//     color: AppColors.orange,
//     padding: EdgeInsets.only(
//       top: MediaQuery.of(context).padding.top + 8,
//       left: 16,
//       right: 16,
//       bottom: 14,
//     ),
//     child: Column(
//       children: [
//         Row(
//           children: [
//             Container(
//               width: 28,
//               height: 28,
//               decoration: BoxDecoration(
//                 color: AppColors.navy,
//                 borderRadius: BorderRadius.circular(7),
//               ),
//               child: Center(
//                 child: Padding(
//                   padding: const EdgeInsets.all(2.0),
//                   child: Image.asset(
//                     'assets/images/logo.jpeg',
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 8),
//             const Expanded(
//               child: Text(
//                 'NKsereke',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 15,
//                   fontWeight: FontWeight.w800,
//                 ),
//               ),
//             ),
//             Obx(
//               () => GestureDetector(
//                 onTap: () => Get.toNamed(AppRoutes.cart),
//                 child: Stack(
//                   clipBehavior: Clip.none,
//                   children: [
//                     const Icon(
//                       Icons.shopping_bag_outlined,
//                       color: Colors.white,
//                       size: 26,
//                     ),
//                     if (cart.totalItems > 0)
//                       Positioned(
//                         top: -4,
//                         right: -4,
//                         child: Container(
//                           width: 16,
//                           height: 16,
//                           decoration: const BoxDecoration(
//                             color: AppColors.red,
//                             shape: BoxShape.circle,
//                           ),
//                           child: Center(
//                             child: Text(
//                               '${cart.totalItems}',
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 9,
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 8),
//         Obx(
//           () => GestureDetector(
//             onTap: () => Get.to(() => const LocationOnboardingScreen()),
//             child: Row(
//               children: [
//                 const Icon(Icons.location_on, color: Colors.white, size: 16),
//                 const SizedBox(width: 4),
//                 Expanded(
//                   child: Text(
//                     ctrl.delivAddr.value ?? 'Set delivery location',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 13,
//                       fontWeight: FontWeight.w600,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 const Icon(
//                   Icons.keyboard_arrow_down,
//                   color: Colors.white70,
//                   size: 18,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }

// // ─── Category Chip ────────────────────────────────────────────────────────────
// class _CategoryChip extends StatelessWidget {
//   final Category cat;
//   const _CategoryChip({required this.cat});

//   @override
//   Widget build(BuildContext context) {
//     final categoryIcons = {
//       'Fast Food': Icons.fastfood_outlined,
//       'Restaurant': Icons.restaurant_outlined,
//       'Supermarket': Icons.shopping_cart_outlined,
//       'Pharmacy': Icons.local_pharmacy_outlined,
//       'Bakery': Icons.bakery_dining_outlined,
//       'Pizza': Icons.local_pizza_outlined,
//       'Drinks': Icons.local_drink_outlined,
//       'Grocery': Icons.eco_outlined,
//     };
//     final icon = categoryIcons[cat.name] ?? Icons.store_outlined;

//     return GestureDetector(
//       onTap: () {
//         final ctrl = CustomerHomeController.to;
//         ctrl.selectedCatId.value = cat.id;
//         ctrl.selectedCatName.value = cat.name;
//         Get.toNamed(AppRoutes.vendors);
//       },
//       child: Container(
//         margin: const EdgeInsets.only(right: 10),
//         width: 70,
//         child: Column(
//           children: [
//             Container(
//               width: 56,
//               height: 56,
//               decoration: BoxDecoration(
//                 color: AppColors.chipBg,
//                 borderRadius: BorderRadius.circular(14),
//                 border: Border.all(color: AppColors.border),
//               ),
//               child: cat.imageUrl != null
//                   ? ClipRRect(
//                       borderRadius: BorderRadius.circular(14),
//                       child: CachedNetworkImage(
//                         imageUrl: cat.imageUrl!,
//                         fit: BoxFit.cover,
//                         errorWidget: (_, __, ___) =>
//                             Icon(icon, size: 26, color: AppColors.orange),
//                       ),
//                     )
//                   : Icon(icon, size: 26, color: AppColors.orange),
//             ),
//             const SizedBox(height: 5),
//             Text(
//               cat.name,
//               style: const TextStyle(
//                 fontSize: 10,
//                 fontWeight: FontWeight.w600,
//                 color: AppColors.textPrimary,
//               ),
//               textAlign: TextAlign.center,
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ─── Vendor Card ──────────────────────────────────────────────────────────────
// class VendorCard extends StatelessWidget {
//   final Vendor vendor;
//   const VendorCard({super.key, required this.vendor});

//   @override
//   Widget build(BuildContext context) => GestureDetector(
//     onTap: () => Get.toNamed(AppRoutes.vendorDetail, arguments: vendor.id),
//     child: Container(
//       margin: const EdgeInsets.fromLTRB(14, 0, 14, 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: AppColors.border),
//         boxShadow: const [
//           BoxShadow(
//             color: Color(0x14000000),
//             blurRadius: 4,
//             offset: Offset(0, 1),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           // Banner
//           Stack(
//             children: [
//               ClipRRect(
//                 borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(16),
//                 ),
//                 child: vendor.bannerUrl != null
//                     ? CachedNetworkImage(
//                         imageUrl: vendor.bannerUrl!,
//                         height: 80,
//                         width: double.infinity,
//                         fit: BoxFit.cover,
//                         errorWidget: (_, __, ___) => _bannerFallback(),
//                       )
//                     : _bannerFallback(),
//               ),
//               Positioned(
//                 top: 8,
//                 right: 10,
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 9,
//                     vertical: 3,
//                   ),
//                   decoration: BoxDecoration(
//                     color: vendor.isOpen
//                         ? const Color(0xECF0FDF4)
//                         : const Color(0xECFEF2F2),
//                     borderRadius: BorderRadius.circular(20),
//                     border: Border.all(
//                       color: vendor.isOpen ? AppColors.green : AppColors.red,
//                     ),
//                   ),
//                   child: Text(
//                     vendor.isOpen ? '● Open' : '● Closed',
//                     style: TextStyle(
//                       fontSize: 11,
//                       fontWeight: FontWeight.w700,
//                       color: vendor.isOpen ? AppColors.green : AppColors.red,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           // Info
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: Row(
//               children: [
//                 vendor.logoUrl != null
//                     ? AppNetworkImage(
//                         url: vendor.logoUrl,
//                         width: 44,
//                         height: 44,
//                         borderRadius: BorderRadius.circular(11),
//                       )
//                     : AvatarFallback(initials: vendor.initials, size: 44),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         vendor.name,
//                         style: const TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w700,
//                           color: AppColors.navy,
//                         ),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       Row(
//                         children: [
//                           Text(
//                             '★ ${(vendor.rating ?? 0).toStringAsFixed(1)}',
//                             style: const TextStyle(
//                               fontSize: 11,
//                               fontWeight: FontWeight.w600,
//                               color: AppColors.orange,
//                             ),
//                           ),
//                           if (vendor.distanceKm != null) ...[
//                             const SizedBox(width: 8),
//                             Row(
//                               children: [
//                                 const Icon(
//                                   Icons.near_me_outlined,
//                                   size: 11,
//                                   color: AppColors.textSecondary,
//                                 ),
//                                 const SizedBox(width: 2),
//                                 Text(
//                                   '${vendor.distanceKm!.toStringAsFixed(1)}km',
//                                   style: const TextStyle(
//                                     fontSize: 11,
//                                     color: AppColors.textSecondary,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ],
//                       ),
//                       if (vendor.address != null)
//                         Text(
//                           vendor.address!,
//                           style: const TextStyle(
//                             fontSize: 11,
//                             color: AppColors.textSecondary,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                     ],
//                   ),
//                 ),
//                 const Icon(
//                   Icons.arrow_forward_ios,
//                   size: 14,
//                   color: AppColors.textLight,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     ),
//   );

//   Widget _bannerFallback() => Container(
//     height: 80,
//     color: AppColors.navyLight,
//     child: const Center(
//       child: Icon(Icons.store, size: 32, color: Colors.white30),
//     ),
//   );
// }

// // ─── Vendors List Screen ──────────────────────────────────────────────────────
// class VendorsScreen extends StatefulWidget {
//   const VendorsScreen({super.key});
//   @override
//   State<VendorsScreen> createState() => _VendorsScreenState();
// }

// class _VendorsScreenState extends State<VendorsScreen> {
//   final ctrl = CustomerHomeController.to;
//   final cart = CartController.to;
//   final _searchCtrl = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ctrl.loadVendors(catId: ctrl.selectedCatId.value);
//     });
//   }

//   @override
//   Widget build(BuildContext context) => Scaffold(
//     backgroundColor: AppColors.bg,
//     appBar: AppBar(
//       backgroundColor: AppColors.navy,
//       title: Obx(
//         () => Text(
//           ctrl.selectedCatName.value ?? 'Vendors Near You',
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 16,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//       ),
//       leading: IconButton(
//         icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
//         onPressed: () {
//           ctrl.selectedCatId.value = null;
//           ctrl.selectedCatName.value = null;
//           Get.back();
//         },
//       ),
//       actions: [
//         Obx(
//           () => GestureDetector(
//             onTap: () => Get.toNamed(AppRoutes.cart),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               child: Stack(
//                 clipBehavior: Clip.none,
//                 children: [
//                   const Icon(
//                     Icons.shopping_bag_outlined,
//                     color: Colors.white,
//                     size: 24,
//                   ),
//                   if (cart.totalItems > 0)
//                     Positioned(
//                       top: -4,
//                       right: -4,
//                       child: Container(
//                         width: 14,
//                         height: 14,
//                         decoration: const BoxDecoration(
//                           color: AppColors.red,
//                           shape: BoxShape.circle,
//                         ),
//                         child: Center(
//                           child: Text(
//                             '${cart.totalItems}',
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 8,
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     ),
//     body: Column(
//       children: [
//         Container(
//           color: Colors.white,
//           padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
//           child: TextField(
//             controller: _searchCtrl,
//             onChanged: (v) => ctrl.vendorSearch.value = v,
//             decoration: InputDecoration(
//               hintText: '🔍 Search vendors...',
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 12,
//                 vertical: 9,
//               ),
//               filled: true,
//               fillColor: AppColors.inputBg,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: const BorderSide(color: AppColors.border),
//               ),
//               hintStyle: const TextStyle(fontSize: 13),
//             ),
//           ),
//         ),
//         Expanded(
//           child: Obx(() {
//             if (ctrl.vendorsLoading.value) {
//               return const Center(
//                 child: CircularProgressIndicator(color: AppColors.orange),
//               );
//             }
//             final list = ctrl.filteredVendors;
//             if (list.isEmpty) {
//               return EmptyState(
//                 icon: Icons.store_outlined,
//                 title: 'No vendors found',
//                 subtitle:
//                     ctrl.vendorsError.value ??
//                     'Try a different search or location',
//               );
//             }
//             return RefreshIndicator(
//               onRefresh: () =>
//                   ctrl.loadVendors(catId: ctrl.selectedCatId.value),
//               child: ListView.builder(
//                 padding: const EdgeInsets.all(14),
//                 itemCount: list.length,
//                 itemBuilder: (_, i) => Padding(
//                   padding: const EdgeInsets.only(bottom: 2),
//                   child: VendorCard(vendor: list[i]),
//                 ),
//               ),
//             );
//           }),
//         ),
//       ],
//     ),
//   );
// }

// // ─── Vendor Detail Screen ─────────────────────────────────────────────────────
// class VendorDetailScreen extends StatefulWidget {
//   const VendorDetailScreen({super.key});
//   @override
//   State<VendorDetailScreen> createState() => _VendorDetailScreenState();
// }

// class _VendorDetailScreenState extends State<VendorDetailScreen> {
//   final ctrl = CustomerHomeController.to;
//   final cart = CartController.to;

//   @override
//   void initState() {
//     super.initState();
//     final id = Get.arguments as int?;
//     if (id != null) ctrl.loadVendorDetail(id);
//   }

//   @override
//   Widget build(BuildContext context) => Obx(() {
//     final v = ctrl.vendorDetail.value;
//     if (ctrl.vendorLoading.value && v == null) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator(color: AppColors.orange)),
//       );
//     }
//     if (v == null) {
//       return Scaffold(
//         appBar: OrangeTopBar(title: 'Vendor'),
//         body: const EmptyState(
//           icon: Icons.error_outline,
//           title: 'Failed to load vendor',
//         ),
//       );
//     }
//     return Scaffold(
//       body: Column(
//         children: [
//           // Banner
//           Stack(
//             children: [
//               v.bannerUrl != null
//                   ? CachedNetworkImage(
//                       imageUrl: v.bannerUrl!,
//                       height: 120,
//                       width: double.infinity,
//                       fit: BoxFit.cover,
//                       errorWidget: (_, __, ___) =>
//                           Container(height: 120, color: AppColors.navyLight),
//                     )
//                   : Container(
//                       height: 120,
//                       color: AppColors.navyLight,
//                       child: const Center(
//                         child: Icon(
//                           Icons.restaurant,
//                           size: 40,
//                           color: Colors.white30,
//                         ),
//                       ),
//                     ),
//               Positioned(
//                 top: MediaQuery.of(context).padding.top + 8,
//                 left: 14,
//                 child: GestureDetector(
//                   onTap: Get.back,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 14,
//                       vertical: 5,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.black45,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: const Text(
//                       '‹ Back',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 13,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 top: MediaQuery.of(context).padding.top + 8,
//                 right: 14,
//                 child: Obx(
//                   () => GestureDetector(
//                     onTap: () => Get.toNamed(AppRoutes.cart),
//                     child: Stack(
//                       clipBehavior: Clip.none,
//                       children: [
//                         const Icon(
//                           Icons.shopping_bag_outlined,
//                           color: Colors.white,
//                           size: 24,
//                         ),
//                         if (cart.totalItems > 0)
//                           Positioned(
//                             top: -4,
//                             right: -4,
//                             child: Container(
//                               width: 14,
//                               height: 14,
//                               decoration: const BoxDecoration(
//                                 color: AppColors.red,
//                                 shape: BoxShape.circle,
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   '${cart.totalItems}',
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 8,
//                                     fontWeight: FontWeight.w700,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           // Vendor info
//           Container(
//             color: Colors.white,
//             padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
//             child: Row(
//               children: [
//                 v.logoUrl != null
//                     ? AppNetworkImage(
//                         url: v.logoUrl,
//                         width: 52,
//                         height: 52,
//                         borderRadius: BorderRadius.circular(13),
//                       )
//                     : AvatarFallback(initials: v.initials, size: 52),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         v.name,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w800,
//                           color: AppColors.navy,
//                         ),
//                       ),
//                       Row(
//                         children: [
//                           StatusBadge(v.isOpen ? 'delivered' : 'cancelled'),
//                           const SizedBox(width: 8),
//                           Text(
//                             '★ ${(v.rating ?? 0).toStringAsFixed(1)}',
//                             style: const TextStyle(
//                               fontSize: 11,
//                               fontWeight: FontWeight.w600,
//                               color: AppColors.orange,
//                             ),
//                           ),
//                           if (v.distanceKm != null) ...[
//                             const SizedBox(width: 8),
//                             Row(
//                               children: [
//                                 const Icon(
//                                   Icons.near_me_outlined,
//                                   size: 11,
//                                   color: AppColors.textSecondary,
//                                 ),
//                                 const SizedBox(width: 2),
//                                 Text(
//                                   '${v.distanceKm!.toStringAsFixed(1)}km',
//                                   style: const TextStyle(
//                                     fontSize: 11,
//                                     color: AppColors.textSecondary,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ],
//                       ),
//                       if (v.address != null)
//                         Text(
//                           v.address!,
//                           style: const TextStyle(
//                             fontSize: 11,
//                             color: AppColors.textSecondary,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       if (v.rating != null) ...[
//                         const SizedBox(height: 4),
//                         Row(
//                           children: [
//                             Text(
//                               '${v.rating}',
//                               style: const TextStyle(
//                                 fontSize: 11,
//                                 color: AppColors.textSecondary,
//                               ),
//                             ),
//                             Text(
//                               '(${v.totalRatings})',
//                               style: const TextStyle(
//                                 fontSize: 11,
//                                 color: AppColors.textSecondary,
//                               ),
//                             ),
//                             GestureDetector(
//                               onTap: () {

//                               },
//                               child: Text(
//                                 'See Reviews',
//                                 style: const TextStyle(
//                                   fontSize: 11,
//                                   color: Colors.yellow,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // Category filter chips
//           if (v.productCategories.isNotEmpty)
//             Container(
//               color: Colors.white,
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
//                 child: Obx(
//                   () => Row(
//                     children: [
//                       _Chip(
//                         label: 'All',
//                         selected: ctrl.prodFilter.value == null,
//                         onTap: () => ctrl.prodFilter.value = null,
//                       ),
//                       ...v.productCategories.map(
//                         (c) => _Chip(
//                           label: c.name,
//                           selected: ctrl.prodFilter.value == c.id,
//                           onTap: () => ctrl.prodFilter.value = c.id,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           // Products list
//           Expanded(
//             child: Obx(() {
//               final prods = ctrl.filteredProducts;
//               if (ctrl.vendorLoading.value) {
//                 return const Center(
//                   child: CircularProgressIndicator(color: AppColors.orange),
//                 );
//               }
//               if (prods.isEmpty) {
//                 return const EmptyState(
//                   icon: Icons.fastfood_outlined,
//                   title: 'No products available',
//                 );
//               }
//               return ListView.builder(
//                 itemCount: prods.length,
//                 itemBuilder: (_, i) => _ProductRow(
//                   product: prods[i],
//                   vendorId: v.id,
//                   vendorName: v.name,
//                 ),
//               );
//             }),
//           ),
//         ],
//       ),
//       bottomNavigationBar: Obx(
//         () => cart.totalItems > 0
//             ? Container(
//                 padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
//                 color: Colors.white,
//                 child: AppButton(
//                   label: '🛍️  View Cart (${cart.totalItems} items)',
//                   onTap: () => Get.toNamed(AppRoutes.cart),
//                 ),
//               )
//             : const SizedBox.shrink(),
//       ),
//     );
//   });
// }

// class _Chip extends StatelessWidget {
//   final String label;
//   final bool selected;
//   final VoidCallback onTap;
//   const _Chip({
//     required this.label,
//     required this.selected,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) => GestureDetector(
//     onTap: onTap,
//     child: Container(
//       margin: const EdgeInsets.only(right: 8),
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
//       decoration: BoxDecoration(
//         color: selected ? AppColors.orange : Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: selected ? AppColors.orange : AppColors.border,
//           width: 1.5,
//         ),
//       ),
//       child: Text(
//         label,
//         style: TextStyle(
//           fontSize: 12,
//           fontWeight: FontWeight.w600,
//           color: selected ? Colors.white : AppColors.textSecondary,
//         ),
//       ),
//     ),
//   );
// }

// // ─── Product Row ──────────────────────────────────────────────────────────────
// class _ProductRow extends StatelessWidget {
//   final Product product;
//   final int vendorId;
//   final String vendorName;
//   const _ProductRow({
//     required this.product,
//     required this.vendorId,
//     required this.vendorName,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final cart = CartController.to;
//     return Container(
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         border: Border(bottom: BorderSide(color: AppColors.border)),
//       ),
//       padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           product.imageUrl != null
//               ? AppNetworkImage(
//                   url: product.imageUrl,
//                   width: 72,
//                   height: 72,
//                   borderRadius: BorderRadius.circular(13),
//                 )
//               : Container(
//                   width: 72,
//                   height: 72,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFFFF5E6),
//                     borderRadius: BorderRadius.circular(13),
//                   ),
//                   child: const Center(
//                     child: Icon(
//                       Icons.fastfood_outlined,
//                       size: 28,
//                       color: AppColors.orange,
//                     ),
//                   ),
//                 ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   product.name,
//                   style: const TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.w700,
//                     color: AppColors.navy,
//                   ),
//                 ),
//                 if (product.description != null) ...[
//                   const SizedBox(height: 4),
//                   Text(
//                     product.description!,
//                     style: const TextStyle(
//                       fontSize: 11,
//                       color: AppColors.textSecondary,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//                 const SizedBox(height: 6),
//                 Row(
//                   children: [
//                     Text(
//                       AppUtils.formatNaira(product.effectivePrice),
//                       style: const TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w800,
//                         color: AppColors.orange,
//                       ),
//                     ),
//                     if (product.discountPrice != null &&
//                         product.discountPrice! < product.price) ...[
//                       const SizedBox(width: 6),
//                       Text(
//                         AppUtils.formatNaira(product.price),
//                         style: const TextStyle(
//                           fontSize: 11,
//                           color: AppColors.textLight,
//                           decoration: TextDecoration.lineThrough,
//                         ),
//                       ),
//                     ],
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(width: 8),
//           Obx(() {
//             final qty = cart.itemQty(vendorId, product.id);
//             return qty > 0
//                 ? QtyRow(
//                     qty: qty,
//                     onDecrement: () => cart.decrement(vendorId, product.id),
//                     onIncrement: () => cart.increment(vendorId, product.id),
//                   )
//                 : GestureDetector(
//                     onTap: () => cart.addItem(vendorId, vendorName, product),
//                     child: Container(
//                       width: 30,
//                       height: 30,
//                       decoration: BoxDecoration(
//                         color: AppColors.orange,
//                         borderRadius: BorderRadius.circular(9),
//                       ),
//                       child: const Icon(
//                         Icons.add_rounded,
//                         size: 16,
//                         color: Colors.white,
//                       ),
//                     ),
//                   );
//           }),
//         ],
//       ),
//     );
//   }
// }

import 'dart:developer' as myLog;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_utils.dart';
import '../../../data/models/models.dart';
import '../../../data/services/location_service.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/app_widgets.dart';
import '../../auth/auth_controller.dart';
import '../cart/cart_controller.dart';
import '../../../core/utils/toast.dart';
import 'customer_home_controller.dart';
import '../orders/orders_screen.dart';
import '../wallet/wallet_screen.dart';
import '../account/account_screen.dart';

// ─── Customer Shell ───────────────────────────────────────────────────────────
class CustomerShell extends StatelessWidget {
  const CustomerShell({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(CustomerHomeController());
    Get.put(CartController());

    final tabs = [
      const HomeTab(),
      const OrdersScreen(),
      const WalletScreen(),
      const AccountScreen(),
    ];

    return Obx(() {
      if (!ctrl.locationReady.value) return const LocationOnboardingScreen();
      return Scaffold(
        body: IndexedStack(index: ctrl.currentTab.value, children: tabs),
        bottomNavigationBar: _BottomNav(ctrl: ctrl),
      );
    });
  }
}

class _BottomNav extends StatelessWidget {
  final CustomerHomeController ctrl;
  const _BottomNav({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final items = [
      [Icons.home_outlined, Icons.home, 'Home'],
      [Icons.receipt_long_outlined, Icons.receipt_long, 'Orders'],
      [
        Icons.account_balance_wallet_outlined,
        Icons.account_balance_wallet,
        'Wallet',
      ],
      [Icons.person_outline, Icons.person, 'Account'],
    ];
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border, width: 1.5)),
      ),
      padding: const EdgeInsets.only(top: 8, bottom: 6),
      child: Row(
        children: List.generate(
          items.length,
          (i) => Expanded(
            child: GestureDetector(
              onTap: () => ctrl.switchTab(i),
              child: Obx(() {
                final active = ctrl.currentTab.value == i;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      active
                          ? items[i][1] as IconData
                          : items[i][0] as IconData,
                      size: 22,
                      color: active
                          ? AppColors.orange
                          : AppColors.textSecondary,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      items[i][2] as String,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: active
                            ? AppColors.orange
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Location Onboarding ─────────────────────────────────────────────────────
class LocationOnboardingScreen extends StatefulWidget {
  const LocationOnboardingScreen({super.key});
  @override
  State<LocationOnboardingScreen> createState() => _LocationOnboardingState();
}

class _LocationOnboardingState extends State<LocationOnboardingScreen> {
  final ctrl = CustomerHomeController.to;
  final _searchCtrl = TextEditingController();
  final _focusNode = FocusNode();
  List<dynamic> _suggestions = [];
  bool _searching = false;
  String? _error;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    // Load saved addresses if not already loaded
    if (ctrl.addresses.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ctrl.loadAddresses();
      });
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _debounce?.cancel();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  /// Shows saved addresses when the field is focused and empty.
  /// Uses a small delay to handle the case where addresses are still loading.
  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      if (_searchCtrl.text.isEmpty) {
        if (ctrl.addresses.isNotEmpty) {
          // Addresses already loaded — show them immediately
          setState(() => _suggestions = ctrl.addresses.take(5).toList());
        } else {
          // Addresses may still be loading — wait briefly then show if ready
          Future.delayed(const Duration(milliseconds: 300), () {
            if (mounted && _focusNode.hasFocus && _searchCtrl.text.isEmpty) {
              setState(() => _suggestions = ctrl.addresses.take(5).toList());
            }
          });
        }
      }
    } else {
      // Delay dismiss so a tap on a suggestion isn't cancelled by focus loss
      Future.delayed(const Duration(milliseconds: 150), () {
        if (mounted && !_focusNode.hasFocus) {
          setState(() => _suggestions = []);
        }
      });
    }
  }

  void _onSearch(String q) {
    _debounce?.cancel();

    if (q.trim().isEmpty) {
      // Field cleared while focused → fall back to saved addresses
      if (_focusNode.hasFocus && ctrl.addresses.isNotEmpty) {
        setState(() => _suggestions = ctrl.addresses.take(5).toList());
      } else {
        setState(() => _suggestions = []);
      }
      return;
    }

    if (q.trim().length < 3) {
      setState(() => _suggestions = []);
      return;
    }

    // Debounced Nominatim search
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      setState(() => _searching = true);
      final results = await LocationService.instance.searchAddress(q);
      if (mounted) {
        setState(() {
          _suggestions = results;
          _searching = false;
        });
      }
    });
  }

  Future<void> _selectResult(dynamic r) async {
    if (r is NominatimResult) {
      _searchCtrl.text = r.shortName;
      await ctrl.setLocation(
        r.shortName,
        r.lat,
        r.lng,
        city: r.city,
        state: r.state,
      );
    } else if (r is DeliveryAddress) {
      _searchCtrl.text = r.address;
      await ctrl.setLocation(
        r.address,
        r.latitude!,
        r.longitude!,
        city: r.city,
        state: r.state,
      );
    }
    setState(() => _suggestions = []);
    // Only pop when this screen was pushed as a route (change-location flow).
    // In the initial onboarding flow the Obx in CustomerShell rebuilds automatically.
    if (mounted && Navigator.of(context).canPop()) Navigator.of(context).pop();
  }

  Future<void> _useGps(BuildContext ctx, CustomerHomeController ctrl) async {
    try {
      final pos = await ctrl.determinePosition();

      final placemarks = await placemarkFromCoordinates(
        pos.latitude,
        pos.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks[1];

        final addressParts = <String>[];
        if (place.street != null && place.street!.isNotEmpty) {
          addressParts.add(place.street!);
        }
        if (place.locality != null && place.locality!.isNotEmpty) {
          addressParts.add(place.locality!);
        }
        if (place.administrativeArea != null &&
            place.administrativeArea!.isNotEmpty) {
          addressParts.add(place.administrativeArea!);
        }
        if (place.country != null && place.country!.isNotEmpty) {
          addressParts.add(place.country!);
        }

        final address = addressParts.join(', ');

        ctrl.setLocation(address, pos.latitude, pos.longitude);
        ctrl.locationReady.value = true;
        if (ctx.mounted && Navigator.of(ctx).canPop()) Navigator.of(ctx).pop();
      } else {
        showToast('Could not find address for this location. Please select manually.', isError: true);
      }
    } catch (e) {
      myLog.log('Location error: $e');
      showToast('Failed to get GPS location. Please select manually.', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.white,
    body: Column(
      children: [
        // ── Orange header ──
        Container(
          width: double.infinity,
          color: AppColors.orange,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 16,
            left: 20,
            right: 20,
            bottom: 24,
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: AppColors.navy,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/logo.jpeg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Set Your Location',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'We need your address to show nearby vendors',
                style: TextStyle(color: Colors.white70, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),

        // ── Scrollable body ──
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Icon(
                    Icons.location_on,
                    size: 52,
                    color: AppColors.orange,
                  ),
                ),
                const SizedBox(height: 12),
                const Center(
                  child: Text(
                    'Where should we deliver?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                const Center(
                  child: Text(
                    'Your location helps us show vendors within your delivery radius.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),

                // ── Search field ──
                TextField(
                  controller: _searchCtrl,
                  focusNode: _focusNode,
                  onChanged: _onSearch,
                  decoration: InputDecoration(
                    prefixIcon: _searching
                        ? const Padding(
                            padding: EdgeInsets.all(12),
                            child: SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.orange,
                              ),
                            ),
                          )
                        : const Icon(
                            Icons.search,
                            color: AppColors.textSecondary,
                          ),
                    hintText: 'Search your street, area or city...',
                    filled: true,
                    fillColor: AppColors.inputBg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.orange,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),

                // ── Suggestions dropdown ──
                if (_suggestions.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x18000000),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: _suggestions.asMap().entries.map((e) {
                        final r = e.value;
                        final isLast = e.key == _suggestions.length - 1;
                        final isSaved = r is DeliveryAddress;

                        return InkWell(
                          borderRadius: BorderRadius.vertical(
                            top: e.key == 0
                                ? const Radius.circular(12)
                                : Radius.zero,
                            bottom: isLast
                                ? const Radius.circular(12)
                                : Radius.zero,
                          ),
                          onTap: () => _selectResult(r),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              border: isLast
                                  ? null
                                  : const Border(
                                      bottom: BorderSide(
                                        color: AppColors.border,
                                      ),
                                    ),
                            ),
                            child: Row(
                              children: [
                                // Icon differs: bookmark for saved, pin for search
                                Icon(
                                  isSaved
                                      ? Icons.bookmark_outline
                                      : Icons.location_on_outlined,
                                  size: 16,
                                  color: isSaved
                                      ? AppColors.navy
                                      : AppColors.orange,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        isSaved
                                            ? (r as DeliveryAddress).address
                                            : (r as NominatimResult).shortName,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.navy,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      if (isSaved)
                                        const Text(
                                          'Saved address',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: AppColors.textSecondary,
                                          ),
                                        )
                                      else if ((r as NominatimResult).city !=
                                              null ||
                                          r.state != null)
                                        Text(
                                          '${r.city ?? ''}, ${r.state ?? ''}',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                // Arrow hint
                                const Icon(
                                  Icons.north_west,
                                  size: 12,
                                  color: AppColors.textLight,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],

                const SizedBox(height: 16),

                // ── GPS button ──
                Obx(
                  () => AppButton(
                    label: ctrl.gpsLoading.value
                        ? 'Getting location...'
                        : 'Use my current GPS location',
                    loading: ctrl.gpsLocationInProgress.value,
                    onTap: () => _useGps(context, ctrl),
                  ),
                ),

                // ── Error message ──
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFFECACA)),
                    ),
                    child: Text(
                      _error!,
                      style: const TextStyle(
                        color: AppColors.red,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 16),
                AppOutlineButton(
                  label: 'Sign out',
                  onTap: AuthController.to.logout,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

// ─── Home Tab ─────────────────────────────────────────────────────────────────
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = CustomerHomeController.to;
    final cart = CartController.to;
    return Scaffold(
      body: Column(
        children: [
          _OrangeHeader(ctrl: ctrl, cart: cart),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await ctrl.loadCategories();
                await ctrl.loadVendors();
              },
              child: ListView(
                padding: EdgeInsets.zero,
                children: [_categoriesSection(ctrl), _vendorsSection(ctrl)],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoriesSection(CustomerHomeController ctrl) => Obx(
    () => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 16, 14, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Categories',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.vendors),
                child: const Text(
                  'All Vendors',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.orange,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (ctrl.categories.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.orange,
                strokeWidth: 2,
              ),
            ),
          )
        else
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              itemCount: ctrl.categories.length,
              itemBuilder: (_, i) => _CategoryChip(cat: ctrl.categories[i]),
            ),
          ),
      ],
    ),
  );

  Widget _vendorsSection(CustomerHomeController ctrl) => Obx(
    () => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Vendors Near You',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              if (ctrl.vendors.isNotEmpty)
                GestureDetector(
                  onTap: () => Get.toNamed(AppRoutes.vendors),
                  child: const Text(
                    'See all',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.orange,
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (ctrl.vendorsLoading.value)
          const Padding(
            padding: EdgeInsets.all(32),
            child: Center(
              child: CircularProgressIndicator(color: AppColors.orange),
            ),
          )
        else if (ctrl.vendorsError.value != null)
          _errorState(ctrl)
        else if (ctrl.vendors.isEmpty && ctrl.vendorsLoaded.value)
          SizedBox(
            width: double.infinity,
            child: EmptyState(
              icon: Icons.store_outlined,
              title: 'No vendors in your area yet',
              subtitle: 'We are expanding! Try changing your location.',
              buttonLabel: 'Change Location',
              onButton: () => Get.to(() => const LocationOnboardingScreen()),
            ),
          )
        else
          ...ctrl.vendors.take(6).map((v) => VendorCard(vendor: v)),
      ],
    ),
  );

  Widget _errorState(CustomerHomeController ctrl) => Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
      children: [
        const Icon(
          Icons.warning_amber_rounded,
          size: 40,
          color: AppColors.textSecondary,
        ),
        const SizedBox(height: 12),
        Text(
          ctrl.vendorsError.value!,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: 140,
          child: AppButton(
            label: 'Try Again',
            height: 40,
            onTap: () => ctrl.loadVendors(),
          ),
        ),
      ],
    ),
  );
}

// ─── Orange Header ────────────────────────────────────────────────────────────
class _OrangeHeader extends StatelessWidget {
  final CustomerHomeController ctrl;
  final CartController cart;
  const _OrangeHeader({required this.ctrl, required this.cart});

  @override
  Widget build(BuildContext context) => Container(
    color: AppColors.orange,
    padding: EdgeInsets.only(
      top: MediaQuery.of(context).padding.top + 8,
      left: 16,
      right: 16,
      bottom: 14,
    ),
    child: Column(
      children: [
        Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.navy,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Image.asset(
                    'assets/images/logo.jpeg',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'NKsereke',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Obx(
              () => GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.cart),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.white,
                      size: 26,
                    ),
                    if (cart.totalItems > 0)
                      Positioned(
                        top: -4,
                        right: -4,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            color: AppColors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${cart.totalItems}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Obx(
          () => GestureDetector(
            onTap: () => Get.to(() => const LocationOnboardingScreen()),
            child: Row(
              children: [
                const Icon(Icons.location_on, color: Colors.white, size: 16),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    ctrl.delivAddr.value ?? 'Set delivery location',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white70,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

// ─── Category Chip ────────────────────────────────────────────────────────────
class _CategoryChip extends StatelessWidget {
  final Category cat;
  const _CategoryChip({required this.cat});

  @override
  Widget build(BuildContext context) {
    final categoryIcons = {
      'Fast Food': Icons.fastfood_outlined,
      'Restaurant': Icons.restaurant_outlined,
      'Supermarket': Icons.shopping_cart_outlined,
      'Pharmacy': Icons.local_pharmacy_outlined,
      'Bakery': Icons.bakery_dining_outlined,
      'Pizza': Icons.local_pizza_outlined,
      'Drinks': Icons.local_drink_outlined,
      'Grocery': Icons.eco_outlined,
    };
    final icon = categoryIcons[cat.name] ?? Icons.store_outlined;

    return GestureDetector(
      onTap: () {
        final ctrl = CustomerHomeController.to;
        ctrl.selectedCatId.value = cat.id;
        ctrl.selectedCatName.value = cat.name;
        Get.toNamed(AppRoutes.vendors);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        width: 70,
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.chipBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: cat.imageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: CachedNetworkImage(
                        imageUrl: cat.imageUrl!,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) =>
                            Icon(icon, size: 26, color: AppColors.orange),
                      ),
                    )
                  : Icon(icon, size: 26, color: AppColors.orange),
            ),
            const SizedBox(height: 5),
            Text(
              cat.name,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Vendor Card ──────────────────────────────────────────────────────────────
class VendorCard extends StatelessWidget {
  final Vendor vendor;
  const VendorCard({super.key, required this.vendor});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => Get.toNamed(AppRoutes.vendorDetail, arguments: vendor.id),
    child: Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          // Banner
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: vendor.bannerUrl != null
                    ? CachedNetworkImage(
                        imageUrl: vendor.bannerUrl!,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => _bannerFallback(),
                      )
                    : _bannerFallback(),
              ),
              Positioned(
                top: 8,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: vendor.isOpen
                        ? const Color(0xECF0FDF4)
                        : const Color(0xECFEF2F2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: vendor.isOpen ? AppColors.green : AppColors.red,
                    ),
                  ),
                  child: Text(
                    vendor.isOpen ? '● Open' : '● Closed',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: vendor.isOpen ? AppColors.green : AppColors.red,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Info
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                vendor.logoUrl != null
                    ? AppNetworkImage(
                        url: vendor.logoUrl,
                        width: 44,
                        height: 44,
                        borderRadius: BorderRadius.circular(11),
                      )
                    : AvatarFallback(initials: vendor.initials, size: 44),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vendor.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          Text(
                            '★ ${(vendor.rating ?? 0).toStringAsFixed(1)}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.orange,
                            ),
                          ),
                          if (vendor.distanceKm != null) ...[
                            const SizedBox(width: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.near_me_outlined,
                                  size: 11,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  '${vendor.distanceKm!.toStringAsFixed(1)}km',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                      if (vendor.address != null)
                        Text(
                          vendor.address!,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: AppColors.textLight,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Widget _bannerFallback() => Container(
    height: 150,
    color: AppColors.navyLight,
    child: const Center(
      child: Icon(Icons.store, size: 40, color: Colors.white30),
    ),
  );
}

// ─── Vendors List Screen ──────────────────────────────────────────────────────
class VendorsScreen extends StatefulWidget {
  const VendorsScreen({super.key});
  @override
  State<VendorsScreen> createState() => _VendorsScreenState();
}

class _VendorsScreenState extends State<VendorsScreen> {
  final ctrl = CustomerHomeController.to;
  final cart = CartController.to;
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ctrl.loadVendors(catId: ctrl.selectedCatId.value);
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.bg,
    appBar: AppBar(
      backgroundColor: AppColors.navy,
      title: Obx(
        () => Text(
          ctrl.selectedCatName.value ?? 'Vendors Near You',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
        onPressed: () {
          ctrl.selectedCatId.value = null;
          ctrl.selectedCatName.value = null;
          Get.back();
        },
      ),
      actions: [
        Obx(
          () => GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.cart),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                  if (cart.totalItems > 0)
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: const BoxDecoration(
                          color: AppColors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${cart.totalItems}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
    body: Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
          child: TextField(
            controller: _searchCtrl,
            onChanged: (v) => ctrl.vendorSearch.value = v,
            decoration: InputDecoration(
              hintText: '🔍 Search vendors...',
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 9,
              ),
              filled: true,
              fillColor: AppColors.inputBg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              hintStyle: const TextStyle(fontSize: 13),
            ),
          ),
        ),
        Expanded(
          child: Obx(() {
            if (ctrl.vendorsLoading.value) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.orange),
              );
            }
            final list = ctrl.filteredVendors;
            if (list.isEmpty) {
              return EmptyState(
                icon: Icons.store_outlined,
                title: 'No vendors found',
                subtitle:
                    ctrl.vendorsError.value ??
                    'Try a different search or location',
              );
            }
            return RefreshIndicator(
              onRefresh: () =>
                  ctrl.loadVendors(catId: ctrl.selectedCatId.value),
              child: ListView.builder(
                padding: const EdgeInsets.all(14),
                itemCount: list.length,
                itemBuilder: (_, i) => Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: VendorCard(vendor: list[i]),
                ),
              ),
            );
          }),
        ),
      ],
    ),
  );
}

// ─── Vendor Detail Screen ─────────────────────────────────────────────────────
class VendorDetailScreen extends StatefulWidget {
  const VendorDetailScreen({super.key});
  @override
  State<VendorDetailScreen> createState() => _VendorDetailScreenState();
}

class _VendorDetailScreenState extends State<VendorDetailScreen> {
  final ctrl = CustomerHomeController.to;
  final cart = CartController.to;

  @override
  void initState() {
    super.initState();
    final id = Get.arguments as int?;
    if (id != null) ctrl.loadVendorDetail(id);
  }

  @override
  Widget build(BuildContext context) => Obx(() {
    final v = ctrl.vendorDetail.value;
    if (ctrl.vendorLoading.value && v == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppColors.orange)),
      );
    }
    if (v == null) {
      return Scaffold(
        appBar: OrangeTopBar(title: 'Vendor'),
        body: const EmptyState(
          icon: Icons.error_outline,
          title: 'Failed to load vendor',
        ),
      );
    }
    return Scaffold(
      body: Column(
        children: [
          // Banner
          Stack(
            children: [
              v.bannerUrl != null
                  ? CachedNetworkImage(
                      imageUrl: v.bannerUrl!,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) =>
                          Container(height: 120, color: AppColors.navyLight),
                    )
                  : Container(
                      height: 120,
                      color: AppColors.navyLight,
                      child: const Center(
                        child: Icon(
                          Icons.restaurant,
                          size: 40,
                          color: Colors.white30,
                        ),
                      ),
                    ),
              Positioned(
                top: MediaQuery.of(context).padding.top + 8,
                left: 14,
                child: GestureDetector(
                  onTap: Get.back,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '‹ Back',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top + 8,
                right: 14,
                child: Obx(
                  () => GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.cart),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(
                          Icons.shopping_bag_outlined,
                          color: Colors.white,
                          size: 24,
                        ),
                        if (cart.totalItems > 0)
                          Positioned(
                            top: -4,
                            right: -4,
                            child: Container(
                              width: 14,
                              height: 14,
                              decoration: const BoxDecoration(
                                color: AppColors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${cart.totalItems}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Vendor info
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(
              children: [
                v.logoUrl != null
                    ? AppNetworkImage(
                        url: v.logoUrl,
                        width: 52,
                        height: 52,
                        borderRadius: BorderRadius.circular(13),
                      )
                    : AvatarFallback(initials: v.initials, size: 52),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        v.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.navy,
                        ),
                      ),
                      Row(
                        children: [
                          StatusBadge(v.isOpen ? 'delivered' : 'cancelled'),
                          const SizedBox(width: 8),
                          Text(
                            '★ ${(v.rating ?? 0).toStringAsFixed(1)}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.orange,
                            ),
                          ),
                          if (v.distanceKm != null) ...[
                            const SizedBox(width: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.near_me_outlined,
                                  size: 11,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  '${v.distanceKm!.toStringAsFixed(1)}km',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                      if (v.address != null)
                        Text(
                          v.address!,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      if (v.rating != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              '${v.rating}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              '(${v.totalRatings})',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.toNamed(
                                  AppRoutes.vendorReviews,
                                  arguments: {'id': v.id, 'vendor': v},
                                );
                              },
                              child: Text(
                                'See Reviews',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.orange,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Category filter chips
          if (v.productCategories.isNotEmpty)
            Container(
              color: Colors.white,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
                child: Obx(
                  () => Row(
                    children: [
                      _Chip(
                        label: 'All',
                        selected: ctrl.prodFilter.value == null,
                        onTap: () => ctrl.prodFilter.value = null,
                      ),
                      ...v.productCategories.map(
                        (c) => _Chip(
                          label: c.name,
                          selected: ctrl.prodFilter.value == c.id,
                          onTap: () => ctrl.prodFilter.value = c.id,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          // Products list
          Expanded(
            child: Obx(() {
              final prods = ctrl.filteredProducts;
              if (ctrl.vendorLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.orange),
                );
              }
              if (prods.isEmpty) {
                return const EmptyState(
                  icon: Icons.fastfood_outlined,
                  title: 'No products available',
                );
              }
              return ListView.builder(
                itemCount: prods.length,
                itemBuilder: (_, i) => _ProductRow(
                  product: prods[i],
                  vendorId: v.id,
                  vendorName: v.name,
                ),
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: Obx(
        () => cart.totalItems > 0
            ? Container(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                color: Colors.white,
                child: AppButton(
                  label: '🛍️  View Cart (${cart.totalItems} items)',
                  onTap: () => Get.toNamed(AppRoutes.cart),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  });
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? AppColors.orange : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected ? AppColors.orange : AppColors.border,
          width: 1.5,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: selected ? Colors.white : AppColors.textSecondary,
        ),
      ),
    ),
  );
}

// ─── Product Row ──────────────────────────────────────────────────────────────
class _ProductRow extends StatelessWidget {
  final Product product;
  final int vendorId;
  final String vendorName;
  const _ProductRow({
    required this.product,
    required this.vendorId,
    required this.vendorName,
  });

  @override
  Widget build(BuildContext context) {
    final cart = CartController.to;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          product.imageUrl != null
              ? AppNetworkImage(
                  url: product.imageUrl,
                  width: 72,
                  height: 72,
                  borderRadius: BorderRadius.circular(13),
                )
              : Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF5E6),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.fastfood_outlined,
                      size: 28,
                      color: AppColors.orange,
                    ),
                  ),
                ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                if (product.description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    product.description!,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      AppUtils.formatNaira(product.effectivePrice),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.orange,
                      ),
                    ),
                    if (product.discountPrice != null &&
                        product.discountPrice! < product.price) ...[
                      const SizedBox(width: 6),
                      Text(
                        AppUtils.formatNaira(product.price),
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textLight,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Obx(() {
            final qty = cart.itemQty(vendorId, product.id);
            return qty > 0
                ? QtyRow(
                    qty: qty,
                    onDecrement: () => cart.decrement(vendorId, product.id),
                    onIncrement: () => cart.increment(vendorId, product.id),
                  )
                : GestureDetector(
                    onTap: () => cart.addItem(vendorId, vendorName, product),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: AppColors.orange,
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: const Icon(
                        Icons.add_rounded,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  );
          }),
        ],
      ),
    );
  }
}
