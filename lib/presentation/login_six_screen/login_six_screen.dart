// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'controller/login_six_controller.dart';
import 'models/login_six_one_item_model.dart';
import 'widgets/login_six_one_item_widget.dart'; // ignore_for_file: must_be_immutable

class LoginSixScreen extends GetWidget<LoginSixController> {
  const LoginSixScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.gray100,
      body: SafeArea(
        child: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsets.only(top: 12.h),
              decoration: AppDecoration.neutral00.copyWith(
                borderRadius: BorderRadiusStyle.customBorderTL30,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 4.h,
                    width: 42.h,
                    decoration: BoxDecoration(
                      color: appTheme.black900.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(2.h),
                    ),
                  ),
                  SizedBox(height: 36.h),
                  Text(
                    "msg_extreme_cheese_whopper".tr,
                    style: CustomTextStyles.titleLarge21,
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    "msg_a_signature_flame_grilled".tr,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelLarge!.copyWith(height: 1.67),
                  ),
                  SizedBox(height: 30.h),
                  _buildStackpngwingtwo(),
                  SizedBox(height: 30.h),
                  _buildLoginsixone(),
                  SizedBox(height: 60.h),
                  SizedBox(
                    width: 162.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              controller.incrementQuantity();
                            },
                            child: Container(
                              height: 42.h,
                              decoration: AppDecoration.fillPrimary.copyWith(
                                borderRadius: BorderRadiusStyle.circleBorder20,
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  CustomImageView(
                                    imagePath: ImageConstant.imgPlus,
                                    height: 14.h,
                                    width: 16.h,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: CustomTextFormField(
                            readOnly: true,
                            controller: controller.lblQuantity,
                            hintText: "lbl_22".tr,
                            hintStyle: theme.textTheme.titleMedium!,
                            textInputAction: TextInputAction.done,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.h,
                              vertical: 10.h,
                            ),
                            borderDecoration:
                                TextFormFieldStyleHelper.fillOnPrimary,
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              controller.decrementQuantity();
                            },
                            child: Container(
                              height: 42.h,
                              padding: EdgeInsets.only(bottom: 18.h),
                              decoration: AppDecoration.fillPrimary.copyWith(
                                borderRadius: BorderRadiusStyle.circleBorder20,
                              ),
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  CustomImageView(
                                    imagePath: ImageConstant.imgIcon,
                                    height: 2.h,
                                    width: 16.h,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 106.h),
                  _buildRownamemarket(),
                  SizedBox(height: 22.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildStackpngwingtwo() {
    return SizedBox(
      height: 260.h,
      width: double.maxFinite,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgPngwing2,
            height: 206.h,
            width: 46.h,
            alignment: Alignment.bottomRight,
            margin: EdgeInsets.only(bottom: 10.h),
          ),
          CustomImageView(
            imagePath: ImageConstant.imgPngwing3,
            height: 206.h,
            width: 42.h,
            alignment: Alignment.bottomLeft,
            margin: EdgeInsets.only(bottom: 4.h),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 24.h,
              width: 284.h,
              decoration: BoxDecoration(
                color: appTheme.gray40001,
                borderRadius: BorderRadius.circular(142.h),
              ),
            ),
          ),
          CustomImageView(
            imagePath: ImageConstant.imgPngwing1,
            height: 256.h,
            width: 326.h,
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildLoginsixone() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 98.h),
      width: double.maxFinite,
      child: Obx(
        () => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Wrap(
            direction: Axis.horizontal,
            spacing: 32.h,
            children: List.generate(
              controller
                  .loginSixModelObj
                  .value
                  .loginSixOneItemList
                  .value
                  .length,
              (index) {
                LoginSixOneItemModel model =
                    controller
                        .loginSixModelObj
                        .value
                        .loginSixOneItemList
                        .value[index];
                return LoginSixOneItemWidget(model);
              },
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildRownamemarket() {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 34.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10.h),
                child: Text("lbl_price".tr, style: theme.textTheme.titleMedium),
              ),
              Text("lbl_5_99".tr, style: CustomTextStyles.titleLargePrimary),
            ],
          ),
          CustomElevatedButton(
            height: 46.h,
            width: 194.h,
            text: "lbl_add_to_order".tr,
            buttonTextStyle: CustomTextStyles.titleSmallOnPrimary_2,
          ),
        ],
      ),
    );
  }
}
