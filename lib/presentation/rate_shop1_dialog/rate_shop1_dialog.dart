// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'controller/rate_shop1_controller.dart';

// ignore_for_file: must_be_immutable
class RateShop1Dialog extends StatelessWidget {
  RateShop1Dialog(this.controller, {Key? key}) : super(key: key);

  RateShop1Controller controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(vertical: 24.h),
          decoration: AppDecoration.neutral00.copyWith(
            borderRadius: BorderRadiusStyle.roundedBorder14,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgCheckmarkTeal400,
                height: 40.h,
                width: 42.h,
              ),
              SizedBox(height: 8.h),
              Text(
                "msg_you_service_feedback".tr,
                style: theme.textTheme.titleMedium,
              ),
              SizedBox(height: 6.h),
              Text("msg_thanks_for_your".tr, style: theme.textTheme.labelLarge),
              SizedBox(height: 16.h),
              Text("lbl_ok".tr, style: CustomTextStyles.titleSmallPrimaryBold),
            ],
          ),
        ),
      ],
    );
  }
}
