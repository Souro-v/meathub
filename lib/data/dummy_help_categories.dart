import 'package:flutter/material.dart';
import 'package:meathub/models/help_category_item_model.dart';

class DummyHelpCategories {
  DummyHelpCategories._();

  static const Map<String, HelpCategoryData> byTopic = {
    'orders': HelpCategoryData(
      title: 'Orders & Deliveries',
      subtitle: 'Find help related to your orders and delivery',
      items: [
        HelpCategoryItemModel(
          icon: Icons.local_shipping_outlined,
          title: 'Where is my order?',
          subtitle: 'Track your order and real-time status',
          action: HelpItemAction.trackOrder,
        ),
        HelpCategoryItemModel(
          icon: Icons.schedule_outlined,
          title: 'Late or delayed delivery',
          subtitle: 'What to do if your order is delayed',
          action: HelpItemAction.info,
          infoAnswer:
              'If your order is running late, check live status anytime from Track Order. If it is more than 30 minutes past the estimated window, please contact support.',
        ),
        HelpCategoryItemModel(
          icon: Icons.cancel_outlined,
          title: 'Cancel my order',
          subtitle: 'Request to cancel your order',
          action: HelpItemAction.manageOrder,
        ),
        HelpCategoryItemModel(
          icon: Icons.location_on_outlined,
          title: 'Change delivery address',
          subtitle: 'Update your delivery location',
          action: HelpItemAction.manageOrder,
        ),
        HelpCategoryItemModel(
          icon: Icons.inventory_2_outlined,
          title: 'Missing item in order',
          subtitle: 'Report if any item is missing',
          action: HelpItemAction.reportIssue,
          presetIssueType: 'Missing item',
        ),
        HelpCategoryItemModel(
          icon: Icons.swap_horiz,
          title: 'Wrong item received',
          subtitle: 'Received wrong item in your order',
          action: HelpItemAction.reportIssue,
          presetIssueType: 'Wrong item received',
        ),
        HelpCategoryItemModel(
          icon: Icons.map_outlined,
          title: 'Delivery areas',
          subtitle: 'Check if we deliver to your area',
          action: HelpItemAction.info,
          infoAnswer:
              'We currently deliver across Dhaka city. Enter your address at checkout to confirm delivery availability in your area.',
        ),
      ],
    ),
    'product': HelpCategoryData(
      title: 'Product & Quality',
      subtitle: 'Find help related to product freshness and quality',
      items: [
        HelpCategoryItemModel(
          icon: Icons.eco_outlined,
          title: 'Product is not fresh',
          subtitle: 'Report a freshness issue with your order',
          action: HelpItemAction.reportIssue,
          presetIssueType: 'Poor quality',
        ),
        HelpCategoryItemModel(
          icon: Icons.event_busy_outlined,
          title: 'Received expired product',
          subtitle: 'Report an expired or spoiled item',
          action: HelpItemAction.reportIssue,
          presetIssueType: 'Poor quality',
        ),
        HelpCategoryItemModel(
          icon: Icons.scale_outlined,
          title: 'Wrong weight or quantity',
          subtitle: 'Item weight does not match what you ordered',
          action: HelpItemAction.reportIssue,
          presetIssueType: 'Other',
        ),
        HelpCategoryItemModel(
          icon: Icons.verified_outlined,
          title: 'How is meat quality ensured?',
          subtitle: 'Learn about our quality guarantee',
          action: HelpItemAction.info,
          infoAnswer:
              'All meat is sourced from trusted, quality-checked suppliers, properly chilled from store to doorstep, and vacuum-sealed for freshness.',
        ),
      ],
    ),
    'payments': HelpCategoryData(
      title: 'Payments & Refunds',
      subtitle: 'Find help related to payments and refunds',
      items: [
        HelpCategoryItemModel(
          icon: Icons.error_outline,
          title: 'Payment failed but money deducted',
          subtitle: 'Request a refund for a failed payment',
          action: HelpItemAction.refund,
        ),
        HelpCategoryItemModel(
          icon: Icons.replay_circle_filled_outlined,
          title: 'Refund not received yet',
          subtitle: 'Check the status of your refund',
          action: HelpItemAction.refund,
        ),
        HelpCategoryItemModel(
          icon: Icons.credit_card_outlined,
          title: 'Change payment method',
          subtitle: 'See supported payment options',
          action: HelpItemAction.info,
          infoAnswer:
              'You can pay via Cash on Delivery, bKash, Nagad, Credit/Debit Card, or Bank Transfer — choose your preferred method at checkout.',
        ),
        HelpCategoryItemModel(
          icon: Icons.receipt_long_outlined,
          title: 'How do I request a refund?',
          subtitle: 'Steps to request a refund for an order',
          action: HelpItemAction.refund,
        ),
      ],
    ),
  };
}
