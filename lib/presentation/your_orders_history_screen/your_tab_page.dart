// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'controller/your_orders_history_controller.dart';
import 'models/listinfoone_item_model.dart';
import 'models/your_tab_model.dart';
import 'widgets/listinfoone_item_widget.dart';

// ignore_for_file: must_be_immutable
class YourTabPage extends StatelessWidget {
  YourTabPage({Key? key}) : super(key: key);

  YourOrdersHistoryController controller = Get.put(
    YourOrdersHistoryController(),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(children: [SizedBox(height: 16.h), _buildListinfoone()]),
    );
  }

  /// Section Widget
  Widget _buildListinfoone() {
    return Expanded(
      child: Obx(
        () => ListView.separated(
          padding: EdgeInsets.zero,
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          separatorBuilder: (context, index) {
            return SizedBox(height: 16.h);
          },
          itemCount:
              controller.yourTabModelObj.value.listinfooneItemList.value.length,
          itemBuilder: (context, index) {
            ListinfooneItemModel model =
                controller
                    .yourTabModelObj
                    .value
                    .listinfooneItemList
                    .value[index];
            return ListinfooneItemWidget(model);
          },
        ),
      ),
    );
  }
}
