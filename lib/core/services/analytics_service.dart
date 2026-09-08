import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  AnalyticsService._();

  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  static Future<void> logSignUp() =>
      _analytics.logSignUp(signUpMethod: 'email');

  static Future<void> logLogin() => _analytics.logLogin(loginMethod: 'email');

  static Future<void> logAddToCart({
    required String itemId,
    required String itemName,
    required double price,
  }) {
    return _analytics.logAddToCart(
      currency: 'BDT',
      value: price,
      items: [
        AnalyticsEventItem(itemId: itemId, itemName: itemName, price: price),
      ],
    );
  }

  static Future<void> logPurchase({
    required String orderId,
    required double total,
  }) {
    return _analytics.logPurchase(
      transactionId: orderId,
      currency: 'BDT',
      value: total,
    );
  }
}
