import 'package:flutter/material.dart';

class BenefitModel {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String description;

  const BenefitModel({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.description,
  });
}