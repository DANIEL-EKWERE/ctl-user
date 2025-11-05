// TODO Implement this library.
import 'package:ctluser/presentation/profile_page/controller/proflle_controller.dart';
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/listaccount_item_model.dart';

// ignore_for_file: must_be_immutable
class ListaccountItemWidget extends StatelessWidget {
  ListaccountItemWidget(this.listaccountItemModelObj, {Key? key})
    : super(key: key);

  ListaccountItemModel listaccountItemModelObj;

  var controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadiusStyle.roundedBorder14,
      ),
      child: Row(
        children: [
          Obx(
            () => CustomImageView(
              imagePath: listaccountItemModelObj.account!.value,
              height: 24.h,
              width: 24.h,
            ),
          ),
          Expanded(
            child: Column(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Text(
                    listaccountItemModelObj.placeholder!.value,
                    style: theme.textTheme.titleSmall,
                  ),
                ),
                Obx(
                  () => Text(
                    listaccountItemModelObj.placeholderOne!.value,
                    style: theme.textTheme.labelLarge,
                  ),
                ),
              ],
            ),
          ),
          CustomImageView(
            imagePath: ImageConstant.imgArrowLeftGray400,
            height: 24.h,
            width: 24.h,
          ),
        ],
      ),
    );
  }
}
