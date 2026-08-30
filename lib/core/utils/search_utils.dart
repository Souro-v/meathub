import 'package:meathub/data/dummy_data.dart';
import 'package:meathub/models/category_model.dart';
import 'package:meathub/models/product_model.dart';

class SearchUtils {
  SearchUtils._();

  static bool _matchesAllWords(String haystack, String query) {
    final words = query
        .toLowerCase()
        .trim()
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty);
    final h = haystack.toLowerCase();
    return words.every((w) => h.contains(w));
  }

  static List<ProductModel> searchProducts(String query) {
    if (query.trim().isEmpty) return [];
    return DummyData.allProducts.where((p) {
      final haystack = '${p.name} ${p.category} ${p.subCategory}';
      return _matchesAllWords(haystack, query);
    }).toList();
  }

  static List<CategoryModel> searchCategories(String query) {
    if (query.trim().isEmpty) return [];
    final q = query.toLowerCase().trim();
    return DummyData.categories
        .where((c) => c.name.toLowerCase().contains(q))
        .toList();
  }
  static List<String> didYouMeanSuggestions(String query) {
    final q = query.trim().toLowerCase();
    if (q.length < 2) return [];
    final words = q.split(RegExp(r'\s+')).where((w) => w.length >= 2).toList();
    if (words.isEmpty) return [];

    final candidates = <String>{};
    for (final p in DummyData.allProducts) {
      if (p.name.toLowerCase() == q) continue;
      final haystack = '${p.name} ${p.subCategory}'.toLowerCase();
      if (words.any((w) => haystack.contains(w))) {
        candidates.add(p.name);
      }
    }

    final list = candidates.toList()
      ..sort((a, b) => a.length.compareTo(b.length));
    return list.take(3).toList();
  }
}
