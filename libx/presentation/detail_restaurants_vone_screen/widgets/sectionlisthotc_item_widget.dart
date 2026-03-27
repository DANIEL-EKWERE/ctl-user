// TODO Implement this library.
import '../models/cat_prod.dart';
import '../models/model.dart';
import '../../login_three_screen/models/model.dart';
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../controller/detail_restaurants_vone_controller.dart';
import '../models/sectionlisthotc_item_model.dart';

// ignore_for_file: must_be_immutable
class SectionlisthotcItemWidget extends StatelessWidget {
  SectionlisthotcItemWidget(this.sectionlisthotcItemModelObj, {Key? key})
    : super(key: key);

  CatProductItems sectionlisthotcItemModelObj;

  var controller = Get.find<DetailRestaurantsVoneController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        CustomImageView(
          imagePath: sectionlisthotcItemModelObj.imageUrl != null
              ? sectionlisthotcItemModelObj.imageUrl!
              : ImageConstant.imgImportImage80x80,
          height: 80.h,
          width: 80.h,
          radius: BorderRadius.circular(14.h),
        ),
        Expanded(
          child: Column(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: double.maxFinite,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 156.h,
                      child:
                          // Obx(
                          //   () =>
                          Text(
                            sectionlisthotcItemModelObj.product!.name!,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium,
                          ),
                      // ),
                    ),
                    // Obx(
                    //   () =>
                    // CustomImageView(
                    //   imagePath: ImageConstant.imgImportImage80x80,
                    //   height: 24.h,
                    //   width: 26.h,
                    // ),
                    // ),
                  ],
                ),
              ),
              SizedBox(
                width: double.maxFinite,
                child: Row(
                  children: [
                    // Obx(
                    //   () =>
                    Text(
                      "\u20A6${sectionlisthotcItemModelObj.finalPrice}",
                      style: CustomTextStyles.labelLargePrimary,
                      // ),
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
                          // Obx(
                          //   () =>
                          Text(
                            sectionlisthotcItemModelObj.pack != null
                                ? sectionlisthotcItemModelObj.pack!.name!
                                : 'Unknown Unit',

                            // sectionlisthotcItemModelObj.pack != null
                            //     ? sectionlisthotcItemModelObj.pack!.name!
                            style: theme.textTheme.labelLarge,
                          ),
                      // ),
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
