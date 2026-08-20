import 'package:meathub/models/faq_full_item_model.dart';

class DummyFaqFull {
  DummyFaqFull._();

  static const List<FaqFullItemModel> all = [
    FaqFullItemModel(
      question: 'How can I track my order?',
      answer:
          "You can track your order in real-time from the 'Track Order' section. You will also receive updates about your order status.",
      category: 'orders',
      showTrackOrderCta: true,
    ),
    FaqFullItemModel(
      question: 'What if I receive a wrong or damaged item?',
      answer:
          'Report the issue within 12 hours of delivery with photos. We will arrange a free replacement or a full refund.',
      category: 'products',
    ),
    FaqFullItemModel(
      question: 'How do I request a refund?',
      answer:
          'Go to My Orders, select the order, and choose Request Refund. Refunds are processed to your original payment method or MeatHub Wallet.',
      category: 'payments',
    ),
    FaqFullItemModel(
      question: 'How can I change or cancel my order?',
      answer:
          "You can cancel an order from the Orders tab while it's still being prepared. Once it's out for delivery, cancellation isn't available.",
      category: 'orders',
    ),
    FaqFullItemModel(
      question: 'What payment methods do you accept?',
      answer:
          'We accept Cash on Delivery, bKash, Nagad, Credit/Debit Card, and Bank Transfer.',
      category: 'payments',
    ),
    FaqFullItemModel(
      question: 'Do you deliver on weekends?',
      answer:
          'Yes, we deliver every day of the week, including weekends and public holidays.',
      category: 'orders',
    ),
    FaqFullItemModel(
      question: 'What areas do you deliver to?',
      answer:
          'We currently deliver across Dhaka city. Enter your address at checkout to confirm delivery availability in your area.',
      category: 'orders',
    ),
    FaqFullItemModel(
      question: 'How do I use a coupon code?',
      answer:
          "Browse Coupons & Offers in your Profile, tap 'Use Now' on any valid coupon, and it will be applied automatically at checkout.",
      category: 'payments',
    ),
    FaqFullItemModel(
      question: 'What is MeatHub Points?',
      answer:
          'MeatHub Points are loyalty points earned on every order. You can redeem them for discounts on future purchases.',
      category: 'account',
    ),
    FaqFullItemModel(
      question: 'How can I contact customer support?',
      answer:
          'Use the Chat with us button, WhatsApp, Email, or Call Support — all available from the Help & Support screen.',
      category: 'account',
    ),
  ];
}
