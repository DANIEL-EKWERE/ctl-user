// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../controller/search_vone_controller.dart';
import '../models/listburger_king_item_model.dart';

// ignore_for_file: must_be_immutable
class ListburgerKingItemWidget extends StatelessWidget {
  ListburgerKingItemWidget(this.listburgerKingItemModelObj, {Key? key})
    : super(key: key);

  ListburgerKingItemModel listburgerKingItemModelObj;

  var controller = Get.find<SearchVoneController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Obx(
          () => CustomImageView(
            imagePath: listburgerKingItemModelObj.burgerKingOne!.value,
            height: 80.h,
            width: 80.h,
            radius: BorderRadius.circular(14.h),
          ),
        ),
        Expanded(
          child: Column(
            spacing: 8,
            children: [
              SizedBox(
                width: double.maxFinite,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(
                      () => Text(
                        listburgerKingItemModelObj.name!.value,
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    CustomImageView(
                      imagePath: ImageConstant.imgSignalOrange400,
                      height: 24.h,
                      width: 26.h,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.maxFinite,
                child: Row(
                  children: [
                    Obx(
                      () => Text(
                        listburgerKingItemModelObj.usdCounter!.value,
                        style: CustomTextStyles.labelLargePrimary,
                      ),
                    ),
                    Container(
                      height: 2.h,
                      width: 2.h,
                      margin: EdgeInsets.only(left: 8.h),
                      decoration: BoxDecoration(
                        color: appTheme.gray400,
                        borderRadius: BorderRadius.circular(1.h),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.h),
                      child: Obx(
                        () => Text(
                          listburgerKingItemModelObj.food!.value,
                          style: theme.textTheme.labelLarge,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
