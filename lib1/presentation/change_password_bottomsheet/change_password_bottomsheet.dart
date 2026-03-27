import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'controller/change_password_controller.dart';

// ignore_for_file: must_be_immutable
class ChangePasswordBottomsheet extends StatelessWidget {
  ChangePasswordBottomsheet(this.controller, {Key? key}) : super(key: key);
  ChangePasswordController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Container(margin: const EdgeInsets.symmetric(vertical: 12), width: 40, height: 4,
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
          const Text("Change Password", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF1B1B1B))),
          const SizedBox(height: 20),
          _label("Current Password"), const SizedBox(height: 8),
          _field(controller.passwordController, "Enter current password"),
          const SizedBox(height: 16),
          _label("New Password"), const SizedBox(height: 8),
          _field(controller.newpasswordController, "Enter new password"),
          const SizedBox(height: 16),
          _label("Confirm Password"), const SizedBox(height: 8),
          _field(controller.confirmpasswordController, "Confirm new password"),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => controller.onTapSave(),
            child: Container(
              width: double.maxFinite, padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(color: const Color(0xFF1B5E20), borderRadius: BorderRadius.circular(12)),
              child: const Center(child: Text("Save Changes", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String t) => Text(t, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF333333)));
  Widget _field(TextEditingController ctrl, String hint) => TextField(
    controller: ctrl, obscureText: true,
    style: const TextStyle(fontSize: 14, color: Color(0xFF1B1B1B)),
    decoration: InputDecoration(
      hintText: hint, hintStyle: TextStyle(fontSize: 14, color: Colors.grey[400]),
      filled: true, fillColor: const Color(0xFFF8F8F8),
      suffixIcon: const Icon(Icons.visibility_off_outlined, color: Color(0xFF888888), size: 20),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFEEEEEE))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFEEEEEE))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF1B5E20), width: 1.5)),
    ),
  );
}
