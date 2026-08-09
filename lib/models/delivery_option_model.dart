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
}