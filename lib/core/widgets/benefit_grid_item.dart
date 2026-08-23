import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/models/benefit_model.dart';

class BenefitGridItem extends StatelessWidget {
  final BenefitModel benefit;
  const BenefitGridItem({super.key, required this.benefit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(color: benefit.iconBg, shape: BoxShape.circle),
            child: Icon(benefit.icon, size: 18, color: benefit.iconColor),
          ),
          const SizedBox(height: 10),
          Text(benefit.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textDark)),
          const SizedBox(height: 4),
          Text(benefit.description, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.35)),
        ],
      ),
    );
  }
}