import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../core/api.dart';
import '../core/constants.dart';
import '../core/models.dart';
import '../shared/widgets.dart';

// ══════════════════════════════════════════════════════════════════════════════
// SPLASH
// ══════════════════════════════════════════════════════════════════════════════
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override State<SplashScreen> createState() => _SplashState();
}
class _SplashState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _check();
  }
  Future<void> _check() async {
    await Future.delayed(const Duration(milliseconds: 800));
    final token = await Api().getToken();
    if (!mounted) return;
    if (token != null) {
      try {
        final res = await Api().get(Ep.profile);
        final user = UserModel.fromJson(res.data['user']);
        Navigator.pushReplacementNamed(context, user.isRider ? '/rider' : '/customer');
        return;
      } catch (_) {
        await Api().clearToken();
      }
    }
    Navigator.pushReplacementNamed(context, '/login');
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.primary,
    body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 72, height: 72, decoration: BoxDecoration(
        color: AppColors.secondary, borderRadius: BorderRadius.circular(20)),
        child: Center(child: Text('NK', style: AppText.h1.copyWith(color: AppColors.primary)))),
      const SizedBox(height: 16),
      Text('NKsereke', style: AppText.h2.copyWith(color: AppColors.white)),
      const SizedBox(height: 4),
      Text('Fast delivery, your way', style: AppText.cap.copyWith(color: AppColors.white.withOpacity(.85))),
      const SizedBox(height: 40),
      const CircularProgressIndicator(color: AppColors.white),
    ])),
  );
}

// ══════════════════════════════════════════════════════════════════════════════
// LOGIN
// ══════════════════════════════════════════════════════════════════════════════
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override State<LoginScreen> createState() => _LoginState();
}
class _LoginState extends State<LoginScreen> {
  final _email = TextEditingController(text: '');
  final _pass  = TextEditingController(text: '');
  bool _loading = false, _showPass = false;
  String? _err;

  Future<void> _login() async {
    if (_email.text.isEmpty || _pass.text.isEmpty) {
      setState(() => _err = 'Please enter email and password');
      return;
    }
    setState(() { _loading = true; _err = null; });
    try {
      final res = await Api().post(Ep.login, data: {'email': _email.text.trim(), 'password': _pass.text});
      final token = res.data['token'] as String;
      final user  = UserModel.fromJson(res.data['user']);
      await Api().saveToken(token);
      if (!mounted) return;
      if (!user.isEmailVerified) {
        Navigator.pushNamed(context, '/verify-email', arguments: {'email': user.email, 'user_id': user.id});
        return;
      }
      Navigator.pushReplacementNamed(context, user.isRider ? '/rider' : '/customer');
    } on DioException catch (e) {
      setState(() => _err = e.response?.data['message'] ?? 'Login failed');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.white,
    body: SafeArea(child: SingleChildScrollView(child: Column(children: [
      // Orange header with logo
      Container(padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
        color: AppColors.primary, width: double.infinity,
        child: Column(children: [
          Container(width: 64, height: 64,
            decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(18)),
            child: Center(child: Text('NK', style: AppText.h2.copyWith(color: AppColors.primary, fontWeight: FontWeight.w900)))),
          const SizedBox(height: 12),
          Text('NKsereke', style: AppText.h2.copyWith(color: AppColors.white)),
          Text('Fast delivery, your way', style: AppText.cap.copyWith(color: AppColors.white.withOpacity(.85))),
        ])),
      // Form
      Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Welcome back!', style: AppText.h3),
        const SizedBox(height: 4),
        Text('Sign in to your account', style: AppText.cap),
        const SizedBox(height: 24),
        NKField(label: 'Email address', hint: 'your@email.com', keyboardType: TextInputType.emailAddress, controller: _email),
        NKField(label: 'Password', hint: 'Your password', obscure: !_showPass, controller: _pass,
          suffix: IconButton(icon: Icon(_showPass ? Icons.visibility_off : Icons.visibility, size: 18, color: AppColors.textLight),
            onPressed: () => setState(() => _showPass = !_showPass))),
        if (_err != null) Container(margin: const EdgeInsets.only(bottom: 14), padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: AppColors.cancelBg, borderRadius: BorderRadius.circular(10)),
          child: Text(_err!, style: AppText.cap.copyWith(color: AppColors.error))),
        NKBtn(label: 'Sign In', onTap: _login, loading: _loading),
        const SizedBox(height: 16),
        Center(child: GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/forgot-password'),
          child: Text('Forgot password?', style: AppText.cap.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)))),
        const SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text("Don't have an account? ", style: AppText.cap),
          GestureDetector(onTap: () => Navigator.pushNamed(context, '/signup'),
            child: Text('Sign up', style: AppText.cap.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700))),
        ]),
      ])),
    ]))),
  );
}

