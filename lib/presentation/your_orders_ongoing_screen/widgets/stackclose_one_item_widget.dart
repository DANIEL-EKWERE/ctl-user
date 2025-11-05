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

// ignore_for_file: must_be_immutable
class StackcloseOneItemWidget extends StatelessWidget {
  StackcloseOneItemWidget(this.timelinecloseItemModelObj, {Key? key})
    : super(key: key);

  TimelinecloseItemModel timelinecloseItemModelObj;

  var controller = Get.find<YourOrdersOngoingController>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24.h,
      width: 24.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Obx(
            () => CustomImageView(
              imagePath: timelinecloseItemModelObj.closeOne!.value,
              height: 24.h,
              width: 24.h,
            ),
          ),
        ],
      ),
    );
  }
}
