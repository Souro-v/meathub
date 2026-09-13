import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  static const List<Map<String, String>> _sections = [
    {
      'title': '1. Information We Collect',
      'body':
          'We collect information you provide directly, such as your name, phone number, email address, delivery addresses, and order history, to provide and improve our services.',
    },
    {
      'title': '2. How We Use Your Information',
      'body':
          'Your information is used to process orders, deliver products, provide customer support, send order-related notifications, and — where you opt in — send promotional offers.',
    },
    {
      'title': '3. Location Data',
      'body':
          "With your permission, we use your device's location to detect your delivery address and improve delivery accuracy. You can deny or revoke this permission at any time from your device settings.",
    },
    {
      'title': '4. Data Sharing',
      'body':
          'We do not sell your personal information. Delivery-related information may be shared with our delivery partners solely to fulfil your order.',
    },
    {
      'title': '5. Data Security',
      'body':
          'We use industry-standard security measures, including encrypted authentication, to protect your personal and payment information.',
    },
    {
      'title': '6. Your Rights',
      'body':
          'You can review and update your profile information at any time from Edit Profile, and request account deletion from Profile settings.',
    },
    {
      'title': '7. Changes to This Policy',
      'body':
          'We may update this Privacy Policy from time to time. We encourage you to review it periodically.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${AppStrings.lastUpdatedLabel}: August 2026',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textHint,
                      ),
                    ),
                    const SizedBox(height: 16),
                    for (final section in _sections) ...[
                      Text(
                        section['title']!,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        section['body']!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 18),
                    ],
                  ],
                ),
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
          const Text(
            AppStrings.privacyPolicyTitle,
            style: TextStyle(
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
