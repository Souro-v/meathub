import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/core/widgets/notification_card.dart';
import 'package:meathub/data/dummy_notifications.dart';
import 'package:meathub/models/notification_model.dart';

import '../../core/widgets/empty_state_view.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int _selectedTab = 0; // 0 = All, 1 = Promotions
  late List<NotificationModel> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = List.of(DummyNotifications.today);
  }

  void _markAllAsRead() {
    setState(() {
      _notifications = _notifications
          .map((n) => n.copyWith(isUnread: false))
          .toList();
    });
  }
  List<NotificationModel> get _filteredNotifications {
    if (_selectedTab == 1) return _notifications.where((n) => n.isPromotional).toList();
    return _notifications;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            const SizedBox(height: 16),
            _buildTabs(),
            const SizedBox(height: 20),
            Expanded(
              child: _filteredNotifications.isEmpty
                  ? const EmptyStateView(
                      icon: Icons.notifications_none,
                      title: AppStrings.noNotificationsYetTitle,
                      description: AppStrings.noNotificationsYetDesc,
                    )
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      children: [
                        const Text(
                          AppStrings.today,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textHint,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ..._notifications.map(
                          (n) => NotificationCard(notification: n),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.of(context).maybePop(),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.divider),
              ),
              child: const Icon(
                Icons.arrow_back,
                size: 18,
                color: AppColors.primary,
              ),
            ),
          ),
          const Expanded(
            child: Text(
              AppStrings.notifications,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
          ),
          if (_notifications.isNotEmpty)
            GestureDetector(
              onTap: _markAllAsRead,
              child: const Text(
                AppStrings.markAllAsRead,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _TabChip(
              icon: Icons.notifications,
              label: AppStrings.all,
              selected: _selectedTab == 0,
              onTap: () => setState(() => _selectedTab = 0),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _TabChip(
              icon: Icons.sell_outlined,
              label: AppStrings.promotions,
              selected: _selectedTab == 1,
              onTap: () => setState(() => _selectedTab = 1),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabChip({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primarySoft : AppColors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? AppColors.primarySoft : AppColors.divider,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: selected ? AppColors.primary : AppColors.textDark,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? AppColors.primary : AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
