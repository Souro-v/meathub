import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/models/commitment_item_model.dart';

class CommitmentStatItem extends StatelessWidget {
  final CommitmentItemModel item;

  const CommitmentStatItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(item.icon, size: 24, color: AppColors.primary),
        const SizedBox(height: 8),
        Text(
          item.label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}
