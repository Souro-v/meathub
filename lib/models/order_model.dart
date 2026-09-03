import 'package:meathub/core/utils/fee_utils.dart';
import 'package:meathub/core/utils/refund_utils.dart';
import 'package:meathub/models/address_model.dart';
import 'package:meathub/models/cart_item_model.dart';
import 'package:meathub/models/delivery_option_model.dart';
import 'package:meathub/models/payment_method_model.dart';
import 'package:meathub/models/refund_model.dart';

enum OrderStatus {
  placed,
  confirmed,
  preparing,
  outForDelivery,
  delivered,
  deliveryFailed,
  cancelled,
  refundPending,
  refunded,
  returned,
}

class OrderModel {
  final String orderId;
  final DateTime placedAt;
  final List<CartItemModel> items;
  final ManagedAddressModel address;
  final DeliveryOptionModel deliveryOption;
  final PaymentMethodModel paymentMethod;
  final double platformFee;
  final OrderStatus status;
  final DateTime? deliveredAt;
  final DateTime? cancelledAt;
  final RefundModel? refund;
  final double discount;
  final String? couponCode;

  const OrderModel({
    required this.orderId,
    required this.placedAt,
    required this.items,
    required this.address,
    required this.deliveryOption,
    required this.paymentMethod,
    required this.platformFee,
    required this.status,
    this.deliveredAt,
    this.cancelledAt,
    this.refund,
    this.discount = 0,
    this.couponCode,
  });

  double get subtotal => items.fold(0, (sum, item) => sum + item.totalPrice);

  int get totalQuantity => items.fold(0, (sum, item) => sum + item.quantity);

  bool get isCod => paymentMethod.id == 'cod';

  /// Single source of truth for delivery fee — same rule Cart/Checkout use.
  double get deliveryFee => FeeUtils.deliveryFeeFor(
    deliveryOptionId: deliveryOption.id,
    subtotal: subtotal,
  );

  double get total => subtotal - discount + deliveryFee + platformFee;

  OrderStatus get effectiveStatus {
    if (refund == null) return status;
    final refundStatus = RefundUtils.computeStatus(refund!);
    if (refundStatus == RefundStatus.rejected) return status;
    if (refundStatus == RefundStatus.completed) return OrderStatus.refunded;
    return OrderStatus.refundPending;
  }

  OrderModel copyWith({
    OrderStatus? status,
    DateTime? deliveredAt,
    DateTime? cancelledAt,
    RefundModel? refund,
  }) {
    return OrderModel(
      orderId: orderId,
      placedAt: placedAt,
      items: items,
      address: address,
      deliveryOption: deliveryOption,
      paymentMethod: paymentMethod,
      platformFee: platformFee,
      status: status ?? this.status,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      refund: refund ?? this.refund,
      discount: discount,
      couponCode: couponCode,
    );
  }
}
