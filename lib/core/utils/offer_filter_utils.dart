import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/models/coupon_model.dart';

class OfferTabModel {
  final String key;
  final String label;
  const OfferTabModel({required this.key, required this.label});
}

class OfferFilterUtils {
  OfferFilterUtils._();

  static const String allKey = 'all';

  static const List<OfferTabModel> tabs = [
    OfferTabModel(key: allKey, label: AppStrings.tabAll),
    OfferTabModel(key: 'meat', label: AppStrings.tabMeat),
    OfferTabModel(key: 'delivery', label: AppStrings.tabDelivery),
    OfferTabModel(key: 'cashback', label: AppStrings.tabCashback),
    OfferTabModel(key: 'new_user', label: AppStrings.tabNewUser),
  ];

  static String labelForTag(String key) {
    return tabs.firstWhere((t) => t.key == key, orElse: () => const OfferTabModel(key: '', label: '')).label;
  }

  /// Pure, reusable filter — category tag + search query combined.
  static List<CouponModel> filter({
    required List<CouponModel> offers,
    required String selectedTag,
    required String query,
  }) {
    final q = query.trim().toLowerCase();

    return offers.where((offer) {
      final matchesTag = selectedTag == allKey || offer.offerTags.contains(selectedTag);
      if (!matchesTag) return false;
      if (q.isEmpty) return true;

      final searchable = [
        offer.title,
        offer.subtitle,
        offer.code,
        ...offer.offerTags.map(labelForTag),
      ].join(' ').toLowerCase();

      return searchable.contains(q);
    }).toList();
  }

  static int countForTag(List<CouponModel> offers, String key) {
    if (key == allKey) return offers.length;
    return offers.where((o) => o.offerTags.contains(key)).length;
  }
}