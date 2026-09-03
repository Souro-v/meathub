class FeeUtils {
  FeeUtils._();

  /// Single source of truth for checkout fees — used by Cart, Checkout,
  /// Payment, Place Order, Track Order and OrderModel so every screen
  /// shows the exact same numbers for the exact same order.
  static const double platformFee = 20;
  static const double freeDeliveryThreshold = 2400;
  static const double standardDeliveryFee = 60;
  static const double expressDeliveryFee = 60;

  /// Standard delivery is free once the subtotal crosses the threshold;
  /// Express always costs extra since the customer is paying for speed.
  static double deliveryFeeFor({required String deliveryOptionId, required double subtotal}) {
    if (deliveryOptionId == 'express') return expressDeliveryFee;
    return subtotal >= freeDeliveryThreshold ? 0 : standardDeliveryFee;
  }

  static double freeDeliveryProgress(double subtotal) {
    return (subtotal / freeDeliveryThreshold).clamp(0, 1);
  }

  static double amountLeftForFreeDelivery(double subtotal) {
    final left = freeDeliveryThreshold - subtotal;
    return left > 0 ? left : 0;
  }
}