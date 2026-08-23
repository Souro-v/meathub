import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_assets.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';

class ThankYouDetailScreen extends StatelessWidget {
  const ThankYouDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context, AppStrings.thankYouTitle),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                child: Column(
                  children: [
                    SizedBox(
                      height: 220,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            top: 10,
                            left: 30,
                            child: Icon(
                              Icons.favorite,
                              size: 20,
                              color: AppColors.primary.withValues(alpha: 0.25),
                            ),
                          ),
                          Positioned(
                            top: 24,
                            right: 24,
                            child: Icon(
                              Icons.favorite,
                              size: 16,
                              color: AppColors.primary.withValues(alpha: 0.2),
                            ),
                          ),
                          Positioned(
                            bottom: 26,
                            left: 16,
                            child: Icon(
                              Icons.favorite,
                              size: 14,
                              color: AppColors.primary.withValues(alpha: 0.18),
                            ),
                          ),
                          Container(
                            width: 160,
                            height: 160,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primarySoft,
                            ),
                          ),
                          const Icon(
                            Icons.favorite,
                            size: 130,
                            color: AppColors.primary,
                          ),
                          const Text(
                            AppStrings.thankYouHeartText,
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      AppStrings.thankYouDetailDesc,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 22),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.asset(
                        AppAssets.premiumBeef,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
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
