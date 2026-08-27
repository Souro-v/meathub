import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/core/routes/app_routes.dart';
import 'package:meathub/core/utils/refund_utils.dart';
import 'package:meathub/core/widgets/checkout_item_row.dart';
import 'package:meathub/core/widgets/order_status_badge.dart';
import 'package:meathub/models/order_model.dart';
import 'package:meathub/models/refund_model.dart';
import 'package:meathub/providers/orders_provider.dart';
import 'package:meathub/screens/address/address_selection_screen.dart';
import 'package:meathub/screens/help/live_chat_screen.dart';

class OrderDetailsScreen extends StatelessWidget {
  final String orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final order = context.watch<OrdersProvider>().findById(orderId);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            if (order == null)
              Expanded(
                child: Center(
                  child: Text(
                    AppStrings.orderNotFound,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textHint,
                    ),
                  ),
                ),
              )
            else
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderCard(order),
                      const SizedBox(height: 16),
                      _buildItemsCard(order),
                      const SizedBox(height: 16),
                      _buildActionSection(context, order),
                      const SizedBox(height: 16),
                      _buildSecondaryActions(context, order),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.of(context).maybePop(),
            borderRadius: BorderRadius.circular(20),
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(
                Icons.arrow_back,
                size: 22,
                color: AppColors.textDark,
              ),
            ),
          ),
          const SizedBox(width: 2),
          const Text(
            AppStrings.orderDetailsTitle,
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCard(OrderModel order) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.orderId,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
              OrderStatusBadge(status: order.effectiveStatus),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _formatDate(order.placedAt),
            style: const TextStyle(fontSize: 12, color: AppColors.textHint),
          ),
          const SizedBox(height: 2),
          Text(
            order.paymentMethod.title,
            style: const TextStyle(fontSize: 12, color: AppColors.textHint),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsCard(OrderModel order) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${AppStrings.itemsLabel} (${order.items.length})',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          ...order.items.map((item) => CheckoutItemRow(item: item)),
          const Divider(color: AppColors.divider),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                AppStrings.total,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
              Text(
                '৳${order.total.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildActionSection(BuildContext context, OrderModel order) {
    switch (order.effectiveStatus) {
      case OrderStatus.placed:
      case OrderStatus.confirmed:
      case OrderStatus.preparing:
        return _primaryButton(
          label: AppStrings.cancelOrder,
          icon: Icons.cancel_outlined,
          color: AppColors.error,
          onTap: () => _confirmCancel(context, order),
        );

      case OrderStatus.outForDelivery:
        return _primaryButton(
          label: AppStrings.contactSupport,
          icon: Icons.headset_mic_outlined,
          color: AppColors.primary,
          onTap: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const LiveChatScreen())),
        );

      case OrderStatus.delivered:
        return _primaryButton(
          label: AppStrings.reportAnIssueTitle,
          icon: Icons.report_problem_outlined,
          color: AppColors.primary,
          onTap: () => Navigator.of(
            context,
          ).push(AppRoutes.reportIssueRoute(orderId: order.orderId)),
        );

      case OrderStatus.deliveryFailed:
        return _primaryButton(
          label: AppStrings.requestRefundTitle,
          icon: Icons.account_balance_wallet_outlined,
          color: AppColors.primary,
          onTap: () => Navigator.of(
            context,
          ).push(AppRoutes.refundRequestRoute(order.orderId)),
        );

      case OrderStatus.cancelled:
        if (order.refund == null) {
          if (order.isCod) {
            return _infoBanner(
              text:
                  'This order was cancelled. No payment was collected, so no refund is needed.',
            );
          }
          return _primaryButton(
            label: AppStrings.processRefund,
            icon: Icons.account_balance_wallet_outlined,
            color: AppColors.primary,
            onTap: () => Navigator.of(
              context,
            ).push(AppRoutes.refundRequestRoute(order.orderId)),
          );
        }
        return _refundStatusBanner(context, order);

      case OrderStatus.refundPending:
      case OrderStatus.refunded:
        return _refundStatusBanner(context, order);

      case OrderStatus.returned:
        return const SizedBox.shrink();
    }
  }

  Widget _primaryButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 17),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: AppColors.white,
          minimumSize: const Size(0, 52),
          textStyle: const TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w700,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  Widget _infoBanner({required String text}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 18, color: AppColors.textHint),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12.5,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _refundStatusBanner(BuildContext context, OrderModel order) {
    final refund = order.refund!;
    final refundStatus = RefundUtils.computeStatus(refund);
    final isDone = refundStatus == RefundStatus.completed;
    final label = isDone
        ? AppStrings.refundCompleted
        : AppStrings.refundInProgress;
    final color = isDone ? AppColors.success : AppColors.primary;
    final bg = isDone ? AppColors.successSoft : AppColors.primarySoft;

    return InkWell(
      onTap: () => Navigator.of(
        context,
      ).push(AppRoutes.refundStatusRoute(order.orderId)),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isDone ? Icons.check_circle_outline : Icons.autorenew,
                size: 19,
                color: color,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${RefundUtils.statusLabel(refundStatus)} • ${AppStrings.viewRefundDetails}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, size: 20, color: color),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryActions(BuildContext context, OrderModel order) {
    final status = order.effectiveStatus;
    const modifiable = {
      OrderStatus.placed,
      OrderStatus.confirmed,
      OrderStatus.preparing,
    };
    final canChangeAddress = modifiable.contains(status);
    final canTrack = {
      ...modifiable,
      OrderStatus.outForDelivery,
    }.contains(status);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (canTrack)
          _secondaryTile(
            icon: Icons.local_shipping_outlined,
            title: AppStrings.trackOrder,
            onTap: () => Navigator.of(context).push(
              AppRoutes.trackOrderRoute(
                orderId: order.orderId,
                placedAt: order.placedAt,
                items: order.items,
                address: order.address,
                deliveryOption: order.deliveryOption,
                paymentMethod: order.paymentMethod,
                platformFee: order.platformFee,
              ),
            ),
          ),
        if (canChangeAddress)
          _secondaryTile(
            icon: Icons.location_on_outlined,
            title: AppStrings.changeDeliveryAddress,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AddressSelectionScreen()),
            ),
          ),
        _secondaryTile(
          icon: Icons.headset_mic_outlined,
          title: AppStrings.contactSupport,
          onTap: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const LiveChatScreen())),
        ),
      ],
    );
  }

  Widget _secondaryTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 18,
              color: AppColors.textHint,
            ),
          ],
        ),
      ),
    );
  }

  void _confirmCancel(BuildContext context, OrderModel order) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(AppStrings.cancelOrderConfirmTitle),
        content: Text(
          order.isCod
              ? AppStrings.cancelOrderConfirmDesc
              : 'This order was paid via ${order.paymentMethod.title}. A refund will be started automatically.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(AppStrings.no),
          ),
          TextButton(
            onPressed: () {
              context.read<OrdersProvider>().cancelOrder(order.orderId);
              Navigator.pop(dialogContext);
            },
            child: const Text(
              AppStrings.yesCancel,
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final hour12 = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '${date.day} ${months[date.month - 1]} ${date.year}, $hour12:$minute $period';
  }
}
