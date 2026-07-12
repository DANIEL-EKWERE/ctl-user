import 'dart:developer' as myLog;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../widgets/app_widgets.dart';
import '../auth_controller.dart';

// ─── Verify Email ─────────────────────────────────────────────────────────────
class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});
  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final _ctrl = AuthController.to;
  final _otpCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.white,
    appBar: OrangeTopBar(title: 'Verify Email'),
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.mark_email_read_outlined,
              size: 56,
              color: AppColors.orange,
            ),
            const SizedBox(height: 16),
            const Text(
              'Check your email',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'We sent a 6-digit code to ${_ctrl.pendingEmail ?? 'your email'}',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 28),
            AppInput(
              label: 'OTP Code',
              hint: '000000',
              controller: _otpCtrl,
              keyboardType: TextInputType.number,
            ),
            if (_ctrl.error.value != null) ...[
              const SizedBox(height: 12),
              Text(
                _ctrl.error.value!,
                style: const TextStyle(color: AppColors.red, fontSize: 13),
              ),
            ],
            const SizedBox(height: 20),
            AppButton(
              label: 'Verify Email',
              loading: _ctrl.isLoading.value,
              onTap: () {
                myLog.log('Verifying email with OTP: ${_otpCtrl.text.trim()}');
                _ctrl.verifyEmail(_otpCtrl.text.trim());
              },
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: _ctrl.resendOtp,
                child: const Text(
                  'Resend OTP',
                  style: TextStyle(
                    color: AppColors.orange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// ─── Forgot Password ──────────────────────────────────────────────────────────
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _ctrl = AuthController.to;
  final _emailCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  final _newPassCtrl = TextEditingController();
  final _confPassCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.white,
    appBar: OrangeTopBar(title: 'Reset Password'),
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Obx(() {
        final step = _ctrl.forgotStep.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (step == 1) ...[
              const Text(
                'Forgot password?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter your email and we\'ll send a reset code',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              AppInput(
                label: 'Email address',
                hint: 'you@example.com',
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                onChanged: (v) => _ctrl.forgotEmail.value = v,
              ),
              const SizedBox(height: 20),
              AppButton(
                label: 'Send Reset Code',
                loading: _ctrl.isLoading.value,
                onTap: _ctrl.forgotPassword,
              ),
            ] else ...[
              const Text(
                'Reset your password',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 24),
              AppInput(
                label: 'Reset Code',
                hint: '000000',
                controller: _codeCtrl,
                keyboardType: TextInputType.number,
                onChanged: (v) => _ctrl.forgotCode.value = v,
              ),
              const SizedBox(height: 14),
              AppInput(
                label: 'New password',
                hint: 'Minimum 8 characters',
                controller: _newPassCtrl,
                obscure: true,
                onChanged: (v) => _ctrl.forgotNewPass.value = v,
              ),
              const SizedBox(height: 14),
              AppInput(
                label: 'Confirm new password',
                hint: 'Repeat password',
                controller: _confPassCtrl,
                obscure: true,
                onChanged: (v) => _ctrl.forgotConfPass.value = v,
              ),
              const SizedBox(height: 20),
              AppButton(
                label: 'Reset Password',
                loading: _ctrl.isLoading.value,
                onTap: _ctrl.resetPassword,
              ),
            ],
            if (_ctrl.error.value != null) ...[
              const SizedBox(height: 12),
              Text(
                _ctrl.error.value!,
                style: const TextStyle(color: AppColors.red, fontSize: 13),
              ),
            ],
          ],
        );
      }),
    ),
  );
}
