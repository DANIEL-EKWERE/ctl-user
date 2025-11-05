// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../controller/card_list_controller.dart';
import '../models/items_item_model.dart';

// ignore_for_file: must_be_immutable
class ItemsItemWidget extends StatelessWidget {
  ItemsItemWidget(this.itemsItemModelObj, {Key? key}) : super(key: key);

  ItemsItemModel itemsItemModelObj;

  var controller = Get.find<CardListController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.h),
      decoration: AppDecoration.neutral00.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder14,
      ),
      child: Row(
        children: [
          Obx(
            () => CustomImageView(
              imagePath: itemsItemModelObj.visaOne!.value,
              height: 32.h,
              width: 32.h,
              radius: BorderRadius.circular(16.h),
            ),
          ),
          Expanded(
            child: Column(
              spacing: 2,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 12.h),
                  child: Obx(
                    () => Text(
                      itemsItemModelObj.placeholder!.value,
                      style: theme.textTheme.titleSmall,
                    ),
                  ),
                ),
                CustomTextFormField(
                  width: 280.h,
                  controller: itemsItemModelObj.placeholderoneController,
                  hintText: "msg_enter_information".tr,
                  contentPadding: EdgeInsets.all(12.h),
                  borderDecoration: TextFormFieldStyleHelper.custom,
                  filled: false,
                ),
              ],
            ),
          ),
          CustomImageView(
            imagePath: ImageConstant.imgArrowLeftGray400,
            height: 24.h,
            width: 24.h,
            radius: BorderRadius.circular(12.h),
            margin: EdgeInsets.only(left: 12.h),
          ),
        ],
      ),
    );
  }
}
