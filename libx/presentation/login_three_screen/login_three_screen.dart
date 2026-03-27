import '../your_orders_history_screen/your_orders_history_screen.dart';
import '../your_orders_ongoing_screen/your_orders_ongoing_screen.dart';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../login_five_page/login_five_page.dart';
import '../profile_page/profile_page.dart';
import 'controller/login_three_controller.dart';
import 'login_three_initial_page.dart'; // ignore_for_file: must_be_immutable

class LoginThreeScreen extends GetWidget<LoginThreeController> {
  const LoginThreeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.gray100,
      body: SafeArea(
        child: Navigator(
          key: Get.nestedKey(1),
          initialRoute: AppRoutes.loginThreeInitialPage,
          onGenerateRoute:
              (routeSetting) => GetPageRoute(
                page: () => getCurrentPage(routeSetting.name!),
                transition: Transition.noTransition,
              ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        width: double.maxFinite,
        child: _buildBottombar(),
      ),
    );
  }

  /// Section Widget
  Widget _buildBottombar() {
    return SizedBox(
      width: double.maxFinite,
      child: CustomBottomBar(
        onChanged: (BottomBarEnum type) {
          Get.toNamed(getCurrentRoute(type), id: 1);
        },
      ),
    );
  }

  ///Handling route based on bottom click actions
  String getCurrentRoute(BottomBarEnum type) {
    switch (type) {
      case BottomBarEnum.Home:
        return AppRoutes.loginThreeInitialPage;
      case BottomBarEnum.Browse:
        return AppRoutes.loginFivePage;
      case BottomBarEnum.Order:
        return AppRoutes.yourOrdersHistoryScreen;
      // case BottomBarEnum.Cart:
      //   return AppRoutes.profilePage;
      case BottomBarEnum.Profile:
        return AppRoutes.profilePage;
      default:
        return "/";
    }
  }

  ///Handling page based on route
  Widget getCurrentPage(String currentRoute) {
    switch (currentRoute) {
      case AppRoutes.loginThreeInitialPage:
        return LoginThreeInitialPage();
      case AppRoutes.yourOrdersHistoryScreen:
        return YourOrdersHistoryScreen();
      case AppRoutes.profilePage:
        return ProfilePage();
      default:
        return DefaultWidget();
    }
  }
}
