import 'package:flutter/material.dart';
import 'package:meathub/models/faq_category_config_model.dart';

class DummyFaqCategories {
  DummyFaqCategories._();

  static const List<FaqCategoryConfigModel> all = [
    FaqCategoryConfigModel(
      key: 'orders',
      title: 'Orders & Delivery',
      icon: Icons.local_shipping_outlined,
      color: Color(0xFFB71C1C),
      bg: Color(0xFFFCE4E4),
    ),
    FaqCategoryConfigModel(
      key: 'payments',
      title: 'Payments & Refunds',
      icon: Icons.credit_card_outlined,
      color: Color(0xFF2E7D32),
      bg: Color(0xFFE1F5E4),
    ),
    FaqCategoryConfigModel(
      key: 'product',
      title: 'Product & Quality',
      icon: Icons.kebab_dining,
      color: Color(0xFFB71C1C),
      bg: Color(0xFFFCE4E4),
    ),
    FaqCategoryConfigModel(
      key: 'account',
      title: 'Account & Profile',
      icon: Icons.person_outline,
      color: Color(0xFF6A4FBF),
      bg: Color(0xFFEEE9FB),
    ),
    FaqCategoryConfigModel(
      key: 'coupons',
      title: 'Coupons & Offers',
      icon: Icons.sell_outlined,
      color: Color(0xFFE2136E),
      bg: Color(0xFFFCE4EF),
    ),
    FaqCategoryConfigModel(
      key: 'addresses',
      title: 'Addresses & Locations',
      icon: Icons.location_on_outlined,
      color: Color(0xFF3F5FBF),
      bg: Color(0xFFE8EEFB),
    ),
    FaqCategoryConfigModel(
      key: 'wallet',
      title: 'Wallet & Credits',
      icon: Icons.account_balance_wallet_outlined,
      color: Color(0xFFB8860B),
      bg: Color(0xFFFFF3D6),
    ),
    FaqCategoryConfigModel(
      key: 'other',
      title: 'Other Issues',
      icon: Icons.more_horiz,
      color: Color(0xFF757575),
      bg: Color(0xFFF0F0F0),
    ),
  ];
}
