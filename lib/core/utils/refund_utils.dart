import 'dart:math';
import 'package:meathub/models/refund_model.dart';

class RefundUtils {
  RefundUtils._();

  static String generateRefundId() {
    final rand = Random();
    final number = 100000 + rand.nextInt(899999);
    return '#RF$number';
  }

  /// No real backend — status progresses purely from elapsed time,
  /// same demo pattern used by Track Order's delivery timeline.
  static RefundStatus computeStatus(RefundModel refund) {
    if (refund.rejectionReason != null) return RefundStatus.rejected;
    final elapsed = DateTime.now().difference(refund.requestedAt);
    if (elapsed < const Duration(minutes: 5)) return RefundStatus.pendingReview;
    if (elapsed < const Duration(minutes: 30)) return RefundStatus.approved;
    if (elapsed < const Duration(hours: 2)) return RefundStatus.processing;
    return RefundStatus.completed;
  }

  static String statusLabel(RefundStatus status) {
    switch (status) {
      case RefundStatus.pendingReview:
        return 'Pending Review';
      case RefundStatus.approved:
        return 'Approved';
      case RefundStatus.processing:
        return 'Processing';
      case RefundStatus.completed:
        return 'Completed';
      case RefundStatus.rejected:
        return 'Rejected';
    }
  }
}
