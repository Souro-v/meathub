import 'package:flutter/material.dart';
import 'package:meathub/core/services/analytics_service.dart';
import 'package:meathub/core/services/firestore_service.dart';
import 'package:meathub/core/utils/fee_utils.dart';
import 'package:meathub/models/cart_item_model.dart';
import 'package:meathub/models/product_model.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItemModel> _items = [];
  String _orderNote = '';
  bool _loaded = false;

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

  Future<void> loadFromFirestore() async {
    if (_loaded) return;
    _loaded = true;
    final data = await FirestoreService.loadMap('cart');
    if (data == null) return;
    _items.clear();
    final rawItems = (data['items'] as List?) ?? [];
    _items.addAll(
      rawItems.map(
        (e) => CartItemModel.fromJson(Map<String, dynamic>.from(e as Map)),
      ),
    );
    _orderNote = data['orderNote'] as String? ?? '';
    notifyListeners();
  }

  void _persist() {
    FirestoreService.saveMap('cart', {
      'items': _items.map((i) => i.toJson()).toList(),
      'orderNote': _orderNote,
    });
  }

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
    AnalyticsService.logAddToCart(
      itemId: product.id,
      itemName: product.name,
      price: double.tryParse(product.price) ?? 0,
    );
    notifyListeners();
    _persist();
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
    _persist();
  }

  void removeItem(String cartId) {
    _items.removeWhere((i) => i.cartId == cartId);
    notifyListeners();
    _persist();
  }

  void setOrderNote(String note) {
    _orderNote = note;
    notifyListeners();
    _persist();
  }

  void clear() {
    _items.clear();
    _orderNote = '';
    notifyListeners();
    _persist();
  }

  void reset() {
    _items.clear();
    _orderNote = '';
    _loaded = false;
    notifyListeners();
  }
}
