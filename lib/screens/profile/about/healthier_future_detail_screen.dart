import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/core/widgets/commitment_stat_item.dart';
import 'package:meathub/data/dummy_about.dart';

class HealthierFutureDetailScreen extends StatelessWidget {
  const HealthierFutureDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context, AppStrings.togetherHealthierFutureTitle),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                child: Column(
                  children: [
                    SizedBox(
                      height: 150,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            top: 4,
                            right: 40,
                            child: Icon(
                              Icons.favorite,
                              size: 16,
                              color: AppColors.success.withValues(alpha: 0.3),
                            ),
                          ),
                          Positioned(
                            bottom: 6,
                            left: 30,
                            child: Icon(
                              Icons.favorite,
                              size: 14,
                              color: AppColors.success.withValues(alpha: 0.25),
                            ),
                          ),
                          Container(
                            width: 130,
                            height: 130,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.successSoft,
                            ),
                          ),
                          const Icon(
                            Icons.public,
                            size: 58,
                            color: AppColors.success,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      AppStrings.togetherHealthierFutureTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        color: AppColors.success,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      AppStrings.healthierFutureDetailDesc,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.5,
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 26),
                    Row(
                      children: DummyAbout.healthierFutureItems
                          .map(
                            (i) => Expanded(child: CommitmentStatItem(item: i)),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 26),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Flexible(
                          child: Text(
                            'Thank you for being a part of the MeatHub family! ❤️',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                      ],
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
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
