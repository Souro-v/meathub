import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meathub/core/routes/app_routes.dart';
import 'package:meathub/core/utils/order_utils.dart';
import 'package:meathub/models/address_model.dart';
import 'package:meathub/models/cart_item_model.dart';
import 'package:meathub/models/delivery_option_model.dart';
import 'package:meathub/models/order_model.dart';
import 'package:meathub/models/payment_method_model.dart';
import 'package:meathub/providers/cart_provider.dart';
import 'package:meathub/providers/orders_provider.dart';

class OrderSubmissionUtils {
  OrderSubmissionUtils._();

  /// Simulates a real payment gateway result — no backend exists yet.
  /// COD always "succeeds" (no online charge attempted). Online methods
  /// have a ~60% demo success rate so the Payment Failed screen is
  /// actually reachable for testing. Replace with a real gateway call
  /// once one is integrated.
  static bool attemptPayment(PaymentMethodModel method) {
    if (method.id == 'cod') return true;
    return Random().nextDouble() > 0.4;
  }

  /// Creates the order, clears the submitted items from the cart, and
  /// navigates to Order Success — clearing the checkout stack behind it.
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

    final order = OrderModel(
      orderId: orderId,
      placedAt: placedAt,
      items: items,
      address: address,
      deliveryOption: deliveryOption,
      paymentMethod: paymentMethod,
      platformFee: platformFee,
      status: OrderStatus.outForDelivery,
    );
    context.read<OrdersProvider>().placeOrder(order);

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