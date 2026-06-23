import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_utils.dart';
import '../../../data/models/models.dart';
import '../../../data/services/api_client.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/app_widgets.dart';
import '../../auth/auth_controller.dart';
import '../home/customer_home_controller.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});
  @override State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final ctrl = CustomerHomeController.to;

  @override
  void initState() { super.initState(); ctrl.loadWallet(); }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.bg,
    body: Column(children: [
      Container(
        color: AppColors.navy,
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 16, left: 20, right: 20, bottom: 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('My Wallet', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          const Text('Available Balance', style: TextStyle(color: Colors.white60, fontSize: 12)),
          const SizedBox(height: 6),
          Obx(() => Text(AppUtils.formatNaira(ctrl.walletBalance.value),
              style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: -0.5))),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: AppButton(label: 'Fund Wallet', height: 42, onTap: () => Get.toNamed(AppRoutes.fundWallet))),
            const SizedBox(width: 10),
            Expanded(child: OutlinedButton(
              onPressed: () => Get.snackbar('', 'Withdrawal coming soon'),
              style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white38),
                foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 42),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              child: const Text('Withdraw', style: TextStyle(fontWeight: FontWeight.w700)),
            )),
          ]),
        ]),
      ),
      Expanded(child: Obx(() {
        if (ctrl.walletLoading.value) return const Center(child: CircularProgressIndicator(color: AppColors.orange));
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Padding(padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text('Transaction History', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.navy))),
          Expanded(child: ctrl.walletTxns.isEmpty
              ? const EmptyState(icon: Icons.receipt_long_outlined, title: 'No transactions yet',
                  subtitle: 'Fund your wallet to get started')
              : RefreshIndicator(onRefresh: ctrl.loadWallet,
                  child: ListView.builder(itemCount: ctrl.walletTxns.length,
                    itemBuilder: (_, i) => _TxnRow(txn: ctrl.walletTxns[i])))),
        ]);
      })),
    ]),
  );
}

class _TxnRow extends StatelessWidget {
  final WalletTransaction txn;
  const _TxnRow({required this.txn});
  @override
  Widget build(BuildContext context) {
    final isCredit = txn.type == 'credit';
    return Container(
      decoration: const BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: AppColors.border))),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Row(children: [
        Container(width: 40, height: 40,
          decoration: BoxDecoration(color: isCredit ? const Color(0xFFF0FDF4) : const Color(0xFFFEF2F2), borderRadius: BorderRadius.circular(11)),
          child: Center(child: Text(isCredit ? '💰' : '⬆️', style: const TextStyle(fontSize: 18)))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(txn.description ?? txn.category ?? 'Transaction',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.navy), overflow: TextOverflow.ellipsis),
          if (txn.date != null) Text(AppUtils.timeAgo(txn.date), style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('${isCredit ? '+' : '-'}${AppUtils.formatNaira(txn.amount)}',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: isCredit ? AppColors.green : AppColors.red)),
          if (txn.balanceAfter != null)
            Text('Bal: ${AppUtils.formatNaira(txn.balanceAfter!)}', style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
        ]),
      ]),
    );
  }
}

class FundWalletScreen extends StatefulWidget {
  const FundWalletScreen({super.key});
  @override State<FundWalletScreen> createState() => _FundWalletState();
}

class _FundWalletState extends State<FundWalletScreen> {
  final ctrl = CustomerHomeController.to;
  final auth = AuthController.to;
  final _amtCtrl = TextEditingController(text: '5000');
  String gateway = 'paystack';
  bool loading = false;
  final presets = ['1000', '2000', '5000', '10000', '20000'];

  Future<void> _fund() async {
    final amt = double.tryParse(_amtCtrl.text.replaceAll(',', ''));
    if (amt == null || amt < 100) { Get.snackbar('', 'Enter a valid amount (min ₦100)', snackPosition: SnackPosition.BOTTOM); return; }
    setState(() => loading = true);
    final res = await ApiClient.instance.fundWallet({'amount': amt, 'gateway': gateway}, auth.customerToken!);
    setState(() => loading = false);
    if (res['success'] == true) {
      ctrl.loadWallet(); Get.back(); Get.snackbar('', '✅ Wallet funded!', snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar('Error', res['message'] ?? 'Failed', snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.white,
    appBar: OrangeTopBar(title: 'Fund Wallet'),
    body: Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Amount', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
      const SizedBox(height: 8),
      TextField(controller: _amtCtrl, keyboardType: TextInputType.number,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.navy),
        decoration: const InputDecoration(prefixText: '₦ ',
          prefixStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.orange),
          hintText: '0', border: InputBorder.none)),
      const Divider(),
      const SizedBox(height: 12),
      Wrap(spacing: 8, children: presets.map((p) => GestureDetector(
        onTap: () => _amtCtrl.text = p,
        child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(color: AppColors.chipBg, borderRadius: BorderRadius.circular(20)),
          child: Text('₦${int.parse(p) >= 1000 ? '${int.parse(p) ~/ 1000}k' : p}',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.navy))),
      )).toList()),
      const SizedBox(height: 24),
      const Text('Gateway', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
      const SizedBox(height: 8),
      _gwOpt('paystack',    '💳 Paystack',    'Cards, Bank Transfer, USSD'),
      _gwOpt('flutterwave', '🦋 Flutterwave', 'Cards, Bank Transfer, Airtime'),
      const Spacer(),
      AppButton(label: 'Proceed to Payment', loading: loading, onTap: _fund),
    ])),
  );

  Widget _gwOpt(String value, String title, String sub) => GestureDetector(
    onTap: () => setState(() => gateway = value),
    child: Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
          border: Border.all(color: gateway == value ? AppColors.orange : AppColors.border, width: 1.5)),
      child: Row(children: [
        Container(width: 18, height: 18, decoration: BoxDecoration(shape: BoxShape.circle,
          border: Border.all(color: gateway == value ? AppColors.orange : AppColors.border, width: 2)),
          child: gateway == value ? Center(child: Container(width: 8, height: 8,
            decoration: const BoxDecoration(color: AppColors.orange, shape: BoxShape.circle))) : null),
        const SizedBox(width: 12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          Text(sub,   style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ]),
      ]),
    ),
  );
}