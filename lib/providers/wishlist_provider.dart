import 'package:flutter/material.dart';
import 'package:meathub/core/services/firestore_service.dart';
import 'package:meathub/models/product_model.dart';

class WishlistProvider extends ChangeNotifier {
  final List<ProductModel> _items = [];
  bool _loaded = false;

  List<ProductModel> get items => List.unmodifiable(_items);

  int get count => _items.length;

  bool isWishlisted(String productId) => _items.any((p) => p.id == productId);

  Future<void> loadFromFirestore() async {
    if (_loaded) return;
    _loaded = true;
    final raw = await FirestoreService.loadList('wishlist');
    _items.clear();
    _items.addAll(raw.map((e) => ProductModel.fromJson(e)));
    notifyListeners();
  }

  void _persist() {
    FirestoreService.saveList(
      'wishlist',
      _items.map((p) => p.toJson()).toList(),
    );
  }

  void toggle(ProductModel product) {
    if (isWishlisted(product.id)) {
      _items.removeWhere((p) => p.id == product.id);
    } else {
      _items.add(product);
    }
    notifyListeners();
    _persist();
  }

  void remove(String productId) {
    _items.removeWhere((p) => p.id == productId);
    notifyListeners();
    _persist();
  }

  void clear() {
    _items.clear();
    notifyListeners();
    _persist();
  }

  void reset() {
    _items.clear();
    _loaded = false;
    notifyListeners();
  }
}
