// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_title_searchview_one.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import 'controller/search_vone_controller.dart';
import 'models/listburger_king_item_model.dart';
import 'widgets/listburger_king_item_widget.dart'; // ignore_for_file: must_be_immutable

class SearchVoneScreen extends GetWidget<SearchVoneController> {
  const SearchVoneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.colorScheme.onPrimary,
      appBar: _buildAppbar(),
      body: SafeArea(
        top: false,
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 14.h),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  width: double.maxFinite,
                  margin: EdgeInsets.only(right: 8.h),
                  padding: EdgeInsets.only(left: 14.h, top: 14.h, right: 14.h),
                  decoration: AppDecoration.outlineGray1001.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder14,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [_buildListburgerking()],
                  ),
                ),
              ),
              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppbar() {
    return CustomAppBar(
      height: 76.h,
      title: SizedBox(
        width: double.maxFinite,
        child: AppbarTitleSearchviewOne(
          margin: EdgeInsets.symmetric(horizontal: 35.h),
          hintText: "lbl_burger_king".tr,
          controller: controller.searchController,
        ),
      ),
      styleType: Style.bgFillOnPrimary,
    );
  }

  /// Section Widget
  Widget _buildListburgerking() {
    return Expanded(
      child: Obx(
        () => ListView.separated(
          padding: EdgeInsets.zero,
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          separatorBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0.h),
              child: Divider(
                height: 1.h,
                thickness: 1.h,
                color: appTheme.gray100,
              ),
            );
          },
          itemCount:
              controller
                  .searchVoneModelObj
                  .value
                  .listburgerKingItemList
                  .value
                  .length,
          itemBuilder: (context, index) {
            ListburgerKingItemModel model =
                controller
                    .searchVoneModelObj
                    .value
                    .listburgerKingItemList
                    .value[index];
            return ListburgerKingItemWidget(model);
          },
        ),
      ),
    );
  }
}
