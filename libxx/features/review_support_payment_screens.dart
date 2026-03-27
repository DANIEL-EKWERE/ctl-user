import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../lib/core/app_colors.dart';
import '../../lib/core/app_text_styles.dart';
import '../core/models.dart';
import '../../lib/core/network.dart';
import '../shared/widgets.dart';

// ════════════════════════════════════════════════════════════════════════════
// REVIEW SCREENS
// ════════════════════════════════════════════════════════════════════════════

// ── Write Review Screen ───────────────────────────────────────────────────────
class WriteReviewScreen extends StatefulWidget {
  const WriteReviewScreen({super.key});
  @override State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  final _comment = TextEditingController();
  int _rating    = 0;
  bool _loading  = false;
  late OrderModel _order;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _order = ModalRoute.of(context)!.settings.arguments as OrderModel;
  }

  Future<void> _submit() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please select a star rating'), backgroundColor: AppColors.error));
      return;
    }
    setState(() => _loading = true);
    try {
      await ApiClient().post(
        '/customer/orders/${_order.id}/review',
        data: {'rating': _rating, 'comment': _comment.text.trim()},
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Thank you for your review! ⭐'), backgroundColor: AppColors.success,
        duration: Duration(seconds: 3)));
      Navigator.pop(context, true);
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.response?.data['message'] ?? 'Failed to submit review'),
        backgroundColor: AppColors.error));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const NKAppBar(title: 'Write a Review'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          // Vendor info
          NKCard(child: Row(children: [
            Container(width: 50, height: 50, decoration: BoxDecoration(
                color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
              child: Center(child: Text(
                (_order.vendor['name'] ?? 'V').substring(0, 1).toUpperCase(),
                style: AppTextStyles.h3.copyWith(color: AppColors.secondary)))),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(_order.vendor['name'] ?? '', style: AppTextStyles.subtitle),
              Text('Order #${_order.reference}', style: AppTextStyles.caption),
            ])),
          ])),
          const SizedBox(height: 24),

          // Star rating
          Text('How was your experience?', style: AppTextStyles.h3, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(5, (i) {
            return GestureDetector(
              onTap: () => setState(() => _rating = i + 1),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Icon(
                  _rating > i ? Icons.star_rounded : Icons.star_outline_rounded,
                  size: 44,
                  color: _rating > i ? AppColors.primary : AppColors.border2,
                ),
              ),
            );
          })),
          const SizedBox(height: 8),
          Text(
            _rating == 0 ? 'Tap to rate' :
            _rating == 1 ? 'Terrible 😞' : _rating == 2 ? 'Bad 😕' :
            _rating == 3 ? 'Okay 😐' : _rating == 4 ? 'Good 😊' : 'Excellent! 🤩',
            style: AppTextStyles.bodyMd.copyWith(
              color: _rating >= 4 ? AppColors.success : _rating >= 3 ? AppColors.warning : AppColors.error,
              fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 24),

          // Comment
          Text('Write your review', style: AppTextStyles.label),
          const SizedBox(height: 6),
          TextFormField(
            controller: _comment,
            maxLines: 5,
            maxLength: 1000,
            style: AppTextStyles.body,
            decoration: const InputDecoration(
              hintText: 'Tell others about your experience. Was the food good? Delivery fast?',
              filled: true, fillColor: AppColors.inputBg,
            ),
          ),
          const SizedBox(height: 16),
          NKButton(label: 'Submit Review', onTap: _submit, loading: _loading),
          const SizedBox(height: 20),
        ]),
      ),
    );
  }
}

// ── Vendor Reviews Screen (public) ────────────────────────────────────────────
class VendorReviewsScreen extends StatefulWidget {
  const VendorReviewsScreen({super.key});
  @override State<VendorReviewsScreen> createState() => _VendorReviewsScreenState();
}

