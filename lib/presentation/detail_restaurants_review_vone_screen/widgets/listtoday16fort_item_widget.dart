// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_rating_bar.dart';
import '../controller/detail_restaurants_review_vone_controller.dart';
import '../models/listtoday16fort_item_model.dart';

// ignore_for_file: must_be_immutable
class Listtoday16fortItemWidget extends StatelessWidget {
  Listtoday16fortItemWidget(this.listtoday16fortItemModelObj, {Key? key})
    : super(key: key);

  Listtoday16fortItemModel listtoday16fortItemModelObj;

  var controller = Get.find<DetailRestaurantsReviewVoneController>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        children: [
          SizedBox(
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(
                  () => CustomImageView(
                    imagePath: listtoday16fortItemModelObj.today16forty!.value,
                    height: 40.h,
                    width: 40.h,
                    radius: BorderRadius.circular(20.h),
                  ),
                ),
                Expanded(
                  child: Column(
                    spacing: 6,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => Text(
                          listtoday16fortItemModelObj.name!.value,
                          style: theme.textTheme.titleSmall,
                        ),
                      ),
                      CustomRatingBar(ignoreGestures: true, initialRating: 0),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Obx(
                    () => Text(
                      listtoday16fortItemModelObj.duration!.value,
                      style: theme.textTheme.labelLarge,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Obx(
            () => Text(
              listtoday16fortItemModelObj.whatcanisayitsf!.value,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall!.copyWith(height: 1.67),
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      CustomImageView(
                        imagePath: ImageConstant.imgFavorite,
                        height: 12.h,
                        width: 14.h,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 6.h),
                        child: Obx(
                          () => Text(
                            listtoday16fortItemModelObj.likesCounter!.value,
                            style: CustomTextStyles.labelLargePrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgFlag01,
                  height: 14.h,
                  width: 14.h,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
