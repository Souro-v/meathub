import 'dart:math';
import 'package:flutter/material.dart';
import 'package:meathub/models/saved_card_model.dart';

class PaymentMethodsProvider extends ChangeNotifier {
  final List<SavedCardModel> _cards = [];

  PaymentMethodsProvider() {
    _cards.add(
      const SavedCardModel(
        id: 'demo_card_1',
        cardholderName: 'Rafiq Hasan',
        last4: '4242',
        expiry: '12/27',
        brand: CardBrand.visa,
        isDefault: true,
      ),
    );
  }

  List<SavedCardModel> get cards => List.unmodifiable(_cards);

  void addCard({
    required String cardholderName,
    required String cardNumber,
    required String expiry,
  }) {
    final last4 = cardNumber.length >= 4
        ? cardNumber.substring(cardNumber.length - 4)
        : cardNumber;
    final id = 'card_${Random().nextInt(999999)}';
    _cards.add(
      SavedCardModel(
        id: id,
        cardholderName: cardholderName,
        last4: last4,
        expiry: expiry,
        brand: SavedCardModel.brandFromNumber(cardNumber),
        isDefault: _cards.isEmpty,
      ),
    );
    notifyListeners();
  }

  void removeCard(String id) {
    _cards.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  void setDefault(String id) {
    for (var i = 0; i < _cards.length; i++) {
      _cards[i] = _cards[i].copyWith(isDefault: _cards[i].id == id);
    }
    notifyListeners();
  }
}
