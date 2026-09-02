import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/core/routes/app_routes.dart';
import 'package:meathub/core/widgets/checkout_step_indicator.dart';
import 'package:meathub/core/widgets/order_note_tile.dart';
import 'package:meathub/core/widgets/order_summary_card.dart';
import 'package:meathub/models/address_model.dart';
import 'package:meathub/models/cart_item_model.dart';
import 'package:meathub/models/delivery_option_model.dart';
import 'package:meathub/models/payment_method_model.dart';
import 'package:meathub/providers/cart_provider.dart';

import '../../core/utils/order_submission_utils.dart';
import '../../core/utils/order_utils.dart';
import '../../models/order_model.dart';
import '../../providers/orders_provider.dart';

class PlaceOrderScreen extends StatefulWidget {
  final List<CartItemModel> items;
  final DeliveryOptionModel deliveryOption;
  final ManagedAddressModel address;
  final double platformFee;
  final PaymentMethodModel paymentMethod;

  const PlaceOrderScreen({
    super.key,
    required this.items,
    required this.deliveryOption,
    required this.address,
    required this.platformFee,
    required this.paymentMethod,
  });

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  bool _agreedTerms = true;

  double get _subtotal =>
      widget.items.fold(0, (sum, item) => sum + item.totalPrice);

  double get _total =>
      _subtotal + widget.deliveryOption.fee + widget.platformFee;

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
                    const CheckoutStepIndicator(currentStep: 2),
                    const SizedBox(height: 20),
                    OrderSummaryCard(
                      items: widget.items,
                      subtotal: _subtotal,
                      deliveryFee: widget.deliveryOption.fee,
                      platformFee: widget.platformFee,
                      total: _total,
                    ),
                    const SizedBox(height: 16),
                    _buildAddressAndDelivery(context),
                    const SizedBox(height: 16),
                    _buildPaymentMethodCard(context),
                    const SizedBox(height: 16),
                    OrderNoteTile(
                      title: AppStrings.noteToRiderTitle,
                      placeholder: AppStrings.noteToRiderPlaceholder,
                      showChangeLabel: true,
                    ),
                    const SizedBox(height: 16),
                    _buildSecureBanner(),
                    const SizedBox(height: 16),
                    _buildTermsCheckbox(),
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
                    AppStrings.placeOrderTitle,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    AppStrings.placeOrderSubtitle,
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
                  AppStrings.secureCheckout,
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

  Widget _buildAddressAndDelivery(BuildContext context) {
    final address = widget.address;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.white,
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
              InkWell(
                onTap: () => Navigator.of(context).maybePop(),
                child: Row(
                  children: const [
                    Text(
                      AppStrings.change,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      size: 15,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.divider, height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.two_wheeler,
                  color: AppColors.primary,
                  size: 17,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                AppStrings.deliveryTypeLabel,
                style: TextStyle(fontSize: 13, color: AppColors.textDark),
              ),
              const Spacer(),
              Text(
                '${widget.deliveryOption.title} (${widget.deliveryOption.subtitle})',
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.successSoft,
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
              widget.paymentMethod.icon,
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
                  AppStrings.paymentMethodLabel,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  widget.paymentMethod.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                Text(
                  widget.paymentMethod.subtitle,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => Navigator.of(context).maybePop(),
            child: Row(
              children: const [
                Text(
                  AppStrings.change,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.success,
                  ),
                ),
                Icon(Icons.chevron_right, size: 15, color: AppColors.success),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecureBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.successSoft,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.success,
            ),
            child: const Icon(Icons.check, size: 13, color: AppColors.white),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.safeSecureTitle,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                Text(
                  AppStrings.weProtectInfoDesc,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: const [
              Icon(Icons.lock_outline, size: 13, color: AppColors.success),
              SizedBox(width: 3),
              Text(
                AppStrings.secureCheckout,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 22,
          width: 22,
          child: Checkbox(
            value: _agreedTerms,
            activeColor: AppColors.primary,
            onChanged: (v) => setState(() => _agreedTerms = v ?? false),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 12.5,
                  color: AppColors.textDark,
                  height: 1.4,
                ),
                children: [
                  TextSpan(text: AppStrings.agreeToThe),
                  TextSpan(
                    text: AppStrings.termsConditions,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context) {
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
              onPressed: _agreedTerms ? () => _placeOrder(context) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                disabledBackgroundColor: AppColors.divider,
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
                      Icon(Icons.lock_outline, size: 14),
                      SizedBox(width: 6),
                      Text(
                        AppStrings.placeOrder,
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'You will pay ৳${_total.toStringAsFixed(0)} on delivery',
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

  void _placeOrder(BuildContext context) {
    final success = OrderSubmissionUtils.attemptPayment(widget.paymentMethod);

    if (!success) {
      Navigator.of(context).pushReplacement(
        AppRoutes.paymentFailedRoute(
          items: widget.items,
          deliveryOption: widget.deliveryOption,
          address: widget.address,
          platformFee: widget.platformFee,
          paymentMethod: widget.paymentMethod,
        ),
      );
      return;
    }

    OrderSubmissionUtils.submitOrderAndNavigate(
      context,
      items: widget.items,
      address: widget.address,
      deliveryOption: widget.deliveryOption,
      paymentMethod: widget.paymentMethod,
      platformFee: widget.platformFee,
    );
  }
}
