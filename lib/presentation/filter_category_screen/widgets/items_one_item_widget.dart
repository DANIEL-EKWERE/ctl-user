// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../controller/filter_category_controller.dart';
import '../models/items_one_item_model.dart';

// ignore_for_file: must_be_immutable
class ItemsOneItemWidget extends StatelessWidget {
  ItemsOneItemWidget(this.itemsOneItemModelObj, {Key? key}) : super(key: key);

  ItemsOneItemModel itemsOneItemModelObj;

  var controller = Get.find<FilterCategoryController>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.h,
      child: Column(
        spacing: 8,
        children: [
          SizedBox(
            width: double.maxFinite,
            child: Obx(
              () => CustomImageView(
                imagePath: itemsOneItemModelObj.sandwichOne!.value,
                height: 100.h,
                width: double.maxFinite,
                radius: BorderRadius.circular(50.h),
              ),
            ),
          ),
          Obx(
            () => Text(
              itemsOneItemModelObj.namecategory!.value,
              overflow: TextOverflow.ellipsis,
              style: CustomTextStyles.labelLargeBluegray900_1,
            ),
          ),
        ],
      ),
    );
  }
}
