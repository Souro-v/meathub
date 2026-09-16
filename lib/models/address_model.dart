import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';

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

/// A small, fixed set of address "kinds" — stored as a stable string key
/// instead of a raw IconData codePoint, so it survives JSON/Firestore
/// round-trips and stays compatible with Flutter's icon tree-shaking.
enum AddressIconType { home, office, family, village, currentLocation, other }

class ManagedAddressModel {
  final String id;
  final String label;
  final IconData labelIcon;
  final Color labelColor;
  final Color labelBg;
  final String name;
  final String phone;
  final String address;
  final bool isDefault;

  const ManagedAddressModel({
    required this.id,
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
      id: id,
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

  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label,
    'labelIconCodePoint': labelIcon.codePoint,
    'labelColorValue': labelColor.toARGB32(),
    'labelBgValue': labelBg.toARGB32(),
    'name': name,
    'phone': phone,
    'address': address,
    'isDefault': isDefault,
  };

  factory ManagedAddressModel.fromJson(Map<String, dynamic> json) =>
      ManagedAddressModel(
        id: json['id'] as String,
        label: json['label'] as String,
        labelIcon: IconData(
          json['labelIconCodePoint'] as int,
          fontFamily: 'MaterialIcons',
        ),
        labelColor: Color(json['labelColorValue'] as int),
        labelBg: Color(json['labelBgValue'] as int),
        name: json['name'] as String,
        phone: json['phone'] as String,
        address: json['address'] as String,
        isDefault: json['isDefault'] as bool? ?? false,
      );
}
