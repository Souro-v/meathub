import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/models/commitment_item_model.dart';
import 'package:meathub/models/guarantee_item_model.dart';

class DummyGuarantees {
  DummyGuarantees._();

  static const List<GuaranteeItemModel> guarantees = [
    GuaranteeItemModel(
      icon: Icons.military_tech_outlined,
      title: AppStrings.guaranteeFreshTitle,
      description: AppStrings.guaranteeFreshDesc,
    ),
    GuaranteeItemModel(
      icon: Icons.verified_user_outlined,
      title: AppStrings.guaranteeHalalTitle,
      description: AppStrings.guaranteeHalalDesc,
    ),
    GuaranteeItemModel(
      icon: Icons.two_wheeler,
      title: AppStrings.guaranteeDeliveryTitle,
      description: AppStrings.guaranteeDeliveryDesc,
    ),
    GuaranteeItemModel(
      icon: Icons.thermostat_outlined,
      title: AppStrings.guaranteeChilledTitle,
      description: AppStrings.guaranteeChilledDesc,
    ),
    GuaranteeItemModel(
      icon: Icons.inventory_2_outlined,
      title: AppStrings.guaranteePackagingTitle,
      description: AppStrings.guaranteePackagingDesc,
    ),
    GuaranteeItemModel(
      icon: Icons.headset_mic_outlined,
      title: AppStrings.guaranteeSupportTitle,
      description: AppStrings.guaranteeSupportDesc,
    ),
  ];

  static const List<CommitmentItemModel> commitments = [
    CommitmentItemModel(
      icon: Icons.groups_outlined,
      label: AppStrings.commitmentTrustedFamilies,
    ),
    CommitmentItemModel(
      icon: Icons.eco_outlined,
      label: AppStrings.commitmentSourced,
    ),
    CommitmentItemModel(
      icon: Icons.verified_outlined,
      label: AppStrings.commitmentQualityChecked,
    ),
    CommitmentItemModel(
      icon: Icons.favorite_border,
      label: AppStrings.commitmentCareFamily,
    ),
  ];
}
