import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/storage_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _scale = Tween<double>(begin: 0.7, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));
    _fade = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _ctrl, curve: const Interval(0, 0.5)));
    _ctrl.forward();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    final loggedIn = await StorageService.instance.isLoggedIn();
    if (!mounted) return;
    if (loggedIn) {
      final role = await StorageService.instance.getUserRole();
      Get.offAllNamed(role == 'rider' ? AppRoutes.riderHome : AppRoutes.home);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scale,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 100, height: 100,
                  decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(28)),
                  child: const Center(
                    child: Text('NK', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: AppColors.primary)),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('NKsereke', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.white, letterSpacing: -0.5)),
                const SizedBox(height: 6),
                const Text('Fast delivery, delivered.', style: TextStyle(fontSize: 14, color: Colors.white70, fontWeight: FontWeight.w400)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
