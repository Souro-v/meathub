import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/core/routes/app_routes.dart';
import 'package:meathub/screens/profile/about_meathub_screen.dart';
import 'package:meathub/screens/profile/edit_profile_screen.dart';
import 'package:meathub/screens/profile/notification_preferences_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _clearCache(BuildContext context) {
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(AppStrings.cacheClearedMessage),
        backgroundColor: AppColors.primary,
      ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                children: [
                  _sectionCard(AppStrings.preferencesTitle, [
                    _tile(
                      icon: Icons.notifications_outlined,
                      title: AppStrings.pushNotificationsLabel,
                      subtitle: AppStrings.pushNotificationsDesc,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const NotificationPreferencesScreen(),
                        ),
                      ),
                    ),
                    _tile(
                      icon: Icons.language_outlined,
                      title: AppStrings.languageLabel,
                      subtitle: AppStrings.languageValue,
                      onTap: () =>
                          _showComingSoon(context, AppStrings.languageLabel),
                    ),
                  ]),
                  const SizedBox(height: 16),
                  _sectionCard(AppStrings.storageTitle, [
                    _tile(
                      icon: Icons.cleaning_services_outlined,
                      title: AppStrings.clearCacheLabel,
                      subtitle: AppStrings.clearCacheDesc,
                      onTap: () => _clearCache(context),
                      trailing: const SizedBox.shrink(),
                    ),
                  ]),
                  const SizedBox(height: 16),
                  _sectionCard(AppStrings.accountTitle, [
                    _tile(
                      icon: Icons.manage_accounts_outlined,
                      title: AppStrings.manageAccountLabel,
                      subtitle: AppStrings.manageAccountDesc,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const EditProfileScreen(),
                        ),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 16),
                  _sectionCard(AppStrings.legalTitle, [
                    _tile(
                      icon: Icons.description_outlined,
                      title: AppStrings.termsConditions,
                      onTap: () => Navigator.of(
                        context,
                      ).pushNamed(AppRoutes.termsConditions),
                    ),
                    _tile(
                      icon: Icons.privacy_tip_outlined,
                      title: AppStrings.privacyPolicyTitle,
                      onTap: () => Navigator.of(
                        context,
                      ).pushNamed(AppRoutes.privacyPolicy),
                    ),
                  ]),
                  const SizedBox(height: 16),
                  _sectionCard(AppStrings.aboutTitle, [
                    _tile(
                      icon: Icons.info_outline,
                      title: AppStrings.aboutMeatHubTitle,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AboutMeatHubScreen(),
                        ),
                      ),
                    ),
                    _tile(
                      icon: Icons.star_border,
                      title: AppStrings.rateTheApp,
                      subtitle: AppStrings.rateTheAppDesc,
                      onTap: () =>
                          _showComingSoon(context, AppStrings.rateTheApp),
                    ),
                    _tile(
                      icon: Icons.tag_outlined,
                      title: AppStrings.appVersionLabel,
                      subtitle: AppStrings.appVersionValue,
                      onTap: null,
                      trailing: const SizedBox.shrink(),
                    ),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
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
          const SizedBox(width: 2),
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  AppStrings.settingsTitle,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  AppStrings.settingsSubtitle,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard(String title, List<Widget> tiles) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textHint,
              ),
            ),
          ),
          const SizedBox(height: 4),
          for (int i = 0; i < tiles.length; i++) ...[
            tiles[i],
            if (i != tiles.length - 1)
              const Divider(color: AppColors.divider, height: 1),
          ],
        ],
      ),
    );
  }

  Widget _tile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback? onTap,
    Widget? trailing,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: AppColors.primarySoft,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 17, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            trailing ??
                const Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: AppColors.textHint,
                ),
          ],
        ),
      ),
    );
  }
}
