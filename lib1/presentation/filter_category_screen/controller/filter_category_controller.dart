// Filter Category Controller
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../data/apiClient/apiClient.dart';
import '../models/filter_category_model.dart';
import '../models/twenty_tab_model.dart';

/// A controller class for the FilterCategoryScreen.
///
/// This class manages the state of the FilterCategoryScreen, including the
/// current filterCategoryModelObj
class FilterCategoryController extends GetxController
    with GetSingleTickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();
  TextEditingController searchoneController = TextEditingController();

  Rx<FilterCategoryModel> filterCategoryModelObj = FilterCategoryModel().obs;

  Rx<String> selectedCategory = "All".obs;

  late TabController tabviewController = Get.put(
    TabController(vsync: this, length: 3),
  );

  Rx<TwentyTabModel> twentyTabModelObj = TwentyTabModel().obs;

  Rx<bool> isLoading = false.obs;

  final ApiClient apiClient = ApiClient(Duration(seconds: 30));

  // Available categories
  RxList<String> categories = <String>[
    "All",
    "Fast Food",
    "Restaurants",
    "Cafes",
    "Bakeries",
    "Grocery",
    "Pharmacies",
    "Laundry"
  ].obs;

  // Selected filters
  RxSet<String> selectedFilters = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  @override
  void onClose() {
    super.onClose();
    searchController.dispose();
    searchoneController.dispose();
  }

  Future<void> fetchCategories() async {
    isLoading.value = true;
    try {
      // TODO: Implement API call to fetch categories
      // For now, just use the predefined list
      await Future.delayed(const Duration(seconds: 1));
      // Categories are already initialized above
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to load categories: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void onCategorySelected(String category) {
    selectedCategory.value = category;
  }

  void onFilterToggle(String filter) {
    if (selectedFilters.contains(filter)) {
      selectedFilters.remove(filter);
    } else {
      selectedFilters.add(filter);
    }
  }

  void clearFilters() {
    selectedFilters.clear();
    selectedCategory.value = "All";
    searchController.clear();
    searchoneController.clear();
  }

  void applyFilters() {
    // TODO: Apply filters and navigate back with results
    Get.back(result: {
      'category': selectedCategory.value,
      'filters': selectedFilters.toList(),
      'search': searchController.text,
    });
  }
}
