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
  });

  bool get hasDiscount => originalPrice != price;
}