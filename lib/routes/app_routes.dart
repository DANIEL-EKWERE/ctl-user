import 'package:ctluser/presentation/terms_of_service_screen/terms_of_service_screen.dart';

import '../core/app_export.dart';
import '../presentation/add_new_screen/add_new_screen.dart';
import '../presentation/add_new_screen/binding/add_new_binding.dart';
import '../presentation/app_navigation_screen/app_navigation_screen.dart';
import '../presentation/app_navigation_screen/binding/app_navigation_binding.dart';
import '../presentation/detail_restaurants_review_vone_screen/binding/detail_restaurants_review_vone_binding.dart';
import '../presentation/detail_restaurants_review_vone_screen/detail_restaurants_review_vone_screen.dart';
import '../presentation/detail_restaurants_vone_screen/binding/detail_restaurants_vone_binding.dart';
import '../presentation/detail_restaurants_vone_screen/detail_restaurants_vone_screen.dart';
import '../presentation/false_forgot_password_otp_screen/binding/false_forgot_password_otp_binding.dart';
import '../presentation/false_forgot_password_otp_screen/false_forgot_password_otp_screen.dart';
import '../presentation/filter_category_screen/binding/filter_category_binding.dart';
import '../presentation/filter_category_screen/filter_category_screen.dart';
import '../presentation/forget_password_one_screen/binding/forget_password_one_binding.dart';
import '../presentation/forget_password_one_screen/forget_password_one_screen.dart';
import '../presentation/forget_password_two_screen/binding/forget_password_two_binding.dart';
import '../presentation/forget_password_two_screen/forget_password_two_screen.dart';
import '../presentation/forgot_password_otp_screen/binding/forgot_password_otp_binding.dart';
import '../presentation/forgot_password_otp_screen/forgot_password_otp_screen.dart';
import '../presentation/home_screen/binding/home_binding.dart';
import '../presentation/home_screen/home_screen.dart';
import '../presentation/intro_splash_screen/binding/intro_splash_binding.dart';
import '../presentation/intro_splash_screen/intro_splash_screen.dart';
import '../presentation/login_four_screen/binding/login_four_binding.dart';
import '../presentation/login_four_screen/login_four_screen.dart';
import '../presentation/login_one_screen/binding/login_one_binding.dart';
import '../presentation/login_one_screen/login_one_screen.dart';
import '../presentation/login_screen/binding/login_binding.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/login_seven_screen/binding/login_seven_binding.dart';
import '../presentation/login_seven_screen/login_seven_screen.dart';
import '../presentation/login_six_screen/binding/login_six_binding.dart';
import '../presentation/login_six_screen/login_six_screen.dart';
import '../presentation/login_three_screen/binding/login_three_binding.dart';
import '../presentation/login_three_screen/login_three_screen.dart';
import '../presentation/login_two_screen/binding/login_two_binding.dart';
import '../presentation/login_two_screen/login_two_screen.dart';
import '../presentation/new_password_one_screen/binding/new_password_one_binding.dart';
import '../presentation/new_password_one_screen/new_password_one_screen.dart';
import '../presentation/new_password_two_screen/binding/new_password_two_binding.dart';
import '../presentation/new_password_two_screen/new_password_two_screen.dart';
import '../presentation/otp_screen/binding/otp_binding.dart';
import '../presentation/otp_screen/otp_screen.dart';
import '../presentation/otp_verification_screen/binding/otp_verification_binding.dart';
import '../presentation/otp_verification_screen/otp_verification_screen.dart';
import '../presentation/privacy_policy_screen/binding/privacy_policy_binding.dart';
import '../presentation/privacy_policy_screen/privacy_policy_screen.dart';
import '../presentation/search_vone_screen/binding/search_vone_binding.dart';
import '../presentation/search_vone_screen/search_vone_screen.dart';
import '../presentation/signup_one_screen/binding/signup_one_binding.dart';
import '../presentation/signup_one_screen/signup_one_screen.dart';
import '../presentation/signup_screen/binding/signup_binding.dart';
import '../presentation/signup_screen/signup_screen.dart';
import '../presentation/splash_page_five_screen/binding/splash_page_five_binding.dart';
import '../presentation/splash_page_five_screen/splash_page_five_screen.dart';
import '../presentation/splash_page_one_screen/binding/splash_page_one_binding.dart';
import '../presentation/splash_page_one_screen/splash_page_one_screen.dart';
import '../presentation/splash_page_three_screen/binding/splash_page_three_binding.dart';
import '../presentation/splash_page_three_screen/splash_page_three_screen.dart';
import '../presentation/splash_page_two_screen/binding/splash_page_two_binding.dart';
import '../presentation/splash_page_two_screen/splash_page_two_screen.dart';
import '../presentation/terms_of_service_screen/binding/terms_of_service_binding.dart';
import '../presentation/your_orders_history_screen/binding/your_orders_history_binding.dart';
import '../presentation/your_orders_history_screen/your_orders_history_screen.dart';
import '../presentation/your_orders_ongoing_screen/binding/your_orders_ongoing_binding.dart';
import '../presentation/your_orders_ongoing_screen/your_orders_ongoing_screen.dart';

