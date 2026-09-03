import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/core/routes/app_routes.dart';
import 'package:meathub/core/widgets/checkout_step_indicator.dart';
import 'package:meathub/core/widgets/order_summary_card.dart';
import 'package:meathub/core/widgets/payment_method_tile.dart';
import 'package:meathub/data/dummy_data.dart';
import 'package:meathub/models/address_model.dart';
import 'package:meathub/models/cart_item_model.dart';
import 'package:meathub/models/delivery_option_model.dart';
import 'package:meathub/models/payment_method_model.dart';
import 'package:provider/provider.dart';

import '../../core/utils/coupon_utils.dart';
import '../../core/utils/fee_utils.dart';
import '../../models/coupon_model.dart';
import '../../providers/coupon_provider.dart';

class PaymentScreen extends StatefulWidget {
  final List<CartItemModel> items;
  final DeliveryOptionModel deliveryOption;
  final ManagedAddressModel address;
  final double platformFee;

  const PaymentScreen({
    super.key,
    required this.items,
    required this.deliveryOption,
    required this.address,
    required this.platformFee,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedMethodId = 'cod';

  PaymentMethodModel get _selectedMethod =>
      DummyData.paymentMethods.firstWhere((m) => m.id == _selectedMethodId);

  double get _subtotal =>
      widget.items.fold(0, (sum, item) => sum + item.totalPrice);

  double get _discount {
    final coupon = context.read<CouponProvider>().appliedCoupon;
    if (coupon == null) return 0;
    if (CouponUtils.validate(coupon, widget.items, _subtotal).isNotEmpty)
      return 0;
    if (coupon.type == CouponType.freeDelivery) {
      return FeeUtils.deliveryFeeFor(
        deliveryOptionId: widget.deliveryOption.id,
        subtotal: _subtotal,
      );
    }
    return CouponUtils.calculateDiscount(coupon, widget.items, _subtotal);
  }

  double get _deliveryFee => FeeUtils.deliveryFeeFor(
    deliveryOptionId: widget.deliveryOption.id,
    subtotal: _subtotal,
  );

  double get _total =>
      _subtotal - _discount + _deliveryFee + widget.platformFee;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CheckoutStepIndicator(currentStep: 1),
                    const SizedBox(height: 20),
                    OrderSummaryCard(
                      items: widget.items,
                      subtotal: _subtotal,
                      discount: _discount,
                      deliveryFee: _deliveryFee,
                      platformFee: widget.platformFee,
                      total: _total,
                      collapsible: true,
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      AppStrings.paymentMethodsSectionTitle,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...DummyData.paymentMethods.map(
                      (m) => PaymentMethodTile(
                        method: m,
                        selected: _selectedMethodId == m.id,
                        onTap: () => setState(() => _selectedMethodId = m.id),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.successSoft,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.success,
                            ),
                            child: const Icon(
                              Icons.check,
                              size: 13,
                              color: AppColors.white,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppStrings.safeSecureTitle,
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                Text(
                                  AppStrings.paymentProtectedDesc,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildBottomBar(context),
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
                children: const [
                  Text(
                    AppStrings.stepPayment,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    AppStrings.choosePaymentMethodSubtitle,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: const [
                Icon(Icons.shield_outlined, size: 15, color: AppColors.primary),
                SizedBox(width: 4),
                Text(
                  AppStrings.securePayment,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    final method = _selectedMethod;
    final subtitle = method.id == 'cod'
        ? 'You will pay ৳${_total.toStringAsFixed(0)} on delivery'
        : 'Pay ৳${_total.toStringAsFixed(0)} via ${method.title}';

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                AppStrings.totalAmount,
                style: TextStyle(fontSize: 11.5, color: AppColors.textHint),
              ),
              Text(
                '৳${_total.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface,
            ),
            child: const Icon(
              Icons.keyboard_arrow_up,
              size: 18,
              color: AppColors.textDark,
            ),
          ),
          const Spacer(),
          Expanded(
            flex: 3,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                AppRoutes.placeOrderRoute(
                  items: widget.items,
                  deliveryOption: widget.deliveryOption,
                  address: widget.address,
                  platformFee: widget.platformFee,
                  paymentMethod: method,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                minimumSize: const Size(0, 54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        AppStrings.placeOrder,
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(Icons.arrow_forward, size: 15),
                    ],
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
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
}
