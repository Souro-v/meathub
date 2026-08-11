import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/models/tracking_step_model.dart';

class OrderStatusTimeline extends StatelessWidget {
  final List<TrackingStepModel> steps;

  const OrderStatusTimeline({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final isLast = index == steps.length - 1;
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  _buildIconCircle(step),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: step.status == TrackingStepStatus.completed
                            ? AppColors.success
                            : AppColors.divider,
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 22),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              step.title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: _titleColor(step.status),
                              ),
                            ),
                            if (step.description != null) ...[
                              const SizedBox(height: 3),
                              Text(
                                step.description!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                  height: 1.4,
                                ),
                              ),
                            ],
                            if (step.timeLabel.isNotEmpty) ...[
                              const SizedBox(height: 3),
                              Text(
                                step.timeLabel,
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  color: AppColors.textHint,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (step.status == TrackingStepStatus.completed)
                        const Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Text(
                            AppStrings.completedLabel,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.success,
                            ),
                          ),
                        )
                      else if (step.status == TrackingStepStatus.live)
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primarySoft,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.circle,
                                size: 7,
                                color: AppColors.primary,
                              ),
                              SizedBox(width: 5),
                              Text(
                                AppStrings.liveLabel,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
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

  Color _titleColor(TrackingStepStatus status) {
    switch (status) {
      case TrackingStepStatus.completed:
        return AppColors.success;
      case TrackingStepStatus.live:
        return AppColors.primary;
      case TrackingStepStatus.pending:
        return AppColors.textDark;
    }
  }

  Widget _buildIconCircle(TrackingStepModel step) {
    switch (step.status) {
      case TrackingStepStatus.completed:
        return Container(
          width: 30,
          height: 30,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.success,
          ),
          child: const Icon(Icons.check, size: 16, color: AppColors.white),
        );
      case TrackingStepStatus.live:
        return Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.white,
            border: Border.all(color: AppColors.primary, width: 2),
          ),
          child: Icon(step.icon, size: 15, color: AppColors.primary),
        );
      case TrackingStepStatus.pending:
        return Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.white,
            border: Border.all(color: AppColors.divider, width: 1.5),
          ),
          child: Icon(step.icon, size: 15, color: AppColors.textHint),
        );
    }
  }
}
