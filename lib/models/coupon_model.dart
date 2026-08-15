import 'package:flutter/material.dart';

enum CouponType { percentage, flat, freeDelivery }

enum CouponStatus { available, used, expired }

class CouponModel {
  final String code;
  final String title;
  final String subtitle;
  final String? categoryLine;
  final String amountLabel;
  final String amountSuffix;
  final String tagLabel;
  final Color themeColor;
  final Color lightBg;
  final Color chipBg;
  final CouponType type;
  final double value;
  final double minOrderAmount;
  final DateTime validUntil;
  final String? category;
  final CouponStatus status;
  final bool isFeatured;
  final String? image;

  const CouponModel({
    required this.code,
    required this.title,
    required this.subtitle,
    this.categoryLine,
    required this.amountLabel,
    required this.amountSuffix,
    required this.tagLabel,
    required this.themeColor,
    required this.lightBg,
    required this.chipBg,
    required this.type,
    required this.value,
    required this.minOrderAmount,
    required this.validUntil,
    this.category,
    this.status = CouponStatus.available,
    this.isFeatured = false,
    this.image,
  });
}