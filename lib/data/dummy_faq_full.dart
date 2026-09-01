import 'package:meathub/models/faq_full_item_model.dart';

class DummyFaqFull {
  DummyFaqFull._();

  static const List<FaqFullItemModel> all = [
    // Orders & Delivery
    FaqFullItemModel(
      question: 'How long does delivery take?',
      answer:
          'Standard Delivery takes 45-60 minutes and Express Delivery takes 20-30 minutes — choose your preferred option at checkout.',
      category: 'orders',
    ),
    FaqFullItemModel(
      question: 'How can I track my order?',
      answer:
          "You can track your order in real-time from the 'Track Order' section. You will also receive updates about your order status.",
      category: 'orders',
      showTrackOrderCta: true,
    ),
    FaqFullItemModel(
      question: 'What if I am not at home during delivery?',
      answer:
          'Our rider will try contacting you by phone. Please make sure someone is available to receive the order, or add delivery notes at checkout.',
      category: 'orders',
    ),
    FaqFullItemModel(
      question: 'How can I change or cancel my order?',
      answer:
          "You can cancel an order from the Orders tab while it's still being prepared. Once it's out for delivery, cancellation isn't available.",
      category: 'orders',
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
      question: 'What if my order is delayed?',
      answer:
          'You can check live status anytime from Track Order. If it runs more than 30 minutes past the estimated window, please contact support.',
      category: 'orders',
    ),

    // Payments & Refunds
    FaqFullItemModel(
      question: 'What payment methods do you accept?',
      answer:
          'We accept Cash on Delivery, bKash, Nagad, Credit/Debit Card, and Bank Transfer.',
      category: 'payments',
    ),
    FaqFullItemModel(
      question: 'How do I request a refund?',
      answer:
          'Go to My Orders, select the order, and choose Request Refund (for undelivered orders) or Report an Issue (for delivered orders with a problem).',
      category: 'payments',
    ),
    FaqFullItemModel(
      question: 'How long does a refund take?',
      answer:
          'MeatHub Wallet refunds are usually instant. Refunds to your original payment method can take 2-5 business days.',
      category: 'payments',
    ),
    FaqFullItemModel(
      question: 'Can I pay with Cash on Delivery?',
      answer:
          'Yes, Cash on Delivery is available and is our most popular payment method.',
      category: 'payments',
    ),

    // Product & Quality
    FaqFullItemModel(
      question: 'What if I receive a wrong or damaged item?',
      answer:
          'Report the issue within 12 hours of delivery with photos. We will arrange a free replacement or a full refund.',
      category: 'product',
    ),
    FaqFullItemModel(
      question: 'How is meat quality ensured?',
      answer:
          'All meat is sourced from trusted, quality-checked suppliers, properly chilled from store to doorstep, and vacuum-sealed for freshness.',
      category: 'product',
    ),
    FaqFullItemModel(
      question: 'Is the meat halal certified?',
      answer:
          'Yes, all meat sold on MeatHub is 100% halal and processed under strict hygiene standards.',
      category: 'product',
    ),
    FaqFullItemModel(
      question: 'How is the meat packaged and kept fresh?',
      answer:
          'All items are vacuum-sealed and packed in insulated packaging to keep them safe and fresh during delivery.',
      category: 'product',
    ),

    // Account & Profile
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
    FaqFullItemModel(
      question: 'How do I update my profile information?',
      answer:
          "Go to Profile → Edit Profile to update your name, phone, email, date of birth, gender, and photo.",
      category: 'account',
    ),
    FaqFullItemModel(
      question: 'How do I delete my account?',
      answer:
          'Go to Profile → Edit Profile → Delete Account. Please note this action is permanent.',
      category: 'account',
    ),

    // Coupons & Offers
    FaqFullItemModel(
      question: 'How do I use a coupon code?',
      answer:
          "Browse Coupons & Offers in your Profile, tap 'Use Now' on any valid coupon, and it will be applied automatically at checkout.",
      category: 'coupons',
    ),
    FaqFullItemModel(
      question: 'Can I use multiple coupons at once?',
      answer:
          'Only one coupon can be applied per order. Coupons also cannot be combined with other offers.',
      category: 'coupons',
    ),
    FaqFullItemModel(
      question: "Why isn't my coupon code working?",
      answer:
          'Check that your cart meets the minimum order value and category requirements for that coupon, and that it hasn\'t expired.',
      category: 'coupons',
    ),
    FaqFullItemModel(
      question: 'Do coupons expire?',
      answer:
          'Yes, every coupon has a valid-until date shown on the offer card. Expired coupons can no longer be applied.',
      category: 'coupons',
    ),

    // Addresses & Locations
    FaqFullItemModel(
      question: 'Can I save multiple delivery addresses?',
      answer:
          'Yes, you can save Home, Office, and other addresses under Manage Addresses in your Profile.',
      category: 'addresses',
    ),
    FaqFullItemModel(
      question: 'How do I add or edit a saved address?',
      answer:
          "Go to Profile → My Addresses → Manage, then tap Add New Address or the edit icon on any saved address.",
      category: 'addresses',
    ),
    FaqFullItemModel(
      question: 'Can I change my delivery address after placing an order?',
      answer:
          'You can change the delivery address while the order is still being prepared, from Order Details → Change Delivery Address.',
      category: 'addresses',
    ),

    // Wallet & Credits
    FaqFullItemModel(
      question: 'What is MeatHub Wallet?',
      answer:
          'MeatHub Wallet holds your refunds and credits, which you can use towards future orders.',
      category: 'wallet',
    ),
    FaqFullItemModel(
      question: 'How do refunds to my wallet work?',
      answer:
          'Wallet refunds are usually instant and appear in your balance right after approval.',
      category: 'wallet',
    ),
    FaqFullItemModel(
      question: 'Can I withdraw money from my wallet?',
      answer:
          'Wallet balance can currently only be used for MeatHub orders and cannot be withdrawn to a bank account.',
      category: 'wallet',
    ),

    // Other Issues
    FaqFullItemModel(
      question: 'How do I report a problem with my order?',
      answer:
          "Go to Orders → select the delivered order → Report an Issue, choose an issue type, and submit with photos if needed.",
      category: 'other',
    ),
    FaqFullItemModel(
      question: 'Where can I view my order history?',
      answer:
          'All your past and ongoing orders are available under the Orders tab in the bottom navigation.',
      category: 'other',
    ),
    FaqFullItemModel(
      question: 'Is my personal information kept secure?',
      answer:
          'Yes, your personal and payment information is protected with industry-standard encryption.',
      category: 'other',
    ),
  ];
}
