// Redesigned: App Navigation Screen (dev navigation map - kept minimal)
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'controller/app_navigation_controller.dart';

// ignore_for_file: must_be_immutable
class AppNavigationScreen extends GetWidget<AppNavigationController> {
  const AppNavigationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text("Navigation", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF1B1B1B))),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection("Authentication", [
            _navTile("Login", AppRoutes.loginScreen),
            _navTile("Sign Up", AppRoutes.signupScreen),
            _navTile("OTP Verification", AppRoutes.otpScreen),
            _navTile("Forgot Password", AppRoutes.forgetPasswordOneScreen),
          ]),
          const SizedBox(height: 12),
          _buildSection("Main App", [
            _navTile("Home (Explore)", AppRoutes.loginThreeScreen),
            _navTile("Search", AppRoutes.searchVoneScreen),
            _navTile("Vendor Detail", AppRoutes.detailRestaurantsVoneScreen),
            _navTile("Orders / Cart", AppRoutes.addNewScreen),
            _navTile("Order Tracking", AppRoutes.yourOrdersOngoingScreen),
            _navTile("Checkout", AppRoutes.loginFourScreen),
            _navTile("Profile", AppRoutes.profilePage),
          ]),
          const SizedBox(height: 12),
          _buildSection("Filters", [
            _navTile("Filter Screen", AppRoutes.filterCategoryScreen),
          ]),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> tiles) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
          child: Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey[500], letterSpacing: 0.5)),
        ),
        ...tiles,
      ]),
    );
  }

  Widget _navTile(String label, String route) {
    return ListTile(
      dense: true,
      title: Text(label, style: const TextStyle(fontSize: 14, color: Color(0xFF1B1B1B))),
      trailing: const Icon(Icons.chevron_right, size: 18, color: Color(0xFF999999)),
      onTap: () => Get.toNamed(route),
    );
  }
}
