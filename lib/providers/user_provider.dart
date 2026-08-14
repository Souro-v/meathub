import 'dart:io';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String _name = 'Sourov Ahmed';
  String _phone = '+880 1712 345678';
  String _email = 'sourovahmed@gmail.com';
  DateTime? _dateOfBirth = DateTime(2001, 5, 15);
  String? _gender = 'Male';
  File? _photo;

  String get name => _name;

  String get phone => _phone;

  String get email => _email;

  DateTime? get dateOfBirth => _dateOfBirth;

  String? get gender => _gender;

  File? get photo => _photo;

  bool get hasPhoto => _photo != null;

  String get initials {
    final parts = _name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  void updateProfile({
    String? name,
    String? phone,
    String? email,
    DateTime? dateOfBirth,
    String? gender,
  }) {
    if (name != null) _name = name;
    if (phone != null) _phone = phone;
    if (email != null) _email = email;
    if (dateOfBirth != null) _dateOfBirth = dateOfBirth;
    if (gender != null) _gender = gender;
    notifyListeners();
  }

  void updatePhoto(File photo) {
    _photo = photo;
    notifyListeners();
  }
}
