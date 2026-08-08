import 'package:flutter/material.dart';
import 'package:meathub/models/cart_item_model.dart';
import 'package:meathub/models/product_model.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItemModel> _items = [];
  String _orderNote = '';

  static const double _freeDeliveryThreshold = 2400;
  static const double _standardDeliveryFee = 60;
  static const double _platformFeeAmount = 40;

  List<CartItemModel> get items => List.unmodifiable(_items);

  int get lineItemCount => _items.length;

  int get totalQuantity => _items.fold(0, (sum, item) => sum + item.quantity);

  String get orderNote => _orderNote;

  double get subtotal => _items.fold(0, (sum, item) => sum + item.totalPrice);

  double get platformFee => _platformFeeAmount;

  double get deliveryFee =>
      (_items.isEmpty || subtotal >= _freeDeliveryThreshold)
      ? 0
      : _standardDeliveryFee;

  double get total => _items.isEmpty ? 0 : subtotal + deliveryFee + platformFee;

  double get amountLeftForFreeDelivery {
    final left = _freeDeliveryThreshold - subtotal;
    return left > 0 ? left : 0;
  }

  double get freeDeliveryProgress =>
      (subtotal / _freeDeliveryThreshold).clamp(0, 1);

  bool get qualifiesForFreeDelivery => subtotal >= _freeDeliveryThreshold;

  void addItem(ProductModel product, double weightGrams, int quantity) {
    final index = _items.indexWhere(
      (i) => i.product.id == product.id && i.weightGrams == weightGrams,
    );
    if (index >= 0) {
      _items[index].quantity += quantity;
    } else {
      _items.add(
        CartItemModel(
          product: product,
          weightGrams: weightGrams,
          quantity: quantity,
        ),
      );
    }
    notifyListeners();
  }

  void updateQuantity(String cartId, int quantity) {
    final index = _items.indexWhere((i) => i.cartId == cartId);
    if (index == -1) return;
    if (quantity <= 0) {
      _items.removeAt(index);
    } else {
      _items[index].quantity = quantity;
    }
    notifyListeners();
  }

  void removeItem(String cartId) {
    _items.removeWhere((i) => i.cartId == cartId);
    notifyListeners();
  }

  void setOrderNote(String note) {
    _orderNote = note;
    notifyListeners();
  }

  void clear() {
    _items.clear();
    _orderNote = '';
    notifyListeners();
  }
}
