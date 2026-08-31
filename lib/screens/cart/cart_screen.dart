import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/core/routes/app_routes.dart';
import 'package:meathub/core/utils/coupon_utils.dart';
import 'package:meathub/core/widgets/cart_item_card.dart';
import 'package:meathub/core/widgets/coupon_section.dart';
import 'package:meathub/core/widgets/free_delivery_progress_card.dart';
import 'package:meathub/core/widgets/order_note_tile.dart';
import 'package:meathub/models/coupon_model.dart';
import 'package:meathub/providers/cart_provider.dart';
import 'package:meathub/providers/coupon_provider.dart';

import '../../core/widgets/empty_state_view.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final couponProvider = context.watch<CouponProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (couponProvider.consumeJustApplied() &&
          couponProvider.appliedCoupon != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '✓ ${couponProvider.appliedCoupon!.title} ${AppStrings.couponAppliedSuccessSuffix}',
            ),
            backgroundColor: AppColors.success,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context, cart),
            if (cart.items.isEmpty)
              Expanded(child: _buildEmptyState(context))
            else ...[
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FreeDeliveryProgressCard(
                        amountLeft: cart.amountLeftForFreeDelivery,
                        progress: cart.freeDeliveryProgress,
                        qualifies: cart.qualifiesForFreeDelivery,
                      ),
                      const SizedBox(height: 16),
                      ...cart.items.map(
                        (item) => CartItemCard(
                          item: item,
                          onQuantityChanged: (q) => context
                              .read<CartProvider>()
                              .updateQuantity(item.cartId, q),
                          onRemove: () => context
                              .read<CartProvider>()
                              .removeItem(item.cartId),
                        ),
                      ),
                      CouponSection(
                        items: cart.items,
                        subtotal: cart.subtotal,
                        originalDeliveryFee: cart.deliveryFee,
                      ),
                      const OrderNoteTile(),
                    ],
                  ),
                ),
              ),
              _buildOrderSummary(context, cart),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, CartProvider cart) {
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
                    AppStrings.yourCart,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    AppStrings.reviewCartSubtitle,
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
            padding: const EdgeInsets.only(top: 6),
            child: InkWell(
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.wishlist),
              borderRadius: BorderRadius.circular(20),
              child: const Padding(
                padding: EdgeInsets.all(6),
                child: Icon(
                  Icons.favorite_border,
                  size: 22,
                  color: AppColors.textDark,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Badge(
              label: Text('${cart.lineItemCount}'),
              isLabelVisible: cart.lineItemCount > 0,
              backgroundColor: AppColors.primary,
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 22,
                color: AppColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return EmptyStateView(
      icon: Icons.shopping_cart_outlined,
      title: AppStrings.cartEmptyTitle,
      description: AppStrings.cartEmptyDesc,
      buttonLabel: AppStrings.startShopping,
      onButtonTap: () => Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(AppRoutes.main, (route) => false, arguments: 0),
    );
  }

  Widget _buildOrderSummary(BuildContext context, CartProvider cart) {
    final coupon = context.watch<CouponProvider>().appliedCoupon;
    final subtotal = cart.subtotal;
    double discount = 0;
    double deliveryFee = cart.deliveryFee;

    if (coupon != null) {
      final error = CouponUtils.validate(coupon, cart.items, subtotal);
      if (error.isEmpty) {
        if (coupon.type == CouponType.freeDelivery) {
          deliveryFee = 0;
        } else {
          discount = CouponUtils.calculateDiscount(
            coupon,
            cart.items,
            subtotal,
          );
        }
      }
    }

    final total = subtotal - discount + deliveryFee + cart.platformFee;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _summaryRow(
                  '${AppStrings.subtotal} (${cart.totalQuantity} ${AppStrings.itemsLabel})',
                  '৳${subtotal.toStringAsFixed(0)}',
                ),
                if (discount > 0) ...[
                  const SizedBox(height: 6),
                  _summaryRow(
                    AppStrings.couponDiscountLabel,
                    '- ৳${discount.toStringAsFixed(0)}',
                    valueColor: AppColors.success,
                  ),
                ],
                const SizedBox(height: 6),
                _summaryRow(
                  AppStrings.deliveryFee,
                  deliveryFee == 0
                      ? 'FREE'
                      : '৳${deliveryFee.toStringAsFixed(0)}',
                ),
                const SizedBox(height: 6),
                _summaryRow(
                  AppStrings.platformFee,
                  '৳${cart.platformFee.toStringAsFixed(0)}',
                ),
                const SizedBox(height: 8),
                const Divider(color: AppColors.divider),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      AppStrings.total,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      '৳${total.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.successSoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.success,
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 11,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.safeSecureTitle,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark,
                              ),
                            ),
                            Text(
                              AppStrings.safeSecureDesc,
                              style: TextStyle(
                                fontSize: 9.5,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(
                      context,
                    ).push(AppRoutes.checkoutRoute(cart.items)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      minimumSize: const Size(0, 46),
                      textStyle: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(AppStrings.proceedToCheckout),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward, size: 15),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(
    String label,
    String value, {
    Color valueColor = AppColors.textDark,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12.5,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