// ignore_for_file: must_be_immutable
class AppRoutes {
  static const String introSplashScreen = '/intro_splash_screen';

  static const String splashPageOneScreen = '/splash_page_one_screen';

  static const String splashPageTwoScreen = '/splash_page_two_screen';

  static const String splashPageThreeScreen = '/splash_page_three_screen';

  static const String splashPageFiveScreen = '/splash_page_five_screen';

  static const String signupScreen = '/signup_screen';

  static const String signupOneScreen = '/signup_one_screen';

  static const String otpScreen = '/otp_screen';

  static const String otpVerificationScreen = '/otp_verification_screen';

  static const String termsOfServiceScreen = '/terms_of_service_screen';

  static const String privacyPolicyScreen = '/privacy_policy_screen';

  static const String loginScreen = '/login_screen';

  static const String loginOneScreen = '/login_one_screen';

  static const String forgetPasswordOneScreen = '/forget_password_one_screen';

  static const String forgetPasswordTwoScreen = '/forget_password_two_screen';

  static const String falseForgotPasswordOtpScreen =
      '/false_forgot_password_otp_screen';

  static const String forgotPasswordOtpScreen = '/forgot_password_otp_screen';

  static const String newPasswordOneScreen = '/new_password_one_screen';

  static const String newPasswordTwoScreen = '/new_password_two_screen';

  static const String loginTwoScreen = '/login_two_screen';

  static const String homeScreen = '/home_screen';

  static const String loginThreeScreen = '/login_three_screen';

  static const String loginThreeInitialPage = '/login_three_initial_page';

  static const String loginFourScreen = '/login_four_screen';

  static const String detailRestaurantsVoneScreen =
      '/detail_restaurants_vone_screen';

  static const String detailTabPage = '/detail_tab_page';

  static const String loginFivePage = '/login_five_page';

  static const String detailRestaurantsReviewVoneScreen =
      '/detail_restaurants_review_vone_screen';

  static const String loginSixScreen = '/login_six_screen';

  static const String loginSevenScreen = '/login_seven_screen';

  static const String addNewScreen = '/add_new_screen';

  static const String yourOrdersOngoingScreen = '/your_orders_ongoing_screen';

  static const String yourOrdersHistoryScreen = '/your_orders_history_screen';

  static const String yourTabPage = '/your_tab_page';

  static const String profilePage = '/profile_page';

  static const String filterCategoryScreen = '/filter_category_screen';

  static const String twentyTabPage = '/twenty_tab_page';

  static const String filterSortByPage = '/filter_sort_by_page';

  static const String filterPricePage = '/filter_price_page';

  static const String searchVoneScreen = '/search_vone_screen';

  static const String appNavigationScreen = '/app_navigation_screen';

  static const String initialRoute = '/initialRoute';

