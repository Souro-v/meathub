import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String _name = 'Sourov Ahmed';
  String _phone = '+880 1712 345678';
  String _email = 'sourovahmed@gmail.com';

  String get name => _name;
  String get phone => _phone;
  String get email => _email;

  String get initials {
    final parts = _name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1)).toUpperCase();
  }

  void updateProfile({String? name, String? phone, String? email}) {
    if (name != null) _name = name;
    if (phone != null) _phone = phone;
    if (email != null) _email = email;
    notifyListeners();
  }
}