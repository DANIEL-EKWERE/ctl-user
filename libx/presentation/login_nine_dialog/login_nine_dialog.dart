// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'controller/login_nine_controller.dart';

// ignore_for_file: must_be_immutable
class LoginNineDialog extends StatelessWidget {
  LoginNineDialog(this.controller, {Key? key}) : super(key: key);

  LoginNineController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 30.h, vertical: 24.h),
          decoration: AppDecoration.neutral00.copyWith(
            borderRadius: BorderRadiusStyle.roundedBorder14,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgCheckmarkTeal400,
                height: 40.h,
                width: 42.h,
              ),
              SizedBox(height: 8.h),
              Text(
                "msg_you_ordered_successfully".tr,
                style: theme.textTheme.titleMedium,
              ),
              SizedBox(height: 6.h),
              Text(
                "msg_you_successfully".tr,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: theme.textTheme.labelLarge!.copyWith(height: 1.67),
              ),
              SizedBox(height: 12.h),
              Text(
                "lbl_keep_browsing".tr,
                style: CustomTextStyles.titleSmallPrimary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
