import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/core/widgets/checkout_item_row.dart';
import 'package:meathub/models/cart_item_model.dart';

class OrderSummaryCard extends StatefulWidget {
  final List<CartItemModel> items;
  final double subtotal;
  final double deliveryFee;
  final double platformFee;
  final double total;
  final bool collapsible;

  const OrderSummaryCard({
    super.key,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.platformFee,
    required this.total,
    this.collapsible = false,
  });

  @override
  State<OrderSummaryCard> createState() => _OrderSummaryCardState();
}

class _OrderSummaryCardState extends State<OrderSummaryCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final showToggle = widget.collapsible && widget.items.length > 1;
    final totalQuantity = widget.items.fold<int>(
      0,
      (sum, item) => sum + item.quantity,
    );

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppStrings.orderSummary,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          CheckoutItemRow(item: widget.items.first),
          if (showToggle) ...[
            if (_expanded)
              ...widget.items
                  .skip(1)
                  .map((item) => CheckoutItemRow(item: item)),
            GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _expanded
                          ? AppStrings.hideDetails
                          : AppStrings.viewDetails,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    Icon(
                      _expanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 18,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ),
          ] else if (!widget.collapsible && widget.items.length > 1)
            ...widget.items.skip(1).map((item) => CheckoutItemRow(item: item)),
          const Divider(color: AppColors.divider),
          const SizedBox(height: 6),
          _row(
            '${AppStrings.subtotal} ($totalQuantity ${AppStrings.itemsLabel})',
            '৳${widget.subtotal.toStringAsFixed(0)}',
          ),
          const SizedBox(height: 8),
          _row(
            AppStrings.deliveryFee,
            widget.deliveryFee == 0
                ? AppStrings.freeLabel
                : '৳${widget.deliveryFee.toStringAsFixed(0)}',
            valueColor: widget.deliveryFee == 0
                ? AppColors.success
                : AppColors.textDark,
          ),
          const SizedBox(height: 8),
          _row(
            AppStrings.platformFee,
            '৳${widget.platformFee.toStringAsFixed(0)}',
          ),
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
                '৳${widget.total.toStringAsFixed(0)}',
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
