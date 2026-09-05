import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/core/routes/app_routes.dart';
import 'package:meathub/core/widgets/profile_menu_tile.dart';
import 'package:meathub/core/widgets/profile_stat_item.dart';
import 'package:meathub/data/dummy_addresses.dart';
import 'package:meathub/data/dummy_notifications.dart';
import 'package:meathub/providers/orders_provider.dart';
import 'package:meathub/providers/user_provider.dart';
import 'package:meathub/providers/wishlist_provider.dart';

import '../../core/services/auth_service.dart';
import '../../core/utils/image_picker_utils.dart';
import '../../core/widgets/user_avatar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _goToMainTab(BuildContext context, int index) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.main,
      (route) => false,
      arguments: index,
    );
  }

  void _showComingSoon(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label — ${AppStrings.comingSoon}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () => Navigator.pop(dialogContext),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surface,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 15,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
              ),
              _buildLogoutGraphic(),
              const SizedBox(height: 14),
              const Text(
                AppStrings.logOutTitle,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                AppStrings.logOutConfirmDesc,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Column(
                  children: [
                    _LogoutNoteRow(
                      icon: Icons.person_outline,
                      text: AppStrings.logOutNoteLoginAgain,
                    ),
                    SizedBox(height: 10),
                    _LogoutNoteRow(
                      icon: Icons.favorite_border,
                      text: AppStrings.logOutNoteSavedItems,
                    ),
                    SizedBox(height: 10),
                    _LogoutNoteRow(
                      icon: Icons.inventory_2_outlined,
                      text: AppStrings.logOutNoteOrdersSafe,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        minimumSize: const Size(0, 50),
                        textStyle: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(AppStrings.cancel),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await AuthService.signOut();
                        if (!dialogContext.mounted) return;
                        Navigator.of(dialogContext).pushNamedAndRemoveUntil(
                          AppRoutes.login,
                          (route) => false,
                        );
                      },
                      icon: const Icon(Icons.logout, size: 15),
                      label: const Text(AppStrings.logout),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        minimumSize: const Size(0, 50),
                        textStyle: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutGraphic() {
    return SizedBox(
      height: 108,
      width: 108,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 108,
            height: 108,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primarySoft,
            ),
          ),
          const Icon(Icons.logout_rounded, size: 48, color: AppColors.primary),
          Positioned(
            bottom: 4,
            left: 10,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white,
              ),
              child: const Icon(Icons.eco, size: 14, color: AppColors.success),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>();
    final ordersCount = context.watch<OrdersProvider>().orders.length;
    final wishlistCount = context.watch<WishlistProvider>().count;
    final addressesCount = DummyAddresses.managed.length;
    final points = context.watch<OrdersProvider>().totalPoints;
    final unreadNotifications = DummyNotifications.today
        .where((n) => n.isUnread)
        .length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context, unreadNotifications),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileCard(
                      context,
                      user,
                      ordersCount,
                      wishlistCount,
                      addressesCount,
                      points,
                    ),
                    const SizedBox(height: 16),
                    _buildMembershipBanner(context),
                    const SizedBox(height: 16),
                    _buildMenuCard(context),
                    const SizedBox(height: 16),
                    _buildFooterBanner(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, int unreadCount) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.myProfile,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  AppStrings.myProfileSubtitle,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => _showComingSoon(context, 'Settings'),
            borderRadius: BorderRadius.circular(20),
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(
                Icons.settings_outlined,
                size: 22,
                color: AppColors.textDark,
              ),
            ),
          ),
          const SizedBox(width: 4),
          InkWell(
            onTap: () =>
                Navigator.of(context).pushNamed(AppRoutes.notification),
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Badge(
                label: Text('$unreadCount'),
                isLabelVisible: unreadCount > 0,
                backgroundColor: AppColors.primary,
                child: const Icon(
                  Icons.notifications_outlined,
                  size: 22,
                  color: AppColors.textDark,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(
    BuildContext context,
    UserProvider user,
    int ordersCount,
    int wishlistCount,
    int addressesCount,
    int points,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  const UserAvatar(radius: 34),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () async {
                        final file = await ImagePickerUtils.pickFromGallery();
                        if (file != null && context.mounted) {
                          context.read<UserProvider>().updatePhoto(file);
                        }
                      },
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          size: 13,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.phone,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      user.email,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () =>
                    Navigator.of(context).pushNamed(AppRoutes.editProfile),
                child: Row(
                  children: const [
                    Text(
                      AppStrings.editProfile,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: AppColors.divider, height: 1),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ProfileStatItem(
                  icon: Icons.receipt_long_outlined,
                  value: '$ordersCount',
                  label: AppStrings.ordersLabel,
                  onTap: () => _goToMainTab(context, 3),
                ),
              ),
              Expanded(
                child: ProfileStatItem(
                  icon: Icons.favorite_border,
                  value: '$wishlistCount',
                  label: AppStrings.wishlistLabel,
                  onTap: () =>
                      Navigator.of(context).pushNamed(AppRoutes.wishlist),
                ),
              ),
              Expanded(
                child: ProfileStatItem(
                  icon: Icons.location_on_outlined,
                  value: '$addressesCount',
                  label: AppStrings.addressesLabel,
                  onTap: () => Navigator.of(
                    context,
                  ).pushNamed(AppRoutes.manageAddresses),
                ),
              ),
              Expanded(
                child: ProfileStatItem(
                  icon: Icons.star_border,
                  value: '$points',
                  label: AppStrings.meatHubPointsLabel,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMembershipBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.workspace_premium,
              color: AppColors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  AppStrings.meatHubMember,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.white,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  AppStrings.meatHubMemberDesc,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.white,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => _showComingSoon(context, AppStrings.viewBenefits),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.white,
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              textStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(AppStrings.viewBenefits),
                Icon(Icons.chevron_right, size: 15),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context) {
    final items = <ProfileMenuTile>[
      ProfileMenuTile(
        icon: Icons.calendar_today_outlined,
        title: AppStrings.myOrdersMenuTitle,
        subtitle: AppStrings.myOrdersMenuDesc,
        onTap: () => _goToMainTab(context, 3),
      ),
      ProfileMenuTile(
        icon: Icons.favorite_border,
        title: AppStrings.wishlistLabel,
        subtitle: AppStrings.wishlistMenuDesc,
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.wishlist),
      ),
      ProfileMenuTile(
        icon: Icons.location_on_outlined,
        title: AppStrings.myAddressesMenuTitle,
        subtitle: AppStrings.myAddressesMenuDesc,
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.manageAddresses),
      ),
      ProfileMenuTile(
        icon: Icons.credit_card,
        title: AppStrings.paymentMethodsMenuTitle,
        subtitle: AppStrings.paymentMethodsMenuDesc,
        onTap: () =>
            _showComingSoon(context, AppStrings.paymentMethodsMenuTitle),
      ),
      ProfileMenuTile(
        icon: Icons.confirmation_num_outlined,
        title: AppStrings.couponsOffers,
        subtitle: AppStrings.couponsOffersDesc,
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.couponsOffers),
      ),
      ProfileMenuTile(
        icon: Icons.verified_user_outlined,
        title: AppStrings.meatHubGuarantee,
        subtitle: AppStrings.meatHubGuaranteeDesc,
        onTap: () =>
            Navigator.of(context).pushNamed(AppRoutes.meatHubGuarantee),
      ),
      ProfileMenuTile(
        icon: Icons.headset_mic_outlined,
        title: AppStrings.helpSupport,
        subtitle: AppStrings.helpSupportDesc,
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.helpSupport),
      ),
      ProfileMenuTile(
        icon: Icons.info_outline,
        title: AppStrings.aboutMeatHub,
        subtitle: AppStrings.aboutMeatHubDesc,
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.aboutMeatHub),
      ),
      ProfileMenuTile(
        icon: Icons.logout,
        iconColor: AppColors.error,
        title: AppStrings.logout,
        subtitle: AppStrings.logoutDesc,
        onTap: () => _confirmLogout(context),
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: List.generate(items.length, (index) {
          final isLast = index == items.length - 1;
          return Column(
            children: [
              items[index],
              if (!isLast) const Divider(color: AppColors.divider, height: 1),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildFooterBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.successSoft,
        borderRadius: BorderRadius.circular(18),
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
              Icons.eco_outlined,
              color: AppColors.success,
              size: 19,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.freshHalalTrustedTagline,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.success,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  AppStrings.thankYouChoosingMeatHub,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _HalalSeal(),
        ],
      ),
    );
  }
}

class _HalalSeal extends StatelessWidget {
  const _HalalSeal();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: const BoxDecoration(
        color: AppColors.white,
        shape: BoxShape.circle,
        border: Border.fromBorderSide(
          BorderSide(color: AppColors.primary, width: 1.4),
        ),
      ),
      alignment: Alignment.center,
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'حلال',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'HALAL',
            style: TextStyle(
              fontSize: 7,
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoutNoteRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _LogoutNoteRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 12.5, color: AppColors.textDark),
          ),
        ),
      ],
    );
  }
}
