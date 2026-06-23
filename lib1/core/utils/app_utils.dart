import 'package:intl/intl.dart';

class AppUtils {
  static String formatNaira(dynamic value) {
    final n = double.tryParse(value.toString().replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
    return '₦${NumberFormat('#,##0', 'en_NG').format(n)}';
  }

  static String statusLabel(String status) {
    const map = {
      'pending':   'Pending',
      'accepted':  'Accepted',
      'preparing': 'Preparing',
      'ready':     'Ready',
      'picked_up': 'Picked Up',
      'delivered': 'Delivered',
      'cancelled': 'Cancelled',
    };
    return map[status] ?? status;
  }

  static bool isOngoingOrder(String status) =>
      ['pending', 'accepted', 'preparing', 'ready', 'picked_up'].contains(status);

  static String timeAgo(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final d = DateTime.parse(dateStr);
      final diff = DateTime.now().difference(d);
      if (diff.inDays > 0) return '${diff.inDays}d ago';
      if (diff.inHours > 0) return '${diff.inHours}h ago';
      if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
      return 'Just now';
    } catch (_) { return dateStr.substring(0, 10); }
  }

  static double parsePrice(dynamic val) {
    return double.tryParse(val.toString().replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
  }
}