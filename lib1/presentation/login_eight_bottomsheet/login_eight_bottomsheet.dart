// Redesigned: Schedule Delivery Bottomsheet (login_eight = schedule picker)
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'controller/login_eight_controller.dart';

// ignore_for_file: must_be_immutable
class LoginEightBottomsheet extends StatelessWidget {
  LoginEightBottomsheet(this.controller, {Key? key}) : super(key: key);
  LoginEightController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Container(margin: const EdgeInsets.symmetric(vertical: 12), width: 40, height: 4,
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
          const Text("Schedule Delivery", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF1B1B1B))),
          const SizedBox(height: 6),
          Text("Choose when you want your order delivered", style: TextStyle(fontSize: 13, color: Colors.grey[500])),
          const SizedBox(height: 20),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 16),
          _label("Select Date"),
          const SizedBox(height: 10),
          // Date chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ["Today", "Tomorrow", "Wed, Mar 26", "Thu, Mar 27", "Fri, Mar 28"].map((d) =>
                Obx(() => GestureDetector(
                  onTap: () => controller.selectedDate.value = d,
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                    decoration: BoxDecoration(
                      color: controller.selectedDate.value == d ? const Color(0xFF1B5E20) : Colors.white,
                      border: Border.all(color: controller.selectedDate.value == d ? const Color(0xFF1B5E20) : const Color(0xFFDDDDDD)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(d, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,
                      color: controller.selectedDate.value == d ? Colors.white : const Color(0xFF333333))),
                  ),
                )),
              ).toList(),
            ),
          ),
          const SizedBox(height: 20),
          _label("Select Time"),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: ["9:00 AM", "10:00 AM", "11:00 AM", "12:00 PM", "1:00 PM", "2:00 PM", "3:00 PM", "4:00 PM"].map((t) =>
              Obx(() => GestureDetector(
                onTap: () => controller.selectedTime.value = t,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: controller.selectedTime.value == t ? const Color(0xFFE8F5E9) : const Color(0xFFF5F5F5),
                    border: Border.all(color: controller.selectedTime.value == t ? const Color(0xFF1B5E20) : const Color(0xFFEEEEEE)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(t, style: TextStyle(fontSize: 13, color: controller.selectedTime.value == t ? const Color(0xFF1B5E20) : const Color(0xFF555555))),
                ),
              )),
            ).toList(),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () { controller.onTapConfirm(); Get.back(); },
            child: Container(width: double.maxFinite, padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(color: const Color(0xFF1B5E20), borderRadius: BorderRadius.circular(12)),
              child: const Center(child: Text("Confirm Schedule", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)))),
          ),
        ],
      ),
    );
  }

  Widget _label(String t) => Text(t, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF333333)));
}
