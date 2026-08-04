import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_assets.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';

import '../main/main_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> _pages = [
    AppAssets.onboarding1,
    AppAssets.onboarding2,
    AppAssets.onboarding3,
  ];

  // Fallback color behind each image — screen choto/boro hoile
  // kono blank gap dekha dile eta background hishebe blend kore jabe.
  final List<Color> _pageBgColors = [
    AppColors.primary,
    AppColors.background,
    AppColors.background,
  ];

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _finishOnboarding() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainScreen()),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Responsive full-screen images — cover fit + matching bg color
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              return Container(
                color: _pageBgColors[index],
                child: SizedBox.expand(
                  child: Image.asset(
                    _pages[index],
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),

          // Page 1 → Skip button (top-right)
          if (_currentPage == 0)
            Positioned(
              top: 8,
              right: 16,
              child: SafeArea(
                child: TextButton(
                  onPressed: _finishOnboarding,
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black.withValues(alpha:0.15),
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(AppStrings.skip),
                ),
              ),
            ),

          // Page 2 → Next button (bottom)
          if (_currentPage == 1)
            Positioned(
              left: 24,
              right: 24,
              bottom: 32,
              child: SafeArea(
                top: false,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 130,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.white,
                        foregroundColor: AppColors.primary,
                        minimumSize: const Size(0, 52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                      ),
                      child: Text(AppStrings.next),
                    ),
                  ),
                ),
              ),
            ),

          // Page 3 → Get Started button (bottom, full width)
          if (_currentPage == 2)
            Positioned(
              left: 24,
              right: 24,
              bottom: 32,
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _finishOnboarding,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.white,
                      foregroundColor: AppColors.primary,
                      minimumSize: const Size(0, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                    ),
                    icon: const Icon(Icons.arrow_forward),
                    label: Text(AppStrings.getStarted),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}