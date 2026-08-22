import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/models/benefit_model.dart';
import 'package:meathub/models/commitment_item_model.dart';

class DummyAbout {
  DummyAbout._();

  static const List<CommitmentItemModel> differentiators = [
    CommitmentItemModel(icon: Icons.verified_user_outlined, label: AppStrings.diff100FreshHalal),
    CommitmentItemModel(icon: Icons.local_shipping_outlined, label: AppStrings.diffFastSafeDelivery),
    CommitmentItemModel(icon: Icons.inventory_2_outlined, label: AppStrings.diffHygienicPackaging),
    CommitmentItemModel(icon: Icons.groups_outlined, label: AppStrings.diffTrustedByFamilies),
    CommitmentItemModel(icon: Icons.attach_money, label: AppStrings.diffAffordablePrices),
    CommitmentItemModel(icon: Icons.favorite_border, label: AppStrings.diffCustomerFirst),
  ];

  static const List<BenefitModel> values = [
    BenefitModel(
      icon: Icons.shield_outlined,
      iconColor: AppColors.primary,
      iconBg: AppColors.primarySoft,
      title: AppStrings.valueQualityTitle,
      description: AppStrings.valueQualityDesc,
    ),
    BenefitModel(
      icon: Icons.eco_outlined,
      iconColor: Color(0xFF2E7D32),
      iconBg: Color(0xFFE1F5E4),
      title: AppStrings.valueTrustTitle,
      description: AppStrings.valueTrustDesc,
    ),
    BenefitModel(
      icon: Icons.people_outline,
      iconColor: Color(0xFFB2560A),
      iconBg: Color(0xFFFFEFDD),
      title: AppStrings.valueConvenienceTitle,
      description: AppStrings.valueConvenienceDesc,
    ),
    BenefitModel(
      icon: Icons.favorite_border,
      iconColor: Color(0xFF6A4FBF),
      iconBg: Color(0xFFEEE9FB),
      title: AppStrings.valueCareTitle,
      description: AppStrings.valueCareDesc,
    ),
  ];
}