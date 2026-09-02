import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/core/utils/connectivity_utils.dart';
import 'package:meathub/core/widgets/error_state_view.dart';

class NoInternetScreen extends StatefulWidget {
  final String nextRoute;

  const NoInternetScreen({super.key, required this.nextRoute});

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  Future<void> _retry() async {
    final isConnected = await ConnectivityUtils.isConnected();
    if (!mounted) return;
    if (isConnected) {
      Navigator.of(context).pushReplacementNamed(widget.nextRoute);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.stillNoConnectionMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ErrorStateView(
          icon: Icons.wifi_off,
          title: AppStrings.noInternetTitle,
          description: AppStrings.noInternetDesc,
          onRetry: _retry,
        ),
      ),
    );
  }
}
