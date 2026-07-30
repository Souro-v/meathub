import 'package:flutter/material.dart';
import 'package:meathub/app.dart';
import 'package:meathub/core/constants/app_assets.dart';

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
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomePlaceholder()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            AppAssets.splashBg,
            fit: BoxFit.cover,
          ),

          // Foreground content
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 4),

                // Logo
                Image.asset(
                  AppAssets.appLogo,
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 16),

                // App name
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Meat',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFB71C1C),
                        ),
                      ),
                      TextSpan(
                        text: 'Hub',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF2B2B2B),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),

                // Tagline
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(width: 24, height: 1.2, color: const Color(0xFFB71C1C)),
                    const SizedBox(width: 8),
                    const Text(
                      'FRESH MEAT, TRUSTED TO YOU',
                      style: TextStyle(
                        fontSize: 12,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4A4A4A),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(width: 24, height: 1.2, color: const Color(0xFFB71C1C)),
                  ],
                ),

                const Spacer(flex: 3),

                // Feature row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _FeatureItem(
                      image: AppAssets.premiumQualityIcon,
                      label: 'Premium\nQuality Meat',
                    ),
                    _Divider(),
                    _FeatureItem(
                      image: AppAssets.fastDeliveryIcon,
                      label: 'Fast\nDelivery',
                    ),
                    _Divider(),
                    _FeatureItem(
                      image: AppAssets.trustedIcon,
                      label: '100%\nTrusted',
                    ),
                  ],
                ),

                const Spacer(flex: 4),

                // Loading indicator
                const SizedBox(
                  width: 26,
                  height: 26,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB71C1C)),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Loading...',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF4A4A4A),
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
              color: Color(0xFF2B2B2B),
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      color: Colors.grey.shade400,
    );
  }
}