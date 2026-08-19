import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/models/faq_item_model.dart';
import 'package:meathub/models/help_topic_model.dart';

class DummyHelpData {
  DummyHelpData._();

  static const List<HelpTopicModel> topics = [
    HelpTopicModel(
      icon: Icons.local_shipping_outlined,
      title: AppStrings.topicOrdersDeliveries,
      key: 'orders',
    ),
    HelpTopicModel(
      icon: Icons.restaurant_menu,
      title: AppStrings.topicProductQuality,
      key: 'product',
    ),
    HelpTopicModel(
      icon: Icons.credit_card_outlined,
      title: AppStrings.topicPaymentsRefunds,
      key: 'payments',
    ),
    HelpTopicModel(
      icon: Icons.sell_outlined,
      title: AppStrings.topicCouponsOffers,
      key: 'coupons',
    ),
    HelpTopicModel(
      icon: Icons.person_outline,
      title: AppStrings.topicAccountProfile,
      key: 'account',
    ),
    HelpTopicModel(
      icon: Icons.location_on_outlined,
      title: AppStrings.topicAddressesLocations,
      key: 'addresses',
    ),
    HelpTopicModel(
      icon: Icons.account_balance_wallet_outlined,
      title: AppStrings.topicWalletCredits,
      key: 'wallet',
    ),
    HelpTopicModel(
      icon: Icons.more_horiz,
      title: AppStrings.topicOtherIssues,
      key: 'other',
    ),
  ];

  static const List<FaqItemModel> faqs = [
    FaqItemModel(
      question: 'How can I track my order?',
      answer:
          "Go to the Orders tab, select your order, and tap 'Track Order' to see live delivery status and estimated arrival time.",
      topicKey: 'orders',
    ),
    FaqItemModel(
      question: 'What if I receive a wrong or damaged item?',
      answer:
          "Contact us within 12 hours of delivery with photos of the item. We'll arrange a free replacement or a full refund.",
      topicKey: 'product',
    ),
    FaqItemModel(
      question: 'How do I request a refund?',
      answer:
          'Refunds for cancelled orders are processed automatically. For quality issues, reach out via Help & Support within 12 hours of delivery.',
      topicKey: 'payments',
    ),
    FaqItemModel(
      question: 'How can I change or cancel my order?',
      answer:
          "You can cancel an order from the Orders tab while it's still being prepared. Once it's out for delivery, cancellation isn't available.",
      topicKey: 'orders',
    ),
    FaqItemModel(
      question: 'What areas do you deliver to?',
      answer:
          'We currently deliver across Dhaka city. Enter your address at checkout to confirm delivery availability in your area.',
      topicKey: 'addresses',
    ),
  ];
}
