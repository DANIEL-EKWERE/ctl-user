// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../../core/theme/app_theme.dart';
// import '../../../routes/app_routes.dart';
// import '../../../widgets/app_widgets.dart';
// import '../auth_controller.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//   @override State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _emailCtrl = TextEditingController(text: '');
//   final _passCtrl  = TextEditingController(text: '');
//   bool _obscure = true;
//   final _ctrl = AuthController.to;

//   @override
//   void dispose() { _emailCtrl.dispose(); _passCtrl.dispose(); super.dispose(); }

//   @override
//   Widget build(BuildContext context) => Scaffold(
//     backgroundColor: AppColors.white,
//     body: Column(children: [
//       // Orange header
//       Container(
//         color: AppColors.orange,
//         padding: const EdgeInsets.fromLTRB(20, 60, 20, 28),
//         child: Column(children: [
//           Container(
//             width: double.infinity, height: 56,
//             decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(16)),
//             child: const Center(child:
//             Text('NK', style: TextStyle(color: AppColors.orange, fontSize: 18, fontWeight: FontWeight.w900),),
//             ),
//           ),
//           const SizedBox(height: 10),
//           const Text('NKsereke', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
//           const SizedBox(height: 4),
//           const Text('Your local delivery platform', style: TextStyle(color: Colors.white70, fontSize: 13)),
//         ]),
//       ),
//       // Form
//       Expanded(child: SingleChildScrollView(
//         padding: const EdgeInsets.all(24),
//         child: Obx(() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           const Text('Welcome back', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.navy)),
//           const Text('Sign in to your account', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
//           const SizedBox(height: 24),
//           AppInput(
//             label: 'Email address',
//             hint: 'you@example.com',
//             controller: _emailCtrl,
//             keyboardType: TextInputType.emailAddress,
//             onChanged: (v) => _ctrl.emailCtrl.value = v,
//           ),
//           const SizedBox(height: 14),
//           AppInput(
//             label: 'Password',
//             hint: '••••••••',
//             controller: _passCtrl,
//             obscure: _obscure,
//             onChanged: (v) => _ctrl.passCtrl.value = v,
//             suffix: IconButton(
//               icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, size: 20, color: AppColors.textSecondary),
//               onPressed: () => setState(() => _obscure = !_obscure),
//             ),
//           ),
//           Align(alignment: Alignment.centerRight,
//             child: TextButton(onPressed: () => Get.toNamed(AppRoutes.forgotPass),
//               child: const Text('Forgot password?', style: TextStyle(color: AppColors.orange, fontWeight: FontWeight.w600)))),
//           if (_ctrl.error.value != null) ...[
//             const SizedBox(height: 8),
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(color: const Color(0xFFFEF2F2), borderRadius: BorderRadius.circular(10),
//                   border: Border.all(color: const Color(0xFFFECACA))),
//               child: Text(_ctrl.error.value!, style: const TextStyle(color: Color(0xFFB91C1C), fontSize: 13)),
//             ),
//           ],
//           const SizedBox(height: 20),
//           AppButton(label: 'Sign In', loading: _ctrl.isLoading.value, onTap: () {
//             _ctrl.emailCtrl.value = _emailCtrl.text;
//             _ctrl.passCtrl.value  = _passCtrl.text;
//             _ctrl.login();
//           }),
//           const SizedBox(height: 16),
//           Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//             const Text("Don't have an account? ", style: TextStyle(color: AppColors.textSecondary)),
//             GestureDetector(onTap: () => Get.toNamed(AppRoutes.signup),
//               child: const Text('Sign up', style: TextStyle(color: AppColors.orange, fontWeight: FontWeight.w700))),
//           ]),
//         ])),
//       )),
//     ]),
//   );
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/app_widgets.dart';
import '../auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _ctrl = AuthController.to;
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  String _role = 'customer';

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _switchRole(String role) {
    setState(() => _role = role);
    // Pre-fill test credentials on switch
    if (role == 'customer') {
      _emailCtrl.text = 'adewale.ogunleye@gmail.com';
      _passCtrl.text = 'password';
    } else {
      _emailCtrl.text = 'taiwo.oduya@rider.com';
      _passCtrl.text = 'password';
    }
    _ctrl.emailCtrl.value = _emailCtrl.text;
    _ctrl.passCtrl.value = _passCtrl.text;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFE8ECF0),
    body: Center(
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              const BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 20,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              // Orange header
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.orange,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                padding: const EdgeInsets.fromLTRB(20, 36, 20, 28),
                child: Column(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.navy,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          const BoxShadow(
                            color: Color(0x33000000),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/images/logo.jpeg',
                          fit: BoxFit.contain,
                          width: 32,
                          height: 32,
                        ),
                        //   Text('NK',
                        //       style: TextStyle(color: AppColors.orange, fontSize: 24, fontWeight: FontWeight.w900)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'NKsereke',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Fast delivery, your way',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),

              // Form body
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome back!',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.navy,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Sign in to continue',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Role switcher
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.chipBg,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          children: [
                            _roleBtn(
                              'customer',
                              Icons.person_outline,
                              'Customer',
                            ),
                            _roleBtn(
                              'rider',
                              Icons.delivery_dining_outlined,
                              'Rider',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Email
                      const Text(
                        'Email address',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (v) => _ctrl.emailCtrl.value = v,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'you@example.com',
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Password
                      const Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _passCtrl,
                        obscureText: _obscure,
                        onChanged: (v) => _ctrl.passCtrl.value = v,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: '••••••••',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscure
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 20,
                              color: AppColors.textSecondary,
                            ),
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                          ),
                        ),
                      ),

                      // Error box
                      if (_ctrl.error.value != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF2F2),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFFECACA)),
                          ),
                          child: Text(
                            _ctrl.error.value!,
                            style: const TextStyle(
                              color: AppColors.red,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),

                      // Sign in button
                      AppButton(
                        label: 'Sign In',
                        loading: _ctrl.isLoading.value,
                        onTap: () {
                          _ctrl.emailCtrl.value = _emailCtrl.text;
                          _ctrl.passCtrl.value = _passCtrl.text;
                          _ctrl.login();
                        },
                      ),
                      const SizedBox(height: 14),

                      // Forgot password
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => Get.toNamed(AppRoutes.forgotPass),
                          child: const Text(
                            'Forgot password?',
                            style: TextStyle(
                              color: AppColors.orange,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Sign up
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account? ",
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Get.toNamed(AppRoutes.signup),
                            child: const Text(
                              'Sign up',
                              style: TextStyle(
                                color: AppColors.orange,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _roleBtn(String value, IconData icon, String label) => Expanded(
    child: GestureDetector(
      onTap: () => _switchRole(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: _role == value ? AppColors.navy : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: _role == value
              ? [
                  const BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: _role == value ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: _role == value ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
