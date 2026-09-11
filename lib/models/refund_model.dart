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
  Map<String, dynamic> toJson() => {
    'refundId': refundId,
    'orderId': orderId,
    'reason': reason,
    'methodId': methodId,
    'methodLabel': methodLabel,
    'amount': amount,
    'requestedAt': requestedAt.toIso8601String(),
    'additionalDetails': additionalDetails,
    'rejectionReason': rejectionReason,
  };

  factory RefundModel.fromJson(Map<String, dynamic> json) => RefundModel(
    refundId: json['refundId'] as String,
    orderId: json['orderId'] as String,
    reason: json['reason'] as String,
    methodId: json['methodId'] as String,
    methodLabel: json['methodLabel'] as String,
    amount: (json['amount'] as num).toDouble(),
    requestedAt: DateTime.parse(json['requestedAt'] as String),
    additionalDetails: json['additionalDetails'] as String?,
    rejectionReason: json['rejectionReason'] as String?,
  );
}