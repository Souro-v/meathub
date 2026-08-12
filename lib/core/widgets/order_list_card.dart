import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/core/utils/order_utils.dart';
import 'package:meathub/core/widgets/order_mini_timeline.dart';
import 'package:meathub/core/widgets/order_status_badge.dart';
import 'package:meathub/models/order_model.dart';

class OrderListCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onViewDetails;
  final VoidCallback onTrackOrder;
  final VoidCallback onOrderAgain;
  final VoidCallback onCancelOrder;

  const OrderListCard({
    super.key,
    required this.order,
    required this.onViewDetails,
    required this.onTrackOrder,
    required this.onOrderAgain,
    required this.onCancelOrder,
  });

  @override
  Widget build(BuildContext context) {
    final firstItem = order.items.first;
    final extraCount = order.items.length - 1;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.divider)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${AppStrings.orderIdLabel}: ${order.orderId}', style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                    const SizedBox(height: 2),
                    Text(_formatDate(order.placedAt), style: const TextStyle(fontSize: 11.5, color: AppColors.textHint)),
                  ],
                ),
              ),
              OrderStatusBadge(status: order.status),
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right, size: 18, color: AppColors.textHint),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(firstItem.product.image, width: 76, height: 76, fit: BoxFit.cover),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(firstItem.product.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                    const SizedBox(height: 2),
                    Text('${firstItem.weightLabel} • ${AppStrings.qtyLabel}: ${firstItem.quantity}', style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
                    if (extraCount > 0) ...[
                      const SizedBox(height: 2),
                      Text('+$extraCount more item${extraCount > 1 ? 's' : ''}', style: const TextStyle(fontSize: 11.5, color: AppColors.textHint)),
                    ],
                    const SizedBox(height: 4),
                    Text('৳${order.total.toStringAsFixed(0)}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.primary)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(_rightLabel(), style: const TextStyle(fontSize: 10.5, color: AppColors.textHint), textAlign: TextAlign.right),
                  const SizedBox(height: 3),
                  SizedBox(
                    width: 100,
                    child: Text(_rightValue(), style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.textDark), textAlign: TextAlign.right),
                  ),
                ],
              ),
            ],
          ),
          if (order.status == OrderStatus.outForDelivery) ...[
            const SizedBox(height: 16),
            OrderMiniTimeline(placedAt: order.placedAt),
          ],
          const SizedBox(height: 14),
          _buildActionButtons(),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final hour12 = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '${date.day} ${months[date.month - 1]} ${date.year}, $hour12:$minute $period';
  }

  String _rightLabel() {
    switch (order.status) {
      case OrderStatus.delivered:
        return 'Delivered on';
      case OrderStatus.cancelled:
        return 'Cancelled on';
      case OrderStatus.returned:
        return 'Returned on';
      default:
        return AppStrings.estimatedDelivery;
    }
  }

  String _rightValue() {
    switch (order.status) {
      case OrderStatus.delivered:
        return order.deliveredAt != null ? _formatDate(order.deliveredAt!) : '-';
      case OrderStatus.cancelled:
      case OrderStatus.returned:
        return order.cancelledAt != null ? _formatDate(order.cancelledAt!) : '-';
      default:
        return 'Today, ${OrderUtils.deliveryWindowLabel(order.placedAt)}';
    }
  }

  Widget _buildActionButtons() {
    switch (order.status) {
      case OrderStatus.outForDelivery:
      case OrderStatus.placed:
      case OrderStatus.confirmed:
        return Row(
          children: [
            Expanded(child: _outlineButton(AppStrings.viewDetails, onViewDetails)),
            const SizedBox(width: 10),
            Expanded(child: _filledButton(AppStrings.trackOrder, onTrackOrder)),
          ],
        );
      case OrderStatus.preparing:
        return Row(
          children: [
            Expanded(child: _outlineButton(AppStrings.cancelOrder, onCancelOrder, icon: Icons.cancel_outlined)),
            const SizedBox(width: 10),
            Expanded(child: _filledButton(AppStrings.trackOrder, onTrackOrder)),
          ],
        );
      case OrderStatus.delivered:
      case OrderStatus.cancelled:
      case OrderStatus.returned:
        return Row(
          children: [
            Expanded(child: _outlineButton(AppStrings.orderAgain, onOrderAgain, icon: Icons.refresh)),
            const SizedBox(width: 10),
            Expanded(child: _filledButton(AppStrings.viewDetails, onViewDetails)),
          ],
        );
    }
  }

  Widget _outlineButton(String label, VoidCallback onTap, {IconData? icon}) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary),
        minimumSize: const Size(0, 46),
        textStyle: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 15), const SizedBox(width: 6)],
          Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  Widget _filledButton(String label, VoidCallback onTap, {IconData icon = Icons.arrow_forward}) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        minimumSize: const Size(0, 46),
        textStyle: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
          const SizedBox(width: 6),
          Icon(icon, size: 15),
        ],
      ),
    );
  }
}