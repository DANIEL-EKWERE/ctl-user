// import 'package:ctluser/modules/customer/home/customer_home_controller.dart';
// import 'package:ctluser/modules/rider/dashboard/rider_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'core/theme/app_theme.dart';
// import 'data/services/storage_service.dart';
// import 'modules/auth/auth_controller.dart';
// import 'modules/auth/login/login_screen.dart';
// import 'modules/auth/signup/signup_screen.dart';
// import 'modules/auth/verify/verify_screens.dart';
// import 'modules/customer/home/customer_home_screen.dart';
// import 'modules/customer/cart/cart_screen.dart';
// import 'modules/customer/checkout/checkout_screen.dart';
// import 'modules/customer/orders/orders_screen.dart';
// import 'modules/customer/wallet/wallet_screen.dart';
// import 'modules/customer/account/account_screen.dart';
// import 'modules/rider/dashboard/rider_screens.dart';
// import 'routes/app_routes.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   SystemChrome.setSystemUIOverlayStyle(
//     const SystemUiOverlayStyle(
//       statusBarColor: Colors.transparent,
//       statusBarIconBrightness: Brightness.light,
//     ),
//   );
//   runApp(const NKserekeApp());
// }

// class NKserekeApp extends StatelessWidget {
//   const NKserekeApp({super.key});

//   @override
//   Widget build(BuildContext context) => GetMaterialApp(
//     title: 'NKsereke',
//     debugShowCheckedModeBanner: false,
//     theme: AppTheme.theme,
//     initialBinding: _AppBindings(),
//     initialRoute: AppRoutes.splash,
//     getPages: _pages,
//   );
// }

// class _AppBindings extends Bindings {
//   @override
//   void dependencies() {
//     Get.put(AuthController(), permanent: true);
//   }
// }

// final _pages = [
//   GetPage(name: AppRoutes.splash, page: () => const _SplashScreen()),
//   GetPage(name: AppRoutes.login, page: () => const LoginScreen()),
//   GetPage(name: AppRoutes.signup, page: () => const SignupScreen()),
//   GetPage(name: AppRoutes.verifyEmail, page: () => const VerifyEmailScreen()),
//   GetPage(name: AppRoutes.forgotPass, page: () => const ForgotPasswordScreen()),

//   // Customer
//   GetPage(
//     name: AppRoutes.customerShell,
//     page: () => const CustomerShell(),
//     binding: BindingsBuilder(() {
//       Get.lazyPut(() => CustomerHomeController());
//     }),
//   ),
//   GetPage(name: AppRoutes.vendors, page: () => const VendorsScreen()),
//   GetPage(name: AppRoutes.vendorDetail, page: () => const VendorDetailScreen()),
//   GetPage(name: AppRoutes.cart, page: () => const CartScreen()),
//   GetPage(name: AppRoutes.checkout, page: () => const CheckoutScreen()),
//   GetPage(name: AppRoutes.orderDetail, page: () => const OrderDetailScreen()),
//   GetPage(name: AppRoutes.fundWallet, page: () => const FundWalletScreen()),
//   GetPage(name: AppRoutes.addresses, page: () => AddressesScreen()),
//   GetPage(name: AppRoutes.addAddress, page: () => const AddAddressScreen()),
//   GetPage(
//     name: AppRoutes.notifications,
//     page: () => const NotificationsScreen(),
//   ),
//   GetPage(name: AppRoutes.editProfile, page: () => const EditProfileScreen()),
//   GetPage(name: AppRoutes.changePass, page: () => const ChangePasswordScreen()),
//   GetPage(name: AppRoutes.setPin, page: () => const SetPinScreen()),
//   GetPage(name: AppRoutes.support, page: () => const SupportScreen()),

//   // Rider
//   GetPage(
//     name: AppRoutes.riderShell,
//     page: () => const RiderShell(),
//     binding: BindingsBuilder(() {
//       Get.lazyPut(() => RiderController());
//     }),
//   ),
//   GetPage(
//     name: AppRoutes.riderOrderDetail,
//     page: () => const RiderOrderDetailScreen(),
//   ),
// ];

// // ─── Splash Screen ────────────────────────────────────────────────────────────
// class _SplashScreen extends StatefulWidget {
//   const _SplashScreen();
//   @override
//   State<_SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<_SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _navigate();
//   }

//   Future<void> _navigate() async {
//     await Future.delayed(const Duration(seconds: 1));
//     final storage = StorageService.instance;
//     final role = await storage.getRole();
//     final cToken = await storage.getCustomerToken();
//     final rToken = await storage.getRiderToken();

//     if (role == 'rider' && rToken != null) {
//       Get.offAllNamed(AppRoutes.riderShell);
//     } else if (cToken != null) {
//       Get.offAllNamed(AppRoutes.customerShell);
//     } else {
//       Get.offAllNamed(AppRoutes.login);
//     }
//   }

