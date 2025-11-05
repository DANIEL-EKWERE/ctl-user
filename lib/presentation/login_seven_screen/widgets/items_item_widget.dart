// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../controller/login_seven_controller.dart';
import '../models/items_item_model.dart';

// ignore_for_file: must_be_immutable
class ItemsItemWidget extends StatelessWidget {
  ItemsItemWidget(this.itemsItemModelObj, {Key? key}) : super(key: key);

  ItemsItemModel itemsItemModelObj;

  var controller = Get.find<LoginSevenController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 2.h),
      child: Row(
        children: [
          Container(
            height: 82.h,
            width: 82.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadiusStyle.roundedBorder14,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Obx(
                  () => CustomImageView(
                    imagePath: itemsItemModelObj.imageOne!.value,
                    height: 50.h,
                    width: 64.h,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              spacing: 8,
              children: [
                Obx(
                  () => Text(
                    itemsItemModelObj.name!.value,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    children: [
                      Container(
                        width: 92.h,
                        padding: EdgeInsets.all(4.h),
                        decoration: AppDecoration.fs42Cardlist.copyWith(
                          borderRadius: BorderRadiusStyle.roundedBorder8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.decrementQuantity(
                                    itemsItemModelObj,
                                  );
                                },
                                child: Container(
                                  height: 24.h,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      CustomImageView(
                                        imagePath: ImageConstant.imgUserGray400,
                                        height: 24.h,
                                        width: 24.h,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Obx(
                              () => Text(
                                (itemsItemModelObj.lblQuantity!.value)
                                    .toString(),
                                style: CustomTextStyles.labelLargeBluegray900_2,
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.incrementQuantity(
                                    itemsItemModelObj,
                                  );
                                },
                                child: Container(
                                  height: 24.h,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      CustomImageView(
                                        imagePath: ImageConstant.imgIconL,
                                        height: 24.h,
                                        width: 24.h,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16.h),
                        child: Obx(
                          () => Text(
                            itemsItemModelObj.price!.value,
                            style: CustomTextStyles.labelLargePrimary_3,
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
      ),
    );
  }
}
