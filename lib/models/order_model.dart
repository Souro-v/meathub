import 'package:meathub/models/address_model.dart';
import 'package:meathub/models/cart_item_model.dart';
import 'package:meathub/models/delivery_option_model.dart';
import 'package:meathub/models/payment_method_model.dart';

enum OrderStatus { placed, confirmed, preparing, outForDelivery, delivered, cancelled, returned }

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
  });

  double get subtotal => items.fold(0, (sum, item) => sum + item.totalPrice);
  double get total => subtotal + deliveryOption.fee + platformFee;
  int get totalQuantity => items.fold(0, (sum, item) => sum + item.quantity);

  OrderModel copyWith({
    OrderStatus? status,
    DateTime? deliveredAt,
    DateTime? cancelledAt,
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
    );
  }
}