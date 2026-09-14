import 'package:flutter/material.dart';
import 'package:meathub/models/product_model.dart';

class ProductFilterCriteria {
  final RangeValues priceRange;
  final double minRating;
  final bool discountOnly;

  const ProductFilterCriteria({
    this.priceRange = const RangeValues(0, 2000),
    this.minRating = 0,
    this.discountOnly = false,
  });

  bool matches(ProductModel product) {
    final price = double.tryParse(product.price) ?? 0;
    if (price < priceRange.start || price > priceRange.end) return false;
    if (product.rating < minRating) return false;
    if (discountOnly && !product.hasDiscount) return false;
    return true;
  }

  bool get isActive =>
      priceRange.start > 0 ||
      priceRange.end < 2000 ||
      minRating > 0 ||
      discountOnly;
}
