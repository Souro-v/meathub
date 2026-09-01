import 'package:flutter/material.dart';

class SearchHistoryProvider extends ChangeNotifier {
  final List<String> _recent = [];
  static const int _maxItems = 8;

  List<String> get recent => List.unmodifiable(_recent);

  void add(String term) {
    final trimmed = term.trim();
    if (trimmed.isEmpty) return;
    _recent.removeWhere((t) => t.toLowerCase() == trimmed.toLowerCase());
    _recent.insert(0, trimmed);
    if (_recent.length > _maxItems) {
      _recent.removeRange(_maxItems, _recent.length);
      notifyListeners();
    }
  }

  void remove(String term) {
    _recent.remove(term);
    notifyListeners();
  }

  void clear() {
    _recent.clear();
    notifyListeners();
  }
}
