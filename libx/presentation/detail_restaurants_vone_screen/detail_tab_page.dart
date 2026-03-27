// TODO Implement this library.
import 'models/cat_prod.dart';
import 'models/model.dart';
import 'models/promotionModel.dart';
import '../login_three_screen/models/model.dart'
    hide State;
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import '../../core/app_export.dart';
import 'controller/detail_restaurants_vone_controller.dart';
import 'models/detail_tab_model.dart';
import 'models/listnamemarket_item_model.dart';
import 'models/sectionlisthotc_item_model.dart';
import 'widgets/listnamemarket_item_widget.dart';
import 'widgets/sectionlisthotc_item_widget.dart';

// ignore_for_file: must_be_immutable
class DetailTabPage extends StatefulWidget {
  DetailTabPage(this.vendorData, {Key? key}) : super(key: key);
  Vendor? vendorData;
  @override
  State<DetailTabPage> createState() => _DetailTabPageState();
}

class _DetailTabPageState extends State<DetailTabPage> {
  DetailRestaurantsVoneController controller = Get.put(
    DetailRestaurantsVoneController(),
  );

  @override
  void initState() {
    super.initState();
    // controller.fetchSectionListHotc();
    controller.fetchCategoriesAndProducts(
      widget.vendorData?.locations?.first.id.toString() ?? "",
      widget.vendorData?.category?.id.toString() ?? "",
    );
    controller.fetchPromotion();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 32.h),
      child: Column(
        children: [
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.only(left: 34.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Promotions', style: CustomTextStyles.titleMediumBold),
                SizedBox(height: 16.h),
                Obx(
                  () => controller.isLoading1.value
                      ? Center(
                          child: Text(
                            'Loading promotions...',
                            style: TextStyle(
                              color: appTheme.blueGray400,
                              fontSize: 12,
                            ),
                          ),
                        )
                      : controller.promotionItem!.isNotEmpty
                      ? _buildListnamemarket()
                      : Center(
                          child: Text(
                            'No promotions available for this vendor at the moment!',
                            style: TextStyle(
                              color: appTheme.blueGray400,
                              fontSize: 12,
                            ),
                          ),
                        ),
                ),
                // promotion goes here
                //SizedBox(height: 0.h),
                Obx(
                  () => controller.isLoading.value
                      ? Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Center(
                            child: Text(
                              'Loading Products for this vendor...',
                              style: TextStyle(
                                color: appTheme.blueGray400,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        )
                      : _buildSectionlisthotc(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildListnamemarket() {
    return Container(
      child:
          //  Obx(
          //   () =>
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Wrap(
              direction: Axis.horizontal,
              spacing: 8.h,
              children: List.generate(controller.promotionItem?.length ?? 0, (
                index,
              ) {
                PromotionItem model = controller.promotionItem![index];
                return GestureDetector(
                  onTap: () {
                    Get.toNamed(
                      AppRoutes.loginSixScreen,
                      arguments: {'promotion': model},
                    );
                  },
                  child: ListnamemarketItemWidget(model),
                );
              }),
            ),
          ),
      // ),
    );
  }

  /// Section Widget
  Widget _buildSectionlisthotc() {
    return
    // Obx(
    //   () =>
    GroupedListView<CateProdItem, String>(
      shrinkWrap: true,
      stickyHeaderBackgroundColor: Colors.transparent,
      elements: controller.cateProdItem ?? [],
      groupBy: (element) => element.name ?? "Unknown",
      sort: false,
      groupSeparatorBuilder: (String value) {
        return Padding(
          padding: EdgeInsets.only(top: 0.h, bottom: 20.h),
          child: Text(
            value,
            style: CustomTextStyles.titleMediumBold.copyWith(
              color: appTheme.blueGray900,
            ),
          ),
        );
      },
      itemBuilder: (context, model) {
        final items = model.products ?? []; // 👈 your list inside each group

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final product = items[index];
            return GestureDetector(
              onTap: () => Get.toNamed(
                AppRoutes.loginSixScreen,
                arguments: {'product': product, 'vendor': widget.vendorData},
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: SectionlisthotcItemWidget(product),
              ),
            );
          },
        );
      },
      separator: SizedBox(height: 20.h),
    );
  }
}
