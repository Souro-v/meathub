import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_assets.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../core/services/auth_service.dart';
import '../../core/utils/connectivity_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final isConnected = await ConnectivityUtils.isConnected();
    if (!isConnected) {
      Navigator.of(
        context,
      ).pushReplacement(AppRoutes.noInternetRoute(AppRoutes.onboarding));
      return;
    }

    if (AuthService.currentUser != null) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.main);
      return;
    }

    Navigator.of(context).pushReplacementNamed(AppRoutes.onboarding);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(AppAssets.splashBg, fit: BoxFit.cover),
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 4),

                Image.asset(AppAssets.appLogo, width: 150, height: 150),
                const SizedBox(height: 16),

                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: AppStrings.appNamePart1,
                        style: const TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                        ),
                      ),
                      TextSpan(
                        text: AppStrings.appNamePart2,
                        style: const TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(width: 24, height: 1.2, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      AppStrings.splashTagline,
                      style: const TextStyle(
                        fontSize: 12,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(width: 24, height: 1.2, color: AppColors.primary),
                  ],
                ),

                const Spacer(flex: 3),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _FeatureItem(
                      image: AppAssets.premiumQualityIcon,
                      label: AppStrings.featurePremiumQuality,
                    ),
                    const _Divider(),
                    _FeatureItem(
                      image: AppAssets.fastDeliveryIcon,
                      label: AppStrings.featureFastDelivery,
                    ),
                    const _Divider(),
                    _FeatureItem(
                      image: AppAssets.trustedIcon,
                      label: AppStrings.featureTrusted,
                    ),
                  ],
                ),

                const Spacer(flex: 4),

                const SizedBox(
                  width: 26,
                  height: 26,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppStrings.loading,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final String image;
  final String label;

  const _FeatureItem({required this.image, required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      child: Column(
        children: [
          Image.asset(image, width: 44, height: 44),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 40, color: AppColors.divider);
  }
}
