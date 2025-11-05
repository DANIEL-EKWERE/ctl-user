// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../controller/detail_restaurants_vone_controller.dart';
import '../models/listnamemarket_item_model.dart';

// ignore_for_file: must_be_immutable
class ListnamemarketItemWidget extends StatelessWidget {
  ListnamemarketItemWidget(this.listnamemarketItemModelObj, {Key? key})
    : super(key: key);

  ListnamemarketItemModel listnamemarketItemModelObj;

  var controller = Get.find<DetailRestaurantsVoneController>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 144.h,
      child: Column(
        spacing: 4,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(
            () => CustomImageView(
              imagePath: listnamemarketItemModelObj.image!.value,
              height: 146.h,
              width: 144.h,
              radius: BorderRadius.circular(14.h),
            ),
          ),
          SizedBox(
            width: 120.h,
            child: Obx(
              () => Text(
                listnamemarketItemModelObj.namemarket!.value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium,
              ),
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            child: Row(
              children: [
                Obx(
                  () => Text(
                    listnamemarketItemModelObj.price!.value,
                    style: CustomTextStyles.labelLargeTeal700_2,
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
                      listnamemarketItemModelObj.infoone!.value,
                      style: theme.textTheme.labelLarge,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