class _VendorReviewsScreenState extends State<VendorReviewsScreen> {
  Map<String, dynamic> _stats = {};
  List<dynamic> _reviews = [];
  bool _loading = true;
  late int _vendorId;
  late String _vendorName;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _vendorId   = args['vendor_id'];
    _vendorName = args['vendor_name'] ?? 'Vendor';
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final res = await ApiClient().get('/browse/vendors/$_vendorId/reviews');
      setState(() {
        _stats   = res.data['stats'] ?? {};
        _reviews = res.data['data'] ?? [];
      });
    } catch (_) {}
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final avg   = (_stats['average'] ?? 0.0) as num;
    final total = (_stats['total'] ?? 0) as num;
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: NKAppBar(title: '$_vendorName — Reviews'),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : RefreshIndicator(
              onRefresh: _load, color: AppColors.primary,
              child: CustomScrollView(slivers: [
                // Stats header
                SliverToBoxAdapter(child: Container(
                  color: AppColors.white, padding: const EdgeInsets.all(16),
                  child: Row(children: [
                    // Big rating
                    Column(children: [
                      Text(avg.toStringAsFixed(1), style: AppTextStyles.priceLg.copyWith(color: AppColors.secondary, fontSize: 42)),
                      Row(children: List.generate(5, (i) => Icon(
                        avg > i ? Icons.star_rounded : Icons.star_outline_rounded,
                        size: 18, color: AppColors.primary))),
                      const SizedBox(height: 4),
                      Text('$total reviews', style: AppTextStyles.caption),
                    ]),
                    const SizedBox(width: 20),
                    // Star breakdown
                    Expanded(child: Column(children: List.generate(5, (i) {
                      final star = 5 - i;
                      final count = (_stats['breakdown']?[star.toString()] ?? 0) as num;
                      final pct   = total > 0 ? count / total : 0.0;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(children: [
                          Text('$star', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700)),
                          const SizedBox(width: 4),
                          const Icon(Icons.star_rounded, size: 12, color: AppColors.primary),
                          const SizedBox(width: 6),
                          Expanded(child: LinearProgressIndicator(
                            value: pct.toDouble(),
                            backgroundColor: AppColors.chipBg,
                            color: AppColors.primary,
                            minHeight: 8,
                            borderRadius: BorderRadius.circular(4),
                          )),
                          const SizedBox(width: 6),
                          Text('$count', style: AppTextStyles.caption2),
                        ]),
                      );
                    }))),
                  ]),
                )),
                if (_reviews.isEmpty)
                  const SliverToBoxAdapter(child: Center(child: Padding(
                    padding: EdgeInsets.all(48),
                    child: Column(children: [
                      Text('⭐', style: TextStyle(fontSize: 48)),
                      SizedBox(height: 12),
                      Text('No reviews yet', style: AppTextStyles.body),
                    ]),
                  )))
                else
                  SliverList(delegate: SliverChildBuilderDelegate(
                    (_, i) => _ReviewTile(review: _reviews[i]),
                    childCount: _reviews.length,
                  )),
              ]),
            ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final Map<String, dynamic> review;
  const _ReviewTile({required this.review});

  @override
  Widget build(BuildContext context) {
    final rating  = (review['rating'] as num).toInt();
    final comment = review['comment'] as String? ?? '';
    final reply   = review['vendor_reply'] as String?;
    final cust    = review['customer'] as Map<String, dynamic>? ?? {};
    final date    = review['date']?.toString().substring(0, 10) ?? '';
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.all(14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          CircleAvatar(radius: 18, backgroundColor: AppColors.secondary,
            child: Text((cust['name'] ?? 'A').substring(0, 1).toUpperCase(),
              style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.w700, fontSize: 13))),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(cust['name'] ?? 'Customer', style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w600)),
            Text(date, style: AppTextStyles.caption2),
          ])),
          Row(children: List.generate(5, (i) => Icon(
            rating > i ? Icons.star_rounded : Icons.star_outline_rounded,
            size: 16, color: AppColors.primary))),
        ]),
        if (comment.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(comment, style: AppTextStyles.bodyMd),
        ],
        if (reply != null && reply.isNotEmpty) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8F0),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.primary.withOpacity(.2))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Icon(Icons.store, size: 14, color: AppColors.primary),
                const SizedBox(width: 4),
                Text('Vendor Reply', style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary, fontWeight: FontWeight.w700)),
              ]),
              const SizedBox(height: 4),
              Text(reply, style: AppTextStyles.caption),
            ]),
          ),
        ],
        const Divider(height: 20),
      ]),
    );
  }
}

