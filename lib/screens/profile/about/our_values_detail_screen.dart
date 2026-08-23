import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/core/widgets/feature_row_tile.dart';
import 'package:meathub/data/dummy_about.dart';

class OurValuesDetailScreen extends StatelessWidget {
  const OurValuesDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context, AppStrings.ourValuesTitle),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.divider)),
                  child: Column(
                    children: List.generate(DummyAbout.values.length, (index) {
                      final isLast = index == DummyAbout.values.length - 1;
                      return Column(
                        children: [
                          FeatureRowTile(feature: DummyAbout.values[index], filled: false),
                          if (!isLast) const Divider(color: AppColors.divider, height: 1),
                        ],
                      );
                    }),
                  ),
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
            child: const Padding(padding: EdgeInsets.all(8), child: Icon(Icons.arrow_back, size: 22, color: AppColors.textDark)),
          ),
          const SizedBox(width: 2),
          Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: AppColors.textDark)),
        ],
      ),
    );
  }
}