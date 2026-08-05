import 'package:flutter/material.dart';
import 'package:meathub/models/notification_model.dart';

class DummyNotifications {
  DummyNotifications._();

  static const List<NotificationModel> today = [
    NotificationModel(
      icon: Icons.inventory_2_outlined,
      iconColor: Color(0xFFD32F2F),
      iconBg: Color(0xFFFCE4E4),
      title: 'Your order is confirmed!',
      description:
          "We've received your order #MH1256. We'll notify you when it's on the way.",
      time: '10:30 AM',
      isUnread: true,
    ),
    NotificationModel(
      icon: Icons.local_shipping_outlined,
      iconColor: Color(0xFF2E7D32),
      iconBg: Color(0xFFE1F5E4),
      title: 'Order is on the way',
      description:
          'Rider is on the way to deliver your order #MH1256. Get ready!',
      time: '09:15 AM',
      isUnread: true,
    ),
  ];
}
