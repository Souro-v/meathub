import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/utils/date_format_utils.dart';
import 'package:meathub/core/utils/order_utils.dart';
import 'package:meathub/core/utils/refund_utils.dart';
import 'package:meathub/models/refund_model.dart';

class RefundProgressTimeline extends StatelessWidget {
  final RefundModel refund;

  const RefundProgressTimeline({super.key, required this.refund});

  static const List<RefundStatus> _steps = [
    RefundStatus.pendingReview,
    RefundStatus.approved,
    RefundStatus.processing,
    RefundStatus.completed,
  ];

  @override
  Widget build(BuildContext context) {
    final current = RefundUtils.computeStatus(refund);
    final currentIndex = current == RefundStatus.rejected
        ? -1
        : _steps.indexOf(current);

    return Column(
      children: List.generate(_steps.length, (index) {
        final step = _steps[index];
        final isLast = index == _steps.length - 1;
        final isDone =
            index < currentIndex ||
            (index == currentIndex && step == RefundStatus.completed);
        final isActive =
            index == currentIndex && step != RefundStatus.completed;
        final color = isDone
            ? AppColors.success
            : (isActive ? AppColors.primary : AppColors.textHint);

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDone ? AppColors.success : AppColors.white,
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
                            color: AppColors.white,
                          )
                        : isActive
                        ? Center(
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primary,
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
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 4 : 22),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              RefundUtils.statusLabel(step),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: color,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              RefundUtils.stepDescription(step),
                              style: TextStyle(
                                fontSize: 12,
                                color: isDone || isActive
                                    ? AppColors.textSecondary
                                    : AppColors.textHint,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isDone || isActive) ...[
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              DateFormatUtils.formatFullDate(
                                RefundUtils.stepTime(refund, step),
                              ),
                              style: TextStyle(
                                fontSize: 10.5,
                                color: color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              OrderUtils.formatTime(
                                RefundUtils.stepTime(refund, step),
                              ),
                              style: TextStyle(
                                fontSize: 10.5,
                                color: color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
