enum CardBrand { visa, mastercard, amex, other }

class SavedCardModel {
  final String id;
  final String cardholderName;
  final String last4;
  final String expiry;
  final CardBrand brand;
  final bool isDefault;

  const SavedCardModel({
    required this.id,
    required this.cardholderName,
    required this.last4,
    required this.expiry,
    required this.brand,
    this.isDefault = false,
  });

  SavedCardModel copyWith({bool? isDefault}) {
    return SavedCardModel(
      id: id,
      cardholderName: cardholderName,
      last4: last4,
      expiry: expiry,
      brand: brand,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  static CardBrand brandFromNumber(String number) {
    if (number.startsWith('4')) return CardBrand.visa;
    if (number.startsWith('5')) return CardBrand.mastercard;
    if (number.startsWith('3')) return CardBrand.amex;
    return CardBrand.other;
  }

  String get brandLabel {
    switch (brand) {
      case CardBrand.visa:
        return 'VISA';
      case CardBrand.mastercard:
        return 'Mastercard';
      case CardBrand.amex:
        return 'AMEX';
      case CardBrand.other:
        return 'Card';
    }
  }
}
