import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/core/routes/app_routes.dart';
import 'package:meathub/core/utils/order_utils.dart';
import 'package:meathub/core/widgets/delivery_partner_section.dart';
import 'package:meathub/core/widgets/order_detail_item.dart';
import 'package:meathub/core/widgets/order_status_timeline.dart';
import 'package:meathub/core/widgets/track_order_item_card.dart';
import 'package:meathub/data/dummy_data.dart';
import 'package:meathub/models/address_model.dart';
import 'package:meathub/models/cart_item_model.dart';
import 'package:meathub/models/delivery_option_model.dart';
import 'package:meathub/models/payment_method_model.dart';

import '../../core/utils/fee_utils.dart';

class TrackOrderScreen extends StatelessWidget {
  final String orderId;
  final DateTime placedAt;
  final List<CartItemModel> items;
  final ManagedAddressModel address;
  final DeliveryOptionModel deliveryOption;
  final PaymentMethodModel paymentMethod;
  final double platformFee;
  final double discount;

  const TrackOrderScreen({
    super.key,
    required this.orderId,
    required this.placedAt,
    required this.items,
    required this.address,
    required this.deliveryOption,
    required this.paymentMethod,
    required this.platformFee,
    this.discount = 0,
  });

  double get _subtotal => items.fold(0, (sum, item) => sum + item.totalPrice);

  double get _deliveryFee => FeeUtils.deliveryFeeFor(
    deliveryOptionId: deliveryOption.id,
    subtotal: _subtotal,
  );

  double get _total => _subtotal - discount + _deliveryFee + platformFee;

  @override
  Widget build(BuildContext context) {
    final steps = OrderUtils.buildTrackingSteps(placedAt);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...items.map(
                      (item) => TrackOrderItemCard(
                        item: item,
                        onViewDetails: () => Navigator.of(
                          context,
                        ).push(AppRoutes.productDetailsRoute(item.product)),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildStatusCard(steps),
                    const SizedBox(height: 16),
                    DeliveryPartnerSection(
                      rider: DummyData.demoRider,
                      estimatedWindow: OrderUtils.deliveryWindowLabel(placedAt),
                    ),
                    const SizedBox(height: 14),
                    _buildNotificationBanner(),
                    const SizedBox(height: 16),
                    _buildOrderDetailsCard(),
                    const SizedBox(height: 14),
                    _buildChatTile(),
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    AppStrings.trackOrderTitle,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
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
                            fontSize: 12.5,
                            color: AppColors.textSecondary,
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
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: InkWell(
              onTap: () {},
              child: Row(
                children: const [
                  Icon(
                    Icons.headset_mic_outlined,
                    size: 17,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 5),
                  Text(
                    AppStrings.help,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(List<dynamic> steps) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
                AppStrings.orderStatusTitle,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.successSoft,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.shield_outlined,
                      size: 13,
                      color: AppColors.success,
                    ),
                    SizedBox(width: 5),
                    Text(
                      AppStrings.onTimeBadge,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          OrderStatusTimeline(steps: steps.cast()),
        ],
      ),
    );
  }

  Widget _buildNotificationBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: const [
          Icon(
            Icons.notifications_active_outlined,
            size: 18,
            color: AppColors.primary,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              AppStrings.notificationDeliveredNote,
              style: TextStyle(
                fontSize: 12.5,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderDetailsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 2),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppStrings.orderDetails,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    OrderDetailItem(
                      icon: Icons.event_note_outlined,
                      label: AppStrings.stepOrderPlaced,
                      value: 'Today, ${OrderUtils.formatTime(placedAt)}',
                    ),
                    OrderDetailItem(
                      icon: Icons.credit_card,
                      label: AppStrings.paymentMethodLabel,
                      value: paymentMethod.title,
                    ),
                    OrderDetailItem(
                      icon: Icons.location_on_outlined,
                      label: AppStrings.deliveryAddressLabel,
                      value: address.address,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  children: [
                    OrderDetailItem(
                      icon: Icons.two_wheeler,
                      label: AppStrings.deliveryTypeLabel,
                      value:
                          '${deliveryOption.title} (${deliveryOption.subtitle})',
                    ),
                    OrderDetailItem(
                      icon: Icons.receipt_long_outlined,
                      label: AppStrings.totalAmount,
                      value: '৳${_total.toStringAsFixed(0)}',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChatTile() {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: const [
            Icon(
              Icons.chat_bubble_outline,
              size: 18,
              color: AppColors.textDark,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                AppStrings.needHelpChat,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
            ),
            Icon(Icons.chevron_right, size: 18, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}
