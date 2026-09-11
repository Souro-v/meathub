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

  Map<String, dynamic> toJson() => {
    'id': id,
    'iconCodePoint': icon.codePoint,
    'iconColorValue': iconColor.toARGB32(),
    'iconBgValue': iconBg.toARGB32(),
    'title': title,
    'subtitle': subtitle,
    'isRecommended': isRecommended,
    'showCardBrands': showCardBrands,
  };

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) =>
      PaymentMethodModel(
        id: json['id'] as String,
        icon: IconData(
          json['iconCodePoint'] as int,
          fontFamily: 'MaterialIcons',
        ),
        iconColor: Color(json['iconColorValue'] as int),
        iconBg: Color(json['iconBgValue'] as int),
        title: json['title'] as String,
        subtitle: json['subtitle'] as String,
        isRecommended: json['isRecommended'] as bool? ?? false,
        showCardBrands: json['showCardBrands'] as bool? ?? false,
      );
}
