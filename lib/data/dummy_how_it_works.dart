import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';

class HowToStepData {
  final int number;
  final IconData icon;
  final String title;
  final String description;

  const HowToStepData({
    required this.number,
    required this.icon,
    required this.title,
    required this.description,
  });
}

class OfferCategoryInfoData {
  final IconData icon;
  final Color color;
  final Color iconBg;
  final String title;
  final String description;
  final String tagKey; // matches OfferFilterUtils tab keys

  const OfferCategoryInfoData({
    required this.icon,
    required this.color,
    required this.iconBg,
    required this.title,
    required this.description,
    required this.tagKey,
  });
}

class DummyHowItWorks {
  DummyHowItWorks._();

  static const List<HowToStepData> steps = [
    HowToStepData(
      number: 1,
      icon: Icons.sell_outlined,
      title: AppStrings.stepChooseOffer,
      description: AppStrings.stepChooseOfferDesc,
    ),
    HowToStepData(
      number: 2,
      icon: Icons.confirmation_number_outlined,
      title: AppStrings.stepTapUseNow,
      description: AppStrings.stepTapUseNowDesc,
    ),
    HowToStepData(
      number: 3,
      icon: Icons.shopping_cart_checkout,
      title: AppStrings.stepDiscountApplied,
      description: AppStrings.stepDiscountAppliedDesc,
    ),
    HowToStepData(
      number: 4,
      icon: Icons.account_balance_wallet_outlined,
      title: AppStrings.stepCheckoutSave,
      description: AppStrings.stepCheckoutSaveDesc,
    ),
  ];

  static const List<OfferCategoryInfoData> categories = [
    OfferCategoryInfoData(
      icon: Icons.kebab_dining,
      color: AppColors.primary,
      iconBg: AppColors.primarySoft,
      title: AppStrings.meatOffersTitle,
      description: AppStrings.meatOffersDesc,
      tagKey: 'meat',
    ),
    OfferCategoryInfoData(
      icon: Icons.two_wheeler,
      color: Color(0xFF2E7D32),
      iconBg: Color(0xFFE1F5E4),
      title: AppStrings.deliveryOffersTitle,
      description: AppStrings.deliveryOffersDesc,
      tagKey: 'delivery',
    ),
    OfferCategoryInfoData(
      icon: Icons.monetization_on_outlined,
      color: Color(0xFFEF6C00),
      iconBg: Color(0xFFFFEEDD),
      title: AppStrings.cashbackOffersTitle,
      description: AppStrings.cashbackOffersDesc,
      tagKey: 'cashback',
    ),
    OfferCategoryInfoData(
      icon: Icons.person_add_alt,
      color: Color(0xFF7B4FC9),
      iconBg: Color(0xFFEEE9FB),
      title: AppStrings.newUserOffersTitle,
      description: AppStrings.newUserOffersDesc,
      tagKey: 'new_user',
    ),
  ];

  static const List<String> importantPoints = [
    AppStrings.pointOneOfferPerOrder,
    AppStrings.pointNoCombine,
    AppStrings.pointMinOrder,
    AppStrings.pointCaseSensitive,
    AppStrings.pointCheckTerms,
    AppStrings.pointValidDate,
  ];
}
