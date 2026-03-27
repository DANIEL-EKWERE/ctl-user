import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/constants.dart';
import '../core/models.dart';

// ── Primary button ────────────────────────────────────────────────────────────
class NKBtn extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool loading;
  final double height;
  final Color bg, fg;
  final bool outlined;
  const NKBtn({super.key, required this.label, this.onTap, this.loading = false,
    this.height = 52, this.bg = AppColors.primary, this.fg = AppColors.white,
    this.outlined = false});
  factory NKBtn.navy({Key? key, required String label, VoidCallback? onTap, bool loading = false}) =>
      NKBtn(key: key, label: label, onTap: onTap, loading: loading, bg: AppColors.secondary);
  factory NKBtn.outline({Key? key, required String label, VoidCallback? onTap}) =>
      NKBtn(key: key, label: label, onTap: onTap, bg: AppColors.white, fg: AppColors.primary, outlined: true);
  factory NKBtn.green({Key? key, required String label, VoidCallback? onTap}) =>
      NKBtn(key: key, label: label, onTap: onTap, bg: AppColors.success);
  factory NKBtn.red({Key? key, required String label, VoidCallback? onTap}) =>
      NKBtn(key: key, label: label, onTap: onTap, bg: AppColors.error);
  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity, height: height,
    child: Material(
      color: outlined ? Colors.transparent : bg,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: (loading || onTap == null) ? null : onTap,
        child: Container(
          decoration: outlined ? BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.primary, width: 2)) : null,
          child: Center(child: loading
              ? SizedBox(width: 20, height: 20,
                  child: CircularProgressIndicator(color: fg, strokeWidth: 2.5))
              : Text(label, style: AppText.btn.copyWith(color: fg))),
        ),
      ),
    ),
  );
}

// ── Text field ────────────────────────────────────────────────────────────────
class NKField extends StatelessWidget {
  final String label, hint;
  final bool obscure, enabled;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final Widget? suffix;
  final int maxLines;
  const NKField({super.key, required this.label, this.hint = '', this.obscure = false,
    this.enabled = true, this.keyboardType = TextInputType.text,
    this.controller, this.validator, this.onChanged, this.suffix, this.maxLines = 1});
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(label, style: AppText.cap.copyWith(fontWeight: FontWeight.w600)),
    const SizedBox(height: 6),
    TextFormField(
      controller: controller, obscureText: obscure, enabled: enabled,
      keyboardType: keyboardType, validator: validator, onChanged: onChanged,
      maxLines: maxLines,
      style: AppText.body,
      decoration: InputDecoration(
        hintText: hint, filled: true, fillColor: AppColors.inputBg,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border, width: 1.5)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border, width: 1.5)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
        suffixIcon: suffix,
        hintStyle: AppText.cap2.copyWith(color: AppColors.textHint),
      ),
    ),
    const SizedBox(height: 14),
  ]);
}

// ── App bar ───────────────────────────────────────────────────────────────────
class NKBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool canPop;
  const NKBar({super.key, required this.title, this.actions, this.canPop = true});
  @override Size get preferredSize => const Size.fromHeight(56);
  @override
  Widget build(BuildContext context) => AppBar(
    backgroundColor: AppColors.secondary,
    title: Text(title, style: AppText.sub.copyWith(color: AppColors.white)),
    leading: canPop ? IconButton(icon: const Icon(Icons.arrow_back_ios, color: AppColors.white, size: 18),
      onPressed: () => Navigator.pop(context)) : null,
    automaticallyImplyLeading: canPop,
    actions: actions,
  );
}

// ── Card ──────────────────────────────────────────────────────────────────────
class NKCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? margin, padding;
  const NKCard({super.key, required this.child, this.onTap, this.margin, this.padding});
  @override
  Widget build(BuildContext context) => Container(
    margin: margin ?? const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
    decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.border), boxShadow: AppColors.shadowSm),
    child: Material(color: Colors.transparent, borderRadius: BorderRadius.circular(16),
      child: InkWell(borderRadius: BorderRadius.circular(16), onTap: onTap,
        child: Padding(padding: padding ?? const EdgeInsets.all(14), child: child))));
}

