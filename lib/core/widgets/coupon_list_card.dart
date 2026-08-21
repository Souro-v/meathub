import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/core/utils/date_format_utils.dart';
import 'package:meathub/core/widgets/coupon_code_chip.dart';
import 'package:meathub/models/coupon_model.dart';

class CouponListCard extends StatelessWidget {
  final CouponModel coupon;
  final VoidCallback onUseNow;

  const CouponListCard({
    super.key,
    required this.coupon,
    required this.onUseNow,
  });

  bool get _isActionable => coupon.status == CouponStatus.available;

  void _showTerms(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(AppStrings.termsConditions),
        content: const Text(
          AppStrings.couponTermsBody,
          style: TextStyle(fontSize: 13, height: 1.7),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      clipBehavior: Clip.antiAlias,
      child: Opacity(
        opacity: _isActionable ? 1 : 0.55,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 108,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 8,
                ),
                color: coupon.lightBg,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      coupon.amountLabel,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: coupon.themeColor,
                      ),
                    ),
                    Text(
                      coupon.amountSuffix,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: coupon.themeColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: coupon.chipBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        coupon.tagLabel,
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          color: coupon.themeColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              coupon.title,
                              style: const TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _showTerms(context),
                            child: const Text(
                              'T&C',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textHint,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        coupon.subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text(
                            'Use code',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: AppColors.textHint,
                            ),
                          ),
                          const SizedBox(width: 8),
                          CouponCodeChip(
                            code: coupon.code,
                            color: coupon.themeColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            coupon.status == CouponStatus.used
                                ? Icons.check_circle_outline
                                : Icons.access_time,
                            size: 12,
                            color: AppColors.textHint,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            coupon.status == CouponStatus.used
                                ? 'Used'
                                : coupon.status == CouponStatus.expired
                                ? 'Expired'
                                : 'Valid till ${DateFormatUtils.formatFullDate(coupon.validUntil)}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textHint,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: _isActionable
                            ? OutlinedButton(
                                onPressed: onUseNow,
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: coupon.themeColor,
                                  side: BorderSide(color: coupon.themeColor),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 8,
                                  ),
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  textStyle: const TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(AppStrings.useNow),
                              )
                            : Text(
                                coupon.status == CouponStatus.used
                                    ? 'Used'
                                    : 'Expired',
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textHint,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
