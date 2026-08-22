import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/models/commitment_item_model.dart';

class IconLabelGridCard extends StatelessWidget {
  final CommitmentItemModel item;
  const IconLabelGridCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(item.icon, size: 26, color: AppColors.primary),
          const SizedBox(height: 10),
          Text(
            item.label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textDark, height: 1.3),
          ),
        ],
      ),
    );
  }
}