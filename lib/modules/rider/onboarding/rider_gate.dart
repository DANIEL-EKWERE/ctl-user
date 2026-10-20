import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/services/api_client.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/app_widgets.dart';
import '../../auth/auth_controller.dart';
import '../dashboard/rider_screens.dart';
import 'rider_onboarding_screen.dart';

/// Sends a logged-in rider to the right place based on their onboarding
/// state (backend logic):
///   can_access_dashboard  → dashboard
///   rider_status rejected → rejection screen (with reason)
///   rider_status blocked  → blocked screen
///   onboarding_step 3     → awaiting approval
///   onboarding_step 0/1/2 → onboarding step 1/2/3
///
/// The latest state is fetched from `rider/onboarding/status`; if that call
/// fails we fall back to the fields stored from the login user resource.
Future<void> routeRider() async {
  final auth = AuthController.to;
  final token = auth.riderToken;
  if (token == null) {
    Get.offAllNamed(AppRoutes.login);
    return;
  }

  final res = await ApiClient.instance.getRiderOnboardingStatus(token);
  if (res['success'] == true) await auth.applyRiderStatus(res['data']);

  final user = auth.riderUser;
  if (user == null) {
    Get.offAllNamed(AppRoutes.login);
    return;
  }

  final status = user.riderStatus?.toLowerCase();
  if (user.canAccessDashboard) {
    Get.offAllNamed(AppRoutes.riderShell);
  } else if (status == 'rejected') {
    Get.offAll(() => const RiderRejectedScreen());
  } else if (status == 'blocked') {
    Get.offAll(() => const RiderBlockedScreen());
  } else if (user.onboardingStep >= 3) {
    Get.offAll(() => const RiderAwaitingApprovalScreen());
  } else {
    Get.offAll(
      () => RiderOnboardingScreen(startStep: user.onboardingStep + 1),
    );
  }
}

// ─── Shared layout for the status screens ─────────────────────────────────────
class _RiderStatusScaffold extends StatefulWidget {
  final IconData icon;
  final Color tint;
  final String title;
  final String message;
  final Widget? extra;
  final String? primaryLabel;
  final Future<void> Function()? onPrimary;

  const _RiderStatusScaffold({
    required this.icon,
    required this.tint,
    required this.title,
    required this.message,
    this.extra,
    this.primaryLabel,
    this.onPrimary,
  });

  @override
  State<_RiderStatusScaffold> createState() => _RiderStatusScaffoldState();
}

class _RiderStatusScaffoldState extends State<_RiderStatusScaffold> {
  bool _checking = false;
  bool _busy = false;

  Future<void> _refresh() async {
    setState(() => _checking = true);
    await routeRider();
    if (mounted) setState(() => _checking = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.bg,
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: widget.tint.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(widget.icon, size: 40, color: widget.tint),
            ),
            const SizedBox(height: 20),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            if (widget.extra != null) ...[
              const SizedBox(height: 16),
              widget.extra!,
            ],
            const Spacer(),
            if (widget.primaryLabel != null) ...[
              AppButton(
                label: widget.primaryLabel!,
                loading: _busy,
                onTap: () async {
                  setState(() => _busy = true);
                  await widget.onPrimary?.call();
                  if (mounted) setState(() => _busy = false);
                },
              ),
              const SizedBox(height: 10),
            ],
            OutlinedButton(
              onPressed: _checking ? null : _refresh,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                side: const BorderSide(color: AppColors.border2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                _checking ? 'Checking…' : 'Check status',
                style: const TextStyle(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => Get.to(() => const RiderSupportScreen()),
                  child: const Text('Contact support'),
                ),
                const Text('·', style: TextStyle(color: AppColors.textLight)),
                TextButton(
                  onPressed: AuthController.to.logout,
                  child: const Text(
                    'Log out',
                    style: TextStyle(color: AppColors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

// ─── Awaiting approval (onboarding_step == 3) ────────────────────────────────
class RiderAwaitingApprovalScreen extends StatelessWidget {
  const RiderAwaitingApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) => const _RiderStatusScaffold(
    icon: Icons.hourglass_top_rounded,
    tint: AppColors.orange,
    title: 'Awaiting approval',
    message:
        "Thanks! We've received your details and documents. Our team is "
        "reviewing your application — you'll be able to start delivering as "
        'soon as it is approved.',
  );
}

// ─── Rejected ────────────────────────────────────────────────────────────────
class RiderRejectedScreen extends StatelessWidget {
  const RiderRejectedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reason = AuthController.to.riderUser?.rejectionReason;
    return _RiderStatusScaffold(
      icon: Icons.cancel_outlined,
      tint: AppColors.red,
      title: 'Application not approved',
      message:
          'Unfortunately your rider application was not approved. '
          'Review the reason below, update your details and resubmit.',
      extra: reason == null || reason.trim().isEmpty
          ? null
          : Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFECACA)),
              ),
              child: Text(
                'Reason: $reason',
                style: const TextStyle(color: AppColors.red, fontSize: 13),
              ),
            ),
      primaryLabel: 'Update details & resubmit',
      onPrimary: () async {
        Get.to(() => const RiderOnboardingScreen(startStep: 1));
      },
    );
  }
}

// ─── Blocked ─────────────────────────────────────────────────────────────────
class RiderBlockedScreen extends StatelessWidget {
  const RiderBlockedScreen({super.key});

  @override
  Widget build(BuildContext context) => const _RiderStatusScaffold(
    icon: Icons.block,
    tint: AppColors.red,
    title: 'Account blocked',
    message:
        'Your rider account has been blocked. Please contact support for '
        'more information.',
  );
}
