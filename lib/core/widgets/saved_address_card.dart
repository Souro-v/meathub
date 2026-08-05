import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/models/address_model.dart';

class SavedAddressCard extends StatelessWidget {
  final SavedAddressModel data;
  final VoidCallback onEdit;

  const SavedAddressCard({super.key, required this.data, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(color: AppColors.primarySoft, shape: BoxShape.circle),
            child: const Icon(Icons.location_on_outlined, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(data.title, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                    if (data.isDefault) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(10)),
                        child: const Text(
                          AppStrings.defaultLabel,
                          style: TextStyle(fontSize: 10.5, color: AppColors.primary, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 6),
                Text(data.address, style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.5)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.call_outlined, size: 13, color: AppColors.textHint),
                    const SizedBox(width: 4),
                    Text(data.phone, style: const TextStyle(fontSize: 12.5, color: AppColors.textDark)),
                  ],
                ),
              ],
            ),
          ),
          InkWell(
            onTap: onEdit,
            borderRadius: BorderRadius.circular(16),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(Icons.edit_outlined, size: 18, color: AppColors.textHint),
            ),
          ),
        ],
      ),
    );
  }
}