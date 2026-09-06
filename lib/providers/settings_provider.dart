import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  bool orderUpdates = true;
  bool promotionalOffers = true;
  bool deliveryAlerts = true;
  bool appUpdates = true;

  void toggle(String key, bool value) {
    switch (key) {
      case 'orderUpdates':
        orderUpdates = value;
        break;
      case 'promotionalOffers':
        promotionalOffers = value;
        break;
      case 'deliveryAlerts':
        deliveryAlerts = value;
        break;
      case 'appUpdates':
        appUpdates = value;
        break;
    }
    notifyListeners();
  }
}
