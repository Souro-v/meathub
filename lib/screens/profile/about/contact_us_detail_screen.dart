import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/core/utils/contact_link_utils.dart';
import 'package:meathub/screens/profile/help_support_screen.dart';

class ContactUsDetailScreen extends StatelessWidget {
  const ContactUsDetailScreen({super.key});

  static const String _supportEmail = 'support@meathub.com';
  static const String _supportPhone = '+8801234567890';
  static const String _supportPhoneDisplay = '+880 1234-567890';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context, AppStrings.contactUsTitle),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: Column(
                        children: [
                          _row(
                            icon: Icons.headset_mic_outlined,
                            title: AppStrings.needHelpRowTitle,
                            subtitle: AppStrings.needHelpRowDesc,
                            trailing: const Icon(
                              Icons.chevron_right,
                              size: 20,
                              color: AppColors.primary,
                            ),
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const HelpSupportScreen(),
                              ),
                            ),
                          ),
                          const Divider(color: AppColors.divider, height: 1),
                          _row(
                            icon: Icons.mail_outline,
                            title: 'Email',
                            subtitle: _supportEmail,
                            trailing: const Icon(
                              Icons.mail_outline,
                              size: 18,
                              color: AppColors.primary,
                            ),
                            onTap: () => ContactLinkUtils.sendEmail(
                              context,
                              _supportEmail,
                            ),
                          ),
                          const Divider(color: AppColors.divider, height: 1),
                          _row(
                            icon: Icons.call_outlined,
                            title: 'Phone',
                            subtitle: _supportPhoneDisplay,
                            trailing: const Icon(
                              Icons.call_outlined,
                              size: 18,
                              color: AppColors.primary,
                            ),
                            onTap: () => ContactLinkUtils.callPhone(
                              context,
                              _supportPhone,
                            ),
                          ),
                          const Divider(color: AppColors.divider, height: 1),
                          _row(
                            icon: Icons.location_on_outlined,
                            title: 'Address',
                            subtitle: 'Dhaka, Bangladesh',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.primarySoft,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  AppStrings.weLoveToHearFromYou,
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primary,
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  AppStrings.feedbackHelpsImprove,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.two_wheeler,
                            size: 34,
                            color: AppColors.primary.withValues(alpha: 0.5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: AppColors.primarySoft,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 18, color: AppColors.primary),
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
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, String title) {
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
