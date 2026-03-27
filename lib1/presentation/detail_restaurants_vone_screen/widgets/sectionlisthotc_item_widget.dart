import 'package:ctluser/presentation/detail_restaurants_vone_screen/models/cat_prod.dart';
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../controller/detail_restaurants_vone_controller.dart';
import '../models/sectionlisthotc_item_model.dart';

// ignore_for_file: must_be_immutable
class SectionlisthotcItemWidget extends StatelessWidget {
  SectionlisthotcItemWidget(this.sectionlisthotcItemModelObj, {Key? key}) : super(key: key);

  CatProductItems sectionlisthotcItemModelObj;
  var controller = Get.find<DetailRestaurantsVoneController>();

  @override
  Widget build(BuildContext context) {
    final bool hasDiscount = sectionlisthotcItemModelObj.price != null &&
        sectionlisthotcItemModelObj.finalPrice != null &&
        sectionlisthotcItemModelObj.price.toString() != sectionlisthotcItemModelObj.finalPrice.toString();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sectionlisthotcItemModelObj.product?.name ?? "Product",
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1B1B1B)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    sectionlisthotcItemModelObj.product?.description ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF777777)),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (hasDiscount) ...[
                        Text(
                          "From ₦${sectionlisthotcItemModelObj.price}",
                          style: const TextStyle(fontSize: 12, color: Color(0xFFAAAAAA), decoration: TextDecoration.lineThrough),
                        ),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        "From ₦${sectionlisthotcItemModelObj.finalPrice}",
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1B1B1B)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CustomImageView(
                      imagePath: sectionlisthotcItemModelObj.imageUrl ?? ImageConstant.imgImportImage80x80,
                      height: 88, width: 88, fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 6, right: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(4)),
                      child: const Icon(Icons.card_giftcard_outlined, size: 12, color: Color(0xFF555555)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Container(
                width: 88,
                padding: const EdgeInsets.symmetric(vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFA5D6A7)),
                ),
                child: const Center(
                  child: Text("Add +", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1B5E20))),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