// ══════════════════════════════════════════════════════════════════════════════
// SIGNUP
// ══════════════════════════════════════════════════════════════════════════════
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override State<SignupScreen> createState() => _SignupState();
}
class _SignupState extends State<SignupScreen> {
  final _name  = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _pass  = TextEditingController();
  final _conf  = TextEditingController();
  final _ref   = TextEditingController();
  String _role = 'customer';
  bool _loading = false;
  String? _err;

  Future<void> _signup() async {
    if (_name.text.isEmpty || _email.text.isEmpty || _pass.text.isEmpty) {
      setState(() => _err = 'Please fill all required fields'); return;
    }
    if (_pass.text != _conf.text) {
      setState(() => _err = 'Passwords do not match'); return;
    }
    setState(() { _loading = true; _err = null; });
    try {
      final res = await Api().post(Ep.register, data: {
        'name': _name.text.trim(), 'email': _email.text.trim(),
        'phone': _phone.text.trim(), 'password': _pass.text, 'role': _role,
        if (_ref.text.isNotEmpty) 'referral_code': _ref.text.trim(),
      });
      final userId = res.data['user_id'] ?? res.data['user']?['id'];
      if (!mounted) return;
      Navigator.pushNamed(context, '/verify-email', arguments: {
        'email': _email.text.trim(), 'user_id': userId,
      });
    } on DioException catch (e) {
      setState(() => _err = e.response?.data['message'] ?? 'Registration failed');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.white,
    appBar: const NKBar(title: 'Create Account'),
    body: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(children: [
      // Role toggle
      Container(margin: const EdgeInsets.only(bottom: 20), padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(color: AppColors.chipBg, borderRadius: BorderRadius.circular(12)),
        child: Row(children: [
          _roleBtn('customer', '👤 Customer'),
          _roleBtn('rider',    '🏍️ Rider'),
        ])),
      NKField(label: 'Full name *', hint: 'e.g. Emeka Okafor', controller: _name),
      NKField(label: 'Email address *', hint: 'your@email.com', keyboardType: TextInputType.emailAddress, controller: _email),
      NKField(label: 'Phone number', hint: '08012345678', keyboardType: TextInputType.phone, controller: _phone),
      NKField(label: 'Password *', hint: 'Minimum 8 characters', obscure: true, controller: _pass),
      NKField(label: 'Confirm password *', hint: 'Repeat your password', obscure: true, controller: _conf),
      NKField(label: 'Referral code (optional)', hint: 'e.g. NK2F8A', controller: _ref),
      if (_err != null) Container(margin: const EdgeInsets.only(bottom: 14), padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppColors.cancelBg, borderRadius: BorderRadius.circular(10)),
        child: Text(_err!, style: AppText.cap.copyWith(color: AppColors.error))),
      NKBtn.navy(label: 'Create Account', onTap: _signup, loading: _loading),
      const SizedBox(height: 16),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text('Already have an account? ', style: AppText.cap),
        GestureDetector(onTap: () => Navigator.pop(context),
          child: Text('Sign in', style: AppText.cap.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700))),
      ]),
    ])),
  );

  Widget _roleBtn(String role, String label) => Expanded(child: GestureDetector(
    onTap: () => setState(() => _role = role),
    child: AnimatedContainer(duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(color: _role == role ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(9)),
      child: Center(child: Text(label, style: AppText.md.copyWith(
        color: _role == role ? AppColors.white : AppColors.textLight,
        fontWeight: FontWeight.w700))))));
}

