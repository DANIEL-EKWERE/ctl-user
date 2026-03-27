// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../controller/login_six_controller.dart';
import '../models/login_six_one_item_model.dart';

// ignore_for_file: must_be_immutable
class LoginSixOneItemWidget extends StatelessWidget {
  LoginSixOneItemWidget(this.loginSixOneItemModelObj, {Key? key})
    : super(key: key);

  LoginSixOneItemModel loginSixOneItemModelObj;

  var controller = Get.find<LoginSixController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42.h,
      height: 42.h,
      alignment: Alignment.center,
      decoration: AppDecoration.outlineGray.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder14,
      ),
      child: Obx(
        () => Text(
          loginSixOneItemModelObj.frame!.value,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium,
        ),
      ),
    );
  }
}
