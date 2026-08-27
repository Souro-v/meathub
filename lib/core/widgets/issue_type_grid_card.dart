import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';

class IssueTypeGridCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const IssueTypeGridCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? AppColors.primarySoft : AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? AppColors.primary : AppColors.divider, width: selected ? 1.6 : 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 26, color: selected ? AppColors.primary : iconColor),
            const SizedBox(height: 8),
            Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: selected ? AppColors.primary : AppColors.textDark)),
          ],
        ),
      ),
    );
  }
}