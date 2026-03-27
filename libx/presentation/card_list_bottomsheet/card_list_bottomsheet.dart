// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'controller/card_list_controller.dart';
import 'models/items_item_model.dart';
import 'widgets/items_item_widget.dart';

// ignore_for_file: must_be_immutable
class CardListBottomsheet extends StatelessWidget {
  CardListBottomsheet(this.controller, {Key? key}) : super(key: key);

  CardListController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 34.h, vertical: 16.h),
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            spacing: 34,
            children: [
              Container(
                height: 5.h,
                width: 40.h,
                decoration: BoxDecoration(
                  color: appTheme.black900.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(2.h),
                ),
              ),
              Obx(
                () => ListView.separated(
                  padding: EdgeInsets.zero,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 8.h);
                  },
                  itemCount:
                      controller
                          .cardListModelObj
                          .value
                          .itemsItemList
                          .value
                          .length,
                  itemBuilder: (context, index) {
                    ItemsItemModel model =
                        controller
                            .cardListModelObj
                            .value
                            .itemsItemList
                            .value[index];
                    return ItemsItemWidget(model);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
