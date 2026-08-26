enum RefundStatus { pendingReview, approved, processing, completed, rejected }

class RefundModel {
  final String refundId;
  final String orderId;
  final String reason;
  final String methodId; // 'wallet' or 'original'
  final String methodLabel;
  final double amount;
  final DateTime requestedAt;
  final String? additionalDetails;
  final String? rejectionReason;

  const RefundModel({
    required this.refundId,
    required this.orderId,
    required this.reason,
    required this.methodId,
    required this.methodLabel,
    required this.amount,
    required this.requestedAt,
    this.additionalDetails,
    this.rejectionReason,
  });
}