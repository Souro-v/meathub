import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_assets.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/models/category_model.dart';
import 'package:meathub/models/product_model.dart';

import '../core/constants/app_colors.dart';
import '../models/delivery_option_model.dart';
import '../models/payment_method_model.dart';

class DummyData {
  DummyData._();

  static const List<String> banners = [
    AppAssets.banner1,
    AppAssets.banner2,
    AppAssets.banner3,
    AppAssets.banner4,
    AppAssets.banner5,
  ];

  static const List<CategoryModel> categories = [
    CategoryModel(
      name: AppStrings.categoryBeefLabel,
      icon: AppAssets.categoryBeef,
    ),
    CategoryModel(
      name: AppStrings.categoryMuttonLabel,
      icon: AppAssets.categoryMutton,
    ),
    CategoryModel(
      name: AppStrings.categoryChickenLabel,
      icon: AppAssets.categoryChicken,
    ),
    CategoryModel(
      name: AppStrings.categoryFishLabel,
      icon: AppAssets.categoryFish,
    ),
    CategoryModel(
      name: AppStrings.categoryEggLabel,
      icon: AppAssets.categoryEgg,
    ),
  ];

  static const List<ProductModel> popularToday = [
    ProductModel(
      id: 'premium_beef',
      name: 'Premium Beef',
      image: AppAssets.premiumBeef,
      category: 'Beef',
      price: '850',
      originalPrice: '950',
      unit: '1 kg',
      rating: 4.9,
      reviewCount: 128,
    ),
    ProductModel(
      id: 'chicken_curry_cut',
      name: 'Chicken Curry Cut',
      image: AppAssets.chickenCurryCut,
      category: 'Chicken',
      price: '220',
      originalPrice: '220',
      unit: '1 kg',
      rating: 4.7,
      reviewCount: 156,
    ),
    ProductModel(
      id: 'mutton',
      name: 'Mutton Curry Cut',
      image: AppAssets.mutton,
      category: 'Mutton',
      price: '980',
      originalPrice: '1150',
      unit: '1 kg',
      rating: 4.8,
      reviewCount: 96,
    ),
  ];

  static const List<ProductModel> todaysFreshPicks = [
    ProductModel(
      id: 'rui_fish',
      name: 'Rui Fish',
      image: AppAssets.ruiFish,
      category: 'Fish',
      price: '380',
      originalPrice: '380',
      unit: '1 kg',
      rating: 4.5,
      reviewCount: 64,
    ),
    ProductModel(
      id: 'beef_mince',
      name: 'Beef Mince',
      image: AppAssets.beefMince,
      category: 'Beef',
      price: '680',
      originalPrice: '680',
      unit: '1 kg',
      rating: 4.6,
      reviewCount: 82,
    ),
    ProductModel(
      id: 'beef_liver',
      name: 'Beef Liver',
      image: AppAssets.beefLiver,
      category: 'Beef',
      price: '260',
      originalPrice: '320',
      unit: '500 g',
      rating: 4.6,
      reviewCount: 74,
    ),
    ProductModel(
      id: 'beef',
      name: 'Premium Beef',
      image: AppAssets.beef,
      category: 'Beef',
      price: '980',
      originalPrice: '1150',
      unit: '1 kg',
      rating: 4.8,
      reviewCount: 96,
    ),
    ProductModel(
      id: 'beef_bone',
      name: 'Beef Bone',
      image: AppAssets.beefBone,
      category: 'Beef',
      price: '700',
      originalPrice: '900',
      unit: '1 kg',
      rating: 4.3,
      reviewCount: 16,
    ),
    ProductModel(
      id: 'shusi_fish',
      name: 'Shusi Fish',
      image: AppAssets.shusiCutFish,
      category: 'Fish',
      price: '400',
      originalPrice: '599',
      unit: '500 g',
      rating: 4.1,
      reviewCount: 10,
    ),
    ProductModel(
      id: 'chicken_drum_stick',
      name: 'Chicken Drum Stick',
      image: AppAssets.chickenDrumStick,
      category: 'Chicken',
      price: '499',
      originalPrice: '599',
      unit: '1 kg',
      rating: 4.7,
      reviewCount: 36,
    ),
    ProductModel(
      id: 'mutton_leg',
      name: 'Mutton Leg Piece',
      image: AppAssets.muttonLeg,
      category: 'Mutton',
      price: '1099',
      originalPrice: '1350',
      unit: '1 kg',
      rating: 4.9,
      reviewCount: 51,
    ),
    ProductModel(
      id: 'mutton_curry_cut',
      name: 'Mutton',
      image: AppAssets.muttonCurryCut,
      category: 'Mutton',
      price: '1150',
      originalPrice: '1300',
      unit: '1 kg',
      rating: 4.6,
      reviewCount: 89,
    ),
    ProductModel(
      id: 'chicken_wings',
      name: 'Chicken Wings',
      image: AppAssets.chickenWings,
      category: 'Chicken',
      price: '280',
      originalPrice: '280',
      unit: '1 kg',
      rating: 4.7,
      reviewCount: 210,
    ),
    ProductModel(
      id: 'chicken_liver',
      name: 'Chicken Liver',
      image: AppAssets.chickenLiver,
      category: 'Chicken',
      price: '180',
      originalPrice: '180',
      unit: '500 g',
      rating: 4.4,
      reviewCount: 51,
    ),
  ];
  static const List<DeliveryOptionModel> deliveryOptions = [
    DeliveryOptionModel(
      id: 'standard',
      icon: Icons.two_wheeler,
      title: 'Standard Delivery',
      subtitle: '45-60 mins',
      fee: 0,
    ),
    DeliveryOptionModel(
      id: 'express',
      icon: Icons.timer_outlined,
      title: 'Express Delivery',
      subtitle: '20-30 mins',
      fee: 60,
    ),
  ];
  static const List<PaymentMethodModel> paymentMethods = [
    PaymentMethodModel(
      id: 'cod',
      icon: Icons.payments_outlined,
      iconColor: AppColors.primary,
      iconBg: AppColors.primarySoft,
      title: 'Cash on Delivery',
      subtitle: 'Pay in cash when your order is delivered',
      isRecommended: true,
    ),
    PaymentMethodModel(
      id: 'bkash',
      icon: Icons.account_balance_wallet_outlined,
      iconColor: Color(0xFFE2136E),
      iconBg: Color(0xFFFCE4EF),
      title: 'bKash',
      subtitle: 'Pay easily with bKash',
    ),
    PaymentMethodModel(
      id: 'nagad',
      icon: Icons.account_balance_wallet_outlined,
      iconColor: Color(0xFFF7941D),
      iconBg: Color(0xFFFEF0E0),
      title: 'Nagad',
      subtitle: 'Pay easily with Nagad',
    ),
    PaymentMethodModel(
      id: 'card',
      icon: Icons.credit_card,
      iconColor: AppColors.textDark,
      iconBg: AppColors.surface,
      title: 'Credit / Debit Card',
      subtitle: 'Visa, MasterCard, AMEX',
      showCardBrands: true,
    ),
    PaymentMethodModel(
      id: 'bank',
      icon: Icons.account_balance_outlined,
      iconColor: AppColors.textDark,
      iconBg: AppColors.surface,
      title: 'Bank Transfer',
      subtitle: 'Transfer from any bank',
    ),
  ];
}
