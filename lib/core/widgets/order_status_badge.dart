import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/models/order_model.dart';

class OrderStatusBadge extends StatelessWidget {
  final OrderStatus status;

  const OrderStatusBadge({super.key, required this.status});

  _StatusStyle get _style {
    switch (status) {
      case OrderStatus.outForDelivery:
        return _StatusStyle(
          icon: Icons.local_shipping,
          label: 'Out for Delivery',
          fg: AppColors.success,
          bg: AppColors.successSoft,
        );
      case OrderStatus.delivered:
        return _StatusStyle(
          icon: Icons.check_circle,
          label: 'Delivered',
          fg: AppColors.success,
          bg: AppColors.successSoft,
        );
      case OrderStatus.preparing:
        return _StatusStyle(
          icon: Icons.access_time_filled,
          label: 'Preparing',
          fg: const Color(0xFFB26A00),
          bg: const Color(0xFFFFF1D6),
        );
      case OrderStatus.confirmed:
        return _StatusStyle(
          icon: Icons.check_circle_outline,
          label: 'Confirmed',
          fg: AppColors.primary,
          bg: AppColors.primarySoft,
        );
      case OrderStatus.placed:
        return _StatusStyle(
          icon: Icons.receipt_long,
          label: 'Placed',
          fg: AppColors.primary,
          bg: AppColors.primarySoft,
        );
      case OrderStatus.cancelled:
        return _StatusStyle(
          icon: Icons.cancel_outlined,
          label: 'Cancelled',
          fg: AppColors.textHint,
          bg: AppColors.surface,
        );
      case OrderStatus.returned:
        return _StatusStyle(
          icon: Icons.assignment_return_outlined,
          label: 'Returned',
          fg: const Color(0xFF6A4FBF),
          bg: const Color(0xFFEEE9FB),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = _style;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: s.bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(s.icon, size: 13, color: s.fg),
          const SizedBox(width: 5),
          Text(
            s.label,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: s.fg,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusStyle {
  final IconData icon;
  final String label;
  final Color fg;
  final Color bg;

  _StatusStyle({
    required this.icon,
    required this.label,
    required this.fg,
    required this.bg,
  });
}
