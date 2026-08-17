import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/core/utils/date_format_utils.dart';
import 'package:meathub/core/widgets/coupon_code_chip.dart';
import 'package:meathub/models/coupon_model.dart';

class AllOfferListCard extends StatelessWidget {
  final CouponModel offer;
  final VoidCallback onUseNow;

  const AllOfferListCard({super.key, required this.offer, required this.onUseNow});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.divider)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 78,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(color: offer.lightBg, borderRadius: BorderRadius.circular(12)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(offer.amountLabel, textAlign: TextAlign.center, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: offer.themeColor)),
                Text(offer.amountSuffix, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: offer.themeColor)),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(color: offer.chipBg, borderRadius: BorderRadius.circular(6)),
                  child: Text(offer.tagLabel, style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: offer.themeColor)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(offer.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                const SizedBox(height: 3),
                Text(offer.subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 12, color: AppColors.textHint),
                    const SizedBox(width: 4),
                    Text('${AppStrings.validTillPrefix} ${DateFormatUtils.formatFullDate(offer.validUntil)}',
                        style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Use code', style: TextStyle(fontSize: 10.5, color: AppColors.textHint)),
                        const SizedBox(height: 3),
                        CouponCodeChip(code: offer.code, color: offer.themeColor),
                      ],
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: onUseNow,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: offer.themeColor,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text(AppStrings.useNow),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}