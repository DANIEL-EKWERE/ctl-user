import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../profile_page/profile_page.dart';
import 'controller/login_five_controller.dart';
import 'models/login_five_model.dart';

// ignore_for_file: must_be_immutable
class LoginFivePage extends StatelessWidget {
  LoginFivePage({Key? key}) : super(key: key);

  LoginFiveController controller = Get.put(
    LoginFiveController(LoginFiveModel().obs),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.gray100,
      body: SafeArea(
        child: Container(
          width: double.maxFinite,
          decoration: AppDecoration.fs42Cardlist,
          child: Column(
            children: [
              SizedBox(width: double.maxFinite, child: _buildBottombarone()),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        width: double.maxFinite,
        child: _buildBottombarone1(),
      ),
    );
  }

  /// Section Widget
  Widget _buildBottombarone() {
    return SizedBox(
      width: double.maxFinite,
      child: CustomBottomBar(
        onChanged: (BottomBarEnum type) {
          Get.toNamed(getCurrentRoute(type), id: 1);
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildBottombarone1() {
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
      case BottomBarEnum.Favourites:
        return "/";
      case BottomBarEnum.Cart:
        return AppRoutes.profilePage;
      case BottomBarEnum.Profile:
        return "/";
      default:
        return "/";
    }
  }
}
