import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/toast.dart';
import '../../../widgets/app_widgets.dart';
import '../home/customer_home_controller.dart';

/// Arguments: {
///   'orderId': int,
///   'orderRef': String?,
///   'riderUserId': int?,   // passed so server can identify who is being reported
///   'vendorUserId': int?,
/// }
class ReportOrderScreen extends StatefulWidget {
  const ReportOrderScreen({super.key});

  @override
  State<ReportOrderScreen> createState() => _ReportOrderScreenState();
}

class _ReportOrderScreenState extends State<ReportOrderScreen> {
  final ctrl = CustomerHomeController.to;

  late final int orderId;
  late final String orderRef;
  late final int? riderUserId;
  late final int? vendorUserId;

  String? _selectedType;
  final _descCtrl = TextEditingController();
  bool _loading = false;

  // Maps display label → API value
  static const _abuseTypes = {
    'Food/Package was tampered': 'tampered',
    'Order was not delivered': 'not_delivered',
    'Received wrong items': 'wrong_item',
    'Rude or unprofessional behavior': 'rude_behavior',
    'Fraud or scam': 'fraud',
    'Other': 'other',
  };

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map? ?? {};
    orderId = args['orderId'] as int? ?? 0;
    orderRef = args['orderRef'] as String? ?? '';
    riderUserId = args['riderUserId'] as int?;
    vendorUserId = args['vendorUserId'] as int?;
  }

  @override
  void dispose() {
    _descCtrl.dispose();
    super.dispose();
  }

  // Determine reported_user_id based on abuse type
  int? get _reportedUserId {
    if (_selectedType == 'not_delivered') return riderUserId;
    if (_selectedType == 'wrong_item') return vendorUserId;
    return riderUserId ?? vendorUserId;
  }

  Future<void> _submit() async {
    if (_selectedType == null) {
      showToast('Please select an abuse type', isError: true);
      return;
    }
    final desc = _descCtrl.text.trim();
    if (desc.length < 20) {
      showToast('Description must be at least 20 characters', isError: true);
      return;
    }
    setState(() => _loading = true);
    final ok = await ctrl.reportOrder(
      orderId: orderId,
      abuseType: _selectedType!,
      description: desc,
      reportedUserId: _reportedUserId,
    );
    setState(() => _loading = false);
    if (ok) {
      Get.back();
      showToast('Report submitted. We will look into this.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: OrangeTopBar(title: 'Report an Issue'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.flag_outlined,
                        color: AppColors.red, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Report Abuse',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.navy,
                          ),
                        ),
                        if (orderRef.isNotEmpty)
                          Text(
                            'Order $orderRef',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'What type of issue?',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 10),

            // Abuse type selector
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: _abuseTypes.entries.toList().asMap().entries.map((e) {
                  final i = e.key;
                  final label = e.value.key;
                  final value = e.value.value;
                  final isLast = i == _abuseTypes.length - 1;
                  final selected = _selectedType == value;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedType = value),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0xFFFFF5E6)
                            : Colors.transparent,
                        borderRadius: BorderRadius.only(
                          topLeft: i == 0
                              ? const Radius.circular(14)
                              : Radius.zero,
                          topRight: i == 0
                              ? const Radius.circular(14)
                              : Radius.zero,
                          bottomLeft: isLast
                              ? const Radius.circular(14)
                              : Radius.zero,
                          bottomRight: isLast
                              ? const Radius.circular(14)
                              : Radius.zero,
                        ),
                        border: isLast
                            ? null
                            : const Border(
                                bottom:
                                    BorderSide(color: AppColors.border)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: selected
                                    ? AppColors.orange
                                    : AppColors.border,
                                width: 2,
                              ),
                              color: selected
                                  ? AppColors.orange
                                  : Colors.transparent,
                            ),
                            child: selected
                                ? const Icon(Icons.check,
                                    size: 12, color: Colors.white)
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              label,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: selected
                                    ? FontWeight.w700
                                    : FontWeight.normal,
                                color: selected
                                    ? AppColors.navy
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            // Description
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Describe what happened',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Minimum 20 characters',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ValueListenableBuilder(
                    valueListenable: _descCtrl,
                    builder: (_, _, _) {
                      final len = _descCtrl.text.trim().length;
                      final enough = len >= 20;
                      return TextField(
                        controller: _descCtrl,
                        maxLines: 4,
                        maxLength: 500,
                        decoration: InputDecoration(
                          hintText: 'Describe the issue in detail…',
                          hintStyle: const TextStyle(
                            color: AppColors.textLight,
                            fontSize: 13,
                          ),
                          filled: true,
                          fillColor: AppColors.inputBg,
                          contentPadding: const EdgeInsets.all(14),
                          suffixIcon: len > 0
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      right: 10, bottom: 48),
                                  child: Icon(
                                    enough
                                        ? Icons.check_circle
                                        : Icons.error_outline,
                                    color: enough
                                        ? AppColors.green
                                        : AppColors.orange,
                                    size: 18,
                                  ),
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: AppColors.border, width: 1.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: AppColors.border, width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: AppColors.orange, width: 1.5),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            AppButton(
              label: _loading ? 'Submitting…' : 'Submit Report',
              onTap: _loading ? null : _submit,
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
