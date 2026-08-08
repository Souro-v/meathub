import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/core/utils/pricing_utils.dart';

class WeightSelector extends StatelessWidget {
  final List<double> options;
  final double selectedGrams;
  final ValueChanged<double> onChanged;

  const WeightSelector({
    super.key,
    required this.options,
    required this.selectedGrams,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isCustomSelected = !options.contains(selectedGrams);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...options.map((grams) {
            final selected = !isCustomSelected && grams == selectedGrams;
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: _Chip(
                label: PricingUtils.formatWeight(grams),
                selected: selected,
                onTap: () => onChanged(grams),
              ),
            );
          }),
          _Chip(
            label: isCustomSelected
                ? PricingUtils.formatWeight(selectedGrams)
                : AppStrings.custom,
            selected: isCustomSelected,
            icon: Icons.edit,
            onTap: () => _showCustomDialog(context),
          ),
        ],
      ),
    );
  }

  Future<void> _showCustomDialog(BuildContext context) async {
    final controller = TextEditingController();
    final result = await showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.custom),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Enter weight in grams'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(context, double.tryParse(controller.text)),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    if (result != null && result > 0) onChanged(result);
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final IconData? icon;
  final VoidCallback onTap;

  const _Chip({
    required this.label,
    required this.selected,
    this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.divider,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: selected ? AppColors.white : AppColors.textDark,
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: 6),
              Icon(
                icon,
                size: 14,
                color: selected ? AppColors.white : AppColors.textHint,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
