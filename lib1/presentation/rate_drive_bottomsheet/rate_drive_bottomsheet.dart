// Redesigned: Chewdeck-style Rate Driver Bottomsheet
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'controller/rate_drive_controller.dart';
import 'models/chipviewlabel_item_model.dart';
import 'widgets/chipviewlabel_item_widget.dart';

// ignore_for_file: must_be_immutable
class RateDriveBottomsheet extends StatelessWidget {
  RateDriveBottomsheet(this.controller, {Key? key}) : super(key: key);
  RateDriveController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(margin: const EdgeInsets.symmetric(vertical: 12), width: 40, height: 4,
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
          const Text("Rate your Driver", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF1B1B1B))),
          const SizedBox(height: 4),
          Text("How was your delivery experience?", style: TextStyle(fontSize: 13, color: Colors.grey[500])),
          const SizedBox(height: 20),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 36,
            backgroundColor: const Color(0xFFE3F2FD),
            child: const Icon(Icons.delivery_dining, size: 36, color: Color(0xFF1565C0)),
          ),
          const SizedBox(height: 12),
          const Text("Your Rider", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1B1B1B))),
          const SizedBox(height: 20),
          Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) => GestureDetector(
              onTap: () => controller.rating.value = i + 1.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Icon(
                  i < controller.rating.value ? Icons.star : Icons.star_border,
                  color: const Color(0xFFFFC107), size: 36,
                ),
              ),
            )),
          )),
          const SizedBox(height: 20),
          Obx(() => Wrap(
            spacing: 8, runSpacing: 8,
            children: controller.chipItems.map((chip) => GestureDetector(
              onTap: () => chip.isSelected.toggle(),
              child: Obx(() => Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: chip.isSelected.value ? const Color(0xFFE3F2FD) : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: chip.isSelected.value ? const Color(0xFF1565C0) : const Color(0xFFEEEEEE)),
                ),
                child: Text(chip.label ?? "", style: TextStyle(fontSize: 13, color: chip.isSelected.value ? const Color(0xFF1565C0) : const Color(0xFF555555))),
              )),
            )).toList(),
          )),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: double.maxFinite,
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(color: const Color(0xFF1B5E20), borderRadius: BorderRadius.circular(12)),
              child: const Center(child: Text("Submit Rating", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700))),
            ),
          ),
        ],
      ),
    );
  }
}
