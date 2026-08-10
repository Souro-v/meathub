import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/core/widgets/checkout_item_row.dart';
import 'package:meathub/models/cart_item_model.dart';

class OrderSuccessDetailsCard extends StatelessWidget {
  final String orderId;
  final List<CartItemModel> items;
  final double subtotal;
  final double deliveryFee;
  final double platformFee;
  final double total;

  const OrderSuccessDetailsCard({
    super.key,
    required this.orderId,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.platformFee,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                AppStrings.orderDetails,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: orderId));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Order ID copied'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${AppStrings.orderIdLabel}: $orderId',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textHint,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Icon(
                      Icons.copy_outlined,
                      size: 13,
                      color: AppColors.textHint,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map((item) => CheckoutItemRow(item: item)),
          const Divider(color: AppColors.divider),
          const SizedBox(height: 6),
          _row(AppStrings.subtotal, '৳${subtotal.toStringAsFixed(0)}'),
          const SizedBox(height: 8),
          _row(
            AppStrings.deliveryFee,
            deliveryFee == 0
                ? AppStrings.freeLabel
                : '৳${deliveryFee.toStringAsFixed(0)}',
            valueColor: deliveryFee == 0
                ? AppColors.success
                : AppColors.textDark,
          ),
          const SizedBox(height: 8),
          _row(AppStrings.platformFee, '৳${platformFee.toStringAsFixed(0)}'),
          const SizedBox(height: 10),
          const Divider(color: AppColors.divider),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                AppStrings.totalAmount,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
              Text(
                '৳${total.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _row(
    String label,
    String value, {
    Color valueColor = AppColors.textDark,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
