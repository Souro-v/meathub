import 'package:flutter/material.dart';

enum HelpItemAction { trackOrder, manageOrder, reportIssue, info, chat, refund }

class HelpCategoryItemModel {
  final IconData icon;
  final String title;
  final String subtitle;
  final HelpItemAction action;
  final String? presetIssueType;
  final String? infoAnswer;

  const HelpCategoryItemModel({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.action,
    this.presetIssueType,
    this.infoAnswer,
  });
}

class HelpCategoryData {
  final String title;
  final String subtitle;
  final List<HelpCategoryItemModel> items;

  const HelpCategoryData({required this.title, required this.subtitle, required this.items});
}