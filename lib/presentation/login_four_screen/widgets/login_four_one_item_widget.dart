// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../controller/login_four_controller.dart';
import '../models/login_four_one_item_model.dart';

// ignore_for_file: must_be_immutable
class LoginFourOneItemWidget extends StatelessWidget {
  LoginFourOneItemWidget(this.loginFourOneItemModelObj, {Key? key})
    : super(key: key);

  LoginFourOneItemModel loginFourOneItemModelObj;

  var controller = Get.find<LoginFourController>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150.h,
      child: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: 150.h,
          child: Column(
            spacing: 6,
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgImportImage152x150,
                height: 152.h,
                width: 150.h,
                radius: BorderRadius.circular(14.h),
              ),
              SizedBox(
                width: double.maxFinite,
                child: Obx(
                  () => Text(
                    loginFourOneItemModelObj.namemarket!.value,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
