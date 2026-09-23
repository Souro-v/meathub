import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meathub/core/services/category_repository.dart';
import 'package:meathub/models/category_model.dart';

class CategoryProvider extends ChangeNotifier {
  List<CategoryModel> _categories = [];
  StreamSubscription<List<CategoryModel>>? _sub;
  bool _isLoading = true;

  CategoryProvider() {
    _sub = CategoryRepository.watchAll().listen(
      (categories) {
        _categories = categories;
        _isLoading = false;
        notifyListeners();
      },
      onError: (_) {
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  bool get isLoading => _isLoading;

  List<CategoryModel> get categories => List.unmodifiable(_categories);

  CategoryModel? byName(String name) {
    try {
      return _categories.firstWhere((c) => c.name == name);
    } catch (_) {
      return null;
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
