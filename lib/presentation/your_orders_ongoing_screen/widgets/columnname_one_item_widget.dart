// TODO Implement this library.
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:timelines_plus/timelines_plus.dart';
import '../../../core/app_export.dart';
import '../../../theme/custom_button_style.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/custom_icon_button.dart';
import '../../login_five_page/login_five_page.dart';
import '../../profile_page/profile_page.dart';
import '../controller/your_orders_ongoing_controller.dart';
import '../models/timelineclose_item_model.dart';
import 'stackclose_one_item_widget.dart';

// ignore_for_file: must_be_immutable
class ColumnnameOneItemWidget extends StatelessWidget {
  ColumnnameOneItemWidget(this.timelinecloseItemModelObj, {Key? key})
    : super(key: key);

  TimelinecloseItemModel timelinecloseItemModelObj;

  var controller = Get.find<YourOrdersOngoingController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(left: 8.h, top: 2.h, bottom: 22.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 222.h,
            child: Obx(
              () => Text(
                timelinecloseItemModelObj.nameOne!.value,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall,
              ),
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            child: Row(
              children: [
                Obx(
                  () => Text(
                    timelinecloseItemModelObj.infooneTwo!.value,
                    style: theme.textTheme.labelLarge,
                  ),
                ),
                Container(
                  height: 4.h,
                  width: 4.h,
                  margin: EdgeInsets.only(left: 8.h),
                  decoration: BoxDecoration(
                    color: appTheme.gray400,
                    borderRadius: BorderRadius.circular(2.h),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.h),
                  child: Obx(
                    () => Text(
                      timelinecloseItemModelObj.time!.value,
                      style: theme.textTheme.labelLarge,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
