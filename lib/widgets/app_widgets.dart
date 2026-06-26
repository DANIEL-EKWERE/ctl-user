import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/app_utils.dart';

// ─── App Button ──────────────────────────────────────────────────────────────
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool loading;
  final Color? color;
  final double height;

  const AppButton({
    super.key,
    required this.label,
    this.onTap,
    this.loading = false,
    this.color,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
    height: height,
    width: double.infinity,
    child: ElevatedButton(
      onPressed: loading ? null : onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? AppColors.orange,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 3,
      ),
      child: loading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
    ),
  );
}

// ─── Outline Button ──────────────────────────────────────────────────────────
class AppOutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  const AppOutlineButton({super.key, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 50,
    width: double.infinity,
    child: OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.orange, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: AppColors.orange,
        ),
      ),
    ),
  );
}

// ─── Input Field ─────────────────────────────────────────────────────────────
class AppInput extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscure;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final Widget? suffix;
  final bool readOnly;

  const AppInput({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.obscure = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.suffix,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
      ),
      const SizedBox(height: 5),
      TextFormField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        validator: validator,
        onChanged: onChanged,
        readOnly: readOnly,
        style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
        decoration: InputDecoration(hintText: hint, suffixIcon: suffix),
      ),
    ],
  );
}

// ─── Network Image ───────────────────────────────────────────────────────────
class AppNetworkImage extends StatelessWidget {
  final String? url;
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final Widget? fallback;

  const AppNetworkImage({
    super.key,
    this.url,
    required this.width,
    required this.height,
    this.borderRadius,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    final br = borderRadius ?? BorderRadius.circular(12);
    if (url == null || url!.isEmpty) return fallback ?? _placeholder(br);
    return ClipRRect(
      borderRadius: br,
      child: CachedNetworkImage(
        imageUrl: url!,
        width: width,
        height: height,
        fit: BoxFit.cover,
        placeholder: (_, __) =>
            Container(width: width, height: height, color: AppColors.chipBg),
        errorWidget: (_, __, ___) => fallback ?? _placeholder(br),
      ),
    );
  }

  Widget _placeholder(BorderRadius br) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(color: AppColors.chipBg, borderRadius: br),
    child: const Icon(Icons.store_outlined, color: AppColors.textLight),
  );
}

// ─── Avatar Fallback ─────────────────────────────────────────────────────────
class AvatarFallback extends StatelessWidget {
  final String initials;
  final double size;
  final Color bg;
  final Color fg;
  final BorderRadius? borderRadius;

  const AvatarFallback({
    super.key,
    required this.initials,
    this.size = 44,
    this.bg = AppColors.orange,
    this.fg = AppColors.navy,
    this.borderRadius,
  });

  bool get _useLogo => initials == 'NK';

  @override
  Widget build(BuildContext context) {
    final br = borderRadius ?? BorderRadius.circular(11);
    return ClipRRect(
      borderRadius: br,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: bg, borderRadius: br),
        child: _useLogo
            ? Image.asset(
                'assets/images/logo.jpeg',
                fit: BoxFit.cover,
                width: size,
                height: size,
              )
            : Center(
                child: Text(
                  initials.substring(0, initials.length >= 2 ? 2 : 1),
                  style: TextStyle(
                    color: fg,
                    fontWeight: FontWeight.w800,
                    fontSize: size * 0.3,
                  ),
                ),
              ),
      ),
    );
  }
}

// ─── Status Badge ────────────────────────────────────────────────────────────
class StatusBadge extends StatelessWidget {
  final String status;
  const StatusBadge(this.status, {super.key});

  Color get _bg {
    switch (status) {
      case 'pending':
        return const Color(0xFFFFFBEB);
      case 'accepted':
      case 'preparing':
        return const Color(0xFFF5F3FF);
      case 'ready':
        return const Color(0xFFEFF6FF);
      case 'picked_up':
        return const Color(0xFFEFF6FF);
      case 'delivered':
        return const Color(0xFFF0FDF4);
      case 'cancelled':
        return const Color(0xFFFEF2F2);
      default:
        return const Color(0xFFFFFBEB);
    }
  }

  Color get _fg {
    switch (status) {
      case 'pending':
        return const Color(0xFFB45309);
      case 'accepted':
      case 'preparing':
        return const Color(0xFF6D28D9);
      case 'ready':
      case 'picked_up':
        return const Color(0xFF1D4ED8);
      case 'delivered':
        return const Color(0xFF15803D);
      case 'cancelled':
        return const Color(0xFFB91C1C);
      default:
        return const Color(0xFFB45309);
    }
  }

  Color get _border => _fg.withOpacity(0.3);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: _bg,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: _border),
    ),
    child: Text(
      AppUtils.statusLabel(status),
      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _fg),
    ),
  );
}

// ─── Empty State ─────────────────────────────────────────────────────────────
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? buttonLabel;
  final VoidCallback? onButton;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.buttonLabel,
    this.onButton,
  });

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 64, color: AppColors.textLight.withOpacity(0.5)),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
            ),
            textAlign: TextAlign.center,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (buttonLabel != null && onButton != null) ...[
            const SizedBox(height: 20),
            SizedBox(
              width: 180,
              child: AppButton(
                label: buttonLabel!,
                onTap: onButton,
                height: 44,
              ),
            ),
          ],
        ],
      ),
    ),
  );
}

// ─── Loading Overlay ─────────────────────────────────────────────────────────
class LoadingOverlay extends StatelessWidget {
  final bool loading;
  final Widget child;
  const LoadingOverlay({super.key, required this.loading, required this.child});

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      child,
      if (loading)
        const ColoredBox(
          color: Color(0x44000000),
          child: Center(
            child: CircularProgressIndicator(color: AppColors.orange),
          ),
        ),
    ],
  );
}

// ─── Orange Top Bar ──────────────────────────────────────────────────────────
class OrangeTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final List<Widget>? actions;

  const OrangeTopBar({
    super.key,
    required this.title,
    this.showBack = true,
    this.actions,
  });

  @override
  Widget build(BuildContext context) => AppBar(
    backgroundColor: AppColors.orange,
    title: Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    ),
    leading: showBack
        ? IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          )
        : null,
    automaticallyImplyLeading: showBack,
    actions: actions,
    elevation: 0,
  );

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// ─── Qty Row ─────────────────────────────────────────────────────────────────
class QtyRow extends StatelessWidget {
  final int qty;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const QtyRow({
    super.key,
    required this.qty,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      _qBtn(Icons.remove_rounded, onDecrement, AppColors.border),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          '$qty',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
      ),
      _qBtn(Icons.add_rounded, onIncrement, AppColors.orange),
    ],
  );

  Widget _qBtn(IconData ic, VoidCallback fn, Color bg) => GestureDetector(
    onTap: fn,
    child: Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: bg == AppColors.orange ? bg : null,
        border: bg != AppColors.orange ? Border.all(color: bg) : null,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Icon(
        ic,
        size: 14,
        color: bg == AppColors.orange ? Colors.white : AppColors.textPrimary,
      ),
    ),
  );
}
