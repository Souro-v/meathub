import 'package:meathub/core/utils/pricing_utils.dart';
import 'package:meathub/models/product_model.dart';

class CartItemModel {
  final ProductModel product;
  final double weightGrams;
  int quantity;

  CartItemModel({
    required this.product,
    required this.weightGrams,
    this.quantity = 1,
  });

  String get cartId => '${product.id}_${weightGrams.toInt()}';

  String get weightLabel => PricingUtils.formatWeight(weightGrams);

  double get unitPrice => PricingUtils.priceForWeight(
    basePrice: double.tryParse(product.price) ?? 0,
    baseGrams: PricingUtils.unitToGrams(product.unit),
    targetGrams: weightGrams,
  );

  double get unitOriginalPrice => PricingUtils.priceForWeight(
    basePrice: double.tryParse(product.originalPrice) ?? 0,
    baseGrams: PricingUtils.unitToGrams(product.unit),
    targetGrams: weightGrams,
  );

  double get totalPrice => unitPrice * quantity;
}
