import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/models/payment_method_model.dart';

class PaymentMethodTile extends StatelessWidget {
  final PaymentMethodModel method;
  final bool selected;
  final VoidCallback onTap;

  const PaymentMethodTile({
    super.key,
    required this.method,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primarySoft : AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.divider,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? AppColors.primary : AppColors.divider,
              size: 20,
            ),
            const SizedBox(width: 10),
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: method.iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(method.icon, size: 19, color: method.iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    method.subtitle,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
            if (method.isRecommended)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  AppStrings.recommended,
                  style: TextStyle(
                    fontSize: 10.5,
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            else ...[
              if (method.showCardBrands) ...[
                _BrandChip(label: 'VISA', color: const Color(0xFF1A1F71)),
                const SizedBox(width: 4),
                _BrandChip(label: 'MC', color: const Color(0xFFEB6323)),
                const SizedBox(width: 4),
                _BrandChip(label: 'AMEX', color: const Color(0xFF2E77BB)),
                const SizedBox(width: 6),
              ],
              const Icon(
                Icons.chevron_right,
                size: 18,
                color: AppColors.textHint,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _BrandChip extends StatelessWidget {
  final String label;
  final Color color;

  const _BrandChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 8.5,
          color: AppColors.white,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
