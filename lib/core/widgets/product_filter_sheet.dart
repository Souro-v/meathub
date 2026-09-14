import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/core/utils/product_filter_criteria.dart';

class ProductFilterSheet extends StatefulWidget {
  final ProductFilterCriteria initialCriteria;

  const ProductFilterSheet({super.key, required this.initialCriteria});

  @override
  State<ProductFilterSheet> createState() => _ProductFilterSheetState();
}

class _ProductFilterSheetState extends State<ProductFilterSheet> {
  late RangeValues _priceRange;
  late double _minRating;
  late bool _discountOnly;

  static const double _maxPrice = 2000;
  static const List<double> _ratingOptions = [0, 3.5, 4, 4.5];

  @override
  void initState() {
    super.initState();
    _priceRange = widget.initialCriteria.priceRange;
    _minRating = widget.initialCriteria.minRating;
    _discountOnly = widget.initialCriteria.discountOnly;
  }

  void _reset() {
    setState(() {
      _priceRange = const RangeValues(0, _maxPrice);
      _minRating = 0;
      _discountOnly = false;
    });
  }

  void _apply() {
    Navigator.of(context).pop(
      ProductFilterCriteria(
        priceRange: _priceRange,
        minRating: _minRating,
        discountOnly: _discountOnly,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  AppStrings.filterProductsTitle,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                GestureDetector(
                  onTap: _reset,
                  child: const Text(
                    AppStrings.resetFiltersLabel,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  AppStrings.priceRangeLabel,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                Text(
                  '৳${_priceRange.start.toStringAsFixed(0)} - ৳${_priceRange.end.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            RangeSlider(
              values: _priceRange,
              min: 0,
              max: _maxPrice,
              divisions: 40,
              activeColor: AppColors.primary,
              inactiveColor: AppColors.divider,
              labels: RangeLabels(
                '৳${_priceRange.start.toStringAsFixed(0)}',
                '৳${_priceRange.end.toStringAsFixed(0)}',
              ),
              onChanged: (values) => setState(() => _priceRange = values),
            ),
            const SizedBox(height: 12),
            const Text(
              AppStrings.minimumRatingLabel,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: _ratingOptions.map((rating) {
                final selected = _minRating == rating;
                return ChoiceChip(
                  label: Text(
                    rating == 0 ? AppStrings.anyRatingLabel : '$rating+',
                  ),
                  selected: selected,
                  onSelected: (_) => setState(() => _minRating = rating),
                  selectedColor: AppColors.primarySoft,
                  labelStyle: TextStyle(
                    color: selected ? AppColors.primary : AppColors.textDark,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: selected ? AppColors.primary : AppColors.divider,
                    ),
                  ),
                  backgroundColor: AppColors.white,
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    AppStrings.discountedItemsOnlyLabel,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                Switch(
                  value: _discountOnly,
                  activeThumbColor: AppColors.primary,
                  onChanged: (v) => setState(() => _discountOnly = v),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _apply,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  minimumSize: const Size(0, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(AppStrings.applyFiltersLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
