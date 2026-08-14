import 'package:flutter/material.dart';

class EarnPointsRuleModel {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String pointsLabel;

  const EarnPointsRuleModel({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.pointsLabel,
  });
}