// ─── Mini review widget shown on vendor detail ────────────────────────────────
class VendorRatingBar extends StatelessWidget {
  final double rating;
  final int totalRatings;
  final int vendorId;
  final String vendorName;
  const VendorRatingBar({super.key, required this.rating, required this.totalRatings, required this.vendorId, required this.vendorName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/vendor-reviews', arguments: {
        'vendor_id': vendorId, 'vendor_name': vendorName,
      }),
      child: Row(children: [
        ...List.generate(5, (i) => Icon(
          rating > i ? Icons.star_rounded : Icons.star_outline_rounded,
          size: 16, color: AppColors.primary)),
        const SizedBox(width: 4),
        Text(rating.toStringAsFixed(1), style: AppTextStyles.bodyMd.copyWith(
            color: AppColors.primary, fontWeight: FontWeight.w700)),
        const SizedBox(width: 4),
        Text('($totalRatings)', style: AppTextStyles.caption2),
        const SizedBox(width: 4),
        const Icon(Icons.chevron_right, size: 16, color: AppColors.textHint),
      ]),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// SUPPORT SCREENS
// ════════════════════════════════════════════════════════════════════════════

class SupportListScreen extends StatefulWidget {
  const SupportListScreen({super.key});
  @override State<SupportListScreen> createState() => _SupportListScreenState();
}

class _SupportListScreenState extends State<SupportListScreen> {
  List<dynamic> _tickets = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final res = await ApiClient().get('/support');
      setState(() => _tickets = res.data['data'] ?? []);
    } catch (_) {}
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: NKAppBar(
        title: 'Support',
        actions: [IconButton(
          icon: const Icon(Icons.add, color: AppColors.white),
          onPressed: () => Navigator.pushNamed(context, '/support/new').then((_) => _load()),
        )],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _tickets.isEmpty
              ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Text('💬', style: TextStyle(fontSize: 52)),
                  const SizedBox(height: 12),
                  Text('No support tickets', style: AppTextStyles.h3),
                  const SizedBox(height: 20),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 60),
                    child: NKButton(label: '+ Open a Ticket',
                        onTap: () => Navigator.pushNamed(context, '/support/new').then((_) => _load()))),
                ]))
              : RefreshIndicator(
                  onRefresh: _load, color: AppColors.primary,
                  child: ListView.builder(
                    itemCount: _tickets.length,
                    itemBuilder: (_, i) {
                      final t = _tickets[i];
                      final status = t['status'] as String;
                      Color sc = status == 'open' ? AppColors.warning
                          : status == 'resolved' ? AppColors.success
                          : status == 'in_progress' ? AppColors.pickText
                          : AppColors.textLight;
                      return NKCard(
                        onTap: () => Navigator.pushNamed(context, '/support/detail', arguments: t['id']).then((_) => _load()),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text(t['ticket_no'] ?? '', style: AppTextStyles.caption.copyWith(
                                fontWeight: FontWeight.w700, color: AppColors.secondary, letterSpacing: .3)),
                            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(color: sc.withOpacity(.12), borderRadius: BorderRadius.circular(20)),
                              child: Text(status.replaceAll('_', ' ').toUpperCase(),
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: sc))),
                          ]),
                          const SizedBox(height: 8),
                          Text(t['subject'] ?? '', style: AppTextStyles.subtitle.copyWith(fontSize: 14),
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 4),
                          Row(children: [
                            Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(color: AppColors.chipBg, borderRadius: BorderRadius.circular(6)),
                              child: Text(t['category'] ?? '', style: AppTextStyles.caption2.copyWith(fontWeight: FontWeight.w600))),
                            const SizedBox(width: 8),
                            Text('${t['reply_count'] ?? 0} replies', style: AppTextStyles.caption2),
                            const Spacer(),
                            Text(t['updated_at']?.toString().substring(0, 10) ?? '', style: AppTextStyles.caption2),
                          ]),
                        ]),
                      );
                    },
                  ),
                ),
    );
  }
}