  static List<GetPage> pages = [
    GetPage(
      name: introSplashScreen,
      page: () => IntroSplashScreen(),
      bindings: [IntroSplashBinding()],
    ),
    GetPage(
      name: splashPageOneScreen,
      page: () => SplashPageOneScreen(),
      bindings: [SplashPageOneBinding()],
    ),
    GetPage(
      name: splashPageTwoScreen,
      page: () => SplashPageTwoScreen(),
      bindings: [SplashPageTwoBinding()],
    ),
    GetPage(
      name: splashPageThreeScreen,
      page: () => SplashPageThreeScreen(),
      bindings: [SplashPageThreeBinding()],
    ),
    GetPage(
      name: splashPageFiveScreen,
      page: () => SplashPageFiveScreen(),
      bindings: [SplashPageFiveBinding()],
    ),
    GetPage(
      name: signupScreen,
      page: () => SignupScreen(),
      bindings: [SignupBinding()],
    ),
    GetPage(
      name: signupOneScreen,
      page: () => SignupOneScreen(),
      bindings: [SignupOneBinding()],
    ),
    GetPage(name: otpScreen,
    page: () => OtpScreen(),
    bindings: [OtpBinding()]),
    GetPage(
      name: otpVerificationScreen,
      page: () => OtpVerificationScreen(),
      bindings: [OtpVerificationBinding()],
    ),
    GetPage(
      name: termsOfServiceScreen,
      page: () => TermsOfServiceScreen(),
      bindings: [TermsOfServiceBinding()],
    ),
    GetPage(
      name: privacyPolicyScreen,
      page: () => PrivacyPolicyScreen(),
      bindings: [PrivacyPolicyBinding()],
    ),
    GetPage(
      name: loginScreen,
      page: () => LoginScreen(),
      bindings: [LoginBinding()],
    ),
    GetPage(
      name: loginOneScreen,
      page: () => LoginOneScreen(),
      bindings: [LoginOneBinding()],
    ),
    GetPage(
      name: forgetPasswordOneScreen,
      page: () => ForgetPasswordOneScreen(),
      bindings: [ForgetPasswordOneBinding()],
    ),
    GetPage(
      name: forgetPasswordTwoScreen,
      page: () => ForgetPasswordTwoScreen(),
      bindings: [ForgetPasswordTwoBinding()],
    ),
    GetPage(
      name: falseForgotPasswordOtpScreen,
      page: () => FalseForgotPasswordOtpScreen(),
      bindings: [FalseForgotPasswordOtpBinding()],
    ),
    GetPage(
      name: forgotPasswordOtpScreen,
      page: () => ForgotPasswordOtpScreen(),
      bindings: [ForgotPasswordOtpBinding()],
    ),
    GetPage(
      name: newPasswordOneScreen,
      page: () => NewPasswordOneScreen(),
      bindings: [NewPasswordOneBinding()],
    ),
    GetPage(
      name: newPasswordTwoScreen,
      page: () => NewPasswordTwoScreen(),
      bindings: [NewPasswordTwoBinding()],
    ),
    GetPage(
      name: loginTwoScreen,
      page: () => LoginTwoScreen(),
      bindings: [LoginTwoBinding()],
    ),
    GetPage(
      name: homeScreen,
      page: () => HomeScreen(),
      bindings: [HomeBinding()],
    ),
    GetPage(
      name: loginThreeScreen,
      page: () => LoginThreeScreen(),
      bindings: [LoginThreeBinding()],
    ),
    GetPage(
      name: loginFourScreen,
      page: () => LoginFourScreen(),
      bindings: [LoginFourBinding()],
    ),
    GetPage(
      name: detailRestaurantsVoneScreen,
      page: () => DetailRestaurantsVoneScreen(),
      bindings: [DetailRestaurantsVoneBinding()],
    ),
    GetPage(
      name: detailRestaurantsReviewVoneScreen,
      page: () => DetailRestaurantsReviewVoneScreen(),
      bindings: [DetailRestaurantsReviewVoneBinding()],
    ),
    GetPage(
      name: loginSixScreen,
      page: () => LoginSixScreen(),
      bindings: [LoginSixBinding()],
    ),
    GetPage(
      name: loginSevenScreen,
      page: () => LoginSevenScreen(),
      bindings: [LoginSevenBinding()],
    ),
    GetPage(
      name: addNewScreen,
      page: () => AddNewScreen(),
      bindings: [AddNewBinding()],
    ),
    GetPage(
      name: yourOrdersOngoingScreen,
      page: () => YourOrdersOngoingScreen(),
      bindings: [YourOrdersOngoingBinding()],
    ),
    GetPage(
      name: yourOrdersHistoryScreen,
      page: () => YourOrdersHistoryScreen(),
      bindings: [YourOrdersHistoryBinding()],
    ),
    GetPage(
      name: filterCategoryScreen,
      page: () => FilterCategoryScreen(),
      bindings: [FilterCategoryBinding()],
    ),
    GetPage(
      name: searchVoneScreen,
      page: () => SearchVoneScreen(),
      bindings: [SearchVoneBinding()],
    ),
    GetPage(
      name: appNavigationScreen,
      page: () => AppNavigationScreen(),
      bindings: [AppNavigationBinding()],
    ),
    GetPage(
      name: initialRoute,
      page: () => IntroSplashScreen(),
      bindings: [IntroSplashBinding()],
    ),
  ];
}
