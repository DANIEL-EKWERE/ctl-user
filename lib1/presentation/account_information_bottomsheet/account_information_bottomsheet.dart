import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'controller/account_information_controller.dart';

// ignore_for_file: must_be_immutable
class AccountInformationBottomsheet extends StatelessWidget {
  AccountInformationBottomsheet(this.controller, {Key? key}) : super(key: key);
  AccountInformationController controller;

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
          const Text("Account Information", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF1B1B1B))),
          const SizedBox(height: 20),
          _buildInfoTile(Icons.person_outline, "Full Name", "User Name"),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          _buildInfoTile(Icons.email_outlined, "Email", "user@email.com"),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          _buildInfoTile(Icons.phone_outlined, "Phone", "+234 800 000 0000"),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          _buildInfoTile(Icons.cake_outlined, "Date of Birth", "Not set"),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: double.maxFinite, padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(color: const Color(0xFF1B5E20), borderRadius: BorderRadius.circular(12)),
              child: const Center(child: Text("Edit Information", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, size: 18, color: const Color(0xFF333333)),
      ),
      title: Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
      subtitle: Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1B1B1B))),
      trailing: const Icon(Icons.chevron_right, size: 18, color: Color(0xFF999999)),
    );
  }
}
