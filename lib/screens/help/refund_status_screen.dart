import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/core/utils/date_format_utils.dart';
import 'package:meathub/core/utils/order_utils.dart';
import 'package:meathub/core/utils/refund_utils.dart';
import 'package:meathub/core/widgets/refund_progress_timeline.dart';
import 'package:meathub/models/refund_model.dart';
import 'package:meathub/providers/orders_provider.dart';
import 'package:meathub/screens/help/live_chat_screen.dart';

class RefundStatusScreen extends StatelessWidget {
  final String orderId;

  const RefundStatusScreen({super.key, required this.orderId});

  void _showHowItWorksDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(AppStrings.howRefundsWorkTitle),
        content: const Text(
          AppStrings.howRefundsWorkDesc,
          style: TextStyle(fontSize: 13, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

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
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildIdCard(refund, currentStatus),
                    const SizedBox(height: 22),
                    if (isRejected)
                      _buildRejectedCard(refund)
                    else ...[
                      const Text(
                        AppStrings.refundProgressTitle,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 14),
                      RefundProgressTimeline(refund: refund),
                    ],
                    const SizedBox(height: 8),
                    const Divider(color: AppColors.divider),
                    const SizedBox(height: 14),
                    _buildDetailsCard(refund),
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
                          minimumSize: const Size(0, 52),
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
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
          const Expanded(
            child: Text(
              AppStrings.refundStatusTitle,
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
          ),
          InkWell(
            onTap: () => _showHowItWorksDialog(context),
            borderRadius: BorderRadius.circular(18),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.divider),
              ),
              child: const Icon(
                Icons.help_outline,
                size: 18,
                color: AppColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdCard(RefundModel refund, RefundStatus status) {
    final isDone = status == RefundStatus.completed;
    final isRejected = status == RefundStatus.rejected;
    final badgeColor = isRejected
        ? AppColors.error
        : (isDone ? AppColors.success : AppColors.primary);
    final badgeBg = isRejected
        ? const Color(0xFFFCE4E4)
        : (isDone ? AppColors.successSoft : AppColors.primarySoft);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
              color: AppColors.primarySoft,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.assignment_return_outlined,
              color: AppColors.primary,
              size: 21,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      AppStrings.refundIdLabel,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: AppColors.textHint,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: badgeBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        RefundUtils.statusLabel(status),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: badgeColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  refund.refundId,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${AppStrings.orderIdLabel}: ${refund.orderId}',
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Requested on: ${DateFormatUtils.formatFullDate(refund.requestedAt)}, ${OrderUtils.formatTime(refund.requestedAt)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard(RefundModel refund) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppStrings.refundDetailsTitle,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 14),
          _detailRow(
            Icons.receipt_long_outlined,
            AppStrings.refundAmountLabel,
            '৳${refund.amount.toStringAsFixed(0)}',
            valueColor: AppColors.primary,
          ),
          const SizedBox(height: 12),
          _detailRow(
            Icons.account_balance_wallet_outlined,
            AppStrings.refundMethodResultLabel,
            refund.methodLabel,
          ),
          const SizedBox(height: 12),
          _detailRow(
            Icons.access_time,
            AppStrings.estimatedTimeFieldLabel,
            RefundUtils.estimatedTimeLabel(refund),
          ),
          const SizedBox(height: 12),
          _detailRow(
            Icons.description_outlined,
            AppStrings.noteFieldLabel,
            AppStrings.refundNotificationNote,
            isNote: true,
          ),
        ],
      ),
    );
  }

  Widget _detailRow(
    IconData icon,
    String label,
    String value, {
    Color valueColor = AppColors.textDark,
    bool isNote = false,
  }) {
    if (isNote) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 17, color: AppColors.textHint),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
    return Row(
      children: [
        Icon(icon, size: 17, color: AppColors.textHint),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, color: AppColors.textDark),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _buildRejectedCard(RefundModel refund) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFCE4E4),
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
