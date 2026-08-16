import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/core/utils/date_format_utils.dart';
import 'package:meathub/core/widgets/coupon_code_chip.dart';
import 'package:meathub/models/coupon_model.dart';

class FeaturedCouponCard extends StatelessWidget {
  final CouponModel coupon;
  final VoidCallback onUseNow;
  const FeaturedCouponCard({super.key, required this.coupon, required this.onUseNow});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: AppColors.divider), borderRadius: BorderRadius.circular(18)),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 130,
              padding: const EdgeInsets.all(14),
              color: coupon.lightBg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: coupon.chipBg, borderRadius: BorderRadius.circular(8)),
                    child: Text(coupon.tagLabel, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: coupon.themeColor)),
                  ),
                  const SizedBox(height: 10),
                  Text(coupon.amountLabel, style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: coupon.themeColor)),
                  Text(coupon.amountSuffix, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: coupon.themeColor)),
                  if (coupon.categoryLine != null) ...[
                    const SizedBox(height: 4),
                    Text(coupon.categoryLine!, style: const TextStyle(fontSize: 11.5, color: AppColors.textDark, fontWeight: FontWeight.w600)),
                  ],
                  const SizedBox(height: 4),
                  Text(coupon.subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.access_time, size: 12, color: AppColors.textHint),
                              const SizedBox(width: 4),
                              Text('Valid till ${DateFormatUtils.formatFullDate(coupon.validUntil)}', style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text('Use code', style: TextStyle(fontSize: 11.5, color: AppColors.textHint)),
                          const SizedBox(height: 4),
                          CouponCodeChip(code: coupon.code, color: coupon.themeColor),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: onUseNow,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: coupon.themeColor,
                                foregroundColor: AppColors.white,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              child: const Text(AppStrings.useNow),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (coupon.image != null) ...[
                      const SizedBox(width: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(coupon.image!, width: 60, height: 100, fit: BoxFit.cover),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}