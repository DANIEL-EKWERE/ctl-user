// ─────────────────────────────────────────────────────────────────────────────
// App-wide constants
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';

class AppColors {
  static const primary     = Color(0xFFF5A623); // Orange
  static const primaryDark = Color(0xFFD4881A);
  static const secondary   = Color(0xFF1B3A6B); // Navy
  static const secondaryLt = Color(0xFF2A5299);
  static const success     = Color(0xFF27AE60);
  static const error       = Color(0xFFE74C3C);
  static const warning     = Color(0xFFF39C12);
  static const surface     = Color(0xFFF4F6F9);
  static const white       = Color(0xFFFFFFFF);
  static const inputBg     = Color(0xFFF7F9FC);
  static const chipBg      = Color(0xFFEDF2F7);
  static const text        = Color(0xFF1A202C);
  static const textLight   = Color(0xFF718096);
  static const textHint    = Color(0xFFA0AEC0);
  static const border      = Color(0xFFE2E8F0);
  static const border2     = Color(0xFFCBD5E0);
  // Status
  static const pendingBg   = Color(0xFFFFFBEB);
  static const pendingText = Color(0xFFB45309);
  static const doneBg      = Color(0xFFF0FDF4);
  static const doneText    = Color(0xFF15803D);
  static const cancelBg    = Color(0xFFFEF2F2);
  static const cancelText  = Color(0xFFB91C1C);
  // Gradients
  static const brandGradient  = LinearGradient(colors: [primary, Color(0xFFFF8C00)], begin: Alignment.topLeft, end: Alignment.bottomRight);
  static const navyGradient   = LinearGradient(colors: [secondary, secondaryLt], begin: Alignment.topLeft, end: Alignment.bottomRight);
  static const vendorGradient = LinearGradient(colors: [Color(0xFF2A5299), secondary], begin: Alignment.topLeft, end: Alignment.bottomRight);
  // Shadows
  static List<BoxShadow> get shadowSm => [const BoxShadow(color: Color(0x14000000), blurRadius: 4, offset: Offset(0, 1))];
  static List<BoxShadow> get shadowMd => [const BoxShadow(color: Color(0x1A000000), blurRadius: 12, offset: Offset(0, 4))];
}

class AppText {
  static const h1  = TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.text, letterSpacing: -.5);
  static const h2  = TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.text);
  static const h3  = TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.text);
  static const sub = TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.text);
  static const body= TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.text, height: 1.5);
  static const md  = TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.text, height: 1.4);
  static const cap = TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textLight);
  static const cap2= TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: AppColors.textLight);
  static const lbl = TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textLight, letterSpacing: .5);
  static const price= TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.primary);
  static const priceLg= TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: AppColors.white, letterSpacing: -.5);
  static const btn = TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.white);
  static const badge= TextStyle(fontSize: 11, fontWeight: FontWeight.w700);
}

const kBase = 'https://nksereke.elianaeliohotels.com/api';

String fmtPrice(double v) {
  final n = v.toStringAsFixed(0);
  final buf = StringBuffer();
  int c = 0;
  for (int i = n.length - 1; i >= 0; i--) {
    if (c > 0 && c % 3 == 0) buf.write(',');
    buf.write(n[i]);
    c++;
  }
  return '₦${buf.toString().split('').reversed.join()}';
}

Color statusColor(String s) {
  switch (s) {
    case 'pending':    return AppColors.warning;
    case 'accepted':
    case 'preparing': return const Color(0xFF6D28D9);
    case 'ready':
    case 'picked_up': return const Color(0xFF1D4ED8);
    case 'delivered': return AppColors.success;
    case 'cancelled': return AppColors.error;
    default:          return AppColors.textLight;
  }
}

Color statusBg(String s) {
  switch (s) {
    case 'pending':   return AppColors.pendingBg;
    case 'delivered': return AppColors.doneBg;
    case 'cancelled': return AppColors.cancelBg;
    default:          return const Color(0xFFEFF6FF);
  }
}

String statusLabel(String s) =>
    s.replaceAll('_', ' ').split(' ').map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}').join(' ');
