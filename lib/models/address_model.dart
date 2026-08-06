import 'package:flutter/material.dart';

class RecentAddressModel {
  final IconData icon;
  final String title;
  final String area;
  final String note;

  const RecentAddressModel({
    required this.icon,
    required this.title,
    required this.area,
    required this.note,
  });
}
class RecentAddressFullModel {
  final String title;
  final String address;
  final String timeLabel;

  const RecentAddressFullModel({
    required this.title,
    required this.address,
    required this.timeLabel,
  });
}

class SavedAddressModel {
  final String title;
  final bool isDefault;
  final String address;
  final String phone;

  const SavedAddressModel({
    required this.title,
    required this.address,
    required this.phone,
    this.isDefault = false,
  });
}