//   @override
//   Widget build(BuildContext context) => Scaffold(
//     backgroundColor: AppColors.orange,
//     body: Center(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 80,
//             height: 80,
//             decoration: BoxDecoration(
//               color: AppColors.navy,
//               borderRadius: BorderRadius.circular(22),
//             ),
//             child: Center(
//               child: Image.asset('assets/images/logo.jpeg', fit: BoxFit.cover),
//             ),
//           ),
//           const SizedBox(height: 16),
//           const Text(
//             'NKsereke',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 28,
//               fontWeight: FontWeight.w800,
//             ),
//           ),
//           const SizedBox(height: 8),
//           const Text(
//             'Your local delivery platform',
//             style: TextStyle(color: Colors.white70, fontSize: 14),
//           ),
//           const SizedBox(height: 48),
//           const CircularProgressIndicator(
//             color: Colors.white70,
//             strokeWidth: 2,
//           ),
//         ],
//       ),
//     ),
//   );
// }

import 'package:ctluser/modules/customer/home/customer_home_controller.dart';
import 'package:ctluser/modules/rider/dashboard/rider_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'core/theme/app_theme.dart';
import 'data/services/push_notification_service.dart';
import 'data/services/storage_service.dart';
import 'firebase_options.dart';
import 'modules/auth/auth_controller.dart';
import 'modules/auth/login/login_screen.dart';
import 'modules/auth/signup/signup_screen.dart';
import 'modules/auth/verify/verify_screens.dart';
import 'modules/customer/home/customer_home_screen.dart';
import 'modules/customer/cart/cart_screen.dart';
import 'modules/customer/checkout/checkout_screen.dart';
import 'modules/customer/orders/orders_screen.dart';
import 'modules/customer/wallet/wallet_screen.dart';
import 'modules/customer/account/account_screen.dart';
import 'modules/customer/notifications/notifications_controller.dart';
import 'modules/customer/notifications/notifications_screen.dart';
import 'modules/customer/reviews/vendor_reviews_screen.dart';
import 'modules/customer/reviews/write_review_screen.dart';
import 'modules/rider/dashboard/rider_screens.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const NKserekeApp());
}

class NKserekeApp extends StatelessWidget {
  const NKserekeApp({super.key});

  @override
  Widget build(BuildContext context) => GetMaterialApp(
    title: 'NKsereke',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.theme,
    initialBinding: _AppBindings(),
    initialRoute: AppRoutes.splash,
    getPages: _pages,
  );
}

class _AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
  }
}

final _pages = [
  GetPage(name: AppRoutes.splash, page: () => const _SplashScreen()),
  GetPage(name: AppRoutes.login, page: () => const LoginScreen()),
  GetPage(name: AppRoutes.signup, page: () => const SignupScreen()),
  GetPage(name: AppRoutes.verifyEmail, page: () => const VerifyEmailScreen()),
  GetPage(name: AppRoutes.forgotPass, page: () => const ForgotPasswordScreen()),

  // Customer
  GetPage(
    name: AppRoutes.customerShell,
    page: () => const CustomerShell(),
    binding: BindingsBuilder(() {
      Get.lazyPut(() => CustomerHomeController());
      Get.lazyPut(() => NotificationsController());
    }),
  ),
  GetPage(name: AppRoutes.vendors, page: () => const VendorsScreen()),
  GetPage(name: AppRoutes.vendorDetail, page: () => const VendorDetailScreen()),
  GetPage(name: AppRoutes.cart, page: () => const CartScreen()),
  GetPage(name: AppRoutes.checkout, page: () => const CheckoutScreen()),
  GetPage(name: AppRoutes.orderDetail, page: () => const OrderDetailScreen()),
  GetPage(name: AppRoutes.fundWallet, page: () => const FundWalletScreen()),
  GetPage(name: AppRoutes.addresses, page: () => AddressesScreen()),
  GetPage(name: AppRoutes.addAddress, page: () => const AddAddressScreen()),
  GetPage(
    name: AppRoutes.notifications,
    page: () => const NotificationsScreen(),
  ),
  GetPage(name: AppRoutes.editProfile, page: () => const EditProfileScreen()),
  GetPage(name: AppRoutes.changePass, page: () => const ChangePasswordScreen()),
  GetPage(name: AppRoutes.setPin, page: () => const SetPinScreen()),
  GetPage(name: AppRoutes.support, page: () => const SupportScreen()),
  GetPage(
    name: AppRoutes.vendorReviews,
    page: () => const VendorReviewsScreen(),
  ),
  GetPage(name: AppRoutes.writeReview, page: () => const WriteReviewScreen()),

  // Rider
  GetPage(
    name: AppRoutes.riderShell,
    page: () => const RiderShell(),
    binding: BindingsBuilder(() {
      Get.lazyPut(() => RiderController());
    }),
  ),
  GetPage(
    name: AppRoutes.riderOrderDetail,
    page: () => const RiderOrderDetailScreen(),
  ),
];

// ─── Splash Screen ────────────────────────────────────────────────────────────
class _SplashScreen extends StatefulWidget {
  const _SplashScreen();
  @override
  State<_SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<_SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 1));
    final storage = StorageService.instance;
    final role = await storage.getRole();
    final cToken = await storage.getCustomerToken();
    final rToken = await storage.getRiderToken();

    if (role == 'rider' && rToken != null) {
      Get.offAllNamed(AppRoutes.riderShell);
    } else if (cToken != null) {
      Get.offAllNamed(AppRoutes.customerShell);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.orange,
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.navy,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Center(
              child: Image.asset('assets/images/logo.jpeg', fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'NKsereke',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your local delivery platform',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 48),
          const CircularProgressIndicator(
            color: Colors.white70,
            strokeWidth: 2,
          ),
        ],
      ),
    ),
  );
}
