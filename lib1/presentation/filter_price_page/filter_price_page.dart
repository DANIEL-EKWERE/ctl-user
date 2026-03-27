// Redesigned: Price range filter
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'controller/filter_price_controller.dart';

// ignore_for_file: must_be_immutable
class FilterPricePage extends GetWidget<FilterPriceController> {
  const FilterPricePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("₦${controller.minPrice.value.round()}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1B1B1B))),
            Text("₦${controller.maxPrice.value.round()}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1B1B1B))),
          ],
        ),
        const SizedBox(height: 8),
        RangeSlider(
          values: RangeValues(controller.minPrice.value, controller.maxPrice.value),
          min: 0, max: 50000,
          activeColor: const Color(0xFF1B5E20),
          inactiveColor: const Color(0xFFDDDDDD),
          onChanged: (v) {
            controller.minPrice.value = v.start;
            controller.maxPrice.value = v.end;
          },
        ),
      ],
    ));
  }
}
