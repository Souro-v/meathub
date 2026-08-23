import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/models/benefit_model.dart';
import 'package:meathub/models/commitment_item_model.dart';

class DummyAbout {
  DummyAbout._();

  static const List<CommitmentItemModel> differentiators = [
    CommitmentItemModel(
      icon: Icons.verified_user_outlined,
      label: AppStrings.diff100FreshHalal,
    ),
    CommitmentItemModel(
      icon: Icons.local_shipping_outlined,
      label: AppStrings.diffFastSafeDelivery,
    ),
    CommitmentItemModel(
      icon: Icons.inventory_2_outlined,
      label: AppStrings.diffHygienicPackaging,
    ),
    CommitmentItemModel(
      icon: Icons.groups_outlined,
      label: AppStrings.diffTrustedByFamilies,
    ),
    CommitmentItemModel(
      icon: Icons.attach_money,
      label: AppStrings.diffAffordablePrices,
    ),
    CommitmentItemModel(
      icon: Icons.favorite_border,
      label: AppStrings.diffCustomerFirst,
    ),
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

  static const List<BenefitModel> differentiatorsDetailed = [
    BenefitModel(
      icon: Icons.verified_user_outlined,
      iconColor: AppColors.primary,
      iconBg: AppColors.primarySoft,
      title: '100% Fresh & Halal',
      description: 'We guarantee fresh, halal and hygienic meat.',
    ),
    BenefitModel(
      icon: Icons.local_shipping_outlined,
      iconColor: Color(0xFF2E7D32),
      iconBg: Color(0xFFE1F5E4),
      title: 'Fast & Safe Delivery',
      description: 'Quick delivery with proper cold-chain.',
    ),
    BenefitModel(
      icon: Icons.inventory_2_outlined,
      iconColor: Color(0xFF6A4FBF),
      iconBg: Color(0xFFEEE9FB),
      title: 'Hygienic Packaging',
      description: 'Vacuum-sealed and safe packaging.',
    ),
    BenefitModel(
      icon: Icons.groups_outlined,
      iconColor: Color(0xFFB2560A),
      iconBg: Color(0xFFFFEFDD),
      title: 'Trusted by Families',
      description: 'Thousands of happy families trust us.',
    ),
    BenefitModel(
      icon: Icons.attach_money,
      iconColor: Color(0xFFEF6C00),
      iconBg: Color(0xFFFFF3D6),
      title: 'Affordable Prices',
      description: 'Best quality meat at fair and honest prices.',
    ),
    BenefitModel(
      icon: Icons.favorite_border,
      iconColor: AppColors.primary,
      iconBg: AppColors.primarySoft,
      title: 'Customer First',
      description: 'Your satisfaction is our top priority.',
    ),
  ];

  static const List<BenefitModel> missionPoints = [
    BenefitModel(
      icon: Icons.verified_outlined,
      iconColor: AppColors.primary,
      iconBg: AppColors.primarySoft,
      title: 'Fresh & Always Halal',
      description: 'We ensure 100% halal and hygienic meat.',
    ),
    BenefitModel(
      icon: Icons.eco_outlined,
      iconColor: Color(0xFF2E7D32),
      iconBg: Color(0xFFE1F5E4),
      title: 'Healthy & Nutritious',
      description: "We care about your family's health.",
    ),
    BenefitModel(
      icon: Icons.people_outline,
      iconColor: Color(0xFFB2560A),
      iconBg: Color(0xFFFFEFDD),
      title: 'Convenient & Reliable',
      description: 'Order easily, get it fast and worry-free.',
    ),
  ];

  static const List<String> visionPoints = [
    'Everyone has access to clean & fresh meat',
    'Families eat healthy, worry-free',
    'Meat delivery is simple, fast & reliable',
    'Trust is the core of every order',
  ];

  static const List<CommitmentItemModel> healthierFutureItems = [
    CommitmentItemModel(icon: Icons.eco_outlined, label: 'Fresh Food'),
    CommitmentItemModel(icon: Icons.groups_outlined, label: 'Happy Families'),
    CommitmentItemModel(icon: Icons.favorite_border, label: 'Better Life'),
  ];
}