// ── Status badge ──────────────────────────────────────────────────────────────
class StatusBadge extends StatelessWidget {
  final String status;
  const StatusBadge({super.key, required this.status});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(color: statusBg(status), borderRadius: BorderRadius.circular(20),
      border: Border.all(color: statusColor(status).withOpacity(.3))),
    child: Text(statusLabel(status), style: AppText.badge.copyWith(color: statusColor(status))));
}

// ── Cart badge ────────────────────────────────────────────────────────────────
class CartBadge extends StatelessWidget {
  final int count;
  final VoidCallback onTap;
  const CartBadge({super.key, required this.count, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Stack(children: [
      const Padding(padding: EdgeInsets.all(4),
        child: Icon(Icons.shopping_bag_outlined, color: AppColors.white, size: 24)),
      if (count > 0) Positioned(top: 0, right: 0,
        child: Container(width: 16, height: 16,
          decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
          child: Center(child: Text('$count',
            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white))))),
    ]),
  );
}

// ── Bottom nav ────────────────────────────────────────────────────────────────
class NKNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavigationBarItem> items;
  const NKNav({super.key, required this.currentIndex, required this.onTap, required this.items});
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: AppColors.white,
      border: Border(top: BorderSide(color: AppColors.border)),
      boxShadow: AppColors.shadowMd),
    child: BottomNavigationBar(
      currentIndex: currentIndex, onTap: onTap, items: items,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.transparent, elevation: 0,
      selectedItemColor: AppColors.primary, unselectedItemColor: AppColors.textLight,
      selectedLabelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.w700),
      unselectedLabelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 10)));
}

// ── Section header ────────────────────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;
  const SectionHeader({super.key, required this.title, this.action, this.onAction});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(title, style: AppText.sub),
      if (action != null)
        GestureDetector(onTap: onAction,
          child: Text(action!, style: AppText.cap.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700))),
    ]),
  );
}

// ── Vendor card ───────────────────────────────────────────────────────────────
class VendorCard extends StatelessWidget {
  final VendorModel vendor;
  final VoidCallback onTap;
  const VendorCard({super.key, required this.vendor, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border), boxShadow: AppColors.shadowSm),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Banner
        ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
          child: SizedBox(height: 90, width: double.infinity,
            child: vendor.bannerUrl != null
                ? CachedNetworkImage(imageUrl: vendor.bannerUrl!, fit: BoxFit.cover,
                    errorWidget: (_,__,___) => _bannerFallback())
                : _bannerFallback())),
        // Info
        Padding(padding: const EdgeInsets.all(12), child: Row(children: [
          // Logo
          ClipRRect(borderRadius: BorderRadius.circular(10),
            child: vendor.logoUrl.isNotEmpty
                ? CachedNetworkImage(imageUrl: vendor.logoUrl, width: 44, height: 44, fit: BoxFit.cover,
                    errorWidget: (_,__,___) => _logoFb())
                : _logoFb()),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(vendor.name, style: AppText.sub.copyWith(fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Row(children: [
              const Icon(Icons.star_rounded, size: 13, color: AppColors.primary),
              const SizedBox(width: 2),
              Text(vendor.rating.toStringAsFixed(1), style: AppText.cap2.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
              if (vendor.totalRatings > 0) Text(' (${vendor.totalRatings})', style: AppText.cap2),
              if (vendor.distanceKm != null) ...[
                const SizedBox(width: 8),
                const Icon(Icons.place_outlined, size: 11, color: AppColors.textLight),
                Text(vendor.distanceLabel, style: AppText.cap2),
              ],
            ]),
            if (vendor.address.isNotEmpty)
              Text(vendor.address, style: AppText.cap2, maxLines: 1, overflow: TextOverflow.ellipsis),
          ])),
          Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: vendor.isOpen ? AppColors.doneBg : AppColors.cancelBg,
              borderRadius: BorderRadius.circular(20)),
            child: Text(vendor.isOpen ? 'Open' : 'Closed', style: AppText.badge.copyWith(
              fontSize: 10, color: vendor.isOpen ? AppColors.doneText : AppColors.cancelText))),
        ])),
      ]),
    ),
  );
  Widget _bannerFallback() => Container(decoration: const BoxDecoration(gradient: AppColors.vendorGradient),
    child: const Center(child: Text('🍽️', style: TextStyle(fontSize: 32))));
  Widget _logoFb() => Container(width: 44, height: 44, color: AppColors.primary,
    child: Center(child: Text(vendor.initials, style: AppText.sub.copyWith(color: AppColors.secondary, fontSize: 13))));
}

