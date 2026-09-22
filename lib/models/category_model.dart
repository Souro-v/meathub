import 'package:flutter/material.dart';

/// Unified model — replaces the old split CategoryModel (name+icon, used
/// for the Home row) and CategoryConfigModel (theme+tagline+chips, used
/// for the category listing page). One document per category now covers
/// both, so there's no more risk of the two going out of sync.
class CategoryModel {
  final String name;
  final String icon; // asset path OR Cloudinary URL
  final int themeColorValue;
  final int themeBgValue;
  final String tagline;
  final List<String> chips;

  const CategoryModel({
    required this.name,
    required this.icon,
    required this.themeColorValue,
    required this.themeBgValue,
    required this.tagline,
    required this.chips,
  });

  Color get themeColor => Color(themeColorValue);

  Color get themeBg => Color(themeBgValue);

  Map<String, dynamic> toJson() => {
    'name': name,
    'icon': icon,
    'themeColorValue': themeColorValue,
    'themeBgValue': themeBgValue,
    'tagline': tagline,
    'chips': chips,
  };

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    name: json['name'] as String,
    icon: json['icon'] as String,
    themeColorValue: json['themeColorValue'] as int,
    themeBgValue: json['themeBgValue'] as int,
    tagline: json['tagline'] as String,
    chips: List<String>.from(json['chips'] as List),
  );
}
