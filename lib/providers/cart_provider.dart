import 'package:flutter/material.dart';
import 'package:meathub/core/utils/fee_utils.dart';
import 'package:meathub/models/cart_item_model.dart';
import 'package:meathub/models/product_model.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItemModel> _items = [];
  String _orderNote = '';

  List<CartItemModel> get items => List.unmodifiable(_items);

  int get lineItemCount => _items.length;

  int get totalQuantity => _items.fold(0, (sum, item) => sum + item.quantity);

  String get orderNote => _orderNote;

  double get subtotal => _items.fold(0, (sum, item) => sum + item.totalPrice);

  double get platformFee => FeeUtils.platformFee;

  double get deliveryFee => _items.isEmpty
      ? 0
      : FeeUtils.deliveryFeeFor(
          deliveryOptionId: 'standard',
          subtotal: subtotal,
        );

  double get total => _items.isEmpty ? 0 : subtotal + deliveryFee + platformFee;

  double get amountLeftForFreeDelivery =>
      FeeUtils.amountLeftForFreeDelivery(subtotal);

  double get freeDeliveryProgress => FeeUtils.freeDeliveryProgress(subtotal);

  bool get qualifiesForFreeDelivery =>
      subtotal >= FeeUtils.freeDeliveryThreshold;

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
