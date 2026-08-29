import 'package:flutter/material.dart';

class FaqCategoryConfigModel {
  final String key;
  final String title;
  final IconData icon;
  final Color color;
  final Color bg;

  const FaqCategoryConfigModel({
    required this.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.bg,
  });
}