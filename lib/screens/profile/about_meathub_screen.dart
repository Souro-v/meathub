import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_assets.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/core/routes/app_routes.dart';
import 'package:meathub/core/utils/contact_link_utils.dart';
import 'package:meathub/core/widgets/benefit_grid_item.dart';
import 'package:meathub/core/widgets/icon_label_grid_card.dart';
import 'package:meathub/data/dummy_about.dart';
import 'package:meathub/screens/profile/help_support_screen.dart';

class AboutMeatHubScreen extends StatelessWidget {
  const AboutMeatHubScreen({super.key});

  static const String _supportEmail = 'support@meathub.com';
  static const String _supportPhone = '+8801234567890';
  static const String _supportPhoneDisplay = '+880 1234-567890';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeroBanner(),
                    const SizedBox(height: 16),
                    _infoBanner(
                      icon: Icons.favorite_border,
                      iconColor: AppColors.primary,
                      bg: AppColors.primarySoft,
                      title: AppStrings.freshMeatDeliveredTitle,
                      desc: AppStrings.freshMeatDeliveredDesc,
                    ),
                    const SizedBox(height: 20),

                    // Our Mission
                    GestureDetector(
                      onTap: () => Navigator.of(
                        context,
                      ).pushNamed(AppRoutes.ourMissionDetail),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionHeader(AppStrings.ourMissionTitle),
                          const SizedBox(height: 10),
                          _infoBanner(
                            icon: Icons.track_changes,
                            iconColor: AppColors.primary,
                            bg: AppColors.primarySoft,
                            desc: AppStrings.ourMissionDesc,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Our Vision
                    GestureDetector(
                      onTap: () => Navigator.of(
                        context,
                      ).pushNamed(AppRoutes.ourVisionDetail),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionHeader(AppStrings.ourVisionTitle),
                          const SizedBox(height: 10),
                          _infoBanner(
                            icon: Icons.visibility_outlined,
                            iconColor: const Color(0xFF2E7D32),
                            bg: AppColors.successSoft,
                            desc: AppStrings.ourVisionDesc,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),

                    // What Makes Us Different
                    GestureDetector(
                      onTap: () => Navigator.of(
                        context,
                      ).pushNamed(AppRoutes.whatMakesUsDifferentDetail),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionHeader(AppStrings.whatMakesUsDifferentTitle),
                          const SizedBox(height: 12),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: DummyAbout.differentiators.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                  childAspectRatio: 0.95,
                                ),
                            itemBuilder: (context, index) => IconLabelGridCard(
                              item: DummyAbout.differentiators[index],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Thank You footer
                    GestureDetector(
                      onTap: () => Navigator.of(
                        context,
                      ).pushNamed(AppRoutes.thankYouDetail),
                      child: _buildThankYouFooter(),
                    ),
                    const SizedBox(height: 26),

                    // Our Story
                    GestureDetector(
                      onTap: () => Navigator.of(
                        context,
                      ).pushNamed(AppRoutes.ourStoryDetail),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionHeader(AppStrings.ourStoryTitle),
                          const SizedBox(height: 10),
                          const Text(
                            AppStrings.ourStoryDesc,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildStoryImageAndQuote(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 26),

                    // Our Values
                    GestureDetector(
                      onTap: () => Navigator.of(
                        context,
                      ).pushNamed(AppRoutes.ourValuesDetail),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionHeader(AppStrings.ourValuesTitle),
                          const SizedBox(height: 12),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: DummyAbout.values.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                  childAspectRatio: 0.98,
                                ),
                            itemBuilder: (context, index) => BenefitGridItem(
                              benefit: DummyAbout.values[index],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 26),

                    // Contact Us — shudhu header tap-able, card-er bhitorer row-gula age-moto-i direct kaj kore
                    GestureDetector(
                      onTap: () => Navigator.of(
                        context,
                      ).pushNamed(AppRoutes.contactUsDetail),
                      child: _sectionHeader(AppStrings.contactUsTitle),
                    ),
                    const SizedBox(height: 12),
                    _buildContactCard(context),
                    const SizedBox(height: 20),

                    // Together for a Healthier Future
                    GestureDetector(
                      onTap: () => Navigator.of(
                        context,
                      ).pushNamed(AppRoutes.healthierFutureDetail),
                      child: _buildHealthierFutureBanner(),
                    ),
                    const SizedBox(height: 20),

                    Center(
                      child: Text(
                        '© ${DateTime.now().year} MeatHub. ${AppStrings.allRightsReserved}',
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: AppColors.textHint,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
        const Icon(Icons.chevron_right, size: 20, color: AppColors.textHint),
      ],
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.of(context).maybePop(),
            borderRadius: BorderRadius.circular(20),
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(
                Icons.arrow_back,
                size: 22,
                color: AppColors.textDark,
              ),
            ),
          ),
          const SizedBox(width: 2),
          const Text(
            AppStrings.aboutMeatHubTitle,
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroBanner() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 220,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primaryDark, AppColors.primary],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: -18,
              bottom: -12,
              child: Opacity(
                opacity: 0.3,
                child: Image.asset(
                  AppAssets.beef,
                  width: 140,
                  height: 140,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              right: -18,
              top: -12,
              child: Opacity(
                opacity: 0.3,
                child: Image.asset(
                  AppAssets.beefBone,
                  width: 140,
                  height: 140,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(AppAssets.appLogo, width: 68, height: 68),
                ),
                const SizedBox(height: 12),
                const Text(
                  'MeatHub',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 22, height: 1, color: Colors.white70),
                    const SizedBox(width: 8),
                    const Text(
                      AppStrings.meatHubTagline,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Colors.white70,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(width: 22, height: 1, color: Colors.white70),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoBanner({
    required IconData icon,
    required Color iconColor,
    required Color bg,
    String? title,
    required String desc,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 19, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) ...[
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThankYouFooter() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.favorite, size: 15, color: AppColors.primary),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        AppStrings.thankYouAboutFooterTitle,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  AppStrings.thankYouAboutFooterDesc,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              AppAssets.premiumBeef,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryImageAndQuote() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(AppAssets.beef, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.format_quote, size: 22, color: AppColors.primary),
                  SizedBox(height: 8),
                  Text(
                    AppStrings.goodFoodQuote,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                      height: 1.35,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text('❤️', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            right: -10,
            bottom: -10,
            child: Icon(
              Icons.two_wheeler,
              size: 100,
              color: AppColors.primary.withValues(alpha: 0.07),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const HelpSupportScreen()),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: AppColors.primarySoft,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.headset_mic_outlined,
                          color: AppColors.primary,
                          size: 19,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.needHelpRowTitle,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              AppStrings.needHelpRowDesc,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        size: 20,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(color: AppColors.divider, height: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 4),
                child: InkWell(
                  onTap: () =>
                      ContactLinkUtils.sendEmail(context, _supportEmail),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.mail_outline,
                        size: 17,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 10),
                      Text(
                        _supportEmail,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
                child: InkWell(
                  onTap: () =>
                      ContactLinkUtils.callPhone(context, _supportPhone),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.call_outlined,
                        size: 17,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 10),
                      Text(
                        _supportPhoneDisplay,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(14, 10, 14, 16),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 17,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Dhaka, Bangladesh',
                      style: TextStyle(fontSize: 13, color: AppColors.textDark),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHealthierFutureBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.successSoft,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.eco, color: AppColors.success, size: 18),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  AppStrings.togetherHealthierFutureTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.success,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.eco, color: AppColors.success, size: 18),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            AppStrings.togetherHealthierFutureDesc,
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
