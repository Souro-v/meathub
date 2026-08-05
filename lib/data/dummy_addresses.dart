import 'package:flutter/material.dart';
import 'package:meathub/models/address_model.dart';

class DummyAddresses {
  DummyAddresses._();

  static const List<RecentAddressModel> recent = [
    RecentAddressModel(
      icon: Icons.home_outlined,
      title: 'Home',
      area: 'Polashbari, Gaibandha',
      note: 'Near Polashbari Bazar, Gaibandha',
    ),
    RecentAddressModel(
      icon: Icons.work_outline,
      title: 'Work',
      area: 'Rangpur City, Rangpur',
      note: 'Near Rangpur Medical College',
    ),
  ];

  static const List<SavedAddressModel> saved = [
    SavedAddressModel(
      title: 'Home',
      isDefault: true,
      address: 'Vill: Polashbari, Post: Polashbari - 5700\nUpazila: Polashbari, District: Gaibandha',
      phone: '017XXXXXXXX',
    ),
    SavedAddressModel(
      title: "Parents' Home",
      address: 'Vill: Saghata, Post: Saghata - 5720\nUpazila: Saghata, District: Gaibandha',
      phone: '016XXXXXXXX',
    ),
  ];
}