import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_assets.dart';
import 'package:meathub/core/utils/fee_utils.dart';
import 'package:meathub/core/utils/order_utils.dart';
import 'package:meathub/core/utils/refund_utils.dart';
import 'package:meathub/data/dummy_addresses.dart';
import 'package:meathub/data/dummy_data.dart';
import 'package:meathub/models/cart_item_model.dart';
import 'package:meathub/models/order_model.dart';
import 'package:meathub/models/product_model.dart';
import 'package:meathub/models/refund_model.dart';

class OrdersProvider extends ChangeNotifier {
  final List<OrderModel> _orders = [];

  OrdersProvider() {
    _seedDemoOrders();
  }

  List<OrderModel> get orders => List.unmodifiable(_orders);

  void placeOrder(OrderModel order) {
    _orders.insert(0, order);
    notifyListeners();
  }

  void cancelOrder(String orderId) {
    final index = _orders.indexWhere((o) => o.orderId == orderId);
    if (index == -1) return;
    final order = _orders[index];

    RefundModel? refund;
    if (!order.isCod) {
      refund = RefundModel(
        refundId: RefundUtils.generateRefundId(),
        orderId: order.orderId,
        reason: 'Order cancelled',
        methodId: 'wallet',
        methodLabel: 'MeatHub Wallet',
        amount: order.total,
        requestedAt: DateTime.now(),
      );
    }

    _orders[index] = order.copyWith(
      status: OrderStatus.cancelled,
      cancelledAt: DateTime.now(),
      refund: refund,
    );
    notifyListeners();
  }

  void requestRefund(String orderId, RefundModel refund) {
    final index = _orders.indexWhere((o) => o.orderId == orderId);
    if (index == -1) return;
    _orders[index] = _orders[index].copyWith(refund: refund);
    notifyListeners();
  }

  bool hasActiveRefund(String orderId) {
    final order = findById(orderId);
    if (order?.refund == null) return false;
    final s = RefundUtils.computeStatus(order!.refund!);
    return s != RefundStatus.completed && s != RefundStatus.rejected;
  }

  OrderModel? findById(String orderId) {
    try {
      return _orders.firstWhere((o) => o.orderId == orderId);
    } catch (_) {
      return null;
    }
  }

  OrderModel? get mostRelevantOrder {
    if (_orders.isEmpty) return null;
    final ongoing = _orders.where(
      (o) => [
        OrderStatus.placed,
        OrderStatus.confirmed,
        OrderStatus.preparing,
        OrderStatus.outForDelivery,
      ].contains(o.status),
    );
    if (ongoing.isNotEmpty) return ongoing.first;
    return _orders.first;
  }

  int get totalPoints {
    return _orders.fold<int>(
      0,
      (sum, order) => sum + OrderUtils.calculatePoints(order.total),
    );
  }

  void _seedDemoOrders() {
    final address = DummyAddresses.managed.first;
    final delivery = DummyData.deliveryOptions.first;
    final codPayment = DummyData.paymentMethods.firstWhere(
      (m) => m.id == 'cod',
    );
    final bkashPayment = DummyData.paymentMethods.firstWhere(
      (m) => m.id == 'bkash',
    );
    final now = DateTime.now();

    _orders.addAll([
      OrderModel(
        orderId: '#MH784523',
        placedAt: now.subtract(const Duration(hours: 2)),
        items: [
          CartItemModel(
            product: const ProductModel(
              id: 'demo_premium_beef',
              name: 'Premium Fresh Beef',
              image: AppAssets.premiumBeef,
              category: 'Beef',
              price: '850',
              originalPrice: '850',
              unit: '1 kg',
              rating: 4.9,
              reviewCount: 2486,
            ),
            weightGrams: 1000,
          ),
        ],
        address: address,
        deliveryOption: delivery,
        paymentMethod: codPayment,
        platformFee: FeeUtils.platformFee,
        status: OrderStatus.outForDelivery,
      ),
      OrderModel(
        orderId: '#MH764231',
        placedAt: now.subtract(const Duration(days: 2, hours: 3)),
        items: [
          CartItemModel(
            product: const ProductModel(
              id: 'demo_beef_curry_cut',
              name: 'Beef Curry Cut',
              image: AppAssets.beef,
              category: 'Beef',
              price: '750',
              originalPrice: '750',
              unit: '1 kg',
              rating: 4.7,
              reviewCount: 210,
            ),
            weightGrams: 1500,
          ),
        ],
        address: address,
        deliveryOption: delivery,
        paymentMethod: codPayment,
        platformFee: FeeUtils.platformFee,
        status: OrderStatus.delivered,
        deliveredAt: now.subtract(
          const Duration(days: 2, hours: 1, minutes: 35),
        ),
      ),
      OrderModel(
        orderId: '#MH752118',
        placedAt: now.subtract(const Duration(hours: 1)),
        items: [
          CartItemModel(
            product: const ProductModel(
              id: 'demo_beef_mince',
              name: 'Beef Mince',
              image: AppAssets.beefMince,
              category: 'Beef',
              price: '780',
              originalPrice: '780',
              unit: '1 kg',
              rating: 4.6,
              reviewCount: 82,
            ),
            weightGrams: 1000,
          ),
        ],
        address: address,
        deliveryOption: delivery,
        paymentMethod: codPayment,
        platformFee: FeeUtils.platformFee,
        status: OrderStatus.preparing,
      ),
      OrderModel(
        orderId: '#MH742009',
        placedAt: now.subtract(const Duration(days: 9, hours: 4)),
        items: [
          CartItemModel(
            product: const ProductModel(
              id: 'demo_beef_ribs',
              name: 'Beef Ribs',
              image: AppAssets.beefBone,
              category: 'Beef',
              price: '920',
              originalPrice: '920',
              unit: '1 kg',
              rating: 4.4,
              reviewCount: 41,
            ),
            weightGrams: 1000,
          ),
        ],
        address: address,
        deliveryOption: delivery,
        paymentMethod: bkashPayment,
        platformFee: FeeUtils.platformFee,
        status: OrderStatus.cancelled,
        cancelledAt: now.subtract(const Duration(minutes: 45)),
        // Amount = subtotal 920 + delivery 60 (below free-delivery threshold) + platform 20.
        refund: RefundModel(
          refundId: '#RF556231',
          orderId: '#MH742009',
          reason: 'Order cancelled',
          methodId: 'wallet',
          methodLabel: 'MeatHub Wallet',
          amount: 1000,
          requestedAt: now.subtract(const Duration(minutes: 45)),
        ),
      ),
      OrderModel(
        orderId: '#MH731102',
        placedAt: now.subtract(const Duration(days: 1)),
        items: [
          CartItemModel(
            product: const ProductModel(
              id: 'demo_chicken_curry_cut',
              name: 'Chicken Curry Cut',
              image: AppAssets.chickenCurryCut,
              category: 'Chicken',
              price: '220',
              originalPrice: '220',
              unit: '1 kg',
              rating: 4.7,
              reviewCount: 156,
            ),
            weightGrams: 1000,
          ),
        ],
        address: address,
        deliveryOption: delivery,
        paymentMethod: codPayment,
        platformFee: FeeUtils.platformFee,
        status: OrderStatus.deliveryFailed,
      ),
    ]);
  }
}
