// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_title_searchview.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../login_five_page/login_five_page.dart';
import '../profile_page/profile_page.dart';
import 'controller/your_orders_history_controller.dart';
import 'your_tab_page.dart'; // ignore_for_file: must_be_immutable

class YourOrdersHistoryScreen extends GetWidget<YourOrdersHistoryController> {
  const YourOrdersHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appTheme.gray100,
      body: SafeArea(
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              _buildNavigationbar(),
              Expanded(
                child: Container(
                  child: TabBarView(
                    controller: controller.tabviewController,
                    children: [Container(), YourTabPage()],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: double.maxFinite,
        margin: EdgeInsets.only(left: 16.h, right: 16.h, bottom: 16.h),
        child: _buildBottombar(),
      ),
    );
  }

  /// Section Widget
  Widget _buildNavigationbar() {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 34.h),
      decoration: AppDecoration.neutral00,
      child: Column(
        spacing: 22,
        children: [
          CustomAppBar(
            height: 44.h,
            title: SizedBox(
              width: double.maxFinite,
              child: AppbarTitleSearchview(
                hintText: "lbl_search_on_coody".tr,
                controller: controller.searchController,
              ),
            ),
            styleType: Style.bgFillGray100,
          ),
          SizedBox(
            width: double.maxFinite,
            child: TabBar(
              controller: controller.tabviewController,
              labelPadding: EdgeInsets.zero,
              labelColor: theme.colorScheme.primary,
              labelStyle: TextStyle(
                fontSize: 10.fSize,
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w500,
              ),
              unselectedLabelColor: appTheme.blueGray900,
              unselectedLabelStyle: TextStyle(
                fontSize: 10.fSize,
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w500,
              ),
              indicatorColor: theme.colorScheme.primary,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Tab(child: Text("lbl_ongoing".tr)),
                Tab(child: Text("lbl_history".tr)),
              ],
            ),
          ),
        ],
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
