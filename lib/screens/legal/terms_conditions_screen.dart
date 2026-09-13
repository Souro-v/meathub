import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  static const List<Map<String, String>> _sections = [
    {
      'title': '1. Acceptance of Terms',
      'body':
          'By creating an account or placing an order on MeatHub, you agree to be bound by these Terms & Conditions. If you do not agree, please do not use the app.',
    },
    {
      'title': '2. Orders & Payment',
      'body':
          'All orders are subject to availability and confirmation. Prices are shown in Bangladeshi Taka (৳) and may change without prior notice. Payment can be made via Cash on Delivery or supported online payment methods at checkout.',
    },
    {
      'title': '3. Delivery',
      'body':
          'MeatHub aims to deliver within the estimated time window shown at checkout. Delivery delays due to weather, traffic, or unforeseen circumstances are not the responsibility of MeatHub, though we will keep you informed.',
    },
    {
      'title': '4. Cancellations & Refunds',
      'body':
          'Orders can be cancelled while still being prepared. Once out for delivery, cancellation is not available. Refunds for eligible cases are processed to your original payment method or MeatHub Wallet.',
    },
    {
      'title': '5. Product Quality',
      'body':
          'We source all meat from quality-checked, halal-certified suppliers. If you receive a damaged, wrong, or poor-quality item, please report it within 12 hours of delivery for a replacement or refund.',
    },
    {
      'title': '6. Account Responsibility',
      'body':
          'You are responsible for maintaining the confidentiality of your account credentials and for all activities under your account.',
    },
    {
      'title': '7. Changes to Terms',
      'body':
          'MeatHub may update these Terms & Conditions from time to time. Continued use of the app after changes constitutes acceptance of the updated terms.',
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
            AppStrings.termsConditions,
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
