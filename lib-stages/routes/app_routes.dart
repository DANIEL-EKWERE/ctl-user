import 'package:get/get.dart';

import '../presentation/screens/splash/splash_screen.dart';
import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/auth/register_screen.dart';
import '../presentation/screens/auth/otp_screen.dart';
import '../presentation/screens/auth/forgot_password_screen.dart';
import '../presentation/screens/auth/reset_password_screen.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/vendor_detail/vendor_detail_screen.dart';
import '../presentation/screens/cart/cart_screen.dart';
import '../presentation/screens/checkout/checkout_screen.dart';
import '../presentation/screens/orders/orders_screen.dart';
import '../presentation/screens/orders/order_tracking_screen.dart';
import '../presentation/screens/profile/profile_screen.dart';
import '../presentation/screens/search/search_screen.dart';
import '../presentation/screens/rider/rider_home_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String otp = '/otp';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String home = '/home';
  static const String vendorDetail = '/vendor-detail';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String orders = '/orders';
  static const String orderTracking = '/order-tracking';
  static const String profile = '/profile';
  static const String search = '/search';
  static const String riderHome = '/rider-home';

  static final List<GetPage> pages = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: register, page: () => const RegisterScreen()),
    GetPage(name: otp, page: () => const OtpScreen()),
    GetPage(name: forgotPassword, page: () => const ForgotPasswordScreen()),
    GetPage(name: resetPassword, page: () => const ResetPasswordScreen()),
    GetPage(name: home, page: () => const HomeScreen()),
    GetPage(name: vendorDetail, page: () => const VendorDetailScreen()),
    GetPage(name: cart, page: () => const CartScreen()),
    GetPage(name: checkout, page: () => const CheckoutScreen()),
    GetPage(name: orders, page: () => const OrdersScreen()),
    GetPage(name: orderTracking, page: () => const OrderTrackingScreen()),
    GetPage(name: profile, page: () => const ProfileScreen()),
    GetPage(name: search, page: () => const SearchScreen()),
    GetPage(name: riderHome, page: () => const RiderHomeScreen()),
  ];
}
