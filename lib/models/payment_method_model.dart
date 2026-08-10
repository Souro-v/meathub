import 'package:flutter/material.dart';

class PaymentMethodModel {
  final String id;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final bool isRecommended;
  final bool showCardBrands;

  const PaymentMethodModel({
    required this.id,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    this.isRecommended = false,
    this.showCardBrands = false,
  });
}