// ── Product card ──────────────────────────────────────────────────────────────
class ProductCard extends StatelessWidget {
  final ProductModel product;
  final int cartQty;
  final VoidCallback onAdd, onIncrement, onDecrement;
  const ProductCard({super.key, required this.product, required this.cartQty,
    required this.onAdd, required this.onIncrement, required this.onDecrement});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: const BoxDecoration(color: AppColors.white,
      border: Border(bottom: BorderSide(color: AppColors.border))),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Image
      ClipRRect(borderRadius: BorderRadius.circular(10),
        child: product.imageUrl.isNotEmpty
            ? CachedNetworkImage(imageUrl: product.imageUrl, width: 72, height: 72, fit: BoxFit.cover,
                errorWidget: (_,__,___) => _imgFb())
            : _imgFb()),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(product.name, style: AppText.sub.copyWith(fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
        if (product.description != null) ...[
          const SizedBox(height: 3),
          Text(product.description!, style: AppText.cap2, maxLines: 2, overflow: TextOverflow.ellipsis),
        ],
        const SizedBox(height: 8),
        Row(children: [
          Text(fmtPrice(product.effectivePrice), style: AppText.price),
          if (product.hasDiscount) ...[
            const SizedBox(width: 6),
            Text(fmtPrice(product.price), style: AppText.cap2.copyWith(decoration: TextDecoration.lineThrough)),
          ],
        ]),
      ])),
      // Qty control
      if (!product.isInStock)
        const Padding(padding: EdgeInsets.only(top: 4),
          child: Text('Out of stock', style: TextStyle(fontSize: 10, color: AppColors.error)))
      else if (cartQty == 0)
        GestureDetector(onTap: onAdd,
          child: Container(width: 32, height: 32, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(9)),
            child: const Icon(Icons.add, color: Colors.white, size: 18)))
      else
        Row(children: [
          _qBtn(Icons.remove, onDecrement),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text('$cartQty', style: AppText.sub.copyWith(fontSize: 15))),
          _qBtn(Icons.add, onIncrement),
        ]),
    ]),
  );
  Widget _imgFb() => Container(width: 72, height: 72, decoration: BoxDecoration(
    color: const Color(0xFFFFF5E6), borderRadius: BorderRadius.circular(10)),
    child: const Center(child: Text('🍽️', style: TextStyle(fontSize: 28))));
  Widget _qBtn(IconData icon, VoidCallback onTap) => GestureDetector(onTap: onTap,
    child: Container(width: 28, height: 28,
      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
      child: Icon(icon, color: Colors.white, size: 14)));
}

// ── Wallet tx tile ────────────────────────────────────────────────────────────
class TxTile extends StatelessWidget {
  final WalletTransaction tx;
  const TxTile({super.key, required this.tx});
  @override
  Widget build(BuildContext context) => Container(
    color: AppColors.white, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(children: [
      Container(width: 40, height: 40, decoration: BoxDecoration(
        color: tx.type == 'credit' ? AppColors.doneBg : AppColors.cancelBg,
        borderRadius: BorderRadius.circular(12)),
        child: Center(child: Text(tx.type == 'credit' ? '💰' : '🛍️', style: const TextStyle(fontSize: 18)))),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(tx.description.isNotEmpty ? tx.description : tx.category,
          style: AppText.md.copyWith(fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
        Text(tx.date.length > 10 ? tx.date.substring(0, 10) : tx.date, style: AppText.cap2),
      ])),
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text('${tx.type == 'credit' ? '+' : '-'}${fmtPrice(tx.amount)}',
          style: AppText.sub.copyWith(fontSize: 14,
            color: tx.type == 'credit' ? AppColors.success : AppColors.error)),
        Text('Bal: ${fmtPrice(tx.balanceAfter)}', style: AppText.cap2),
      ]),
    ]),
  );
}

