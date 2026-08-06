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
class ManagedAddressModel {
  final String label;
  final IconData labelIcon;
  final Color labelColor;
  final Color labelBg;
  final String name;
  final String phone;
  final String address;
  final bool isDefault;

  const ManagedAddressModel({
    required this.label,
    required this.labelIcon,
    required this.labelColor,
    required this.labelBg,
    required this.name,
    required this.phone,
    required this.address,
    this.isDefault = false,
  });

  ManagedAddressModel copyWith({bool? isDefault}) {
    return ManagedAddressModel(
      label: label,
      labelIcon: labelIcon,
      labelColor: labelColor,
      labelBg: labelBg,
      name: name,
      phone: phone,
      address: address,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}