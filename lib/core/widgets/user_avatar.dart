import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/providers/user_provider.dart';

class UserAvatar extends StatelessWidget {
  final double radius;

  const UserAvatar({super.key, this.radius = 34});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>();

    if (user.hasPhoto) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: FileImage(user.photo!),
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primary,
      child: Text(
        user.initials,
        style: TextStyle(
          fontSize: radius * 0.62,
          fontWeight: FontWeight.w800,
          color: AppColors.white,
        ),
      ),
    );
  }
}
