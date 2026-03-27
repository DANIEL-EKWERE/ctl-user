// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'controller/payment_methods_card_controller.dart';
import 'models/listplaceholder_item_model.dart';
import 'widgets/listplaceholder_item_widget.dart';

// ignore_for_file: must_be_immutable
class PaymentMethodsCardBottomsheet extends StatelessWidget {
  PaymentMethodsCardBottomsheet(this.controller, {Key? key}) : super(key: key);

  PaymentMethodsCardController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: AppDecoration.neutral00.copyWith(
        borderRadius: BorderRadiusStyle.customBorderTL30,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
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
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 34.h),
              child: Text(
                "lbl_credit_cards".tr,
                style: CustomTextStyles.titleSmallBold,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.maxFinite,
            child: Divider(indent: 34.h, endIndent: 34.h),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 34.h),
              child: Obx(
                () => ListView.separated(
                  padding: EdgeInsets.zero,
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 16.h);
                  },
                  itemCount:
                      controller
                          .paymentMethodsCardModelObj
                          .value
                          .listplaceholderItemList
                          .value
                          .length,
                  itemBuilder: (context, index) {
                    ListplaceholderItemModel model =
                        controller
                            .paymentMethodsCardModelObj
                            .value
                            .listplaceholderItemList
                            .value[index];
                    return ListplaceholderItemWidget(model);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
