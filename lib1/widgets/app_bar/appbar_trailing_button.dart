import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../custom_elevated_button.dart';

class AppbarTrailingButton extends StatelessWidget {
  AppbarTrailingButton({Key? key, this.onTap, this.margin}) : super(key: key);

  final Function? onTap;

  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: GestureDetector(
        onTap: () {
          onTap?.call();
        },
        child: CustomElevatedButton(
          height: 40.h,
          width: 80.h,
          text: "lbl_filter".tr,
          leftIcon: Container(
            margin: EdgeInsets.only(right: 4.h),
            child: CustomImageView(
              imagePath: ImageConstant.imgUser,
              height: 24.h,
              width: 24.h,
              fit: BoxFit.contain,
            ),
          ),
          buttonStyle: CustomButtonStyles.fillGray,
          buttonTextStyle: CustomTextStyles.labelLargeBluegray900_1,
        ),
      ),
    );
  }
}
