// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';
import 'controller/payment_methods_controller.dart';

// ignore_for_file: must_be_immutable
class PaymentMethodsBottomsheet extends StatelessWidget {
  PaymentMethodsBottomsheet(this.controller, {Key? key}) : super(key: key);

  PaymentMethodsController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: AppDecoration.neutral00.copyWith(
        borderRadius: BorderRadiusStyle.customBorderTL30,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 5.h,
            width: 40.h,
            decoration: BoxDecoration(
              color: appTheme.black900.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(2.h),
            ),
          ),
          SizedBox(height: 22.h),
          Text(
            "lbl_payment_methods".tr,
            style: CustomTextStyles.titleMediumBold,
          ),
          SizedBox(height: 22.h),
          SizedBox(width: double.maxFinite, child: Divider()),
          SizedBox(height: 38.h),
          Container(
            height: 70.h,
            width: 82.h,
            decoration: AppDecoration.yellow50.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder14,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.img,
                  height: 46.h,
                  width: 34.h,
                ),
              ],
            ),
          ),
          SizedBox(height: 50.h),
          Text(
            "msg_don_t_have_any_card".tr,
            style: CustomTextStyles.headlineSmallDMSansBluegray900,
          ),
          SizedBox(height: 6.h),
          SizedBox(
            width: double.maxFinite,
            child: Text(
              "msg_it_looks_like_you".tr,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: CustomTextStyles.bodyMediumBluegray400_2.copyWith(
                height: 1.71,
              ),
            ),
          ),
          SizedBox(height: 36.h),
          CustomElevatedButton(
            text: "lbl_add_cards".tr,
            margin: EdgeInsets.symmetric(horizontal: 34.h),
          ),
        ],
      ),
    );
  }
}
