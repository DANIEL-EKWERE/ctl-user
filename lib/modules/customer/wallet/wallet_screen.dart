import 'dart:convert';

import 'package:ctluser/modules/customer/wallet/atomicWebViewScreen/atomic_webview_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/toast.dart';
import '../../../core/utils/app_utils.dart';
import '../../../data/models/models.dart';
import '../../../data/services/api_client.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/app_widgets.dart';
import '../../auth/auth_controller.dart';
import '../home/customer_home_controller.dart';
import 'dart:developer' as myLog;

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});
  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final ctrl = CustomerHomeController.to;

  @override
  void initState() {
    super.initState();
    ctrl.loadWallet();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.bg,
    body: Column(
      children: [
        Container(
          color: AppColors.navy,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 16,
            left: 20,
            right: 20,
            bottom: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'My Wallet',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Available Balance',
                style: TextStyle(color: Colors.white60, fontSize: 12),
              ),
              const SizedBox(height: 6),
              Obx(
                () => Text(
                  AppUtils.formatNaira(ctrl.walletBalance.value),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'Fund Wallet',
                      height: 42,
                      onTap: () => Get.toNamed(AppRoutes.fundWallet),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _showCustomerWithdrawSheet(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white38),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 42),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Withdraw',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _showCustomerBankAccountsSheet(context),
                  icon: const Icon(Icons.account_balance_outlined,
                      color: Colors.white70, size: 16),
                  label: const Text(
                    'Link Bank Account',
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white24),
                    minimumSize: const Size(double.infinity, 38),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Obx(() {
            if (ctrl.walletLoading.value)
              return const Center(
                child: CircularProgressIndicator(color: AppColors.orange),
              );
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    'Transaction History',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                ),
                Expanded(
                  child: ctrl.walletTxns.isEmpty
                      ? const EmptyState(
                          icon: Icons.receipt_long_outlined,
                          title: 'No transactions yet',
                          subtitle: 'Fund your wallet to get started',
                        )
                      : RefreshIndicator(
                          onRefresh: ctrl.loadWallet,
                          child: ListView.builder(
                            itemCount: ctrl.walletTxns.length,
                            itemBuilder: (_, i) =>
                                _TxnRow(txn: ctrl.walletTxns[i]),
                          ),
                        ),
                ),
              ],
            );
          }),
        ),
      ],
    ),
  );
}

class _TxnRow extends StatelessWidget {
  final WalletTransaction txn;
  const _TxnRow({required this.txn});
  @override
  Widget build(BuildContext context) {
    final isCredit = txn.type == 'credit';
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isCredit
                  ? const Color(0xFFF0FDF4)
                  : const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Center(
              child: Icon(
                isCredit
                    ? Icons.arrow_downward_rounded
                    : Icons.arrow_upward_rounded,
                color: isCredit ? AppColors.green : AppColors.red,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  txn.description ?? txn.category ?? 'Transaction',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.navy,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (txn.date != null)
                  Text(
                    AppUtils.timeAgo(txn.date),
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isCredit ? '+' : '-'}${AppUtils.formatNaira(txn.amount)}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isCredit ? AppColors.green : AppColors.red,
                ),
              ),
              if (txn.balanceAfter != null)
                Text(
                  'Bal: ${AppUtils.formatNaira(txn.balanceAfter!)}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  //ctrl.loadWallet();
}

class FundWalletScreen extends StatefulWidget {
  const FundWalletScreen({super.key});
  @override
  State<FundWalletScreen> createState() => _FundWalletState();
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
    if (amt == null || amt < 100) {
      showToast('Enter a valid amount (min ₦100)', isError: true);
      return;
    }
    setState(() => loading = true);
    final res = await ApiClient.instance.fundWallet({
      'amount': amt,
      'gateway': gateway,
    }, auth.customerToken!);
    setState(() => loading = false);
    if (res['success'] == true) {
      // var checkoutModel = jsonDecode(res.body);
      var url = res['data']['data']['data']['authorization_url'];
      //myLog.log('Checkout URL: $url');
      Navigator.push(
        Get.context!,
        CupertinoPageRoute(
          builder: (context) => AtomicWebViewScreen(
            url: url,
            // checkoutModel.data?.url ?? '',
          ),
        ),
      );
      //  myLog.log('Wallet funded successfully $res');
      //ctrl.loadWallet();
      //Get.back();
      // Get.snackbar('', '✅ Wallet funded!', snackPosition: SnackPosition.BOTTOM);
    } else {
      showToast(res['message'] ?? 'Failed', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.white,
    appBar: OrangeTopBar(title: 'Fund Wallet'),
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Amount',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _amtCtrl,
            keyboardType: TextInputType.number,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.navy,
            ),
            decoration: const InputDecoration(
              prefixText: '₦ ',
              prefixStyle: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.orange,
              ),
              hintText: '0',
              border: InputBorder.none,
            ),
          ),
          const Divider(),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: presets
                .map(
                  (p) => GestureDetector(
                    onTap: () => _amtCtrl.text = p,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.chipBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '₦${int.parse(p) >= 1000 ? '${int.parse(p) ~/ 1000}k' : p}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.navy,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 24),
          const Text(
            'Gateway',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          _gwOpt(
            'paystack',
            ' Paystack',
            'Cards, Bank Transfer, USSD',
            'assets/images/paystack-logo-png_seeklogo-511548.webp',
          ),
          // _gwOpt(
          //   'flutterwave',
          //   'Flutterwave',
          //   'Cards, Bank Transfer, Airtime',
          //   'assets/images/Flutterwave-Symbol-500x281.webp',
          // ),
          const Spacer(),
          AppButton(
            label: 'Proceed to Payment',
            loading: loading,
            onTap: _fund,
          ),
        ],
      ),
    ),
  );

