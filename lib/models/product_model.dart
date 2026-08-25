class ProductModel {
  final String id;
  final String name;
  final String image;
  final String category;
  final String price;
  final String originalPrice;
  final String unit;
  final double rating;
  final int reviewCount;
  final List<String>? gallery;
  final String? description;
  final bool inStock;
  final bool isFreshToday;
  final String subCategory;
  final String? badgeLabel;

  const ProductModel({
    required this.id,
    required this.name,
    required this.image,
    required this.category,
    required this.price,
    required this.originalPrice,
    required this.unit,
    required this.rating,
    required this.reviewCount,
    this.gallery,
    this.description,
    this.inStock = true,
    this.isFreshToday = true,
    this.subCategory = '',
    this.badgeLabel,
  });

  bool get hasDiscount => originalPrice != price;

  int get discountPercent {
    final orig = double.tryParse(originalPrice) ?? 0;
    final curr = double.tryParse(price) ?? 0;
    if (orig <= 0 || curr >= orig) return 0;
    return (((orig - curr) / orig) * 100).round();
  }

  /// Curated badge (BEST SELLER / NEW) if set, else auto discount badge.
  String? get computedBadge => badgeLabel ?? (hasDiscount ? '$discountPercent% OFF' : null);

  List<String> get images => (gallery != null && gallery!.isNotEmpty) ? gallery! : [image];

  String get fullDescription =>
      description ??
          'Premium halal $category sourced from trusted farms. Freshly cut after order '
              'confirmation. Hygienically packed and delivered in insulated packaging to '
              'ensure maximum freshness.';
}