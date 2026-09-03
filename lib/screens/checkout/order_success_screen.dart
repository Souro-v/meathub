import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/core/routes/app_routes.dart';
import 'package:meathub/core/utils/order_utils.dart';
import 'package:meathub/core/widgets/order_success_details_card.dart';
import 'package:meathub/models/address_model.dart';
import 'package:meathub/models/cart_item_model.dart';
import 'package:meathub/models/delivery_option_model.dart';
import 'package:meathub/models/payment_method_model.dart';
import 'package:provider/provider.dart';

import '../../models/order_model.dart';
import '../../providers/orders_provider.dart';

class OrderSuccessScreen extends StatefulWidget {
  final String orderId;
  final DateTime placedAt;
  final List<CartItemModel> items;
  final DeliveryOptionModel deliveryOption;
  final ManagedAddressModel address;
  final double platformFee;
  final PaymentMethodModel paymentMethod;

  const OrderSuccessScreen({
    super.key,
    required this.orderId,
    required this.placedAt,
    required this.items,
    required this.deliveryOption,
    required this.address,
    required this.platformFee,
    required this.paymentMethod,
  });

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen> {
  late final ConfettiController _confettiController;
  late final String _deliveryWindow;

  OrderModel get _order =>
      context.read<OrdersProvider>().findById(widget.orderId)!;

  double get _subtotal => _order.subtotal;

  double get _total => _order.total;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );

    _deliveryWindow = OrderUtils.estimatedDeliveryWindow(
      widget.deliveryOption.subtitle,
    );
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _confettiController.play(),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _goToMain({int tabIndex = 0}) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.main,
      (route) => false,
      arguments: tabIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final points = OrderUtils.calculatePoints(_total);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                child: Column(
                  children: [
                    _buildCheckmarkGraphic(),
                    const SizedBox(height: 20),
                    const Text(
                      AppStrings.orderPlacedSuccessTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      AppStrings.orderPlacedSuccessSubtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 22),
                    _buildConfirmedBanner(),
                    const SizedBox(height: 14),
                    _buildEstimatedDeliveryCard(),
                    const SizedBox(height: 18),
                    OrderSuccessDetailsCard(
                      orderId: widget.orderId,
                      items: widget.items,
                      subtotal: _subtotal,
                      discount: _order.discount,
                      deliveryFee: _order.deliveryFee,
                      platformFee: widget.platformFee,
                      total: _total,
                    ),
                    const SizedBox(height: 14),
                    _buildAddressCard(),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.two_wheeler,
                      AppStrings.deliveryTypeLabel,
                      '${widget.deliveryOption.title} (${widget.deliveryOption.subtitle})',
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.credit_card,
                      AppStrings.paymentMethodLabel,
                      widget.paymentMethod.title,
                    ),
                    const SizedBox(height: 16),
                    _buildRewardsBanner(points),
                  ],
                ),
              ),
            ),
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckmarkGraphic() {
    return SizedBox(
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              numberOfParticles: 26,
              gravity: 0.25,
              minBlastForce: 8,
              maxBlastForce: 18,
              colors: const [
                AppColors.primary,
                Colors.green,
                Colors.orange,
                Colors.pinkAccent,
                Colors.amber,
              ],
            ),
          ),
          Container(
            width: 130,
            height: 130,
            decoration: const BoxDecoration(
              color: AppColors.successSoft,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 88,
            height: 88,
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: AppColors.white, size: 44),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmedBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.successSoft,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: AppColors.success,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  AppStrings.yourOrderConfirmedTitle,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  AppStrings.yourOrderConfirmedDesc,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEstimatedDeliveryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.access_time,
              color: AppColors.primary,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  AppStrings.estimatedDelivery,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _deliveryWindow,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).push(
              AppRoutes.trackOrderRoute(
                orderId: widget.orderId,
                placedAt: widget.placedAt,
                items: widget.items,
                address: widget.address,
                deliveryOption: widget.deliveryOption,
                paymentMethod: widget.paymentMethod,
                platformFee: widget.platformFee,
                discount: _order.discount,
              ),
            ),
            icon: const Icon(Icons.arrow_forward, size: 14),
            label: const Text(AppStrings.trackOrder),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              textStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard() {
    final address = widget.address;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.primarySoft,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.location_on,
              color: AppColors.primary,
              size: 19,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      address.label,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.primary),
                      ),
                      child: const Text(
                        AppStrings.currentBadge,
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  address.address,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  address.phone,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, size: 18, color: AppColors.textHint),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: AppColors.primarySoft,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 17),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: AppColors.textDark),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardsBanner(int points) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('🎁', style: TextStyle(fontSize: 30)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  AppStrings.thanksForBeingWithMeatHub,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: AppColors.textDark,
                    ),
                    children: [
                      const TextSpan(text: 'You earned '),
                      TextSpan(
                        text: '$points ',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                      const TextSpan(text: AppStrings.pointsEarnedSuffix),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  AppStrings.pointsWillBeAdded,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _goToMain(),
              icon: const Icon(Icons.home_outlined, size: 17),
              label: const Text(AppStrings.backToHome),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                minimumSize: const Size(0, 52),
                textStyle: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _goToMain(tabIndex: 3),
              icon: const Icon(Icons.arrow_forward, size: 16),
              label: const Text(AppStrings.viewMyOrders),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                minimumSize: const Size(0, 52),
                textStyle: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
