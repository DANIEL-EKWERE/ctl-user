// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import '../../core/app_export.dart';
import 'controller/detail_restaurants_vone_controller.dart';
import 'models/detail_tab_model.dart';
import 'models/listnamemarket_item_model.dart';
import 'models/sectionlisthotc_item_model.dart';
import 'widgets/listnamemarket_item_widget.dart';
import 'widgets/sectionlisthotc_item_widget.dart';

// ignore_for_file: must_be_immutable
class DetailTabPage extends StatelessWidget {
  DetailTabPage({Key? key}) : super(key: key);

  DetailRestaurantsVoneController controller = Get.put(
    DetailRestaurantsVoneController(),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 32.h),
      child: Column(
        children: [
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.only(left: 34.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "lbl_popular_items".tr,
                  style: CustomTextStyles.titleMediumBold,
                ),
                SizedBox(height: 16.h),
                _buildListnamemarket(),
                SizedBox(height: 40.h),
                _buildSectionlisthotc(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildListnamemarket() {
    return Container(
      child: Obx(
        () => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Wrap(
            direction: Axis.horizontal,
            spacing: 8.h,
            children: List.generate(
              controller
                  .detailTabModelObj
                  .value
                  .listnamemarketItemList
                  .value
                  .length,
              (index) {
                ListnamemarketItemModel model =
                    controller
                        .detailTabModelObj
                        .value
                        .listnamemarketItemList
                        .value[index];
                return GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.loginSixScreen);
                  },
                  child: ListnamemarketItemWidget(model),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildSectionlisthotc() {
    return Obx(
      () => GroupedListView<SectionlisthotcItemModel, String>(
        shrinkWrap: true,
        stickyHeaderBackgroundColor: Colors.transparent,
        elements:
            controller
                .detailRestaurantsVoneModelObj
                .value
                .sectionlisthotcItemList
                .value,
        groupBy: (element) => element.groupBy!.value,
        sort: false,
        groupSeparatorBuilder: (String value) {
          return Padding(
            padding: EdgeInsets.only(top: 40.h, bottom: 20.h),
            child: Text(
              value,
              style: CustomTextStyles.titleMediumBold.copyWith(
                color: appTheme.blueGray900,
              ),
            ),
          );
        },
        itemBuilder: (context, model) {
          return SectionlisthotcItemWidget(model);
        },
        separator: SizedBox(height: 20.h),
      ),
    );
  }
}
