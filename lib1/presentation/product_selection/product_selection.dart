import 'package:ctluser/presentation/product_selection/controller/product_selection_controller.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';
import 'package:ctluser/presentation/product_selection/controller/product_selection_controller.dart';
import 'package:ctluser/presentation/product_selection/models/mdels.dart';
//import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import '../../widgets/status_bar.dart';
import '../../widgets/back_button.dart';

ProductSelectionController controller = Get.put(ProductSelectionController());

class ProductSelectionScreen extends StatefulWidget {
  const ProductSelectionScreen({super.key});

  @override
  State<ProductSelectionScreen> createState() => _ProductSelectionScreenState();
}

class _ProductSelectionScreenState extends State<ProductSelectionScreen> {
  // RefreshController _refreshController = RefreshController(
  //   initialRefresh: false,
  // );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.fetchBanks();
  }
  //List<bool> isSelectedIngredient = List.generate(controller.data[0]., generator)
  // final List<String> _products = [
  //   'Spices',
  //   'Protein',
  //   'Vegetables',
  //   'Cooking Oil',
  //   'Grains',
  //   'Tuber',
  //   'Fruit',
  //   'Drinks',
  //   'Beverage',
  // ];

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      child: Row(
        children: List.generate(
          7,
          (index) => Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: index < 2 ? Color(0XFF004BFD) : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              const StatusBar(),
              // _buildProgressIndicator(),
              const SizedBox(height: 16),
              const Row(
                children: [
                  CustomBackButton(),
                  SizedBox(width: 16),
                  Text(
                    'Setup bank details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff004BFD),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              DropdownSearch<Data>(
                items: (filter, infiniteScrollProps) => controller.data,
                selectedItem: controller.selectedBank.value,

                // Popup customization
                popupProps: PopupProps.menu(
                  showSearchBox: true,
                  showSelectedItems: true,
                  searchFieldProps: TextFieldProps(
                    decoration: InputDecoration(
                      hintText: 'Search bank...',
                      prefixIcon: Icon(Icons.search, color: Color(0XFF004BFD)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Color(0XFF004BFD),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  itemBuilder: (
                    BuildContext context,
                    Data item,
                    bool isSelected,
                    bool isDisabled,
                  ) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? Color(0xFFFFF4E6) : Colors.white,
                      ),
                      child: Text(
                        item.name ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                          color:
                              isSelected ? Color(0XFF004BFD) : Colors.black87,
                        ),
                      ),
                    );
                  },
                  emptyBuilder: (context, searchEntry) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 48,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 12),
                            Text(
                              'No bank found',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                // Dropdown button customization
                decoratorProps: DropDownDecoratorProps(
                  decoration: InputDecoration(
                    hintText: 'Select Bank',
                    hintStyle: TextStyle(color: Colors.black, fontSize: 14),
                    labelText: 'Select Bank',
                    //prefixText: 'Select Bank',
                    prefixStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Color(0XFF004BFD),
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),

                // Item to string converter (what shows in the dropdown button)
                itemAsString: (Data bank) => bank.name ?? '',

                // Compare function
                compareFn: (item1, item2) => item1.code == item2.code,

                // On changed callback
                onChanged: (Data? bank) {
                  //  controller.fetchBanks();
                  if (bank != null) {
                    // onChanged!(bank);
                    controller.selectedBank.value = bank;
                  }
                },
              ),

              const SizedBox(height: 20),
              TextField(
                //  maxLength: 11,
                controller: controller.bankAccountNumberController,
                decoration: const InputDecoration(
                  hintText: 'Account Number',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: controller.bankAccountNameController,
                decoration: const InputDecoration(
                  hintText: 'Account Name',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              const Spacer(),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    controller.updateVendorBankDetails();
                  },
                  child: const Text(
                    'Continue',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
