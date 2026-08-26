import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';

class HeroInfoBanner extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const HeroInfoBanner({super.key, required this.icon, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(18)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textDark)),
                const SizedBox(height: 6),
                Text(description, style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.5)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
            child: Icon(icon, size: 26, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}