class NewSupportTicketScreen extends StatefulWidget {
  const NewSupportTicketScreen({super.key});
  @override State<NewSupportTicketScreen> createState() => _NewSupportTicketScreenState();
}

class _NewSupportTicketScreenState extends State<NewSupportTicketScreen> {
  final _subjectCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  String _category   = 'general';
  String _priority   = 'medium';
  bool _loading      = false;
  String? _err;

  final _categories = ['general','order','payment','account','technical','product'];
  final _priorities = ['low','medium','high','urgent'];

  Future<void> _submit() async {
    if (_subjectCtrl.text.isEmpty || _messageCtrl.text.isEmpty) {
      setState(() => _err = 'Please fill subject and message'); return;
    }
    setState(() { _loading = true; _err = null; });
    try {
      await ApiClient().post('/support', data: {
        'subject': _subjectCtrl.text.trim(),
        'message': _messageCtrl.text.trim(),
        'category': _category,
        'priority': _priority,
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Ticket created! We'll respond soon."), backgroundColor: AppColors.success,
        duration: Duration(seconds: 3)));
      Navigator.pop(context);
    } on DioException catch (e) {
      setState(() => _err = e.response?.data['message'] ?? 'Failed to create ticket');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const NKAppBar(title: 'New Support Ticket'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(
              color: AppColors.inputBg, borderRadius: BorderRadius.circular(14)),
            child: Row(children: [
              const Text('💬', style: TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('How can we help?', style: AppTextStyles.subtitle),
                Text("Describe your issue and we'll respond within 24 hours",
                    style: AppTextStyles.caption),
              ])),
            ])),
          const SizedBox(height: 20),
          // Category chips
          Text('Category', style: AppTextStyles.label),
          const SizedBox(height: 6),
          Wrap(spacing: 8, runSpacing: 8, children: _categories.map((c) => GestureDetector(
            onTap: () => setState(() => _category = c),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: _category == c ? AppColors.primary : AppColors.chipBg,
                borderRadius: BorderRadius.circular(20)),
              child: Text(c.replaceAll('_', ' '),
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                    color: _category == c ? AppColors.white : AppColors.textLight)),
            ),
          )).toList()),
          const SizedBox(height: 16),
          // Priority
          Text('Priority', style: AppTextStyles.label),
          const SizedBox(height: 6),
          Row(children: _priorities.map((p) => Expanded(child: Padding(
            padding: const EdgeInsets.only(right: 6),
            child: GestureDetector(
              onTap: () => setState(() => _priority = p),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: _priority == p ? _priorityColor(p) : AppColors.chipBg,
                  borderRadius: BorderRadius.circular(10)),
                child: Center(child: Text(p.capitalize,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                      color: _priority == p ? AppColors.white : AppColors.textLight))),
              ),
            ),
          ))).toList()),
          const SizedBox(height: 16),
          NKTextField(label: 'Subject', hint: 'Brief description of your issue', controller: _subjectCtrl),
          Text('Message', style: AppTextStyles.label),
          const SizedBox(height: 5),
          TextFormField(
            controller: _messageCtrl, maxLines: 6, maxLength: 5000,
            style: AppTextStyles.body,
            decoration: const InputDecoration(
              hintText: 'Describe your issue in detail...', filled: true, fillColor: AppColors.inputBg),
          ),
          if (_err != null) Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.cancelBg, borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.cancelText.withOpacity(.3))),
              child: Text(_err!, style: AppTextStyles.caption.copyWith(color: AppColors.cancelText)))),
          const SizedBox(height: 14),
          NKButton(label: 'Submit Ticket', onTap: _submit, loading: _loading),
          const SizedBox(height: 16),
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(
              color: AppColors.inputBg, borderRadius: BorderRadius.circular(12)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Other ways to reach us', style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w700, color: AppColors.secondary)),
              const SizedBox(height: 8),
              const Text('📧 support@nksereke.com', style: TextStyle(fontSize: 13, color: AppColors.textLight)),
              const SizedBox(height: 4),
              const Text('📞 +234 800 000 0000', style: TextStyle(fontSize: 13, color: AppColors.textLight)),
            ])),
          const SizedBox(height: 20),
        ]),
      ),
    );
  }

  Color _priorityColor(String p) {
    return p == 'urgent' ? AppColors.error : p == 'high' ? AppColors.error
        : p == 'medium' ? AppColors.warning : AppColors.success;
  }
}

