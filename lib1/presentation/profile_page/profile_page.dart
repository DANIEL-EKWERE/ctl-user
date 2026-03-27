// Redesigned: Chewdeck-style Profile Screen
import 'package:ctluser/presentation/profile_page/controller/proflle_controller.dart';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'models/profile_model.dart';

// ignore_for_file: must_be_immutable
class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);
  ProfileController controller = Get.put(ProfileController(ProfileModel().obs));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        title: const Text("Profile", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF1B1B1B))),
        actions: [
          IconButton(
            icon: const Icon(Icons.access_time, color: Color(0xFF555555)),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 8),
            _buildSection("Account", [
              _buildTile(Icons.person_outline, "Account Information", () => Get.toNamed(AppRoutes.accountInformationBottomsheet)),
              _buildTile(Icons.lock_outline, "Change Password", () => Get.toNamed(AppRoutes.changePasswordBottomsheet)),
              _buildTile(Icons.location_on_outlined, "Saved Addresses", () {}),
              _buildTile(Icons.credit_card_outlined, "Payment Methods", () => Get.toNamed(AppRoutes.paymentMethodsBottomsheet)),
            ]),
            const SizedBox(height: 8),
            _buildSection("Preferences", [
              _buildTileWithSwitch(Icons.notifications_outlined, "Push Notifications"),
              _buildTileWithSwitch(Icons.email_outlined, "Email Updates"),
            ]),
            const SizedBox(height: 8),
            _buildSection("Support", [
              _buildTile(Icons.help_outline, "Help & FAQ", () {}),
              _buildTile(Icons.privacy_tip_outlined, "Privacy Policy", () => Get.toNamed(AppRoutes.privacyPolicyScreen)),
              _buildTile(Icons.article_outlined, "Terms of Service", () => Get.toNamed(AppRoutes.termsOfServiceScreen)),
              _buildTile(Icons.info_outline, "About", () {}),
            ]),
            const SizedBox(height: 8),
            // Logout
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: const Color(0xFFFFEBEE), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.logout, color: Color(0xFFD32F2F), size: 20),
                ),
                title: const Text("Log Out", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFFD32F2F))),
                onTap: () => controller.onLogout(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 34,
                backgroundColor: const Color(0xFFE8F5E9),
                child: const Icon(Icons.person, size: 36, color: Color(0xFF1B5E20)),
              ),
              Positioned(
                bottom: 0, right: 0,
                child: Container(
                  width: 22, height: 22,
                  decoration: const BoxDecoration(color: Color(0xFF1B5E20), shape: BoxShape.circle),
                  child: const Icon(Icons.edit, color: Colors.white, size: 12),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("User Name", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF1B1B1B))),
                const SizedBox(height: 3),
                Text("user@email.com", style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(12)),
                  child: const Text("Chowpass Member", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1B5E20))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> tiles) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey[500], letterSpacing: 0.5)),
          ),
          ...tiles,
        ],
      ),
    );
  }

  Widget _buildTile(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      dense: true,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, size: 18, color: const Color(0xFF333333)),
      ),
      title: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1B1B1B))),
      trailing: const Icon(Icons.chevron_right, size: 20, color: Color(0xFF999999)),
      onTap: onTap,
    );
  }

  Widget _buildTileWithSwitch(IconData icon, String label) {
    final val = false.obs;
    return ListTile(
      dense: true,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, size: 18, color: const Color(0xFF333333)),
      ),
      title: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1B1B1B))),
      trailing: Obx(() => Switch.adaptive(
        value: val.value,
        onChanged: (v) => val.value = v,
        activeColor: const Color(0xFF1B5E20),
      )),
    );
  }
}
