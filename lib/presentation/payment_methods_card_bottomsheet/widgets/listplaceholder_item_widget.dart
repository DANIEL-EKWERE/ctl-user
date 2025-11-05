import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../controller/payment_methods_card_controller.dart';
import '../models/listplaceholder_item_model.dart';

// ignore_for_file: must_be_immutable
class ListplaceholderItemWidget extends StatelessWidget {
  ListplaceholderItemWidget(this.listplaceholderItemModelObj, {Key? key})
    : super(key: key);

  ListplaceholderItemModel listplaceholderItemModelObj;

  var controller = Get.find<PaymentMethodsCardController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.h),
      decoration: AppDecoration.fs42Cardlist.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder14,
      ),
      child: Row(
        children: [
          Obx(
            () => CustomImageView(
              imagePath: listplaceholderItemModelObj.image!.value,
              height: 32.h,
              width: 32.h,
              radius: BorderRadius.circular(16.h),
            ),
          ),
          Expanded(
            child: Column(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Text(
                    listplaceholderItemModelObj.placeholder!.value,
                    style: theme.textTheme.titleSmall,
                  ),
                ),
                Obx(
                  () => Text(
                    listplaceholderItemModelObj.placeholderOne!.value,
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
            radius: BorderRadius.circular(12.h),
          ),
        ],
      ),
    );
  }
}
