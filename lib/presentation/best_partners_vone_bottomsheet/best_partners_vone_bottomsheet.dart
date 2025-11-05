// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'controller/best_partners_vone_controller.dart';

// ignore_for_file: must_be_immutable
class BestPartnersVoneBottomsheet extends StatelessWidget {
  BestPartnersVoneBottomsheet(this.controller, {Key? key}) : super(key: key);

  BestPartnersVoneController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: AppDecoration.outlineGray100,
      child: Column(
        spacing: 18,
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
          Text("lbl_best_partners".tr, style: CustomTextStyles.titleMediumBold),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
