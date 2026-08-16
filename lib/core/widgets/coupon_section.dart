import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/core/utils/coupon_utils.dart';
import 'package:meathub/models/cart_item_model.dart';
import 'package:meathub/models/coupon_model.dart';
import 'package:meathub/providers/coupon_provider.dart';

class CouponSection extends StatelessWidget {
  final List<CartItemModel> items;
  final double subtotal;
  final double originalDeliveryFee;

  const CouponSection({
    super.key,
    required this.items,
    required this.subtotal,
    required this.originalDeliveryFee,
  });

  @override
  Widget build(BuildContext context) {
    final coupon = context.watch<CouponProvider>().appliedCoupon;
    if (coupon == null) return const SizedBox.shrink();

    final error = CouponUtils.validate(coupon, items, subtotal);

    if (error.isNotEmpty) {
      return Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: const Color(0xFFFFF1D6), borderRadius: BorderRadius.circular(14)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.error_outline, size: 18, color: Color(0xFFB26A00)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${coupon.code} — not applicable', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFFB26A00))),
                  const SizedBox(height: 2),
                  Text(error, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4)),
                ],
              ),
            ),
            TextButton(
              onPressed: () => context.read<CouponProvider>().remove(),
              style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 0)),
              child: const Text(AppStrings.remove, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.error)),
            ),
          ],
        ),
      );
    }

    final saved = coupon.type == CouponType.freeDelivery
        ? originalDeliveryFee
        : CouponUtils.calculateDiscount(coupon, items, subtotal);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.successSoft, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
            child: const Icon(Icons.confirmation_number, size: 17, color: AppColors.success),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('🎟️ ${coupon.code} applied', style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.success)),
                const SizedBox(height: 2),
                Text('You saved ৳${saved.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12.5, color: AppColors.textDark)),
              ],
            ),
          ),
          TextButton(
            onPressed: () => context.read<CouponProvider>().remove(),
            style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 0)),
            child: const Text(AppStrings.remove, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}