// ══════════════════════════════════════════════════════════════════════════════
// VERIFY EMAIL (6-digit OTP)
// ══════════════════════════════════════════════════════════════════════════════
class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});
  @override State<VerifyEmailScreen> createState() => _VerifyEmailState();
}
class _VerifyEmailState extends State<VerifyEmailScreen> {
  final _controllers = List.generate(6, (_) => TextEditingController());
  final _focuses     = List.generate(6, (_) => FocusNode());
  late String _email;
  late int    _userId;
  bool _loading = false;
  String? _err;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>;
    _email  = args['email'] as String;
    _userId = args['user_id'] as int;
    WidgetsBinding.instance.addPostFrameCallback((_) => _focuses[0].requestFocus());
  }

  Future<void> _submit() async {
    final otp = _controllers.map((c) => c.text).join();
    if (otp.length < 6) { setState(() => _err = 'Please enter the 6-digit code'); return; }
    setState(() { _loading = true; _err = null; });
    try {
      final res = await Api().post(Ep.verifyEmail, data: {'user_id': _userId, 'otp': otp});
      final token = res.data['token'] as String;
      final user  = UserModel.fromJson(res.data['user']);
      await Api().saveToken(token);
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, user.isRider ? '/rider' : '/customer');
    } on DioException catch (e) {
      setState(() => _err = e.response?.data['message'] ?? 'Invalid OTP');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _resend() async {
    try {
      await Api().post(Ep.resendOtp, data: {'user_id': _userId, 'email': _email});
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Code resent ✓'), backgroundColor: AppColors.success));
    } catch (_) {}
  }

  void _onDigit(int idx, String val) {
    if (val.length == 1 && idx < 5) _focuses[idx + 1].requestFocus();
    if (val.isEmpty && idx > 0)     _focuses[idx - 1].requestFocus();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.white,
    appBar: const NKBar(title: 'Verify Email'),
    body: Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      const SizedBox(height: 16),
      const Text('📧', style: TextStyle(fontSize: 56)),
      const SizedBox(height: 16),
      Text('Check your email', style: AppText.h3),
      const SizedBox(height: 8),
      Text('We sent a 6-digit code to', style: AppText.cap),
      const SizedBox(height: 2),
      Text(_email, style: AppText.md.copyWith(fontWeight: FontWeight.w700, color: AppColors.secondary)),
      const SizedBox(height: 32),
      // OTP boxes
      Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(6, (i) =>
        Container(
          width: 44, height: 54, margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            border: Border.all(color: _controls[i].text.isNotEmpty ? AppColors.primary : AppColors.border, width: 2),
            borderRadius: BorderRadius.circular(12),
            color: AppColors.inputBg,
          ),
          child: TextField(
            controller: _controllers[i], focusNode: _focuses[i],
            textAlign: TextAlign.center, keyboardType: TextInputType.number,
            maxLength: 1, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            decoration: const InputDecoration(counterText: '', border: InputBorder.none),
            onChanged: (v) => _onDigit(i, v),
          ),
        ))),
      const SizedBox(height: 24),
      if (_err != null) Container(margin: const EdgeInsets.only(bottom: 14), padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppColors.cancelBg, borderRadius: BorderRadius.circular(10)),
        child: Text(_err!, style: AppText.cap.copyWith(color: AppColors.error))),
      NKBtn(label: 'Verify Email', onTap: _submit, loading: _loading),
      const SizedBox(height: 20),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text("Didn't receive the code? ", style: AppText.cap),
        GestureDetector(onTap: _resend,
          child: Text('Resend', style: AppText.cap.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700))),
      ]),
    ])),
  );

  List<TextEditingController> get _controls => _controllers;
}

// ══════════════════════════════════════════════════════════════════════════════
// FORGOT PASSWORD (3 steps)
// ══════════════════════════════════════════════════════════════════════════════
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override State<ForgotPasswordScreen> createState() => _ForgotState();
}
class _ForgotState extends State<ForgotPasswordScreen> {
  int    _step = 1;
  final _emailCtrl    = TextEditingController();
  final _codeCtrl     = TextEditingController();
  final _newPassCtrl  = TextEditingController();
  final _confPassCtrl = TextEditingController();
  bool   _loading = false;
  String? _err;

