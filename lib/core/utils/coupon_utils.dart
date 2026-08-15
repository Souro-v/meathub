import 'package:meathub/models/cart_item_model.dart';
import 'package:meathub/models/coupon_model.dart';

class CouponUtils {
  CouponUtils._();

  static String validate(CouponModel coupon, List<CartItemModel> items, double subtotal) {
    if (coupon.status == CouponStatus.used) return 'This coupon has already been used.';
    if (coupon.status == CouponStatus.expired || coupon.validUntil.isBefore(DateTime.now())) {
      return 'This coupon has expired.';
    }
    if (items.isEmpty) return 'Add items to your cart before applying a coupon.';
    if (subtotal < coupon.minOrderAmount) {
      return 'Minimum order of ৳${coupon.minOrderAmount.toStringAsFixed(0)} required for this coupon.';
    }
    if (coupon.category != null && !items.any((i) => i.product.category == coupon.category)) {
      return 'Add ${coupon.category} items to your cart to use this coupon.';
    }
    return '';
  }

  static double calculateDiscount(CouponModel coupon, List<CartItemModel> items, double subtotal) {
    switch (coupon.type) {
      case CouponType.percentage:
        final base = coupon.category == null
            ? subtotal
            : items.where((i) => i.product.category == coupon.category).fold(0.0, (s, i) => s + i.totalPrice);
        return base * coupon.value / 100;
      case CouponType.flat:
        return coupon.value > subtotal ? subtotal : coupon.value;
      case CouponType.freeDelivery:
        return 0;
    }
  }
}