import 'dart:math';
import 'package:meathub/models/refund_model.dart';

class RefundUtils {
  RefundUtils._();

  static String generateRefundId() {
    final rand = Random();
    final number = 100000 + rand.nextInt(899999);
    return '#RF$number';
  }

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

  /// Approx timestamp each step was/will be reached — same time-simulation
  /// boundaries used in [computeStatus].
  static DateTime stepTime(RefundModel refund, RefundStatus step) {
    switch (step) {
      case RefundStatus.pendingReview:
        return refund.requestedAt;
      case RefundStatus.approved:
        return refund.requestedAt.add(const Duration(minutes: 5));
      case RefundStatus.processing:
        return refund.requestedAt.add(const Duration(minutes: 30));
      case RefundStatus.completed:
        return refund.requestedAt.add(const Duration(hours: 2));
      case RefundStatus.rejected:
        return refund.requestedAt;
    }
  }

  static String stepDescription(RefundStatus step) {
    switch (step) {
      case RefundStatus.pendingReview:
        return 'We have received your refund request and are reviewing it.';
      case RefundStatus.approved:
        return 'Your refund has been approved.';
      case RefundStatus.processing:
        return 'Your refund is being processed. It may take 2-5 business days.';
      case RefundStatus.completed:
        return 'Refund has been successfully completed.';
      case RefundStatus.rejected:
        return 'Your refund request was not approved.';
    }
  }

  static String estimatedTimeLabel(RefundModel refund) {
    return refund.methodId == 'wallet' ? 'Instant (within minutes)' : '2-5 business days';
  }
}