class SupportTicketDetailScreen extends StatefulWidget {
  const SupportTicketDetailScreen({super.key});
  @override State<SupportTicketDetailScreen> createState() => _SupportTicketDetailScreenState();
}

class _SupportTicketDetailScreenState extends State<SupportTicketDetailScreen> {
  final _replyCtrl = TextEditingController();
  Map<String, dynamic>? _ticket;
  bool _loading = true, _sending = false;
  late int _ticketId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _ticketId = ModalRoute.of(context)!.settings.arguments as int;
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final res = await ApiClient().get('/support/$_ticketId');
      setState(() => _ticket = res.data['ticket']);
    } catch (_) {}
    setState(() => _loading = false);
  }

  Future<void> _reply() async {
    if (_replyCtrl.text.trim().isEmpty) return;
    setState(() => _sending = true);
    try {
      await ApiClient().post('/support/$_ticketId/reply', data: {'message': _replyCtrl.text.trim()});
      _replyCtrl.clear();
      await _load();
    } catch (_) {}
    setState(() => _sending = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return Scaffold(appBar: const NKAppBar(title: 'Ticket'), body: const Center(child: CircularProgressIndicator(color: AppColors.primary)));
    if (_ticket == null) return Scaffold(appBar: const NKAppBar(title: 'Ticket'), body: const Center(child: Text('Failed to load')));
    final t = _ticket!;
    final status = t['status'] as String;
    final isClosed = ['resolved','closed'].contains(status);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: NKAppBar(title: t['ticket_no'] ?? 'Ticket'),
      body: Column(children: [
        // Ticket header
        Container(color: AppColors.white, padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(t['subject'] ?? '', style: AppTextStyles.h3),
          const SizedBox(height: 6),
          Row(children: [
            Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(color: AppColors.chipBg, borderRadius: BorderRadius.circular(6)),
              child: Text(t['category'] ?? '', style: AppTextStyles.caption2.copyWith(fontWeight: FontWeight.w700))),
            const SizedBox(width: 8),
            Text(status.replaceAll('_', ' ').toUpperCase(),
              style: AppTextStyles.caption2.copyWith(fontWeight: FontWeight.w800,
                  color: isClosed ? AppColors.success : AppColors.warning)),
          ]),
        ])),
        const Divider(height: 1),
        // Replies
        Expanded(child: ListView.builder(
          padding: const EdgeInsets.all(14),
          itemCount: (t['replies'] as List? ?? []).length,
          itemBuilder: (_, i) {
            final r = (t['replies'] as List)[i];
            final isStaff = r['is_staff'] == true;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: isStaff ? MainAxisAlignment.start : MainAxisAlignment.end,
                children: [
                  if (isStaff) ...[
                    Container(width: 32, height: 32, decoration: const BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle),
                      child: const Center(child: Text('NK', style: TextStyle(color: AppColors.white, fontSize: 10, fontWeight: FontWeight.w900)))),
                    const SizedBox(width: 8),
                  ],
                  Flexible(child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isStaff ? AppColors.secondary : AppColors.primary,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(14),
                        topRight: const Radius.circular(14),
                        bottomLeft: Radius.circular(isStaff ? 4 : 14),
                        bottomRight: Radius.circular(isStaff ? 14 : 4),
                      ),
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(isStaff ? 'NKsereke Support' : (r['sender']?['name'] ?? 'You'),
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white70)),
                      const SizedBox(height: 4),
                      Text(r['message'] ?? '', style: const TextStyle(color: AppColors.white, fontSize: 13, height: 1.4)),
                      const SizedBox(height: 4),
                      Text(r['date']?.toString().substring(0, 16) ?? '',
                        style: const TextStyle(fontSize: 10, color: Colors.white60)),
                    ]),
                  )),
                ],
              ),
            );
          },
        )),
        // Reply input
        if (!isClosed) Container(
          padding: const EdgeInsets.fromLTRB(14, 8, 14, 16),
          decoration: const BoxDecoration(color: AppColors.white,
              border: Border(top: BorderSide(color: AppColors.border))),
          child: Row(children: [
            Expanded(child: TextField(
              controller: _replyCtrl,
              style: AppTextStyles.body,
              maxLines: 3, minLines: 1,
              decoration: const InputDecoration(
                hintText: 'Type your message...', filled: true, fillColor: AppColors.inputBg),
            )),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: _sending ? null : _reply,
              child: Container(width: 44, height: 44,
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
                child: _sending
                    ? const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.white)))
                    : const Icon(Icons.send_rounded, color: AppColors.white, size: 20)),
            ),
          ]),
        ),
        if (isClosed) Container(
          width: double.infinity, padding: const EdgeInsets.all(14),
          color: AppColors.doneBg,
          child: Text('This ticket is ${status}. Open a new ticket for further assistance.',
            style: AppTextStyles.caption.copyWith(color: AppColors.doneText), textAlign: TextAlign.center)),
      ]),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// PAYMENT WEBVIEW (Paystack / Flutterwave)
