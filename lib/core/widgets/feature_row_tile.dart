import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/models/benefit_model.dart';

class FeatureRowTile extends StatelessWidget {
  final BenefitModel feature;
  final bool filled;

  const FeatureRowTile({super.key, required this.feature, this.filled = true});

  @override
  Widget build(BuildContext context) {
    final row = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: filled ? AppColors.white : feature.iconBg, shape: BoxShape.circle),
          child: Icon(feature.icon, size: 19, color: feature.iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(feature.title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: filled ? feature.iconColor : AppColors.textDark)),
              const SizedBox(height: 3),
              Text(feature.description, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4)),
            ],
          ),
        ),
      ],
    );

    if (!filled) {
      return Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: row);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: feature.iconBg, borderRadius: BorderRadius.circular(16)),
      child: row,
    );
  }
}