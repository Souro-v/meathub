import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_assets.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';

class AuthHeader extends StatelessWidget {
  final VoidCallback? onBack;
  const AuthHeader({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: onBack ?? () => Navigator.of(context).maybePop(),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white,
              border: Border.all(color: AppColors.divider),
            ),
            child: const Icon(Icons.arrow_back, size: 18, color: AppColors.textDark),
          ),
        ),
        Column(
          children: [
            const SizedBox(height: 4),
            Image.asset(AppAssets.appLogo, width: 68, height: 68),
            const SizedBox(height: 8),
            const Text(
              'MeatHub',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              AppStrings.tagline,
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
      ],
    );
  }
}