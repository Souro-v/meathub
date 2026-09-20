import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meathub/core/services/product_repository.dart';
import 'package:meathub/models/product_model.dart';

class CatalogProvider extends ChangeNotifier {
  List<ProductModel> _products = [];
  StreamSubscription<List<ProductModel>>? _sub;
  bool _isLoading = true;

  CatalogProvider() {
    _sub = ProductRepository.watchAll().listen(
          (products) {
        _products = products;
        _isLoading = false;
        notifyListeners();
      },
      onError: (_) {
        // Not authenticated yet, or rules not applied — fail quietly;
        // list stays empty until the stream can connect.
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  bool get isLoading => _isLoading;

  List<ProductModel> get allProducts => List.unmodifiable(_products);

  List<ProductModel> get popularToday =>
      _products.where((p) => p.isPopularToday).toList();

  List<ProductModel> get todaysFreshPicks =>
      _products.where((p) => p.isTodaysFreshPick).toList();

  List<ProductModel> productsInCategory(String category) {
    return _products.where((p) => p.category == category).toList();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}