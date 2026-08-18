import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/models/guarantee_item_model.dart';

class GuaranteeCard extends StatelessWidget {
  final GuaranteeItemModel guarantee;
  const GuaranteeCard({super.key, required this.guarantee});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(color: AppColors.primarySoft, shape: BoxShape.circle),
            child: Icon(guarantee.icon, size: 24, color: AppColors.primary),
          ),
          const SizedBox(height: 10),
          Text(
            guarantee.title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textDark),
          ),
          const SizedBox(height: 5),
          Text(
            guarantee.description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary, height: 1.35),
          ),
        ],
      ),
    );
  }
}