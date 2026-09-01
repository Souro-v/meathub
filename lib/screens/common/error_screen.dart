import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/core/widgets/error_state_view.dart';

class ErrorScreen extends StatelessWidget {
  final String? title;
  final String? description;
  final VoidCallback? onRetry;

  const ErrorScreen({super.key, this.title, this.description, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ErrorStateView(
          icon: Icons.cloud_off_outlined,
          title: title ?? AppStrings.somethingWentWrongTitle,
          description: description ?? AppStrings.somethingWentWrongDesc,
          onRetry: onRetry ?? () => Navigator.of(context).maybePop(),
        ),
      ),
    );
  }
}