// ════════════════════════════════════════════════════════════════════════════

class PaymentWebViewScreen extends StatefulWidget {
  const PaymentWebViewScreen({super.key});
  @override State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late WebViewController _ctrl;
  late String _url, _title, _reference;
  bool _loading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _url       = args['url'] as String;
    _title     = args['title'] as String? ?? 'Complete Payment';
    _reference = args['reference'] as String? ?? '';

    _ctrl = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (_) => setState(() => _loading = true),
        onPageFinished: (url) {
          setState(() => _loading = false);
          // Detect success patterns from Paystack and Flutterwave callbacks
          if (url.contains('callback') || url.contains('success') ||
              url.contains('payment_complete') || url.contains('trxref=')) {
            _onPaymentSuccess(url);
          }
        },
      ))
      ..loadRequest(Uri.parse(_url));
  }

  void _onPaymentSuccess(String redirectUrl) {
    // Extract reference from URL if present
    final uri = Uri.tryParse(redirectUrl);
    final ref = uri?.queryParameters['trxref'] ??
                uri?.queryParameters['reference'] ??
                uri?.queryParameters['tx_ref'] ??
                _reference;

    Navigator.pop(context, {'success': true, 'reference': ref});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: NKAppBar(
        title: _title,
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_browser, color: AppColors.white),
            onPressed: () async {
              final uri = Uri.parse(_url);
              if (await canLaunchUrl(uri)) launchUrl(uri, mode: LaunchMode.externalApplication);
            },
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, {'success': true, 'reference': _reference}),
            child: const Text("I've Paid", style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      body: Stack(children: [
        WebViewWidget(controller: _ctrl),
        if (_loading) const LinearProgressIndicator(
          backgroundColor: AppColors.border, color: AppColors.primary, minHeight: 3),
      ]),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// CHECKOUT CONFIG (delivery fee from DB)
// ════════════════════════════════════════════════════════════════════════════

class CheckoutConfig {
  final double serviceChargePct;
  final List<Map<String, dynamic>> deliveryFeeBands;
  final double defaultDeliveryFee;

  const CheckoutConfig({
    required this.serviceChargePct,
    required this.deliveryFeeBands,
    required this.defaultDeliveryFee,
  });

  factory CheckoutConfig.fromJson(Map<String, dynamic> j) => CheckoutConfig(
    serviceChargePct:   (j['service_charge_pct'] ?? 5).toDouble(),
    deliveryFeeBands:   (j['delivery_fee_bands'] as List? ?? []).cast<Map<String, dynamic>>(),
    defaultDeliveryFee: (j['default_delivery_fee'] ?? 500).toDouble(),
  );

  /// Get delivery fee for a given distance in km
  double deliveryFeeFor(double? distanceKm) {
    if (distanceKm == null) return defaultDeliveryFee;
    for (final band in deliveryFeeBands) {
      final minKm = (band['min_km'] as num).toDouble();
      final maxKm = (band['max_km'] as num).toDouble();
      if (distanceKm >= minKm && distanceKm <= maxKm) {
        return (band['price'] as num).toDouble();
      }
    }
    // If beyond all bands, use the last band's price
    return deliveryFeeBands.isNotEmpty
        ? (deliveryFeeBands.last['price'] as num).toDouble()
        : defaultDeliveryFee;
  }

  double serviceCharge(double subtotal) => (subtotal * serviceChargePct / 100).roundToDouble();
}

// Global config cache — loaded once at startup
CheckoutConfig? _cachedCheckoutConfig;

Future<CheckoutConfig> getCheckoutConfig() async {
  if (_cachedCheckoutConfig != null) return _cachedCheckoutConfig!;
  try {
    final res = await ApiClient().get('/browse/checkout-config');
    _cachedCheckoutConfig = CheckoutConfig.fromJson(res.data);
    return _cachedCheckoutConfig!;
  } catch (_) {
    return const CheckoutConfig(
      serviceChargePct: 5, deliveryFeeBands: [], defaultDeliveryFee: 500);
  }
}

// ════════════════════════════════════════════════════════════════════════════
// AD CARD WIDGET (shown in vendor list feed)
// ════════════════════════════════════════════════════════════════════════════

class AdCard extends StatelessWidget {
  final Map<String, dynamic> ad;
  const AdCard({super.key, required this.ad});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final link = ad['link'] as String?;
        if (link != null && link.isNotEmpty) {
          final uri = Uri.tryParse(link);
          if (uri != null && await canLaunchUrl(uri)) {
            launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary.withOpacity(.3)),
          boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(.08), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(children: [
            // Ad image
            if ((ad['image_url'] as String?)?.isNotEmpty == true)
              Image.network(ad['image_url'] as String,
                height: 120, width: double.infinity, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(height: 120,
                  decoration: const BoxDecoration(gradient: AppColors.brandGradient)),
              )
            else
              Container(height: 120, decoration: const BoxDecoration(gradient: AppColors.brandGradient),
                child: Center(child: Text(ad['title'] ?? 'Sponsored',
                  style: AppTextStyles.h3.copyWith(color: AppColors.white)))),
            // Sponsored badge
            Positioned(top: 8, right: 8, child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)),
              child: const Text('Sponsored', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
            )),
            // Title overlay
            Positioned(bottom: 0, left: 0, right: 0, child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(.6)])),
              child: Text(ad['title'] ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
            )),
          ]),
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
extension StringExtension on String {
  String get capitalize => isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}
