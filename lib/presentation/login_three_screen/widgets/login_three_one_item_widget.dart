// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../controller/login_three_controller.dart';
import '../models/login_three_one_item_model.dart';

// ignore_for_file: must_be_immutable
class LoginThreeOneItemWidget extends StatelessWidget {
  LoginThreeOneItemWidget(this.loginThreeOneItemModelObj, {Key? key})
    : super(key: key);

  LoginThreeOneItemModel loginThreeOneItemModelObj;

  var controller = Get.find<LoginThreeController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.h,
      padding: EdgeInsets.all(14.h),
      decoration: AppDecoration.fillPrimaryContainer.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder5,
      ),
      child: Column(
        spacing: 2,
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(
            () => CustomImageView(
              imagePath: loginThreeOneItemModelObj.restaurantsOne!.value,
              height: 16.h,
              width: 42.h,
            ),
          ),
          Obx(
            () => Text(
              loginThreeOneItemModelObj.hanoivietnam!.value,
              overflow: TextOverflow.ellipsis,
              style: CustomTextStyles.bodySmall11,
            ),
          ),
        ],
      ),
    );
  }
}
