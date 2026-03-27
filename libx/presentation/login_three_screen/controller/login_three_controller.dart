// TODO Implement this library.
import '../../../data/apiClient/apiClient.dart';
import '../../../data/model/selectionPopupModel/selection_popup_model.dart';
import '../../best_partners_vone_bottomsheet/best_partners_vone_bottomsheet.dart';
import '../../best_partners_vone_bottomsheet/controller/best_partners_vone_controller.dart';
import '../../best_partners_vtwo_bottomsheet/best_partners_vtwo_bottomsheet.dart';
import '../../best_partners_vtwo_bottomsheet/controller/best_partners_vtwo_controller.dart';
import '../models/category_model.dart';
import '../models/model.dart';
import '../models/vendors_by_category.dart';
import 'package:flutter/material.dart';
import 'package:overlay_kit/overlay_kit.dart';
import '../../../core/app_export.dart';
import '../models/login_three_initial_model.dart';
import '../models/login_three_model.dart';
import 'dart:developer' as myLog;

/// A controller class for the LoginThreeScreen.
///
/// This class manages the state of the LoginThreeScreen, including the
/// current loginThreeModelObj
class LoginThreeController extends GetxController {
  Rx<LoginThreeModel> loginThreeModelObj = LoginThreeModel().obs;

  ApiClient apiClient = ApiClient(Duration(seconds: 60 * 5));

  Rx<bool> isLoading = false.obs;

  Rx<bool> isLoading1 = false.obs;

  NearbyVendors? nearbyVendors;
  List<Vendor>? vendorData = [];

  VendorsByCategory? vendorsByCategory;
  List<VendorsByCategoryItem>? vendorsByCategoryItem = [];

  IndustryType? industryType;
  List<IndustryTypeItem>? industryTypeItem = [];

  Rx<LoginThreeInitialModel> loginThreeInitialModelObj =
      LoginThreeInitialModel().obs;

  SelectionPopupModel? selectedDropDownValue;

  onSelected(dynamic value) {
    for (var element
        in loginThreeInitialModelObj.value.dropdownItemList.value) {
      element.isSelected = false;
      if (element.id == value.id) {
        element.isSelected = true;
      }
    }
    loginThreeInitialModelObj.value.dropdownItemList.refresh();
  }

  void fetchNearByVendor() async {
    isLoading.value = true;
    try {
      var response = await apiClient.fetchNearbyVendors();
      if (response.statusCode == 200) {
        isLoading.value = false;
        var nearbyVendors = nearbyVendorslFromJson(response.body ?? '{}');
        vendorData = nearbyVendors.data;
      } else {
        isLoading.value = false;
        debugPrint("Failed to fetch nearby vendors: ${response.statusCode}");
      }
      //var nearbyVendors = nearbyVendorslFromJson(response.bodyString ?? '{}');
      isLoading.value = false;
      debugPrint("Nearby vendors fetched: ${vendorData?.length ?? 0}");
    } catch (e) {
      isLoading.value = false;
      debugPrint("Error fetching nearby vendors: $e");
    }
  }

  void fetchCategory() async {
    isLoading1.value = true;
    try {
      var response = await apiClient.fetchCategory();
      if (response.statusCode == 200) {
        isLoading1.value = false;
        var industryType = industryTypeFromJson(response.body ?? '{}');
        industryTypeItem = industryType.data;
      } else {
        isLoading1.value = false;
        debugPrint("Failed to fetch category: ${response.statusCode}");
      }
      //var nearbyVendors = nearbyVendorslFromJson(response.bodyString ?? '{}');
      isLoading1.value = false;
      debugPrint("Category fetched: ${industryTypeItem?.length ?? 0}");
    } catch (e) {
      isLoading1.value = false;
      debugPrint("Error fetching category: $e");
    }
  }

  void fetchVendorByCategory(String type, String name) async {
    myLog.log('Fetching vendors for category: $type');
    OverlayLoadingProgress.start(circularProgressColor: Color(0xFF004BFD));

    try {
      var response = await apiClient.fetchVendorByCategory(type);
      if (response.statusCode == 200) {
        OverlayLoadingProgress.stop();
        nearbyVendors = nearbyVendorslFromJson(response.body);
        //  vendorsByCategory = vendorsByCategoryFromJson(
        //   response.body ?? '{}',
        // );
        vendorData = nearbyVendors!.data;
        // Get.dialog(
        //   AlertDialog(
        //     contentPadding: EdgeInsets.zero,
        //     title: Text("Vendors in $type"),
        //     content: SizedBox(
        //       width: double.infinity,
        //       height: double.maxFinite,
        //       child: BestPartnersVoneBottomsheet(BestPartnersVoneController()),
        //     ),
        //     // Container(
        //     //   width: double.maxFinite,
        //     //   child: ListView.builder(
        //     //     shrinkWrap: true,
        //     //     itemCount: vendorsByCategoryItem?.length ?? 0,
        //     //     itemBuilder: (context, index) {
        //     //       var vendor = vendorsByCategoryItem![index];
        //     //       return ListTile(
        //     //         title: Text(vendor.name ?? 'No Name'),
        //     //         subtitle: Text(vendor.description ?? 'No Description'),
        //     //       );
        //     //     },
        //     //   ),
        //     // ),
        //     actions: [
        //       TextButton(onPressed: () => Get.back(), child: Text("Close")),
        //     ],
        //   ),
        // );
        showModalBottomSheet(
          showDragHandle: true,
          isScrollControlled: true,

          context: Get.context!,
          builder: (context) {
            return BestPartnersVoneBottomsheet(
              BestPartnersVoneController(),
              name,
            );
          },
        );
      } else {
        OverlayLoadingProgress.stop();
        debugPrint("Failed to fetch category: ${response.statusCode}");
      }
      //var nearbyVendors = nearbyVendorslFromJson(response.bodyString ?? '{}');
      OverlayLoadingProgress.stop();
      debugPrint("Category fetched: ${vendorsByCategoryItem?.length ?? 0}");
    } catch (e) {
      OverlayLoadingProgress.stop();
      debugPrint("Error fetching category: $e");
    }
  }
}
