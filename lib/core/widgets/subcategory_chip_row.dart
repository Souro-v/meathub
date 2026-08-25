import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';

class SubCategoryChipRow extends StatelessWidget {
  final List<String> chips;
  final String selected;
  final ValueChanged<String> onSelected;

  const SubCategoryChipRow({super.key, required this.chips, required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: chips.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final chip = chips[index];
          final isSelected = selected == chip;
          return GestureDetector(
            onTap: () => onSelected(chip),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isSelected ? AppColors.primary : AppColors.divider),
              ),
              child: Text(chip, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: isSelected ? AppColors.white : AppColors.textDark)),
            ),
          );
        },
      ),
    );
  }
}