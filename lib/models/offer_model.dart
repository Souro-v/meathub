class OfferModel {
  final String image;
  final String badgeLabel;
  final String title;
  final String subtitle;
  final DateTime validUntil;

  const OfferModel({
    required this.image,
    required this.badgeLabel,
    required this.title,
    required this.subtitle,
    required this.validUntil,
  });
}