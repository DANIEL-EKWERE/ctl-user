// TODO Implement this library.
import '../../../data/apiClient/apiClient.dart';
import '../models/cat_prod.dart';
import '../models/model.dart';
import '../models/promotionModel.dart';
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/detail_restaurants_vone_model.dart';
import '../models/detail_tab_model.dart';
import 'dart:developer' as myLog;

/// A controller class for the DetailRestaurantsVoneScreen.
///
/// This class manages the state of the DetailRestaurantsVoneScreen, including the
/// current detailRestaurantsVoneModelObj
class DetailRestaurantsVoneController extends GetxController
    with GetSingleTickerProviderStateMixin {
  Rx<DetailRestaurantsVoneModel> detailRestaurantsVoneModelObj =
      DetailRestaurantsVoneModel().obs;

  ApiClient apiClient = ApiClient(Duration(seconds: 60 * 5));
  ProductByCategory? productByCategory;
  List<ProductItem>? productItem = [];
  Rx<bool> isLoading = false.obs;
  Rx<bool> isLoading1 = false.obs;

  Promotion? promotion;
  List<PromotionItem>? promotionItem = [];

  CategoriesAndProduct? categoriesAndProduct;
  List<CateProdItem>? cateProdItem = [];

  late TabController tabviewController = Get.put(
    TabController(vsync: this, length: 2),
  );

  Rx<DetailTabModel> detailTabModelObj = DetailTabModel().obs;

  void fetchProductByCategory(String company_id, String category_id) async {
    isLoading.value = true;
    try {
      var response = await apiClient.fetchProductByCategory(
        company_id,
        category_id,
      );
      if (response.statusCode == 200) {
        isLoading.value = false;
        var productByCategory = productByCategoryFromJson(
          response.body ?? '{}',
        );
        productItem = productByCategory.data;
        myLog.log(
          "Product by category fetched: ${productByCategory.data?.length ?? 0}",
        );
      } else {
        isLoading.value = false;
        myLog.log(
          "Failed to fetch product by category: ${response.statusCode}",
        );
      }
    } catch (e) {
      isLoading.value = false;
      myLog.log("Error fetching product by category: $e");
    }
  }


  void fetchCategoriesAndProducts(String company_id, String category_id) async {
    isLoading.value = true;
    try {
      var response = await apiClient.fetchCategoriesAndProducts(
        company_id,
        category_id,
      );
      if (response.statusCode == 200) {
        isLoading.value = false;
         categoriesAndProduct = categoriesAndProductFromJson(
          response.body ?? '{}',
        );
        cateProdItem = categoriesAndProduct!.data;
        myLog.log(
          "Product by category fetched: ${categoriesAndProduct!.data?.length ?? 0}",
        );
      } else {
        isLoading.value = false;
        myLog.log(
          "Failed to fetch product by category: ${response.statusCode}",
        );
      }
    } catch (e) {
      isLoading.value = false;
      myLog.log("Error fetching product by category: $e");
    }
  }

  void fetchProductByPromotion(String promotio_id) async {
    isLoading.value = true;
    try {
      var response = await apiClient.fetchProductByCategory(
        ' // company_id,',
        '// category_id,',
      );
      if (response.statusCode == 200) {
        isLoading.value = false;
        var productByCategory = productByCategoryFromJson(
          response.body ?? '{}',
        );
        productItem = productByCategory.data;
        myLog.log(
          "Product by category fetched: ${productByCategory.data?.length ?? 0}",
        );
      } else {
        isLoading.value = false;
        myLog.log(
          "Failed to fetch product by category: ${response.statusCode}",
        );
      }
    } catch (e) {
      isLoading.value = false;
      myLog.log("Error fetching product by category: $e");
    }
  }

  void fetchPromotion() async {
    isLoading1.value = true;
    try {
      var response = await apiClient.fetchPromotion();
      if (response.statusCode == 200) {
        isLoading1.value = false;
        var promotion = promotionFromJson(response.body ?? '{}');
        promotionItem = promotion.data;
        myLog.log("Promotion fetched: ${promotionItem?.length ?? 0}");
      } else {
        isLoading1.value = false;
        myLog.log("Failed to fetch promotion: ${response.statusCode}");
      }
    } catch (e) {
      isLoading1.value = false;
      myLog.log("Error fetching promotion: $e");
    }
  }
}
