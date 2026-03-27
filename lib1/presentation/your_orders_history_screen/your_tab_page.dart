// Redesigned: Chewdeck-style Completed Orders Tab
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'controller/your_orders_history_controller.dart';
import 'models/listinfoone_item_model.dart';
import 'widgets/listinfoone_item_widget.dart';

// ignore_for_file: must_be_immutable
class YourTabPage extends StatelessWidget {
  YourTabPage({Key? key}) : super(key: key);
  YourOrdersHistoryController controller = Get.put(YourOrdersHistoryController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = controller.yourTabModelObj.value.listinfooneItemList.value;
      if (items.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_outline, size: 64, color: Colors.grey[300]),
              const SizedBox(height: 16),
              const Text("No completed orders", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF333333))),
              const SizedBox(height: 8),
              Text("Your order history will appear here", style: TextStyle(fontSize: 13, color: Colors.grey[500])),
            ],
          ),
        );
      }
      return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          ListinfooneItemModel model = items[index];
          return ListinfooneItemWidget(model);
        },
      );
    });
  }
}
