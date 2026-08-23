import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';

class ChecklistRow extends StatelessWidget {
  final String text;
  const ChecklistRow({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 18,
            height: 18,
            margin: const EdgeInsets.only(top: 1),
            decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.success),
            child: const Icon(Icons.check, size: 12, color: AppColors.white),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13, color: AppColors.textDark, height: 1.4))),
        ],
      ),
    );
  }
}