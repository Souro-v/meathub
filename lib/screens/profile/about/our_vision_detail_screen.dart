import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/core/widgets/checklist_row.dart';
import 'package:meathub/core/widgets/icon_graphic_header.dart';
import 'package:meathub/data/dummy_about.dart';

class OurVisionDetailScreen extends StatelessWidget {
  const OurVisionDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context, AppStrings.ourVisionTitle),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                child: Column(
                  children: [
                    const IconGraphicHeader(icon: Icons.visibility_outlined, color: Color(0xFF2E7D32), bg: AppColors.successSoft, title: AppStrings.ourVisionTitle),
                    const SizedBox(height: 14),
                    const Text(AppStrings.ourVisionDesc, textAlign: TextAlign.center, style: TextStyle(fontSize: 13.5, color: AppColors.textSecondary, height: 1.6)),
                    const SizedBox(height: 22),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: AppColors.successSoft, borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(AppStrings.weEnvisionFutureTitle, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF2E7D32))),
                          const SizedBox(height: 12),
                          ...DummyAbout.visionPoints.map((p) => ChecklistRow(text: p)),
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