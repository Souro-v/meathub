import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/utils/date_format_utils.dart';
import 'package:meathub/core/widgets/coupon_code_chip.dart';
import 'package:meathub/models/coupon_model.dart';

class FeaturedOfferMiniCard extends StatelessWidget {
  final CouponModel offer;
  final VoidCallback onUseNow;

  const FeaturedOfferMiniCard({
    super.key,
    required this.offer,
    required this.onUseNow,
  });

  IconData get _fallbackIcon {
    switch (offer.type) {
      case CouponType.freeDelivery:
        return Icons.two_wheeler;
      case CouponType.flat:
        return Icons.account_balance_wallet;
      case CouponType.percentage:
        return Icons.local_offer;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: offer.lightBg,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: offer.chipBg,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Text(
                  offer.tagLabel,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: offer.themeColor,
                  ),
                ),
              ),
              const Spacer(),
              if (offer.image == null)
                Icon(
                  _fallbackIcon,
                  size: 26,
                  color: offer.themeColor.withValues(alpha: 0.5),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offer.amountLabel,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: offer.themeColor,
                      ),
                    ),
                    Text(
                      offer.amountSuffix,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: offer.themeColor,
                      ),
                    ),
                    if (offer.categoryLine != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        offer.categoryLine!,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ] else ...[
                      const SizedBox(height: 2),
                      Text(
                        offer.subtitle,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (offer.image != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    offer.image!,
                    width: 44,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              const Icon(
                Icons.access_time,
                size: 11,
                color: AppColors.textHint,
              ),
              const SizedBox(width: 4),
              Text(
                DateFormatUtils.formatFullDate(offer.validUntil),
                style: const TextStyle(
                  fontSize: 10.5,
                  color: AppColors.textHint,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: CouponCodeChip(
                  code: offer.code,
                  color: offer.themeColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
