import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';

class CountryCodeChip extends StatelessWidget {
  const CountryCodeChip({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('+880', style: TextStyle(fontSize: 14, color: AppColors.textDark, fontWeight: FontWeight.w600)),
        SizedBox(width: 2),
        Icon(Icons.keyboard_arrow_down, size: 18, color: AppColors.textHint),
      ],
    );
  }
}