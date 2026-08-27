import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/core/utils/refund_utils.dart';
import 'package:meathub/models/refund_model.dart';
import 'package:meathub/providers/orders_provider.dart';
import 'package:meathub/screens/help/live_chat_screen.dart';

class RefundStatusScreen extends StatelessWidget {
  final String orderId;

  const RefundStatusScreen({super.key, required this.orderId});

  static const List<RefundStatus> _steps = [
    RefundStatus.pendingReview,
    RefundStatus.approved,
    RefundStatus.processing,
    RefundStatus.completed,
  ];

  @override
  Widget build(BuildContext context) {
    final order = context.watch<OrdersProvider>().findById(orderId);
    final refund = order?.refund;

    if (order == null || refund == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(child: Center(child: Text(AppStrings.orderNotFound))),
      );
    }

    final currentStatus = RefundUtils.computeStatus(refund);
    final isRejected = currentStatus == RefundStatus.rejected;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.successSoft,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: AppColors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check_circle_outline,
                              color: AppColors.success,
                              size: 19,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              AppStrings.refundRequestSubmittedTitle,
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.success,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: Column(
                        children: [
                          _row(AppStrings.refundIdLabel, refund.refundId),
                          const SizedBox(height: 10),
                          _row(AppStrings.orderIdLabel, refund.orderId),
                          const SizedBox(height: 10),
                          _row(
                            AppStrings.refundAmountLabel,
                            '৳${refund.amount.toStringAsFixed(0)}',
                          ),
                          const SizedBox(height: 10),
                          _row(
                            AppStrings.refundMethodResultLabel,
                            refund.methodLabel,
                          ),
                          const SizedBox(height: 10),
                          _row('Reason', refund.reason),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      AppStrings.refundStatusTitle,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (isRejected)
                      _buildRejectedCard(refund)
                    else
                      _buildTimeline(currentStatus),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const LiveChatScreen(),
                          ),
                        ),
                        icon: const Icon(Icons.headset_mic_outlined, size: 16),
                        label: const Text(AppStrings.contactSupport),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary),
                          minimumSize: const Size(0, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.of(context).maybePop(),
            borderRadius: BorderRadius.circular(20),
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(
                Icons.arrow_back,
                size: 22,
                color: AppColors.textDark,
              ),
            ),
          ),
          const SizedBox(width: 2),
          const Text(
            AppStrings.refundStatusTitle,
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12.5,
            color: AppColors.textSecondary,
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeline(RefundStatus current) {
    final currentIndex = _steps.indexOf(current);
    return Column(
      children: List.generate(_steps.length, (index) {
        final step = _steps[index];
        final isDone =
            index < currentIndex ||
            (index == currentIndex && current == RefundStatus.completed);
        final isActive =
            index == currentIndex && current != RefundStatus.completed;
        final isLast = index == _steps.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.white,
                      border: Border.all(
                        color: isDone
                            ? AppColors.success
                            : (isActive
                                  ? AppColors.primary
                                  : AppColors.divider),
                        width: isActive ? 2 : 1.4,
                      ),
                    ),
                    child: isDone
                        ? const Icon(
                            Icons.check,
                            size: 15,
                            color: AppColors.success,
                          )
                        : isActive
                        ? const Padding(
                            padding: EdgeInsets.all(7),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(
                                AppColors.primary,
                              ),
                            ),
                          )
                        : null,
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: isDone ? AppColors.success : AppColors.divider,
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 14),
              Padding(
                padding: EdgeInsets.only(bottom: isLast ? 0 : 26, top: 4),
                child: Text(
                  RefundUtils.statusLabel(step),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isDone
                        ? AppColors.success
                        : (isActive ? AppColors.primary : AppColors.textHint),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildRejectedCard(RefundModel refund) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.cancel_outlined, color: AppColors.error, size: 20),
              SizedBox(width: 8),
              Text(
                AppStrings.refundRejectedTitle,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            refund.rejectionReason ??
                'Please contact support for more details.',
            style: const TextStyle(
              fontSize: 12.5,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
