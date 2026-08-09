import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';

class FreeDeliveryProgressCard extends StatelessWidget {
  final double amountLeft;
  final double progress;
  final bool qualifies;

  const FreeDeliveryProgressCard({
    super.key,
    required this.amountLeft,
    required this.progress,
    required this.qualifies,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_shipping_outlined,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  qualifies
                      ? "You've unlocked FREE delivery!"
                      : "You're ৳${amountLeft.toStringAsFixed(0)} away from FREE delivery!",
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 8,
                          backgroundColor: AppColors.divider,
                          valueColor: const AlwaysStoppedAnimation(
                            AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    if (!qualifies) ...[
                      const SizedBox(width: 10),
                      Text(
                        '৳${amountLeft.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