  Future<void> _step1() async {
    if (_emailCtrl.text.isEmpty) { setState(() => _err = 'Enter your email'); return; }
    setState(() { _loading = true; _err = null; });
    try {
      await Api().post(Ep.forgotPass, data: {'email': _emailCtrl.text.trim()});
      setState(() => _step = 2);
    } on DioException catch (e) {
      setState(() => _err = e.response?.data['message'] ?? 'Error');
    } finally { if (mounted) setState(() => _loading = false); }
  }

  Future<void> _step2() async {
    if (_codeCtrl.text.isEmpty) { setState(() => _err = 'Enter the code'); return; }
    setState(() { _loading = true; _err = null; });
    try {
      await Api().post(Ep.verifyCode, data: {'email': _emailCtrl.text.trim(), 'code': _codeCtrl.text.trim()});
      setState(() => _step = 3);
    } on DioException catch (e) {
      setState(() => _err = e.response?.data['message'] ?? 'Invalid code');
    } finally { if (mounted) setState(() => _loading = false); }
  }

  Future<void> _step3() async {
    if (_newPassCtrl.text != _confPassCtrl.text) { setState(() => _err = 'Passwords do not match'); return; }
    setState(() { _loading = true; _err = null; });
    try {
      await Api().post(Ep.resetPass, data: {
        'email': _emailCtrl.text.trim(), 'code': _codeCtrl.text.trim(),
        'password': _newPassCtrl.text, 'password_confirmation': _confPassCtrl.text,
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Password reset! Please sign in.'), backgroundColor: AppColors.success));
      Navigator.pushReplacementNamed(context, '/login');
    } on DioException catch (e) {
      setState(() => _err = e.response?.data['message'] ?? 'Reset failed');
    } finally { if (mounted) setState(() => _loading = false); }
  }

  @override
  Widget build(BuildContext context) {
    final steps = ['Email', 'Code', 'New Password'];
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: NKBar(title: 'Forgot Password', canPop: _step == 1),
      body: SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(children: [
        // Step indicator
        Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(3, (i) => Row(children: [
          Container(width: 28, height: 28, decoration: BoxDecoration(
            color: i < _step ? AppColors.primary : i == _step - 1 ? AppColors.primary : AppColors.chipBg,
            shape: BoxShape.circle),
            child: Center(child: Text('${i+1}', style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w700,
              color: i + 1 <= _step ? AppColors.white : AppColors.textLight)))),
          if (i < 2) Container(width: 32, height: 2, color: i + 1 < _step ? AppColors.primary : AppColors.border),
        ]))),
        const SizedBox(height: 8),
        Text(steps[_step - 1], style: AppText.sub),
        const SizedBox(height: 28),
        if (_step == 1) ...[
          const Text('📧', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text('Enter your email address and we\'ll send a reset code.', style: AppText.cap, textAlign: TextAlign.center),
          const SizedBox(height: 20),
          NKField(label: 'Email address', hint: 'your@email.com', keyboardType: TextInputType.emailAddress, controller: _emailCtrl),
        ] else if (_step == 2) ...[
          const Text('🔢', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text('Enter the 6-digit code sent to ${_emailCtrl.text}', style: AppText.cap, textAlign: TextAlign.center),
          const SizedBox(height: 20),
          NKField(label: 'Reset code', hint: 'Enter 6-digit code', keyboardType: TextInputType.number, controller: _codeCtrl),
        ] else ...[
          const Text('🔑', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          const Text('Choose a strong new password', style: AppText.cap),
          const SizedBox(height: 20),
          NKField(label: 'New password', hint: 'Minimum 8 characters', obscure: true, controller: _newPassCtrl),
          NKField(label: 'Confirm new password', hint: 'Repeat new password', obscure: true, controller: _confPassCtrl),
        ],
        if (_err != null) Container(margin: const EdgeInsets.only(bottom: 14), padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: AppColors.cancelBg, borderRadius: BorderRadius.circular(10)),
          child: Text(_err!, style: AppText.cap.copyWith(color: AppColors.error))),
        NKBtn(label: _step == 1 ? 'Send Code' : _step == 2 ? 'Verify Code' : 'Reset Password',
          onTap: _step == 1 ? _step1 : _step == 2 ? _step2 : _step3, loading: _loading),
      ])),
    );
  }
}
