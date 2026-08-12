import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/utils/order_utils.dart';
import 'package:meathub/models/tracking_step_model.dart';

class OrderMiniTimeline extends StatelessWidget {
  final DateTime placedAt;
  const OrderMiniTimeline({super.key, required this.placedAt});

  @override
  Widget build(BuildContext context) {
    final steps = OrderUtils.buildTrackingSteps(placedAt).take(5).toList();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final isLast = index == steps.length - 1;
        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  if (index != 0) Expanded(child: Container(height: 2, color: _lineColor(steps[index - 1].status))),
                  _buildCircle(step),
                  if (!isLast) Expanded(child: Container(height: 2, color: _lineColor(step.status))),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                _shortLabel(step.title),
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: _labelColor(step.status)),
              ),
              const SizedBox(height: 2),
              Text(
                step.status == TrackingStepStatus.pending ? 'Pending' : _shortTime(step.timeLabel),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 9.5, color: AppColors.textHint),
              ),
            ],
          ),
        );
      }),
    );
  }

  String _shortLabel(String title) {
    if (title.contains('Placed')) return 'Placed';
    if (title.contains('Confirmed')) return 'Confirmed';
    if (title.contains('Preparing')) return 'Preparing';
    if (title.contains('Out for Delivery')) return 'Out for\nDelivery';
    if (title.contains('Delivered')) return 'Delivered';
    return title;
  }

  String _shortTime(String timeLabel) {
    final parts = timeLabel.split(', ');
    return parts.length > 1 ? parts.last : timeLabel;
  }

  Color _lineColor(TrackingStepStatus status) => status == TrackingStepStatus.completed ? AppColors.success : AppColors.divider;

  Color _labelColor(TrackingStepStatus status) {
    switch (status) {
      case TrackingStepStatus.completed:
        return AppColors.success;
      case TrackingStepStatus.live:
        return AppColors.primary;
      case TrackingStepStatus.pending:
        return AppColors.textHint;
    }
  }

  Widget _buildCircle(TrackingStepModel step) {
    switch (step.status) {
      case TrackingStepStatus.completed:
        return Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.success),
          child: const Icon(Icons.check, size: 13, color: AppColors.white),
        );
      case TrackingStepStatus.live:
        return Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.white, border: Border.all(color: AppColors.primary, width: 2)),
          child: Icon(step.icon, size: 12, color: AppColors.primary),
        );
      case TrackingStepStatus.pending:
        return Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.white, border: Border.all(color: AppColors.divider, width: 1.5)),
          child: Icon(step.icon, size: 12, color: AppColors.textHint),
        );
    }
  }
}