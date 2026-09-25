class BannerModel {
  final String id;
  final String imageUrl; // asset path OR Cloudinary URL
  final int order;

  const BannerModel({required this.id, required this.imageUrl, this.order = 0});

  Map<String, dynamic> toJson() => {
    'id': id,
    'imageUrl': imageUrl,
    'order': order,
  };

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
    id: json['id'] as String,
    imageUrl: json['imageUrl'] as String,
    order: json['order'] as int? ?? 0,
  );
}
