import 'package:flutter/material.dart';

class NotificationModel {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String description;
  final String time;
  final bool isUnread;

  const NotificationModel({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.description,
    required this.time,
    this.isUnread = false,
  });

  NotificationModel copyWith({bool? isUnread}) {
    return NotificationModel(
      icon: icon,
      iconColor: iconColor,
      iconBg: iconBg,
      title: title,
      description: description,
      time: time,
      isUnread: isUnread ?? this.isUnread,
    );
  }
}