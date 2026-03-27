// TODO Implement this library.
import '../../../data/apiClient/apiClient.dart';
import '../models/cartModel.dart';
import '../../../utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:overlay_kit/overlay_kit.dart';
import '../../../core/app_export.dart';
import '../models/add_new_model.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';
import '../models/items_item_model.dart';
import 'dart:developer' as myLog;
import 'dart:convert';

/// A controller class for the AddNewScreen.
///
/// This class manages the state of the AddNewScreen, including the
/// current addNewModelObj
class AddNewController extends GetxController {
  Rx<AddNewModel> addNewModelObj = AddNewModel().obs;
  ApiClient apiClient = ApiClient(Duration(seconds: 60 * 5));
  Cartmodel cartModel = Cartmodel();

  List<Cartmodel> cartList = [];

  void decrementQuantity(int lblQuantity) {
    myLog.log('incoming value: $lblQuantity');
    if (lblQuantity != null) {
      if (lblQuantity! > 1) {
        myLog.log('decreasing incoming value: ${lblQuantity}');
        lblQuantity--;
        myLog.log('to: ${lblQuantity}');
      }
    }
  }

  void incrementQuantity(int itemsItemModelObj) {
    if (itemsItemModelObj != null) {
      itemsItemModelObj++;
    }
  }

  Future<void> createOrder() async {
    OverlayLoadingProgress.start(circularProgressColor: Color(0xff004BFD));
    // myLog.log(email);
    var token = await dataBase.getToken();
    var email = await dataBase.getEmail();
    myLog.log(token);
    var userName = await dataBase.getUserName();
    myLog.log(email);
    myLog.log(userName);
    myLog.log(cartList.length.toString());
    for (var i in cartList) {
      myLog.log(i.products!.length.toString());
      myLog.log(i.date!);
      myLog.log(i.addressId!);
      myLog.log(i.packageType!);
      myLog.log(i.price!);
      myLog.log(i.quantity!);
      myLog.log(i.remark!);
      myLog.log(i.serviceCharge!);
      myLog.log(i.shippingFee!);
      myLog.log(i.companyId!);
      myLog.log(i.vendorId!);
    }
    ;
    try {
      String url =
          '${apiClient.baseUrl}/orders'; // Replace with your API endpoint
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',

        //'Content-Type': 'multipart/form-data', // Important for multipart
      };
      // myLog.log(businessType.value);
      // myLog.log(businessType.value);
      // Create multipart request
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll(headers);

      for (var i in cartList) {
        request.fields['products'] = jsonEncode(
          i.products!.map((p) => p.toJson()).toList(),
        );
        request.fields['date'] = DateFormat(
          'yyyy-MM-dd',
        ).format(DateTime.now());
        request.fields['shipping_fee'] = i.shippingFee!;
        request.fields['service_charge'] = i.serviceCharge!;
        request.fields['address_id'] = i.addressId!;
        request.fields['vat'] = i.vat!;
        request.fields['total'] = i.price!;
        request.fields['remark'] = i.remark!;
        request.fields['package_type'] = 'food'; //i.packageType!;
        request.fields['vendor_id'] = i.vendorId!;
        request.fields['company_id'] = i.companyId!;
      }

      // Send the request
      var response = await request.send();
      print(response.headers);
      print(response.stream);
      print(response.request);
      myLog.log('Response status: ${response.statusCode}');
      myLog.log('Response headers: ${response.headers}');
      myLog.log('Response request: ${response.request}');
      // var responseBody = await response.stream.bytesToString();
      //   myLog.log('Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        OverlayLoadingProgress.stop();
        var responseBody = await response.stream.bytesToString();
        myLog.log('Response Body: $responseBody');
        cartList.clear();
        // vendorSuccessModel = vendorSuccessModelFromJson(responseBody);
        // vendorData = vendorSuccessModel.data!;

        // await dataBase.saveLogo(vendorData.logo!);
        // await dataBase.saveBanner(vendorData.banner!);
        // myLog.log('Response Body: $responseBody');
        //   // Refresh profile data
        //   fetchUserProfile();
        //   ScaffoldMessenger.of(Get.context!).showSnackBar(
        //     const SnackBar(content: Text('Profile updated successfully')),
        //   );
        // } else {
        //   ScaffoldMessenger.of(Get.context!).showSnackBar(
        //     SnackBar(content: Text('Failed to update profile: ${response.body}')),
        //   );
        //Get.snackbar("Success", "Order Created successfully");
        myLog.log('Order Created successfully');
        Get.dialog(
          AlertDialog(
            content: Container(
              height: 230,

              child: Column(
                children: [
                  SizedBox(height: 15),
                  CustomImageView(
                    imagePath: 'assets/images/img_check_circle.svg',
                  ),
                  SizedBox(height: 10),
                  Text(
                    'You ordered successfully',
                    style: CustomTextStyles.titleMediumBold,
                  ),
                  SizedBox(height: 10),
                  Text(
                    textAlign: TextAlign.center,
                    'You successfully place an order, your order is confirmed and delivered within 20 minutes. Wish you enjoy the food',
                    style: CustomTextStyles.bodyMediumBluegray400,
                  ),
                  SizedBox(height: 30),
                  TextButton(
                    onPressed: () {
                      Get.toNamed(AppRoutes.loginThreeScreen);
                    },
                    child: Text(
                      'KEEP BROWSING',
                      style: CustomTextStyles.titleMediumBold.copyWith(
                        color: Color(0xff004BFD),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        // await dataBase.saveAddress(contactAddressController.text);
        // businessNameController.clear();
        // businessLogoFile.value =
        //     null; // Clear the image after successful upload
        // businessDocumentFile.value = businessLogoBanner.value = null;
        // null; // Clear the document after successful upload
        // identificationFile.value =
        //     null; // Clear the identification image after successful upload
        // Navigator.pushNamed(Get.context!, '/product-selection');
      } else {
        OverlayLoadingProgress.stop();
        var responseBody = await response.stream.bytesToString();
        print('Error: ${response.statusCode}, Response: $responseBody');
        Get.snackbar("Error:", " ${response.statusCode} - $responseBody");
      }
    } catch (e) {
      OverlayLoadingProgress.stop();
      //Get.snackbar("Error occurred:", e.toString());
      myLog.log(e.toString());
    } finally {
      OverlayLoadingProgress.stop();
    }
  }
}
