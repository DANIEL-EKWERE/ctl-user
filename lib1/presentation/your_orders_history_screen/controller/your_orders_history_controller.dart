// TODO Implement this library.
import 'package:ctluser/data/apiClient/apiClient.dart';
import 'package:ctluser/presentation/your_orders_history_screen/models/order_model.dart';
import 'package:ctluser/presentation/your_orders_ongoing_screen/models/timelineclose_item_model.dart';
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/your_orders_history_model.dart';
import '../models/your_tab_model.dart';

/// A controller class for the YourOrdersHistoryScreen.
///
/// This class manages the state of the YourOrdersHistoryScreen, including the
/// current yourOrdersHistoryModelObj
class YourOrdersHistoryController extends GetxController
    with GetSingleTickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();

  Rx<YourOrdersHistoryModel> yourOrdersHistoryModelObj =
      YourOrdersHistoryModel().obs;

  late TabController tabviewController = Get.put(
    TabController(vsync: this, length: 2),
  );

  Rx<bool> isLoading = false.obs;

  ApiClient apiClient = ApiClient(Duration(seconds: 60 * 5));

  Rx<YourTabModel> yourTabModelObj = YourTabModel().obs;

  @override
  void onClose() {
    super.onClose();
    searchController.dispose();
  }

  Order? order;
  List<OrderItem>? orderItem;

  Rx<List<TimelinecloseItemModel>> timelinecloseItemList = Rx([
    // TimelinecloseItemModel(
    //   closeOne: ImageConstant.imgClosePrimary.obs,
    //   nameOne: "msg_burger_king_1453".tr.obs,
    //   infooneTwo: "lbl_restaurant".tr.obs,
    //   time: "lbl_13_00_pm".tr.obs,
    // ),
    // TimelinecloseItemModel(
    //   closeOne: ImageConstant.imgLinkedinPrimary.obs,
    //   nameOne: "msg_you_49th_st_los".tr.obs,
    //   infooneTwo: "lbl_home".tr.obs,
    //   time: "lbl_13_30_pm".tr.obs,
    // ),
  ]);

  void fetchOrders() async {
    isLoading.value = true;
    try {
      var response = await apiClient.fetchAllOrders();
      if (response.statusCode == 200) {
        isLoading.value = false;
        order = orderFromJson(response.body);
        orderItem = order?.data;
        timelinecloseItemList.value.addAll(
          orderItem
                  ?.map(
                    (orderItem) => TimelinecloseItemModel(
                      closeOne: ImageConstant.imgClosePrimary.obs,
                      nameOne: orderItem.customer?.firstname?.obs ?? "".obs,
                      infooneTwo: (orderItem.address?.contactAddress ?? "").obs,
                      time: orderItem.createdAt?.obs ?? "".obs,
                    ),
                  )
                  .toList() ??
              [],
        );

        timelinecloseItemList.value.addAll(
          orderItem
                  ?.map(
                    (orderItem) => TimelinecloseItemModel(
                      closeOne: ImageConstant.imgLinkedinPrimary.obs,
                      nameOne: orderItem.customer?.firstname?.obs ?? "".obs,
                      infooneTwo: (orderItem.address?.contactAddress ?? "").obs,
                      time: orderItem.createdAt?.obs ?? "".obs,
                    ),
                  )
                  .toList() ??
              [],
        );

        // orderItem
        //     ?.map(
        //       (orderItem) =>
        //     )
        //     .toList() ??
        // [];

        debugPrint("Orders fetched: ${orderItem?.length ?? 0}");
      } else {
        isLoading.value = false;
        debugPrint("Failed to fetch orders: ${response.statusCode}");
      }
      //var nearbyVendors = nearbyVendorslFromJson(response.bodyString ?? '{}');
      isLoading.value = false;
      debugPrint("Orders fetched: ${orderItem?.length ?? 0}");
    } catch (e) {
      isLoading.value = false;
      debugPrint("Error fetching orders: $e");
    }
  }
}
