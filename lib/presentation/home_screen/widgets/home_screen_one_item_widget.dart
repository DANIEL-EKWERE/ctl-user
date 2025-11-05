// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../controller/home_controller.dart';
import '../models/home_screen_one_item_model.dart';

// ignore_for_file: must_be_immutable
class HomeScreenOneItemWidget extends StatelessWidget {
  HomeScreenOneItemWidget(this.homeScreenOneItemModelObj, {Key? key})
    : super(key: key);

  HomeScreenOneItemModel homeScreenOneItemModelObj;

  var controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 10.h),
      child: Row(
        children: [
          Obx(
            () => CustomImageView(
              imagePath: homeScreenOneItemModelObj.image!.value,
              height: 42.h,
              width: 42.h,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Text(
                    homeScreenOneItemModelObj.prismar!.value,
                    style: CustomTextStyles.titleSmallNexaTextTrialGray90002,
                  ),
                ),
                Obx(
                  () => Text(
                    homeScreenOneItemModelObj.afahaoffot!.value,
                    style: CustomTextStyles.bodyMediumPoppinsGray800,
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