// ── Pin dialog ────────────────────────────────────────────────────────────────
class PinDialog extends StatefulWidget {
  final String title;
  final void Function(String) onConfirm;
  const PinDialog({super.key, required this.title, required this.onConfirm});
  @override State<PinDialog> createState() => _PinDialogState();
}

class _PinDialogState extends State<PinDialog> {
  final _ctrl = TextEditingController();
  bool _show = false;
  @override
  Widget build(BuildContext context) => AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    title: Text(widget.title, style: AppText.sub),
    content: Column(mainAxisSize: MainAxisSize.min, children: [
      const Text('Enter your 4-digit transaction PIN', style: AppText.md),
      const SizedBox(height: 14),
      TextField(
        controller: _ctrl, obscureText: !_show,
        keyboardType: TextInputType.number, maxLength: 4,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 24, letterSpacing: 12, fontWeight: FontWeight.w700),
        decoration: InputDecoration(
          counterText: '', filled: true, fillColor: AppColors.inputBg,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
          suffixIcon: IconButton(
            icon: Icon(_show ? Icons.visibility_off : Icons.visibility, size: 18),
            onPressed: () => setState(() => _show = !_show))),
      ),
    ]),
    actions: [
      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
      ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
        onPressed: () {
          if (_ctrl.text.length == 4) { Navigator.pop(context); widget.onConfirm(_ctrl.text); }
        },
        child: const Text('Confirm')),
    ],
  );
}

// ── Loc dot ───────────────────────────────────────────────────────────────────
class LocDot extends StatelessWidget {
  final String emoji;
  final Color bg;
  const LocDot({super.key, required this.emoji, required this.bg});
  @override
  Widget build(BuildContext context) => Container(
    width: 36, height: 36, decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
    child: Center(child: Text(emoji, style: const TextStyle(fontSize: 16))));
}

// ── Menu item ─────────────────────────────────────────────────────────────────
class MenuItem extends StatelessWidget {
  final String emoji, label;
  final VoidCallback onTap;
  final bool divider;
  final bool isRed;
  const MenuItem({super.key, required this.emoji, required this.label, required this.onTap,
    this.divider = false, this.isRed = false});
  @override
  Widget build(BuildContext context) => Column(children: [
    ListTile(
      leading: Container(width: 36, height: 36,
        decoration: BoxDecoration(color: isRed ? AppColors.cancelBg : AppColors.chipBg,
          borderRadius: BorderRadius.circular(10)),
        child: Center(child: Text(emoji, style: const TextStyle(fontSize: 15)))),
      title: Text(label, style: AppText.md.copyWith(fontWeight: FontWeight.w600,
        color: isRed ? AppColors.error : AppColors.text),
        maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Icon(Icons.chevron_right, color: isRed ? AppColors.error : AppColors.textHint),
      onTap: onTap),
    if (divider) const Divider(height: 1, indent: 62),
  ]);
}

// ── Loading indicator ─────────────────────────────────────────────────────────
class Loader extends StatelessWidget {
  final String? message;
  const Loader({super.key, this.message});
  @override
  Widget build(BuildContext context) => Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
    const CircularProgressIndicator(color: AppColors.primary),
    if (message != null) ...[const SizedBox(height: 12), Text(message!, style: AppText.cap)],
  ]));
}

// ── Empty state ───────────────────────────────────────────────────────────────
class EmptyState extends StatelessWidget {
  final String emoji, title;
  final String? subtitle;
  final Widget? action;
  const EmptyState({super.key, required this.emoji, required this.title, this.subtitle, this.action});
  @override
  Widget build(BuildContext context) => Center(child: Padding(padding: const EdgeInsets.all(32),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Text(emoji, style: const TextStyle(fontSize: 56, color: Color(0x3F000000))),
      const SizedBox(height: 12),
      Text(title, style: AppText.sub, textAlign: TextAlign.center),
      if (subtitle != null) ...[const SizedBox(height: 6),
        Text(subtitle!, style: AppText.cap, textAlign: TextAlign.center)],
      if (action != null) ...[const SizedBox(height: 20), action!],
    ])));
}
