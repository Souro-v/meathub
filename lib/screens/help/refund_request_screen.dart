import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/core/routes/app_routes.dart';
import 'package:meathub/core/utils/refund_utils.dart';
import 'package:meathub/core/widgets/hero_info_banner.dart';
import 'package:meathub/core/widgets/radio_option_tile.dart';
import 'package:meathub/models/order_model.dart';
import 'package:meathub/models/refund_model.dart';
import 'package:meathub/providers/orders_provider.dart';

class RefundRequestScreen extends StatefulWidget {
  final String orderId;

  const RefundRequestScreen({super.key, required this.orderId});

  @override
  State<RefundRequestScreen> createState() => _RefundRequestScreenState();
}

class _RefundRequestScreenState extends State<RefundRequestScreen> {
  String? _selectedReason;
  String _selectedMethodId = 'wallet';
  final _detailsController = TextEditingController();

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  List<Map<String, String>> _reasonsFor(OrderModel order) {
    if (order.status == OrderStatus.deliveryFailed) {
      return [
        {
          'title': AppStrings.reasonOrderNotDelivered,
          'desc': AppStrings.reasonOrderNotDeliveredDesc,
        },
        {'title': AppStrings.reasonOther, 'desc': AppStrings.reasonOtherDesc},
      ];
    }
    return [
      {
        'title': AppStrings.reasonOrderCancelled,
        'desc': AppStrings.reasonOrderCancelledDesc,
      },
      {'title': AppStrings.reasonOther, 'desc': AppStrings.reasonOtherDesc},
    ];
  }

  void _submit(OrderModel order) {
    final methodLabel = _selectedMethodId == 'wallet'
        ? AppStrings.meatHubWalletLabel
        : AppStrings.originalPaymentMethodLabel;
    final refund = RefundModel(
      refundId: RefundUtils.generateRefundId(),
      orderId: order.orderId,
      reason: _selectedReason ?? _reasonsFor(order).first['title']!,
      methodId: _selectedMethodId,
      methodLabel: methodLabel,
      amount: order.total,
      requestedAt: DateTime.now(),
      additionalDetails: _detailsController.text.trim().isEmpty
          ? null
          : _detailsController.text.trim(),
    );
    context.read<OrdersProvider>().requestRefund(order.orderId, refund);
    Navigator.of(
      context,
    ).pushReplacement(AppRoutes.refundStatusRoute(order.orderId));
  }

  @override
  Widget build(BuildContext context) {
    final order = context.watch<OrdersProvider>().findById(widget.orderId);

    if (order == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(child: Center(child: Text(AppStrings.orderNotFound))),
      );
    }

    final reasons = _reasonsFor(order);
    final selectedReason = _selectedReason ?? reasons.first['title']!;
    final isCod = order.isCod;

    final hasActiveRefund =
        order.refund != null &&
        RefundUtils.computeStatus(order.refund!) != RefundStatus.completed &&
        RefundUtils.computeStatus(order.refund!) != RefundStatus.rejected;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            Expanded(
              child: hasActiveRefund
                  ? _buildAlreadyPending(context, order)
                  : SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const HeroInfoBanner(
                            icon: Icons.wallet,
                            title: AppStrings.requestYourRefundTitle,
                            description: AppStrings.requestYourRefundDesc,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            AppStrings.selectOrderLabel,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _buildOrderPreview(order),
                          const SizedBox(height: 20),
                          const Text(
                            AppStrings.selectRefundReason,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...reasons.map(
                            (r) => RadioOptionTile(
                              title: r['title']!,
                              subtitle: r['desc'],
                              selected: selectedReason == r['title'],
                              onTap: () =>
                                  setState(() => _selectedReason = r['title']),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            AppStrings.refundMethod,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          if (isCod)
                            const Text(
                              AppStrings.codNoOnlinePaymentNote,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textHint,
                                height: 1.4,
                              ),
                            ),
                          const SizedBox(height: 10),
                          RadioOptionTile(
                            title: AppStrings.meatHubWalletLabel,
                            subtitle: AppStrings.instantRefundToWallet,
                            selected: _selectedMethodId == 'wallet',
                            onTap: () =>
                                setState(() => _selectedMethodId = 'wallet'),
                          ),
                          if (!isCod)
                            RadioOptionTile(
                              title: AppStrings.originalPaymentMethodLabel,
                              subtitle: AppStrings.refundToOriginalMethod,
                              selected: _selectedMethodId == 'original',
                              onTap: () => setState(
                                () => _selectedMethodId = 'original',
                              ),
                            ),
                          const SizedBox(height: 12),
                          const Text(
                            AppStrings.additionalDetailsOptional,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _detailsController,
                            maxLines: 3,
                            maxLength: 300,
                            onChanged: (_) => setState(() {}),
                            decoration: InputDecoration(
                              hintText: AppStrings.addAdditionalInfoPlaceholder,
                              hintStyle: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textHint,
                              ),
                              filled: true,
                              fillColor: AppColors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(
                                  color: AppColors.divider,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(
                                  color: AppColors.divider,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 22),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => _submit(order),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.white,
                                minimumSize: const Size(0, 54),
                                textStyle: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: const Text(
                                AppStrings.submitRefundRequestBtn,
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
            AppStrings.requestRefundTitle,
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

  Widget _buildOrderPreview(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              order.items.first.product.image,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.orderId,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '৳${order.total.toStringAsFixed(0)} (${order.isCod ? 'COD' : 'Paid'})',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlreadyPending(BuildContext context, OrderModel order) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.info_outline, size: 44, color: AppColors.primary),
          const SizedBox(height: 14),
          const Text(
            AppStrings.alreadyHasActiveRefund,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: () => Navigator.of(
              context,
            ).pushReplacement(AppRoutes.refundStatusRoute(order.orderId)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              minimumSize: const Size(200, 48),
            ),
            child: const Text(AppStrings.viewRefundStatus),
          ),
        ],
      ),
    );
  }
}
