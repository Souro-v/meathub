import 'package:flutter/material.dart';

class DeliveryOptionModel {
  final String id;
  final IconData icon;
  final String title;
  final String subtitle;
  final double fee;

  const DeliveryOptionModel({
    required this.id,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.fee,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'iconCodePoint': icon.codePoint,
    'title': title,
    'subtitle': subtitle,
    'fee': fee,
  };

  factory DeliveryOptionModel.fromJson(Map<String, dynamic> json) =>
      DeliveryOptionModel(
        id: json['id'] as String,
        icon: IconData(
          json['iconCodePoint'] as int,
          fontFamily: 'MaterialIcons',
        ),
        title: json['title'] as String,
        subtitle: json['subtitle'] as String,
        fee: (json['fee'] as num).toDouble(),
      );
}
