import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/core/routes/app_routes.dart';
import 'package:meathub/core/widgets/profile_menu_tile.dart';
import 'package:meathub/data/dummy_help_categories.dart';
import 'package:meathub/models/help_category_item_model.dart';
import 'package:meathub/providers/orders_provider.dart';
import 'package:meathub/screens/help/live_chat_screen.dart';

class HelpCategoryScreen extends StatelessWidget {
  final String topicKey;

  const HelpCategoryScreen({super.key, required this.topicKey});

  void _showInfoDialog(BuildContext context, String title, String answer) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(
          answer,
          style: const TextStyle(fontSize: 13, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _handleItemTap(BuildContext context, HelpCategoryItemModel item) {
    final ordersProvider = context.read<OrdersProvider>();

    if (item.action == HelpItemAction.info) {
      _showInfoDialog(context, item.title, item.infoAnswer ?? '');
      return;
    }
    if (item.action == HelpItemAction.chat) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const LiveChatScreen()));
      return;
    }
    if (item.action == HelpItemAction.reportIssue) {
      final order = ordersProvider.mostRelevantOrder;
      Navigator.of(context).push(
        AppRoutes.reportIssueRoute(
          orderId: order?.orderId,
          presetIssueType: item.presetIssueType,
        ),
      );
      return;
    }

    final order = ordersProvider.mostRelevantOrder;
    if (order == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No orders found. Place an order first.')),
      );
      return;
    }

    switch (item.action) {
      case HelpItemAction.trackOrder:
        Navigator.of(context).push(
          AppRoutes.trackOrderRoute(
            orderId: order.orderId,
            placedAt: order.placedAt,
            items: order.items,
            address: order.address,
            deliveryOption: order.deliveryOption,
            paymentMethod: order.paymentMethod,
            platformFee: order.platformFee,
            discount: order.discount,
          ),
        );
        break;
      case HelpItemAction.manageOrder:
        Navigator.of(context).push(AppRoutes.orderDetailsRoute(order.orderId));
        break;
      case HelpItemAction.refund:
        Navigator.of(context).push(AppRoutes.refundRequestRoute(order.orderId));
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = DummyHelpCategories.byTopic[topicKey];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context, data?.title ?? '', data?.subtitle ?? ''),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                children: [
                  ...?data?.items.map(
                    (item) => ProfileMenuTile(
                      icon: item.icon,
                      title: item.title,
                      subtitle: item.subtitle,
                      onTap: () => _handleItemTap(context, item),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildStillNeedHelpBanner(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => Navigator.of(context).maybePop(),
            borderRadius: BorderRadius.circular(20),
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(
                Icons.arrow_back,
                size: 22,
                color: AppColors.textDark,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStillNeedHelpBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.support_agent,
              color: AppColors.primary,
              size: 19,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.stillNeedHelp,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  AppStrings.chatWithSupportTeam,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const LiveChatScreen())),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              textStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(AppStrings.chatNow),
          ),
        ],
      ),
    );
  }
}
