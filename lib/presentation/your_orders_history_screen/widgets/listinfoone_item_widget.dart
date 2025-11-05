// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../theme/custom_button_style.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../controller/your_orders_history_controller.dart';
import '../models/listinfoone_item_model.dart';

// ignore_for_file: must_be_immutable
class ListinfooneItemWidget extends StatelessWidget {
  ListinfooneItemWidget(this.listinfooneItemModelObj, {Key? key})
    : super(key: key);

  ListinfooneItemModel listinfooneItemModelObj;

  var controller = Get.find<YourOrdersHistoryController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 14.h),
      decoration: AppDecoration.neutral00.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder14,
      ),
      child: Column(
        spacing: 16,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(
                  () => Text(
                    listinfooneItemModelObj.infoone!.value,
                    style: theme.textTheme.labelLarge,
                  ),
                ),
                Container(
                  height: 12.h,
                  width: 1.h,
                  margin: EdgeInsets.only(left: 12.h),
                  decoration: BoxDecoration(
                    color: appTheme.gray100,
                    borderRadius: BorderRadius.circular(1.h),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12.h),
                  child: Obx(
                    () => Text(
                      listinfooneItemModelObj.infothree!.value,
                      style: CustomTextStyles.labelLargeTeal700_2,
                    ),
                  ),
                ),
                Spacer(),
                Obx(
                  () => Text(
                    listinfooneItemModelObj.duration!.value,
                    style: theme.textTheme.labelLarge,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: double.maxFinite, child: Divider(endIndent: 6.h)),
          SizedBox(
            width: double.maxFinite,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => CustomImageView(
                    imagePath: listinfooneItemModelObj.drinkOne!.value,
                    height: 80.h,
                    width: 80.h,
                    radius: BorderRadius.circular(14.h),
                    alignment: Alignment.center,
                  ),
                ),
                Expanded(
                  child: Column(
                    spacing: 2,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.maxFinite,
                        child: Row(
                          children: [
                            Obx(
                              () => Text(
                                listinfooneItemModelObj.namemarket!.value,
                                style: theme.textTheme.titleMedium,
                              ),
                            ),
                            CustomImageView(
                              imagePath: ImageConstant.imgCheckmarkTeal700,
                              height: 24.h,
                              width: 24.h,
                              margin: EdgeInsets.only(left: 2.h),
                            ),
                          ],
                        ),
                      ),
                      Obx(
                        () => Text(
                          listinfooneItemModelObj.infooneOne!.value,
                          style: theme.textTheme.labelLarge,
                        ),
                      ),
                      SizedBox(
                        width: double.maxFinite,
                        child: Row(
                          children: [
                            Obx(
                              () => Text(
                                listinfooneItemModelObj.price!.value,
                                style: CustomTextStyles.labelLargePrimary_1,
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
                                  listinfooneItemModelObj.itemsCounter!.value,
                                  style: theme.textTheme.labelLarge,
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
          ),
          SizedBox(
            width: double.maxFinite,
            child: Row(children: [_buildRate(), _buildReorder()]),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildRate() {
    return Expanded(
      child: CustomElevatedButton(
        text: "lbl_rate".tr,
        buttonStyle: CustomButtonStyles.fillBlueGray,
        buttonTextStyle: theme.textTheme.titleSmall!,
      ),
    );
  }

  /// Section Widget
  Widget _buildReorder() {
    return Expanded(child: CustomElevatedButton(text: "lbl_re_order".tr));
  }
}
