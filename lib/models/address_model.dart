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
  final AddressIconType iconType;
  final String name;
  final String phone;
  final String address;
  final bool isDefault;

  const ManagedAddressModel({
    required this.id,
    required this.label,
    required this.iconType,
    required this.name,
    required this.phone,
    required this.address,
    this.isDefault = false,
  });

  IconData get labelIcon {
    switch (iconType) {
      case AddressIconType.home:
        return Icons.home;
      case AddressIconType.office:
        return Icons.apartment;
      case AddressIconType.family:
        return Icons.people;
      case AddressIconType.village:
        return Icons.cottage;
      case AddressIconType.currentLocation:
        return Icons.my_location;
      case AddressIconType.other:
        return Icons.more_horiz;
    }
  }

  Color get labelColor {
    switch (iconType) {
      case AddressIconType.home:
      case AddressIconType.currentLocation:
        return AppColors.primary;
      case AddressIconType.family:
        return const Color(0xFF7B4FC9);
      case AddressIconType.village:
        return const Color(0xFF2E7D32);
      case AddressIconType.office:
      case AddressIconType.other:
        return AppColors.textDark;
    }
  }

  Color get labelBg {
    switch (iconType) {
      case AddressIconType.home:
      case AddressIconType.currentLocation:
        return AppColors.primarySoft;
      case AddressIconType.family:
        return const Color(0xFFF1E9FB);
      case AddressIconType.village:
        return const Color(0xFFE3F5E6);
      case AddressIconType.office:
      case AddressIconType.other:
        return AppColors.surface;
    }
  }

  ManagedAddressModel copyWith({bool? isDefault}) {
    return ManagedAddressModel(
      id: id,
      label: label,
      iconType: iconType,
      name: name,
      phone: phone,
      address: address,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label,
    'iconType': iconType.name,
    'name': name,
    'phone': phone,
    'address': address,
    'isDefault': isDefault,
  };

  factory ManagedAddressModel.fromJson(Map<String, dynamic> json) =>
      ManagedAddressModel(
        id: json['id'] as String,
        label: json['label'] as String,
        iconType: AddressIconType.values.firstWhere(
          (t) => t.name == json['iconType'],
          orElse: () => AddressIconType.other,
        ),
        name: json['name'] as String,
        phone: json['phone'] as String,
        address: json['address'] as String,
        isDefault: json['isDefault'] as bool? ?? false,
      );
}
