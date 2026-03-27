// TODO Implement this library.
import 'models/order_model.dart';
import '../your_orders_ongoing_screen/controller/your_orders_ongoing_controller.dart';
import '../your_orders_ongoing_screen/models/timelineclose_item_model.dart';
import '../your_orders_ongoing_screen/widgets/columnname_one_item_widget.dart';
import '../your_orders_ongoing_screen/widgets/stackclose_one_item_widget.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_title_searchview.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../login_five_page/login_five_page.dart';
import '../profile_page/profile_page.dart';
import 'controller/your_orders_history_controller.dart';
import 'your_tab_page.dart'; // ignore_for_file: must_be_immutable
import 'package:timelines_plus/timelines_plus.dart';

YourOrdersHistoryController controller = Get.put(YourOrdersHistoryController());
YourOrdersOngoingController controller1 = Get.put(
  YourOrdersOngoingController(),
);

class YourOrdersHistoryScreen extends StatefulWidget {
  const YourOrdersHistoryScreen({Key? key}) : super(key: key);

  @override
  State<YourOrdersHistoryScreen> createState() =>
      _YourOrdersHistoryScreenState();
}

class _YourOrdersHistoryScreenState extends State<YourOrdersHistoryScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.fetchOrders();
  }

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
                    children: [
                      SizedBox(
                        width: double.maxFinite,
                        child: SingleChildScrollView(
                          child: SizedBox(
                            width: double.maxFinite,
                            child:
                            // ListView.builder(itemBuilder: (context, index) {
                            //   return Container();
                            // },),
                            Column(
                              spacing: 44,
                              children: [
                                Container(
                                  //height: 812.h,
                                  width: double.maxFinite,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.h,
                                    vertical: 62.h,
                                  ),
                                  decoration: AppDecoration.stack12,
                                  child: Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      _buildColumn(),
                                      Positioned(
                                        top: -220,
                                        child: CustomImageView(
                                          imagePath:
                                              'assets/images/tracking.svg',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //  _buildRowuserthree(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      YourTabPage(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: Container(
      //   width: double.maxFinite,
      //   margin: EdgeInsets.only(left: 16.h, right: 16.h, bottom: 16.h),
      //   child: _buildBottombar(),
      // ),
    );
  }

  Widget _buildRowuserthree() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14.h),
      padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 24.h),
      decoration: AppDecoration.neutral00.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder14,
      ),
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgUserPrimary,
            height: 24.h,
            width: 26.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 12.h),
            child: Text(
              "lbl_add_voucher".tr,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30.h, vertical: 2.h),
            decoration: AppDecoration.red50.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder8,
            ),
            child: Text(
              "lbl_add".tr,
              textAlign: TextAlign.center,
              style: CustomTextStyles.labelLargePrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColumn() {
    return Container(
      width: double.maxFinite,
      //margin: EdgeInsets.only(bottom: 8.h),
      child: Column(
        spacing: 16,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Obx(
              () =>
                  controller.isLoading.value
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: controller.orderItem!.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          OrderItem orderItem = controller.orderItem![index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Column(
                              spacing: 16,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: double.maxFinite,
                                  padding: EdgeInsets.all(16.h),
                                  decoration: AppDecoration.neutral00.copyWith(
                                    borderRadius:
                                        BorderRadiusStyle.roundedBorder14,
                                  ),
                                  child: Column(
                                    spacing: 16,
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: double.maxFinite,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CustomIconButton(
                                              height: 48.h,
                                              width: 48.h,
                                              padding: EdgeInsets.all(12.h),
                                              decoration:
                                                  IconButtonStyleHelper
                                                      .fillPrimary,
                                              child: Opacity(
                                                opacity: 1,
                                                child: CustomImageView(
                                                  imagePath:
                                                      'assets/images/order.svg',
                                                  //  ImageConstant.imgThumbsUp,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Expanded(
                                              child: Column(
                                                spacing: 2,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "msg_delivery_your_order"
                                                        .tr,
                                                    style:
                                                        CustomTextStyles
                                                            .titleMediumBold,
                                                  ),
                                                  Text(
                                                    "msg_coming_within_30".tr,
                                                    style:
                                                        CustomTextStyles
                                                            .bodyMediumBluegray400,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: double.maxFinite,
                                        child: Divider(
                                          color: appTheme.blueGray50,
                                        ),
                                      ),
                                      SizedBox(
                                        width: double.maxFinite,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                spacing: 4,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    orderItem
                                                            .items!
                                                            .first
                                                            .product!
                                                            .name ??
                                                        "msg_prime_beef_pizza"
                                                            .tr,
                                                    style:
                                                        theme
                                                            .textTheme
                                                            .titleSmall,
                                                  ),
                                                  SizedBox(
                                                    width: double.maxFinite,
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "\u20A6${orderItem.total}" ??
                                                              "lbl_20_99".tr,
                                                          style:
                                                              CustomTextStyles
                                                                  .labelLargePrimary,
                                                        ),
                                                        Container(
                                                          height: 4.h,
                                                          width: 4.h,
                                                          margin:
                                                              EdgeInsets.only(
                                                                left: 8.h,
                                                              ),
                                                          decoration: BoxDecoration(
                                                            color:
                                                                appTheme
                                                                    .gray400,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  2.h,
                                                                ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                left: 8.h,
                                                              ),
                                                          child: Text(
                                                            "${orderItem.items!.length} items",
                                                            style:
                                                                CustomTextStyles
                                                                    .labelLargeGray400,
                                                          ),
                                                        ),
                                                        Container(
                                                          height: 4.h,
                                                          width: 4.h,
                                                          margin:
                                                              EdgeInsets.only(
                                                                left: 8.h,
                                                              ),
                                                          decoration: BoxDecoration(
                                                            color:
                                                                appTheme
                                                                    .gray400,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  2.h,
                                                                ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                left: 8.h,
                                                              ),
                                                          child: Text(
                                                            "lbl_credit_card"
                                                                .tr,
                                                            style:
                                                                CustomTextStyles
                                                                    .labelLargeGray400,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            CustomElevatedButton(
                                              width: 86.h,
                                              text: "lbl_detail".tr,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: double.maxFinite,
                                  padding: EdgeInsets.all(16.h),
                                  decoration: AppDecoration.neutral00.copyWith(
                                    borderRadius:
                                        BorderRadiusStyle.roundedBorder14,
                                  ),
                                  child: Column(
                                    spacing: 15,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: double.maxFinite,
                                        child: Obx(
                                          () => Timeline.tileBuilder(
                                            shrinkWrap: true,
                                            theme: TimelineThemeData(
                                              nodePosition: 0.01,
                                              indicatorPosition: 0,
                                            ),
                                            builder: TimelineTileBuilder.connected(
                                              connectionDirection:
                                                  ConnectionDirection.before,
                                              itemCount:
                                                  controller
                                                      .timelinecloseItemList
                                                      .value
                                                      .length,
                                              indicatorBuilder: (
                                                context,
                                                index,
                                              ) {
                                                TimelinecloseItemModel model =
                                                    controller
                                                        .timelinecloseItemList
                                                        .value[index];
                                                return StackcloseOneItemWidget(
                                                  model,
                                                );
                                              },
                                              contentsBuilder: (
                                                context,
                                                index,
                                              ) {
                                                TimelinecloseItemModel model =
                                                    controller
                                                        .timelinecloseItemList
                                                        .value[index];
                                                return ColumnnameOneItemWidget(
                                                  model,
                                                );
                                              },
                                              connectorBuilder: (
                                                context,
                                                index,
                                                type,
                                              ) {
                                                return DashedLineConnector(
                                                  thickness: 1.h,
                                                  color: appTheme.gray400,
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: double.maxFinite,
                                        child: Row(
                                          //spacing: 10,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CustomImageView(
                                              imagePath:
                                                  ImageConstant.imgEllipse8,
                                              height: 40.h,
                                              width: 40.h,
                                              radius: BorderRadius.circular(
                                                20.h,
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "msg_philippe_troussier".tr,
                                                    style:
                                                        theme
                                                            .textTheme
                                                            .titleSmall,
                                                  ),
                                                  SizedBox(
                                                    width: double.maxFinite,
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "lbl_delivery".tr,
                                                          style:
                                                              theme
                                                                  .textTheme
                                                                  .labelLarge,
                                                        ),
                                                        Container(
                                                          height: 4.h,
                                                          width: 4.h,
                                                          margin:
                                                              EdgeInsets.only(
                                                                left: 4.h,
                                                              ),
                                                          decoration: BoxDecoration(
                                                            color:
                                                                appTheme
                                                                    .gray400,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  2.h,
                                                                ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                left: 4.h,
                                                              ),
                                                          child: Text(
                                                            "lbl_0145425765".tr,
                                                            style:
                                                                theme
                                                                    .textTheme
                                                                    .labelLarge,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            CustomIconButton(
                                              height: 40.h,
                                              width: 40.h,
                                              padding: EdgeInsets.all(8.h),
                                              decoration:
                                                  IconButtonStyleHelper
                                                      .fillTeal,
                                              child: CustomImageView(
                                                imagePath:
                                                    ImageConstant.imgCall,
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            CustomIconButton(
                                              height: 40.h,
                                              width: 40.h,
                                              padding: EdgeInsets.all(8.h),
                                              decoration:
                                                  IconButtonStyleHelper
                                                      .fillPrimaryTL20,
                                              child: CustomImageView(
                                                imagePath:
                                                    ImageConstant
                                                        .imgUserOnprimary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildNavigationbar() {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 24.h),
      decoration: AppDecoration.neutral00,
      child: Column(
        spacing: 22,
        children: [
          //SizedBox(height: 1),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: CustomAppBar(
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
      case BottomBarEnum.Order:
        return AppRoutes.yourOrdersHistoryScreen;
      // case BottomBarEnum.Cart:
      //   return AppRoutes.profilePage;
      case BottomBarEnum.Profile:
        return "/";
      default:
        return "/";
    }
  }
}
