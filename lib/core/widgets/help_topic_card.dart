import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/models/help_topic_model.dart';

class HelpTopicCard extends StatelessWidget {
  final HelpTopicModel topic;
  final VoidCallback onTap;

  const HelpTopicCard({super.key, required this.topic, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.divider)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: const BoxDecoration(color: AppColors.primarySoft, shape: BoxShape.circle),
              child: Icon(topic.icon, size: 21, color: AppColors.primary),
            ),
            const SizedBox(height: 10),
            Text(
              topic.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textDark, height: 1.25),
            ),
          ],
        ),
      ),
    );
  }
}