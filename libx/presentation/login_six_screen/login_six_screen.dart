// TODO Implement this library.
import '../add_new_screen/controller/add_new_controller.dart';
import '../add_new_screen/models/cartModel.dart';
import '../detail_restaurants_vone_screen/models/cat_prod.dart';
import '../detail_restaurants_vone_screen/models/model.dart';
import '../login_three_screen/models/model.dart'
    hide State;
import '../add_new_screen/models/cartModel.dart';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'controller/login_six_controller.dart';
import 'models/login_six_one_item_model.dart';
import 'widgets/login_six_one_item_widget.dart'; // ignore_for_file: must_be_immutable

LoginSixController controller = Get.put(LoginSixController());
AddNewController addNewController = Get.put(AddNewController());

class LoginSixScreen extends StatefulWidget {
  const LoginSixScreen({Key? key}) : super(key: key);

  @override
  State<LoginSixScreen> createState() => _LoginSixScreenState();
}

class _LoginSixScreenState extends State<LoginSixScreen> {
  CatProductItems productItem = Get.arguments['product'] as CatProductItems;

  Vendor? vendorData = Get.arguments['vendor'] as Vendor?;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.gray100,
      body: SafeArea(
        child: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsets.only(top: 12.h),
              decoration: AppDecoration.neutral00.copyWith(
                borderRadius: BorderRadiusStyle.customBorderTL30,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 4.h,
                    width: 42.h,
                    decoration: BoxDecoration(
                      color: appTheme.black900.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(2.h),
                    ),
                  ),
                  SizedBox(height: 36.h),
                  Text(
                    productItem.product!.name ??
                        "msg_extreme_cheese_whopper".tr,
                    style: CustomTextStyles.titleLarge21,
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    productItem.product!.description ??
                        "msg_a_signature_flame_grilled".tr,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelLarge!.copyWith(height: 1.67),
                  ),
                  SizedBox(height: 30.h),
                  _buildStackpngwingtwo(),
                  SizedBox(height: 30.h),
                  //_buildLoginsixone(),
                  Text(
                    '${productItem.product!.name!} by ${vendorData?.businessName ?? "Unknown Vendor"}',
                    style: CustomTextStyles.titleMedium_1,
                  ),
                  SizedBox(height: 60.h),
                  SizedBox(
                    width: 162.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {});
                              controller.decrementQuantity();
                            },
                            child: Container(
                              height: 42.h,
                              padding: EdgeInsets.only(bottom: 18.h),
                              decoration: AppDecoration.fillPrimary.copyWith(
                                borderRadius: BorderRadiusStyle.circleBorder20,
                              ),
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  CustomImageView(
                                    imagePath: ImageConstant.imgIcon,
                                    height: 2.h,
                                    width: 16.h,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: CustomTextFormField(
                            readOnly: true,
                            controller: controller.lblQuantity.value,
                            hintText: "lbl_22".tr,
                            hintStyle: theme.textTheme.titleMedium!,
                            textInputAction: TextInputAction.done,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.h,
                              vertical: 10.h,
                            ),
                            borderDecoration:
                                TextFormFieldStyleHelper.fillOnPrimary,
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {});
                              controller.incrementQuantity();
                            },
                            child: Container(
                              height: 42.h,
                              decoration: AppDecoration.fillPrimary.copyWith(
                                borderRadius: BorderRadiusStyle.circleBorder20,
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  CustomImageView(
                                    imagePath: ImageConstant.imgPlus,
                                    height: 14.h,
                                    width: 16.h,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 106.h),
                  _buildRownamemarket(),
                  SizedBox(height: 22.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildStackpngwingtwo() {
    return SizedBox(
      height: 260.h,
      width: double.maxFinite,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomImageView(
            imagePath: productItem.imageUrl ?? ImageConstant.imgPngwing2,
            height: 206.h,
            width: 46.h,
            alignment: Alignment.bottomRight,
            margin: EdgeInsets.only(bottom: 10.h),
          ),
          CustomImageView(
            imagePath: productItem.imageUrl ?? ImageConstant.imgPngwing3,
            height: 206.h,
            width: 42.h,
            alignment: Alignment.bottomLeft,
            margin: EdgeInsets.only(bottom: 4.h),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 5.h,
              width: 284.h,
              decoration: BoxDecoration(
                color: appTheme.gray40001,
                borderRadius: BorderRadius.circular(142.h),
              ),
            ),
          ),
          CustomImageView(
            imagePath: productItem.imageUrl ?? ImageConstant.imgPngwing1,
            height: 256.h,
            width: 326.h,
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildLoginsixone() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 98.h),
      width: double.maxFinite,
      child: Obx(
        () => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Wrap(
            direction: Axis.horizontal,
            spacing: 32.h,
            children: List.generate(
              controller
                  .loginSixModelObj
                  .value
                  .loginSixOneItemList
                  .value
                  .length,
              (index) {
                LoginSixOneItemModel model = controller
                    .loginSixModelObj
                    .value
                    .loginSixOneItemList
                    .value[index];
                return LoginSixOneItemWidget(model);
              },
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildRownamemarket() {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 34.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10.h),
                child: Text("lbl_price".tr, style: theme.textTheme.titleMedium),
              ),
              Obx(
                () => Text(
                  "\u20A6${int.parse(controller.lblQuantity.value.text) * double.parse(productItem.finalPrice!.toString())}",
                  style: CustomTextStyles.titleLargePrimary,
                ),
              ),
            ],
          ),
          CustomElevatedButton(
            onPressed: () {
              addNewController.cartList.add(
                Cartmodel(
                  date: DateTime.now().toString(),
                  products: [
                    Products(
                      productId: productItem.product!.id,
                      quantity: int.parse(
                        controller.lblQuantity.value.text ?? "1",
                      ),
                      price:
                          int.parse(controller.lblQuantity.value.text) *
                          double.parse(
                            productItem.finalPrice!.toString(),
                          ).toInt(),
                      vendorId: 59,
                      companyId: 3,
                    ),
                  ],
                  packageType: productItem.pack != null
                      ? productItem.pack!.name!
                      : "None",
                  vendorId: '59',
                  companyId: '3',
                  name: productItem.product!.name!,
                  price:
                      (double.tryParse(productItem.finalPrice!)! *
                              int.parse(
                                controller.lblQuantity.value.text ?? "1",
                              ))
                          .toString(), //productItem.finalPrice.toString(),
                  quantity: controller.lblQuantity.value.text,
                  image: productItem.imageUrl!,
                  addressId: '1',
                  remark: 'No remarks',
                  serviceCharge: '0',
                  shippingFee: '0',
                  vat: '0',
                  // product: productItem.product,
                  // quantity: int.parse(controller.lblQuantity.text ?? "1"),
                  // finalPrice: productItem.finalPrice! *
                  //     double.parse(controller.lblQuantity.text ?? "1"),
                ),
              );
              Get.toNamed(
                AppRoutes.addNewScreen,
                arguments: {
                  'product': productItem,
                  'quantity': controller.lblQuantity.value.text,
                  'finalPrice':
                      (double.tryParse(productItem.finalPrice!)! *
                      int.parse(controller.lblQuantity.value.text ?? "1")),
                  'vendor': vendorData,
                },
              );
            },
            height: 46.h,
            width: 194.h,
            text: "lbl_add_to_order".tr,
            buttonTextStyle: CustomTextStyles.titleSmallOnPrimary_2,
          ),
        ],
      ),
    );
  }
}
