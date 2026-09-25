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
  final List<String> offerTags;

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
    this.offerTags = const [],
  });

  Map<String, dynamic> toJson() => {
    'code': code,
    'title': title,
    'subtitle': subtitle,
    'categoryLine': categoryLine,
    'amountLabel': amountLabel,
    'amountSuffix': amountSuffix,
    'tagLabel': tagLabel,
    'themeColorValue': themeColor.toARGB32(),
    'lightBgValue': lightBg.toARGB32(),
    'chipBgValue': chipBg.toARGB32(),
    'type': type.name,
    'value': value,
    'minOrderAmount': minOrderAmount,
    'validUntil': validUntil.toIso8601String(),
    'category': category,
    'status': status.name,
    'isFeatured': isFeatured,
    'image': image,
    'offerTags': offerTags,
  };

  factory CouponModel.fromJson(Map<String, dynamic> json) => CouponModel(
    code: json['code'] as String,
    title: json['title'] as String,
    subtitle: json['subtitle'] as String,
    categoryLine: json['categoryLine'] as String?,
    amountLabel: json['amountLabel'] as String,
    amountSuffix: json['amountSuffix'] as String,
    tagLabel: json['tagLabel'] as String,
    themeColor: Color(json['themeColorValue'] as int),
    lightBg: Color(json['lightBgValue'] as int),
    chipBg: Color(json['chipBgValue'] as int),
    type: CouponType.values.firstWhere(
      (t) => t.name == json['type'],
      orElse: () => CouponType.flat,
    ),
    value: (json['value'] as num).toDouble(),
    minOrderAmount: (json['minOrderAmount'] as num).toDouble(),
    validUntil: DateTime.parse(json['validUntil'] as String),
    category: json['category'] as String?,
    status: CouponStatus.values.firstWhere(
      (s) => s.name == json['status'],
      orElse: () => CouponStatus.available,
    ),
    isFeatured: json['isFeatured'] as bool? ?? false,
    image: json['image'] as String?,
    offerTags: List<String>.from(json['offerTags'] as List? ?? []),
  );
}
