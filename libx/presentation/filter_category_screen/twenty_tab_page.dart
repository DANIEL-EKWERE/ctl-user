import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';
import 'controller/filter_category_controller.dart';
import 'models/items_one_item_model.dart';
import 'models/twenty_tab_model.dart';
import 'widgets/items_one_item_widget.dart';

// ignore_for_file: must_be_immutable
class TwentyTabPage extends StatelessWidget {
  TwentyTabPage({Key? key}) : super(key: key);

  FilterCategoryController controller = Get.put(FilterCategoryController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.h),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                width: double.maxFinite,
                margin: EdgeInsets.only(top: 12.h),
                child: Column(
                  spacing: 28,
                  children: [
                    Container(
                      width: double.maxFinite,
                      child: Obx(
                        () => SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Wrap(
                            direction: Axis.horizontal,
                            spacing: 20.h,
                            children: List.generate(
                              controller
                                  .twentyTabModelObj
                                  .value
                                  .itemsOneItemList
                                  .value
                                  .length,
                              (index) {
                                ItemsOneItemModel model =
                                    controller
                                        .twentyTabModelObj
                                        .value
                                        .itemsOneItemList
                                        .value[index];
                                return ItemsOneItemWidget(model);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    _buildComplete(),
                    Container(
                      height: 5.h,
                      width: 40.h,
                      decoration: BoxDecoration(
                        color: appTheme.black900.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(2.h),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildComplete() {
    return CustomElevatedButton(
      text: "lbl_complete".tr,
      margin: EdgeInsets.only(left: 16.h, right: 18.h),
    );
  }
}