  Widget _gwOpt(String value, String title, String sub, String image) =>
      GestureDetector(
        onTap: () => setState(() => gateway = value),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: gateway == value ? AppColors.orange : AppColors.border,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: gateway == value
                        ? AppColors.orange
                        : AppColors.border,
                    width: 2,
                  ),
                ),
                child: gateway == value
                    ? Center(
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.orange,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(image, width: 20, height: 20),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    sub,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}

// ─── Customer Withdraw Sheet ──────────────────────────────────────────────────
void _showCustomerWithdrawSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _CustomerWithdrawSheet(),
  );
}

class _CustomerWithdrawSheet extends StatefulWidget {
  const _CustomerWithdrawSheet();
  @override
  State<_CustomerWithdrawSheet> createState() => _CustomerWithdrawSheetState();
}

class _CustomerWithdrawSheetState extends State<_CustomerWithdrawSheet> {
  final ctrl = CustomerHomeController.to;
  final _amountCtrl = TextEditingController();
  final _pinCtrl = TextEditingController();
  BankAccount? _selectedAccount;
  bool _loading = false;

  @override
  void dispose() {
    _amountCtrl.dispose();
    _pinCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickAccount() async {
    if (ctrl.bankAccounts.isEmpty) {
      showToast('No bank accounts saved. Add one first.', isError: true);
      return;
    }
    final picked = await showDialog<BankAccount>(
      context: context,
      builder: (_) => SimpleDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Select Account',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        children: ctrl.bankAccounts
            .map((b) => SimpleDialogOption(
                  onPressed: () => Navigator.pop(context, b),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(b.bankName,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 14)),
                      Text(b.accountNumber,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 4),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
    if (picked != null) setState(() => _selectedAccount = picked);
  }

  Future<void> _submit() async {
    final amount = double.tryParse(_amountCtrl.text.trim());
    if (amount == null || amount <= 0) {
      showToast('Enter a valid amount', isError: true);
      return;
    }
    if (_selectedAccount == null) {
      showToast('Select a bank account', isError: true);
      return;
    }
    if (_pinCtrl.text.length < 4) {
      showToast('Enter your 4-digit PIN', isError: true);
      return;
    }
    setState(() => _loading = true);
    final ok = await ctrl.withdrawFromWallet(
      amount: amount,
      bankAccountId: _selectedAccount!.id,
      pin: _pinCtrl.text.trim(),
    );
    setState(() => _loading = false);
    if (ok && mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final inset = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, inset + 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Withdraw',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy)),
          const SizedBox(height: 4),
          Obx(() => Text(
                'Available: ${AppUtils.formatNaira(ctrl.walletBalance.value)}',
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary),
              )),
          const SizedBox(height: 20),
          TextField(
            controller: _amountCtrl,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            decoration: _wInputDec('Amount (₦)'),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _pickAccount,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedAccount != null
                          ? '${_selectedAccount!.bankName} · ${_selectedAccount!.accountNumber}'
                          : 'Select Bank Account',
                      style: TextStyle(
                        fontSize: 14,
                        color: _selectedAccount == null
                            ? Colors.grey.shade600
                            : Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down_rounded,
                      color: Colors.grey),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _pinCtrl,
            obscureText: true,
            maxLength: 6,
            keyboardType: TextInputType.number,
            decoration: _wInputDec('Transaction PIN'),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: _loading ? 'Processing…' : 'Withdraw',
              onTap: _loading ? null : _submit,
            ),
          ),
        ],
      ),
    );
  }
}

InputDecoration _wInputDec(String label) => InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );

// ─── Customer Bank Accounts Sheet ────────────────────────────────────────────

void _showCustomerBankAccountsSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _CustomerBankAccountsSheet(),
  );
}

