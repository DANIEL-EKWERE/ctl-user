// TODO Implement this library.
import 'package:ctluser/presentation/detail_restaurants_vone_screen/models/promotionModel.dart';
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../controller/detail_restaurants_vone_controller.dart';
import '../models/listnamemarket_item_model.dart';

// ignore_for_file: must_be_immutable
class ListnamemarketItemWidget extends StatelessWidget {
  ListnamemarketItemWidget(this.listnamemarketItemModelObj, {Key? key})
    : super(key: key);

  PromotionItem listnamemarketItemModelObj;

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
          // Obx(
          //   () =>
          CustomImageView(
            imagePath:
                listnamemarketItemModelObj.imageUrl ??
                ImageConstant.imgImportImage80x80,
            height: 146.h,
            width: 144.h,
            radius: BorderRadius.circular(14.h),
            // ),
          ),
          SizedBox(
            width: 120.h,
            child:
            // Obx(
            //   () =>
            Text(
              listnamemarketItemModelObj.title!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium,
            ),
            // ),
          ),
          SizedBox(
            width: double.maxFinite,
            child: Row(
              children: [
                // Obx(
                //   () =>
                Text(
                  listnamemarketItemModelObj.discount.toString(),
                  style: CustomTextStyles.labelLargeTeal700_2,
                  //),
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
                  child:
                  //  Obx(
                  //   () =>
                  Text(
                    listnamemarketItemModelObj.typeLabel!.length > 15
                        ? "${listnamemarketItemModelObj.typeLabel!.substring(0, 13)}..."
                        : listnamemarketItemModelObj.typeLabel!,
                    style: theme.textTheme.labelLarge,
                    //   ),
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
