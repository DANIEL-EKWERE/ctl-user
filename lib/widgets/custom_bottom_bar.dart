import 'package:flutter/material.dart';
import '../core/app_export.dart';

enum BottomBarEnum { Home, Browse, Favourites, Cart, Profile }

// ignore_for_file: must_be_immutable
class CustomBottomBar extends StatelessWidget {
  CustomBottomBar({Key? key, this.onChanged}) : super(key: key);

  RxInt selectedIndex = 0.obs;

  List<BottomMenuModel> bottomMenuList = [
    BottomMenuModel(
      icon: ImageConstant.imgNavFavourites,
      activeIcon: ImageConstant.imgNavFavourites,
      title: "lbl_home".tr,
      type: BottomBarEnum.Home,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgNavFavourites,
      activeIcon: ImageConstant.imgNavFavourites,
      title: "lbl_browse".tr,
      type: BottomBarEnum.Browse,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgNavFavourites,
      activeIcon: ImageConstant.imgNavFavourites,
      title: "lbl_favourites".tr,
      type: BottomBarEnum.Favourites,
      isCircle: true,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgNavFavourites,
      activeIcon: ImageConstant.imgNavFavourites,
      title: "lbl_cart".tr,
      type: BottomBarEnum.Cart,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgNavFavourites,
      activeIcon: ImageConstant.imgNavFavourites,
      title: "lbl_profile".tr,
      type: BottomBarEnum.Profile,
    ),
  ];

  Function(BottomBarEnum)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary,
        boxShadow: [
          BoxShadow(
            color: appTheme.black900.withValues(alpha: 0.08),
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Obx(
        () => BottomNavigationBar(
          backgroundColor: Colors.transparent,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedFontSize: 0,
          elevation: 0,
          currentIndex: selectedIndex.value,
          type: BottomNavigationBarType.fixed,
          items: List.generate(bottomMenuList.length, (index) {
            if (bottomMenuList[index].isCircle) {
              return BottomNavigationBarItem(
                icon: Opacity(
                  opacity: 0.4,
                  child: Container(
                    height: 44.h,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomImageView(
                          imagePath: bottomMenuList[index].icon,
                          height: 24.h,
                          width: 26.h,
                          alignment: Alignment.topCenter,
                          margin: EdgeInsets.only(top: 2.h),
                        ),
                        SizedBox(
                          width: double.maxFinite,
                          child: Column(
                            spacing: 14,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 6.h),
                                decoration: AppDecoration.fillGray90001
                                    .copyWith(
                                      borderRadius:
                                          BorderRadiusStyle.roundedBorder8,
                                    ),
                                child: Text(
                                  bottomMenuList[index].title ?? "",
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.labelSmall!.copyWith(
                                    color: appTheme.gray90001,
                                  ),
                                ),
                              ),
                              Text(
                                bottomMenuList[index].title ?? "",
                                style: theme.textTheme.labelMedium!.copyWith(
                                  color: appTheme.gray90001,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                label: '',
              );
            }
            return BottomNavigationBarItem(
              icon: Opacity(
                opacity: 0.4,
                child: Column(
                  spacing: 2,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomImageView(
                      imagePath: bottomMenuList[index].icon,
                      height: 24.h,
                      width: 24.h,
                    ),
                    Text(
                      bottomMenuList[index].title ?? "",
                      style: theme.textTheme.labelMedium!.copyWith(
                        color: appTheme.gray90001,
                      ),
                    ),
                  ],
                ),
              ),
              activeIcon: Opacity(
                opacity: 0.4,
                child: Column(
                  spacing: 2,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomImageView(
                      imagePath: bottomMenuList[index].activeIcon,
                      height: 24.h,
                      width: 24.h,
                    ),
                    Text(
                      bottomMenuList[index].title ?? "",
                      style: theme.textTheme.labelMedium!.copyWith(
                        color: appTheme.gray90001,
                      ),
                    ),
                  ],
                ),
              ),
              label: '',
            );
          }),
          onTap: (index) {
            selectedIndex.value = index;
            onChanged?.call(bottomMenuList[index].type);
          },
        ),
      ),
    );
  }
}

// ignore_for_file: must_be_immutable
class BottomMenuModel {
  BottomMenuModel({
    required this.icon,
    required this.activeIcon,
    this.title,
    required this.type,
    this.isCircle = false,
  });

  String icon;

  String activeIcon;

  String? title;

  BottomBarEnum type;

  bool isCircle;
}

class DefaultWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffffffff),
      padding: EdgeInsets.all(10),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Please replace the respective Widget here',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
