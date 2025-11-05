// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';
import 'controller/filter_price_controller.dart';
import 'models/filter_price_model.dart';

// ignore_for_file: must_be_immutable
class FilterPricePage extends StatelessWidget {
  FilterPricePage({Key? key}) : super(key: key);

  FilterPriceController controller = Get.put(
    FilterPriceController(FilterPriceModel().obs),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: SafeArea(child: _buildScrollview()),
    );
  }

  /// Section Widget
  Widget _buildScrollview() {
    return SingleChildScrollView(
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(horizontal: 34.h, vertical: 12.h),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: 12.h),
            SizedBox(
              width: double.maxFinite,
              child: Column(
                spacing: 20,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "msg_max_delivery_fee".tr,
                      style: CustomTextStyles.titleSmallBold,
                    ),
                  ),
                  Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.h,
                      vertical: 10.h,
                    ),
                    decoration: AppDecoration.fs42Cardlist.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder14,
                    ),
                    child: Column(
                      spacing: 10,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 4.h),
                        SizedBox(
                          width: double.maxFinite,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "lbl_5_00".tr,
                                style: theme.textTheme.bodyLarge,
                              ),
                              Text(
                                "lbl_10_00".tr,
                                style: theme.textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: double.maxFinite,
                          child: SliderTheme(
                            data: SliderThemeData(
                              trackShape: RoundedRectSliderTrackShape(),
                              activeTrackColor: theme.colorScheme.primary,
                              inactiveTrackColor: appTheme.blueGray50,
                              thumbColor: theme.colorScheme.primary,
                              thumbShape: RoundSliderThumbShape(),
                            ),
                            child: Slider(
                              value: 63.1,
                              min: 0.0,
                              max: 100.0,
                              onChanged: (value) {},
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomElevatedButton(text: "lbl_complete".tr),
                  Container(
                    height: 5.h,
                    width: 40.h,
                    decoration: BoxDecoration(
                      color: appTheme.black900.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(2.h),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
