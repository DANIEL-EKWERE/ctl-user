//import '../../../../lib/presentation/screens/orders/orders_screen.dart';
import 'package:ctluser/modules/customer/orders/orders_screen.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'dart:developer' as myLog;
//import 'package:ctluser/modules/customer/orders/order_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:geocoding/geocoding.dart';
// import 'package:google_places_flutter/model/prediction.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/place_type.dart';
import 'package:google_places_flutter/model/prediction.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_utils.dart';
import '../../../data/models/models.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/app_widgets.dart';
import '../account/account_screen.dart';
import '../cart/cart_controller.dart';
import '../wallet/wallet_screen.dart';
import 'customer_home_controller.dart';
// import '../orders/orders_screen.dart';
// import '../wallet/wallet_screen.dart';
// import '../account/account_screen.dart';

// ─── Customer Shell ───────────────────────────────────────────────────────────
class CustomerShell extends StatefulWidget {
  const CustomerShell({super.key});

  @override
  State<CustomerShell> createState() => _CustomerShellState();
}

class _CustomerShellState extends State<CustomerShell> {
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
      [LucideIcons.home, 'Home'],
      [LucideIcons.list, 'Orders'],
      [LucideIcons.wallet, 'Wallet'],
      [LucideIcons.user, 'Account'],
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
              child: Obx(
                () => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      items[i][0] as IconData,
                      size: 20,
                      color: ctrl.currentTab.value == i
                          ? AppColors.orange
                          : AppColors.textSecondary,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      items[i][1] as String,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: ctrl.currentTab.value == i
                            ? AppColors.orange
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Location Onboarding ─────────────────────────────────────────────────────
class LocationOnboardingScreen extends StatelessWidget {
  const LocationOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = CustomerHomeController.to;
    final searchCtrl = TextEditingController();
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: AppColors.orange,
            padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.navy,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text(
                      'NK',
                      style: TextStyle(
                        color: AppColors.orange,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 52,
                    color: AppColors.orange,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Where should we deliver?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Your location helps us show vendors within your delivery radius.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  // TextField(
                  //   controller: searchCtrl,
                  //   decoration: InputDecoration(
                  //     prefixIcon: const Icon(
                  //       Icons.search,
                  //       color: AppColors.textSecondary,
                  //     ),
                  //     hintText: 'Search your street, area or city...',
                  //     filled: true,
                  //     fillColor: AppColors.inputBg,
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(12),
                  //       borderSide: const BorderSide(color: AppColors.border),
                  //     ),
                  //   ),
                  // ),
                  // GooglePlacesAutoComplete(
                  //   apiKey: "AIzaSyCE2eTleryeIXRkcgRft2AD45eKakmFybw",
                  //   textEditingController: searchCtrl,
                  //   isLatLngRequired: true,
                  //   boxDecoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(12),
                  //     color: AppColors.inputBg,
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: Colors.black.withOpacity(0.08),
                  //         blurRadius: 10,
                  //         offset: const Offset(0, 4),
                  //       ),
                  //     ],
                  //   ),
                  //   textStyle: const TextStyle(
                  //     color: AppColors.textSecondary,
                  //     fontSize: 14,
                  //   ),
                  //   seperatedDivider: Divider(
                  //     color: AppColors.border,
                  //     height: 1,
                  //   ),
                  //   getPlaceDetailWithLatLng: (Prediction prediction) {
                  //     print("Lat: ${prediction.lat}, Lng: ${prediction.lng}");
                  //   },
                  //   itmClick: (Prediction prediction) {
                  //     searchCtrl.text = prediction.description!;
                  //     searchCtrl.selection = TextSelection.fromPosition(
                  //       TextPosition(offset: prediction.description!.length),
                  //     );
                  //   },
                  //   inputDecoration: InputDecoration(
                  //     prefixIcon: const Icon(
                  //       Icons.search,
                  //       color: AppColors.textSecondary,
                  //     ),
                  //     hintText: 'Search your street, area or city...',
                  //     filled: true,
                  //     fillColor: AppColors.inputBg,
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(12),
                  //       borderSide: const BorderSide(color: AppColors.border),
                  //     ),
                  //   ),
                  // ),
                  GooglePlaceAutoCompleteTextField(
                    textEditingController: searchCtrl,
                    googleAPIKey: "AIzaSyCE2eTleryeIXRkcgRft2AD45eKakmFybw",
                    inputDecoration: InputDecoration(),
                    debounceTime: 800, // default 600 ms,,
                    //countries: ["in","fr"],// optional by default null is set
                    isLatLngRequired:
                        true, // if you required coordinates from place detail
                    getPlaceDetailWithLatLng: (Prediction prediction) {
                      // this method will return latlng with place detail
                      print("placeDetails" + prediction.lng.toString());
                    }, // this callback is called when isLatLngRequired is true
                    itemClick: (Prediction prediction) {
                      searchCtrl.text = prediction.description!;
                      searchCtrl.selection = TextSelection.fromPosition(
                        TextPosition(offset: prediction.description!.length),
                      );
                    },
                    // if we want to make custom list item builder
                    itemBuilder: (context, index, Prediction prediction) {
                      return Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Icon(Icons.location_on),
                            SizedBox(width: 7),
                            Expanded(
                              child: Text("${prediction.description ?? ""}"),
                            ),
                          ],
                        ),
                      );
                    },
                    // if you want to add seperator between list items
                    seperatedBuilder: Divider(),
                    // want to show close icon
                    isCrossBtnShown: true,
                    // optional container padding
                    containerHorizontalPadding: 10,
                    // place type
                    placeType: PlaceType.geocode,
                    // keyboard type (defaults to TextInputType.streetAddress)
                    keyboardType: TextInputType
                        .text, // optional - defaults to streetAddress for better address input
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => AppButton(
                      loading: ctrl.gpsLocationInProgress.value,
                      label: 'Use my current GPS location',
                      onTap: () => _useGps(context, ctrl),
                    ),
                  ),
                  const SizedBox(height: 12),
                  AppOutlineButton(
                    label: 'Sign out',
                    onTap: () => Get.find<_AuthCtrl>().logout(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _useGps(BuildContext ctx, CustomerHomeController ctrl) async {
    try {
      final pos = await ctrl.determinePosition();

      // Reverse geocode the coordinates to get the address
      final placemarks = await placemarkFromCoordinates(
        pos.latitude,
        pos.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks[1];

        // Format address from placemark
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
      } else {
        Get.snackbar(
          'Location Error',
          'Could not find address for this location. Please select manually.',
          backgroundColor: Colors.white,
          colorText: AppColors.textPrimary,
        );
      }
    } catch (e) {
      myLog.log('Location error: $e');
      Get.snackbar(
        'Location Error',
        'Failed to get GPS location. Please select your location manually.',
        backgroundColor: Colors.white,
        colorText: AppColors.textPrimary,
      );
    }
  }
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
            child:
                // Obx(() =>
                RefreshIndicator(
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
          //),
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
          EmptyState(
            icon: Icons.store_outlined,
            title: 'No vendors in your area yet',
            subtitle: 'We are expanding! Try changing your location.',
            buttonLabel: 'Change Location',
            onButton: () {},
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
              child: const Center(
                child: Text(
                  'NK',
                  style: TextStyle(
                    color: AppColors.orange,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
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
                  children: [
                    const Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.white,
                      size: 26,
                    ),
                    if (cart.totalItems > 0)
                      Positioned(
                        top: 0,
                        right: 0,
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
            onTap: () => Get.toNamed(AppRoutes.location),
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

class _CategoryChip extends StatelessWidget {
  final Category cat;
  const _CategoryChip({required this.cat});

  @override
  Widget build(BuildContext context) {
    final icons = {
      'Fast Food': '🍔',
      'Restaurant': '🍽️',
      'Supermarket': '🛒',
      'Pharmacy': '💊',
      'Bakery': '🥐',
      'Pizza': '🍕',
      'Drinks': '🥤',
      'Grocery': '🥦',
    };
    final icon = icons[cat.name] ?? '🏪';
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
                        errorWidget: (_, __, ___) => Center(
                          child: Text(
                            icon,
                            style: const TextStyle(fontSize: 22),
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Text(icon, style: const TextStyle(fontSize: 22)),
                    ),
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

// ─── Vendor Card ─────────────────────────────────────────────────────────────
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
        boxShadow: [
          const BoxShadow(
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
                        height: 80,
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
                              spacing: 10,
                              children: [
                                Icon(Icons.location_on),

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
    height: 80,
    color: AppColors.navyLight,
    child: const Center(
      child: Icon(Icons.store, size: 32, color: Colors.white30),
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
                children: [
                  const Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                  if (cart.totalItems > 0)
                    Positioned(
                      top: 0,
                      right: 0,
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
                      children: [
                        const Icon(
                          Icons.shopping_bag_outlined,
                          color: Colors.white,
                          size: 24,
                        ),
                        if (cart.totalItems > 0)
                          Positioned(
                            top: 0,
                            right: 0,
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
                              spacing: 10,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 12,
                                  color: AppColors.textSecondary,
                                ),
                                //  const SizedBox(width: 2),
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
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Category chips
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
          // Products
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
                    child: Text('🍽️', style: TextStyle(fontSize: 28)),
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

// ignore reference used only internally
class _AuthCtrl extends GetxController {
  void logout() {}
}
