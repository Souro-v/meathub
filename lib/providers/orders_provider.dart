import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_assets.dart';
import 'package:meathub/data/dummy_addresses.dart';
import 'package:meathub/data/dummy_data.dart';
import 'package:meathub/models/cart_item_model.dart';
import 'package:meathub/models/order_model.dart';
import 'package:meathub/models/product_model.dart';

import '../core/utils/order_utils.dart';

class OrdersProvider extends ChangeNotifier {
  final List<OrderModel> _orders = [];

  OrdersProvider() {
    _seedDemoOrders();
  }

  List<OrderModel> get orders => List.unmodifiable(_orders);

  int get totalPoints {
    return _orders.fold<int>(
      0,
      (sum, order) => sum + OrderUtils.calculatePoints(order.total),
    );
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

  void placeOrder(OrderModel order) {
    _orders.insert(0, order);
    notifyListeners();
  }

  void cancelOrder(String orderId) {
    final index = _orders.indexWhere((o) => o.orderId == orderId);
    if (index == -1) return;
    _orders[index] = _orders[index].copyWith(
      status: OrderStatus.cancelled,
      cancelledAt: DateTime.now(),
    );
    notifyListeners();
  }

  void _seedDemoOrders() {
    final address = DummyAddresses.managed.first;
    final delivery = DummyData.deliveryOptions.first;
    final payment = DummyData.paymentMethods.first;
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
        paymentMethod: payment,
        platformFee: 20,
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
        paymentMethod: payment,
        platformFee: 0,
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
        paymentMethod: payment,
        platformFee: 0,
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
        paymentMethod: payment,
        platformFee: 0,
        status: OrderStatus.cancelled,
        cancelledAt: now.subtract(
          const Duration(days: 9, hours: 3, minutes: 45),
        ),
      ),
    ]);
  }
}
