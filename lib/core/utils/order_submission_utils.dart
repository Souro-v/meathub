import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meathub/core/routes/app_routes.dart';
import 'package:meathub/core/utils/coupon_utils.dart';
import 'package:meathub/core/utils/fee_utils.dart';
import 'package:meathub/core/utils/order_utils.dart';
import 'package:meathub/models/address_model.dart';
import 'package:meathub/models/cart_item_model.dart';
import 'package:meathub/models/coupon_model.dart';
import 'package:meathub/models/delivery_option_model.dart';
import 'package:meathub/models/order_model.dart';
import 'package:meathub/models/payment_method_model.dart';
import 'package:meathub/providers/cart_provider.dart';
import 'package:meathub/providers/coupon_provider.dart';
import 'package:meathub/providers/orders_provider.dart';

class OrderSubmissionUtils {
  OrderSubmissionUtils._();

  static bool attemptPayment(PaymentMethodModel method) {
    if (method.id == 'cod') return true;
    return Random().nextDouble() > 0.4;
  }

  /// Creates the order (capturing whatever coupon is currently applied),
  /// clears the submitted items from the cart, clears the spent coupon,
  /// and navigates to Order Success.
  static void submitOrderAndNavigate(
      BuildContext context, {
        required List<CartItemModel> items,
        required ManagedAddressModel address,
        required DeliveryOptionModel deliveryOption,
        required PaymentMethodModel paymentMethod,
        required double platformFee,
      }) {
    final orderId = OrderUtils.generateOrderId();
    final placedAt = DateTime.now();
    final subtotal = items.fold<double>(0, (sum, item) => sum + item.totalPrice);

    final couponProvider = context.read<CouponProvider>();
    final coupon = couponProvider.appliedCoupon;
    double discount = 0;
    String? couponCode;

    if (coupon != null && CouponUtils.validate(coupon, items, subtotal).isEmpty) {
      couponCode = coupon.code;
      discount = coupon.type == CouponType.freeDelivery
          ? FeeUtils.deliveryFeeFor(deliveryOptionId: deliveryOption.id, subtotal: subtotal)
          : CouponUtils.calculateDiscount(coupon, items, subtotal);
    }

    final order = OrderModel(
      orderId: orderId,
      placedAt: placedAt,
      items: items,
      address: address,
      deliveryOption: deliveryOption,
      paymentMethod: paymentMethod,
      platformFee: platformFee,
      status: OrderStatus.outForDelivery,
      discount: discount,
      couponCode: couponCode,
    );
    context.read<OrdersProvider>().placeOrder(order);

    if (couponCode != null) couponProvider.remove();

    final cart = context.read<CartProvider>();
    for (final item in items) {
      cart.removeItem(item.cartId);
    }

    Navigator.of(context).pushAndRemoveUntil(
      AppRoutes.orderSuccessRoute(
        orderId: orderId,
        placedAt: placedAt,
        items: items,
        deliveryOption: deliveryOption,
        address: address,
        platformFee: platformFee,
        paymentMethod: paymentMethod,
      ),
          (route) => false,
    );
  }
}