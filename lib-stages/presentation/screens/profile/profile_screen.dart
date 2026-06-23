import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/controllers/auth_controller.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/api_client.dart';
import '../../../utils/storage_service.dart';
import '../../widgets/common/app_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = '';
  String _email = '';
  String _phone = '';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadLocal();
    _fetchProfile();
  }

  Future<void> _loadLocal() async {
    _name = await StorageService.instance.getUserName();
    _email = await StorageService.instance.getUserEmail();
    _phone = await StorageService.instance.getUserPhone();
    if (mounted) setState(() {});
  }

  Future<void> _fetchProfile() async {
    final res = await ApiClient.instance.getProfile();
    if (res['success'] == true) {
      final d = res['data'] as Map<String, dynamic>;
      final user = (d['data'] ?? d['user'] ?? d) as Map<String, dynamic>;
      _name = user['name']?.toString() ?? _name;
      _email = user['email']?.toString() ?? _email;
      _phone = user['phone']?.toString() ?? _phone;
      await StorageService.instance.saveUserName(_name);
      await StorageService.instance.saveUserEmail(_email);
      await StorageService.instance.saveUserPhone(_phone);
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final authCtrl = Get.put(AuthController());
    final initial =
        _name.isNotEmpty ? _name[0].toUpperCase() : 'U';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Header ────────────────────────────────────────────────────
          SliverAppBar(
            backgroundColor: AppColors.primary,
            expandedHeight: 220,
            pinned: true,
            automaticallyImplyLeading: false,
            title: const Text('Profile',
                style: TextStyle(
                    color: AppColors.white, fontWeight: FontWeight.w700)),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppColors.primary,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 64),
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.white38, width: 2),
                        ),
                        child: Center(
                          child: Text(initial,
                              style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.white)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _name.isNotEmpty ? _name : 'User',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white),
                      ),
                      if (_email.isNotEmpty)
                        Text(_email,
                            style: const TextStyle(
                                fontSize: 13,
                                color: Colors.white70)),
                    ]),
              ),
            ),
          ),

          // ── Content ───────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                // Account section
                _SectionCard(title: 'Account', tiles: [
                  _ProfileTile(
                      icon: Icons.person_outline_rounded,
                      label: 'Personal Information',
                      onTap: () => _editProfile(context)),
                  _ProfileTile(
                      icon: Icons.location_on_outlined,
                      label: 'Saved Addresses',
                      onTap: () {}),
                  _ProfileTile(
                      icon: Icons.credit_card_outlined,
                      label: 'Payment Methods',
                      onTap: () {}),
                  _ProfileTile(
                      icon: Icons.notifications_outlined,
                      label: 'Notifications',
                      onTap: () {}),
                ]),
                const SizedBox(height: 14),
                _SectionCard(title: 'Activity', tiles: [
                  _ProfileTile(
                      icon: Icons.receipt_long_outlined,
                      label: 'Order History',
                      onTap: () {}),
                  _ProfileTile(
                      icon: Icons.favorite_border_rounded,
                      label: 'Favourites',
                      onTap: () {}),
                  _ProfileTile(
                      icon: Icons.star_border_rounded,
                      label: 'Reviews',
                      onTap: () {}),
                ]),
                const SizedBox(height: 14),
                _SectionCard(title: 'About', tiles: [
                  _ProfileTile(
                      icon: Icons.help_outline_rounded,
                      label: 'Help & Support',
                      onTap: () {}),
                  _ProfileTile(
                      icon: Icons.privacy_tip_outlined,
                      label: 'Privacy Policy',
                      onTap: () {}),
                  _ProfileTile(
                      icon: Icons.description_outlined,
                      label: 'Terms of Service',
                      onTap: () {}),
                  _ProfileTile(
                      icon: Icons.info_outline_rounded,
                      label: 'App Version 1.0.0',
                      onTap: () {},
                      showArrow: false),
                ]),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: () => _confirmLogout(context, authCtrl),
                    icon: const Icon(Icons.logout_rounded,
                        color: AppColors.error),
                    label: const Text('Sign Out',
                        style: TextStyle(
                            color: AppColors.error,
                            fontWeight: FontWeight.w600,
                            fontSize: 15)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                          color: AppColors.error, width: 1.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _editProfile(BuildContext ctx) {
    final nameCtrl = TextEditingController(text: _name);
    final phoneCtrl = TextEditingController(text: _phone);
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child:
              Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('Edit Profile',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 20),
            AppTextField(
                label: 'Full Name',
                controller: nameCtrl),
            const SizedBox(height: 14),
            AppTextField(
                label: 'Phone',
                controller: phoneCtrl,
                keyboardType: TextInputType.phone),
            const SizedBox(height: 20),
            AppButton(
              label: 'Save Changes',
              isLoading: _loading,
              onTap: () async {
                setState(() => _loading = true);
                final res = await ApiClient.instance.updateProfile(
                    name: nameCtrl.text, phone: phoneCtrl.text);
                setState(() => _loading = false);
                if (res['success'] == true) {
                  _name = nameCtrl.text;
                  _phone = phoneCtrl.text;
                  await StorageService.instance
                      .saveUserName(_name);
                  await StorageService.instance
                      .saveUserPhone(_phone);
                  if (mounted) setState(() {});
                  Get.back();
                  Get.snackbar('Saved', 'Profile updated',
                      snackPosition: SnackPosition.TOP);
                }
              },
            ),
          ]),
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext ctx, AuthController authCtrl) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Sign out?',
            style: TextStyle(fontWeight: FontWeight.w700)),
        content:
            const Text('You will be signed out of your account.'),
        actions: [
          TextButton(
              onPressed: Get.back,
              child: const Text('Cancel',
                  style:
                      TextStyle(color: AppColors.textSecondary))),
          ElevatedButton(
            onPressed: () {
              Get.back();
              authCtrl.logout();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8))),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> tiles;
  const _SectionCard({required this.title, required this.tiles});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8, left: 4),
          child: Text(title,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.5)),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(children: [
            for (int i = 0; i < tiles.length; i++) ...[
              tiles[i],
              if (i < tiles.length - 1)
                const Divider(height: 1, indent: 52),
            ],
          ]),
        ),
      ],
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool showArrow;
  const _ProfileTile(
      {required this.icon,
      required this.label,
      required this.onTap,
      this.showArrow = true});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
            color: AppColors.grey100,
            borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, size: 18, color: AppColors.primary),
      ),
      title: Text(label,
          style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w500)),
      trailing: showArrow
          ? const Icon(Icons.arrow_forward_ios_rounded,
              size: 14, color: AppColors.grey400)
          : null,
      onTap: onTap,
      dense: true,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
    );
  }
}