class _CustomerBankAccountsSheet extends StatefulWidget {
  const _CustomerBankAccountsSheet();
  @override
  State<_CustomerBankAccountsSheet> createState() =>
      _CustomerBankAccountsSheetState();
}

class _CustomerBankAccountsSheetState
    extends State<_CustomerBankAccountsSheet> {
  final ctrl = CustomerHomeController.to;
  bool _adding = false;
  bool _saving = false;
  bool _loadingBanks = false;

  BankOption? _selectedBank;
  final _acctNumCtrl = TextEditingController();
  final _acctNameCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchBanks();
  }

  @override
  void dispose() {
    _acctNumCtrl.dispose();
    _acctNameCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchBanks() async {
    if (ctrl.availableBanks.isNotEmpty) return;
    setState(() => _loadingBanks = true);
    await ctrl.loadBanks();
    if (mounted) setState(() => _loadingBanks = false);
  }

  Future<void> _pickBank() async {
    if (_loadingBanks) return;
    if (ctrl.availableBanks.isEmpty) {
      setState(() => _loadingBanks = true);
      await ctrl.loadBanks();
      if (!mounted) return;
      setState(() => _loadingBanks = false);
    }
    if (!mounted) return;
    final picked = await showDialog<BankOption>(
      context: context,
      builder: (_) => _BankPickerDialog(banks: ctrl.availableBanks),
    );
    if (picked != null) setState(() => _selectedBank = picked);
  }

  Future<void> _save() async {
    if (_selectedBank == null ||
        _acctNumCtrl.text.isEmpty ||
        _acctNameCtrl.text.isEmpty) {
      showToast('Fill all fields', isError: true);
      return;
    }
    setState(() => _saving = true);
    final ok = await ctrl.addBankAccount({
      'bank_code': _selectedBank!.code,
      'bank_name': _selectedBank!.name,
      'account_number': _acctNumCtrl.text.trim(),
      'account_name': _acctNameCtrl.text.trim(),
    });
    setState(() => _saving = false);
    if (ok && mounted) setState(() => _adding = false);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (_, sc) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 16, 4),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Bank Accounts',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => setState(() => _adding = !_adding),
                    icon: Icon(_adding ? Icons.close : Icons.add, size: 18),
                    label: Text(_adding ? 'Cancel' : 'Add New'),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            if (_adding)
              Padding(
                padding: EdgeInsets.fromLTRB(
                  20,
                  14,
                  20,
                  MediaQuery.of(context).viewInsets.bottom + 14,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: _loadingBanks ? null : _pickBank,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 14),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _selectedBank?.name ?? 'Select Bank',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: _selectedBank == null
                                      ? Colors.grey.shade600
                                      : Colors.black87,
                                ),
                              ),
                            ),
                            if (_loadingBanks)
                              const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2),
                              )
                            else
                              const Icon(Icons.keyboard_arrow_down_rounded,
                                  color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _acctNumCtrl,
                      keyboardType: TextInputType.number,
                      decoration: _wInputDec('Account Number'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _acctNameCtrl,
                      decoration: _wInputDec('Account Name'),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        label: _saving ? 'Saving…' : 'Save Account',
                        onTap: _saving ? null : _save,
                      ),
                    ),
                  ],
                ),
              )
            else
              Expanded(
                child: Obx(
                  () => ctrl.bankAccounts.isEmpty
                      ? const EmptyState(
                          icon: Icons.account_balance_outlined,
                          title: 'No bank accounts added yet',
                        )
                      : ListView.separated(
                          controller: sc,
                          itemCount: ctrl.bankAccounts.length,
                          separatorBuilder: (_, _) =>
                              const Divider(height: 1),
                          itemBuilder: (_, i) {
                            final b = ctrl.bankAccounts[i];
                            return ListTile(
                              leading: Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: AppColors.bg,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                    Icons.account_balance_outlined,
                                    size: 20,
                                    color: AppColors.navy),
                              ),
                              title: Text(b.bankName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14)),
                              subtitle: Text(b.accountNumber,
                                  style: const TextStyle(fontSize: 12)),
                              trailing: Text(b.accountName,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary)),
                            );
                          },
                        ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _BankPickerDialog extends StatefulWidget {
  final List<BankOption> banks;
  const _BankPickerDialog({required this.banks});
  @override
  State<_BankPickerDialog> createState() => _BankPickerDialogState();
}

class _BankPickerDialogState extends State<_BankPickerDialog> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.banks
        .where((b) => b.name.toLowerCase().contains(_query.toLowerCase()))
        .toList();
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                autofocus: true,
                onChanged: (v) => setState(() => _query = v),
                decoration: _wInputDec('Search bank…'),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (_, i) => ListTile(
                  title: Text(filtered[i].name,
                      style: const TextStyle(fontSize: 14)),
                  onTap: () => Navigator.pop(context, filtered[i]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
