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
  final bool isPopularToday;
  final bool isTodaysFreshPick;

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
    this.isPopularToday = false,
    this.isTodaysFreshPick = false,
  });

  bool get hasDiscount => originalPrice != price;

  int get discountPercent {
    final orig = double.tryParse(originalPrice) ?? 0;
    final curr = double.tryParse(price) ?? 0;
    if (orig <= 0 || curr >= orig) return 0;
    return (((orig - curr) / orig) * 100).round();
  }

  String? get computedBadge => badgeLabel ?? (hasDiscount ? '$discountPercent% OFF' : null);

  List<String> get images => (gallery != null && gallery!.isNotEmpty) ? gallery! : [image];

  String get fullDescription =>
      description ??
          'Premium halal $category sourced from trusted farms. Freshly cut after order '
              'confirmation. Hygienically packed and delivered in insulated packaging to '
              'ensure maximum freshness.';

  /// [image] holds EITHER a local asset path ('assets/images/beef.jpg') OR
  /// a full Cloudinary URL ('https://res.cloudinary.com/...') —
  /// SmartProductImage auto-detects which one and loads it correctly.
  ProductModel copyWith({bool? isPopularToday, bool? isTodaysFreshPick, String? image}) {
    return ProductModel(
      id: id,
      name: name,
      image: image ?? this.image,
      category: category,
      price: price,
      originalPrice: originalPrice,
      unit: unit,
      rating: rating,
      reviewCount: reviewCount,
      gallery: gallery,
      description: description,
      inStock: inStock,
      isFreshToday: isFreshToday,
      subCategory: subCategory,
      badgeLabel: badgeLabel,
      isPopularToday: isPopularToday ?? this.isPopularToday,
      isTodaysFreshPick: isTodaysFreshPick ?? this.isTodaysFreshPick,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'image': image,
    'category': category,
    'price': price,
    'originalPrice': originalPrice,
    'unit': unit,
    'rating': rating,
    'reviewCount': reviewCount,
    'subCategory': subCategory,
    'badgeLabel': badgeLabel,
    'isPopularToday': isPopularToday,
    'isTodaysFreshPick': isTodaysFreshPick,
  };

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json['id'] as String,
    name: json['name'] as String,
    image: json['image'] as String,
    category: json['category'] as String,
    price: json['price'] as String,
    originalPrice: json['originalPrice'] as String,
    unit: json['unit'] as String,
    rating: (json['rating'] as num).toDouble(),
    reviewCount: json['reviewCount'] as int,
    subCategory: json['subCategory'] as String? ?? '',
    badgeLabel: json['badgeLabel'] as String?,
    isPopularToday: json['isPopularToday'] as bool? ?? false,
    isTodaysFreshPick: json['isTodaysFreshPick'] as bool? ?? false,
  );
}