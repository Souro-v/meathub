class FaqFullItemModel {
  final String question;
  final String answer;
  final String category; // orders, payments, products, account
  final bool showTrackOrderCta;

  const FaqFullItemModel({
    required this.question,
    required this.answer,
    required this.category,
    this.showTrackOrderCta = false,
  });
}