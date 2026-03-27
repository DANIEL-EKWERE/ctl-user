// TODO Implement this library.
import 'package:ctluser/presentation/add_new_screen/models/cartModel.dart';
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../controller/add_new_controller.dart';
import '../models/items_item_model.dart';

// ignore_for_file: must_be_immutable
class ItemsItemWidget extends StatefulWidget {
  ItemsItemWidget(this.itemsItemModelObj, {Key? key}) : super(key: key);

  Cartmodel itemsItemModelObj;

  @override
  State<ItemsItemWidget> createState() => _ItemsItemWidgetState();
}

class _ItemsItemWidgetState extends State<ItemsItemWidget> {
  var controller = Get.find<AddNewController>();
  var quantity = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    quantity = int.tryParse(widget.itemsItemModelObj.quantity ?? '') ?? 1;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 2.h),
      child: Row(
        children: [
          Container(
            height: 80.h,
            width: 80.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadiusStyle.roundedBorder14,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Obx(
                //   () =>
                CustomImageView(
                  imagePath: widget.itemsItemModelObj.image!,
                  height: 48.h,
                  width: 62.h,
                ),
                // ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                // Obx(
                //   () =>
                Text(
                  widget.itemsItemModelObj.name!,
                  style: theme.textTheme.titleMedium,
                  //  ),
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    children: [
                      Container(
                        width: 88.h,
                        padding: EdgeInsets.all(4.h),
                        decoration: AppDecoration.fs42Cardlist.copyWith(
                          borderRadius: BorderRadiusStyle.roundedBorder8,
                        ),
                        child: Row(
                          spacing: 10,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  print('object');
                                  controller.decrementQuantity(
                                    quantity,
                                    // int.tryParse(widget.itemsItemModelObj.quantity!) ??
                                    //     1,
                                  );
                                  if (quantity > 1) {
                                    quantity--;
                                  }
                                  setState(() {});
                                },
                                child: Container(
                                  height: 24.h,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Transform.scale(
                                        scale: 2.0,
                                        child: CustomImageView(
                                          imagePath:
                                              ImageConstant.imgUserGray400,
                                          height: 24.h,
                                          width: 24.h,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Obx(
                            //   () =>
                            // Obx(
                            //   () =>
                            Text(
                              (
                              // double.tryParse(
                              //         widget.itemsItemModelObj.quantity ?? '',
                              //       ) ??
                              //       1)
                              //   .toInt()
                              //   .toString(),
                              quantity.toString()),
                              style: CustomTextStyles.labelLargeBluegray900_1
                                  .copyWith(fontSize: 16),
                              //  ),
                            ),
                            // ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.incrementQuantity(
                                    // int.tryParse(widget.itemsItemModelObj.quantity!) ??
                                    //     1,
                                    quantity,
                                  );
                                  quantity++;
                                  setState(() {});
                                },
                                child: Container(
                                  height: 24.h,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      CustomImageView(
                                        imagePath: ImageConstant.imgIconL,
                                        height: 24.h,
                                        width: 24.h,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16.h),
                        child:
                        //  Obx(
                        //   () =>
                        Text(
                          ((double.parse(
                                    widget.itemsItemModelObj.price ?? '0',
                                  ) *
                                  quantity)
                              .toString()),
                          style: CustomTextStyles.labelLargePrimary,
                          //  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
