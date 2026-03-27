import 'dart:convert';
import 'dart:developer' as myLog;
//import 'package:ctlvendor/screens/operation/operations_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ctluser/data/apiClient/apiClient.dart';
import 'package:ctluser/presentation/product_selection/models/mdels.dart';
import 'package:ctluser/utils/storage.dart';
import 'package:overlay_kit/overlay_kit.dart';
import 'package:http/http.dart' as http;

class ProductSelectionController extends GetxController {
  ApiClient apiClient = ApiClient(Duration(seconds: 60 * 5));

  //TextEditingController bankNameController = TextEditingController();
  Rx<Data> selectedBank = Data().obs;
  TextEditingController bankAccountNumberController = TextEditingController();
  TextEditingController bankAccountNameController = TextEditingController();

  Banks banks = Banks();
  List<Data> data = [];

  RxBool isLoading = false.obs;
  @override
  onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchBanks();
    });
  }

  Future<void> fetchBanks() async {
    isLoading.value = true;
    //OverlayLoadingProgress.start(circularProgressColor: Colors.amber);
    //print(selectedProducts);
    try {
      var response = await apiClient.fetchBanks();
      if (response.statusCode == 200 || response.statusCode == 201) {
        var body = jsonDecode(response.body);
        print(body);
        banks = banksFromJson(response.body);
        data = banks.data!;
        var result =
            data.map((e) {
              e.id.toString();
            }).toList();
        myLog.log(result.toString());

        isLoading.value = false;
      } else {
        isLoading.value = false;
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Text('Success: \n${jsonDecode(response.body)}'),
            backgroundColor: Colors.red,
          ),
        );
        myLog.log(response.body);
      }
    } catch (e) {
      myLog.log(e.toString());
      isLoading.value = false;
      // OverlayLoadingProgress.stop();
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text('Error: \n${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      isLoading.value = false;
      //OverlayLoadingProgress.stop();
    }
    //update-vendor-categories/:email
  }

  Future<void> updateVendorBankDetails() async {
    OverlayLoadingProgress.start(circularProgressColor: Color(0xff004BFD));
    // myLog.log(email);
    var email = await dataBase.getEmail();
    myLog.log(bankAccountNameController.text);
    myLog.log(bankAccountNumberController.text);
    myLog.log(selectedBank.value.id.toString());
    try {
      String url =
          '${apiClient.baseUrl}/update-business-profile/$email'; // Replace with your API endpoint
      Map<String, String> headers = {'Accept': 'application/json'};

      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll(headers);
      request.fields['account_number'] = bankAccountNumberController.text;
      request.fields['account_name'] = bankAccountNameController.text;
      //business_type_id
      request.fields['bank_id'] = selectedBank.value.id.toString();
      // request.fields['business_address'] = '20 Willington Bassey Way';
      //

      // if (file1.value != null) {
      //   myLog.log('profile photo adding');
      //   XFile? imageFile = file1.value;
      //   String mimeType = lookupMimeType(imageFile!.path) ?? 'image/jpeg';
      //   String fileName = basename(imageFile.path);

      //   // Convert image to MultipartFile and add it to the request
      //   var multipartFile1 = await http.MultipartFile.fromPath(
      //     'profile_picture', // The name of the field in your API
      //     imageFile.path,
      //     filename: fileName,
      //     contentType:
      //         MediaType(mimeType.split('/')[0], mimeType.split('/')[1]),
      //   );
      //   request.files.add(multipartFile1);
      // }

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
        // var responseBody = await response.stream.bytesToString();
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
        Get.snackbar("Success", "Bank account updated successfully");
        myLog.log('Profile updated successfully');

        //  Get.to(() => OperationsScreen());
      } else {
        OverlayLoadingProgress.stop();
        var responseBody = await response.stream.bytesToString();
        print('Error: ${response.statusCode}, Response: $responseBody');
        Get.snackbar("Error:", " ${response.statusCode} - $responseBody");
      }
    } catch (e) {
      OverlayLoadingProgress.stop();
      Get.snackbar("Error occurred:", e.toString());
      myLog.log(e.toString());
    } finally {
      OverlayLoadingProgress.stop();
    }
  }
}
