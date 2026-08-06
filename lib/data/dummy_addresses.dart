import 'package:flutter/material.dart';
import 'package:meathub/models/address_model.dart';

import '../core/constants/app_colors.dart';

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
      address:
          'Vill: Polashbari, Post: Polashbari - 5700\nUpazila: Polashbari, District: Gaibandha',
      phone: '017XXXXXXXX',
    ),
    SavedAddressModel(
      title: "Parents' Home",
      address:
          'Vill: Saghata, Post: Saghata - 5720\nUpazila: Saghata, District: Gaibandha',
      phone: '016XXXXXXXX',
    ),
  ];
  static const List<RecentAddressFullModel> allRecent = [
    RecentAddressFullModel(
      title: 'Home',
      address: '123 Green Road, Dhanmondi, Dhaka 1205, Bangladesh',
      timeLabel: 'Today',
    ),
    RecentAddressFullModel(
      title: 'Office',
      address: '45 Gulshan Avenue, Gulshan 1, Dhaka 1212, Bangladesh',
      timeLabel: 'Today',
    ),
    RecentAddressFullModel(
      title: 'Parents Home',
      address: '32 Old Airport Road, Banani, Dhaka 1213, Bangladesh',
      timeLabel: 'Yesterday',
    ),
    RecentAddressFullModel(
      title: 'Village Home',
      address: 'Vill: Chandpur, P.O: Chandpur Bazar, P.S: Hajiganj, Chandpur',
      timeLabel: '2 days ago',
    ),
    RecentAddressFullModel(
      title: "Friend's House",
      address: 'House 7, Road 12, Block A, Mirpur 10, Dhaka 1216, Bangladesh',
      timeLabel: '2 days ago',
    ),
    RecentAddressFullModel(
      title: 'Shop',
      address:
          'Shop 15, New Market City Complex, New Market, Dhaka 1205, Bangladesh',
      timeLabel: 'Last week',
    ),
    RecentAddressFullModel(
      title: 'University',
      address:
          'North South University, Bashundhara R/A, Dhaka 1229, Bangladesh',
      timeLabel: 'Last week',
    ),
    RecentAddressFullModel(
      title: 'Apartment',
      address:
          'Apt 5B, House 27, Road 8, Dhanmondi R/A, Dhaka 1209, Bangladesh',
      timeLabel: 'Last week',
    ),
    RecentAddressFullModel(
      title: 'Relative',
      address: 'House 12, Road 3, Sector 6, Uttara, Dhaka 1230, Bangladesh',
      timeLabel: 'Last week',
    ),
    RecentAddressFullModel(
      title: 'Other',
      address: 'House 9, Road 18, Nikunja 2, Khilkhet, Dhaka 1229, Bangladesh',
      timeLabel: 'Last week',
    ),
  ];
  static const List<ManagedAddressModel> managed = [
    ManagedAddressModel(
      label: 'Home',
      labelIcon: Icons.home,
      labelColor: AppColors.primary,
      labelBg: AppColors.primarySoft,
      name: 'Rafiq Hasan',
      phone: '+880 1712 345 678',
      address: '123 Green Road, Dhanmondi, Dhaka 1205, Bangladesh',
      isDefault: true,
    ),
    ManagedAddressModel(
      label: 'Office',
      labelIcon: Icons.apartment,
      labelColor: AppColors.textDark,
      labelBg: AppColors.surface,
      name: 'Rafiq Hasan',
      phone: '+880 1712 345 678',
      address: '45 Gulshan Avenue, Gulshan 1, Dhaka 1212, Bangladesh',
    ),
    ManagedAddressModel(
      label: 'Parents',
      labelIcon: Icons.people,
      labelColor: Color(0xFF7B4FC9),
      labelBg: Color(0xFFF1E9FB),
      name: 'Rafiq Hasan',
      phone: '+880 1712 345 678',
      address: '32 Old Airport Road, Banani, Dhaka 1213, Bangladesh',
    ),
    ManagedAddressModel(
      label: 'Village',
      labelIcon: Icons.cottage,
      labelColor: Color(0xFF2E7D32),
      labelBg: Color(0xFFE3F5E6),
      name: 'Rafiq Hasan',
      phone: '+880 1712 345 678',
      address: 'Vill: Chandpur, P.O: Chandpur Bazar, P.S: Hajiganj, Chandpur',
    ),
    ManagedAddressModel(
      label: 'Other',
      labelIcon: Icons.more_horiz,
      labelColor: AppColors.textDark,
      labelBg: AppColors.surface,
      name: 'Rafiq Hasan',
      phone: '+880 1712 345 678',
      address: 'House 9, Road 18, Nikunja 2, Khilkhet, Dhaka 1229, Bangladesh',
    ),
  ];
}
