import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.divider)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            AppStrings.orDivider,
            style: const TextStyle(color: AppColors.textHint, fontSize: 13),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.divider)),
      ],
    );
  }
}
