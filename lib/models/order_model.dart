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

  Map<String, dynamic> toJson() => {
    'orderId': orderId,
    'placedAt': placedAt.toIso8601String(),
    'items': items.map((i) => i.toJson()).toList(),
    'address': address.toJson(),
    'deliveryOption': deliveryOption.toJson(),
    'paymentMethod': paymentMethod.toJson(),
    'platformFee': platformFee,
    'status': status.name,
    'deliveredAt': deliveredAt?.toIso8601String(),
    'cancelledAt': cancelledAt?.toIso8601String(),
    'refund': refund?.toJson(),
    'discount': discount,
    'couponCode': couponCode,
  };

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
    orderId: json['orderId'] as String,
    placedAt: DateTime.parse(json['placedAt'] as String),
    items: (json['items'] as List)
        .map((e) => CartItemModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList(),
    address: ManagedAddressModel.fromJson(
      Map<String, dynamic>.from(json['address'] as Map),
    ),
    deliveryOption: DeliveryOptionModel.fromJson(
      Map<String, dynamic>.from(json['deliveryOption'] as Map),
    ),
    paymentMethod: PaymentMethodModel.fromJson(
      Map<String, dynamic>.from(json['paymentMethod'] as Map),
    ),
    platformFee: (json['platformFee'] as num).toDouble(),
    status: OrderStatus.values.firstWhere(
      (s) => s.name == json['status'],
      orElse: () => OrderStatus.placed,
    ),
    deliveredAt: json['deliveredAt'] != null
        ? DateTime.parse(json['deliveredAt'] as String)
        : null,
    cancelledAt: json['cancelledAt'] != null
        ? DateTime.parse(json['cancelledAt'] as String)
        : null,
    refund: json['refund'] != null
        ? RefundModel.fromJson(Map<String, dynamic>.from(json['refund'] as Map))
        : null,
    discount: (json['discount'] as num?)?.toDouble() ?? 0,
    couponCode: json['couponCode'] as String?,
  );
}
