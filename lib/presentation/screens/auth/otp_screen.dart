import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/controllers/auth_controller.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/storage_service.dart';
import '../../widgets/common/app_widgets.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final ctrl = Get.put(AuthController());
  final List<TextEditingController> _ctrls = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _nodes = List.generate(6, (_) => FocusNode());
  String _email = '';
  int _userId = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    _email = await StorageService.instance.getOtpEmail();
    _userId = await StorageService.instance.getOtpUserId();
    if (mounted) setState(() {});
  }

  String get _otp => _ctrls.map((c) => c.text).join();

  void _submit() {
    if (_otp.length == 6) ctrl.verifyOtp(userId: _userId, otp: _otp);
  }

  @override
  void dispose() {
    for (var c in _ctrls) c.dispose();
    for (var n in _nodes) n.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            GestureDetector(onTap: Get.back, child: const Icon(Icons.arrow_back_ios_new, size: 20)),
            const SizedBox(height: 32),
            const Text('Verify email', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            Text('Enter the 6-digit code sent to $_email', style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (i) => _OtpBox(
                controller: _ctrls[i],
                focusNode: _nodes[i],
                onChanged: (v) {
                  if (v.isNotEmpty && i < 5) _nodes[i + 1].requestFocus();
                  if (v.isEmpty && i > 0) _nodes[i - 1].requestFocus();
                  if (_otp.length == 6) _submit();
                },
              )),
            ),
            const SizedBox(height: 40),
            Obx(() => AppButton(label: 'Verify', isLoading: ctrl.isLoading.value, onTap: _submit)),
            const SizedBox(height: 24),
            Center(
              child: GestureDetector(
                onTap: () => ctrl.resendOtp(userId: _userId, email: _email),
                child: RichText(text: const TextSpan(
                  style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                  children: [
                    TextSpan(text: "Didn't receive code? "),
                    TextSpan(text: 'Resend', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary)),
                  ],
                )),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final void Function(String) onChanged;
  const _OtpBox({required this.controller, required this.focusNode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48, height: 56,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        maxLength: 1,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        onChanged: onChanged,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        decoration: InputDecoration(
          counterText: '',
          filled: true, fillColor: AppColors.grey50,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
