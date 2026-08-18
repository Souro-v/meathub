import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/core/routes/app_routes.dart';
import 'package:meathub/core/widgets/offer_category_tile.dart';
import 'package:meathub/data/dummy_how_it_works.dart';

class HowItWorksScreen extends StatelessWidget {
  const HowItWorksScreen({super.key});

  void _showComingSoon(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label — ${AppStrings.comingSoon}'), duration: const Duration(seconds: 2)),
    );
  }

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
                    _buildStepsCard(),
                    const SizedBox(height: 22),
                    const Text(AppStrings.offerCategoriesTitle, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                    const SizedBox(height: 12),
                    ...DummyHowItWorks.categories.map((c) => OfferCategoryTile(
                      category: c,
                      onTap: () => Navigator.of(context).pushReplacement(
                        AppRoutes.allOffersRoute(initialTag: c.tagKey),
                      ),
                    )),
                    const SizedBox(height: 10),
                    _buildImportantPointsCard(),
                    const SizedBox(height: 16),
                    _buildNeedHelpBanner(context),
                    const SizedBox(height: 14),
                    _buildHelpCenterRow(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => Navigator.of(context).maybePop(),
            borderRadius: BorderRadius.circular(20),
            child: const Padding(padding: EdgeInsets.all(8), child: Icon(Icons.arrow_back, size: 22, color: AppColors.textDark)),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(AppStrings.howItWorksTitle, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textDark)),
                  SizedBox(height: 2),
                  Text(AppStrings.howItWorksSubtitle, style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(AppStrings.howToUseOffers, style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800, color: AppColors.primary)),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < DummyHowItWorks.steps.length; i++) ...[
                Expanded(child: _StepItem(step: DummyHowItWorks.steps[i])),
                if (i != DummyHowItWorks.steps.length - 1)
                  const Padding(
                    padding: EdgeInsets.only(top: 22),
                    child: Icon(Icons.arrow_forward, size: 14, color: AppColors.primary),
                  ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImportantPointsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.successSoft, borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(AppStrings.importantPoints, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textDark)),
          const SizedBox(height: 12),
          ...DummyHowItWorks.importantPoints.map((point) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 18,
                  height: 18,
                  margin: const EdgeInsets.only(top: 1),
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.success),
                  child: const Icon(Icons.check, size: 12, color: AppColors.white),
                ),
                const SizedBox(width: 10),
                Expanded(child: Text(point, style: const TextStyle(fontSize: 13, color: AppColors.textDark, height: 1.4))),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildNeedHelpBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFE8EEFB), borderRadius: BorderRadius.circular(18)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
            child: const Icon(Icons.headset_mic_outlined, color: Color(0xFF3F5FBF), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(AppStrings.needHelpTitle, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF3F5FBF))),
                const SizedBox(height: 4),
                const Text(AppStrings.needHelpDesc, style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4)),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: () => _showComingSoon(context, AppStrings.contactSupport),
                  icon: const Icon(Icons.chat_bubble_outline, size: 15),
                  label: const Text(AppStrings.contactSupport),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF3F5FBF),
                    side: const BorderSide(color: Color(0xFF3F5FBF)),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    textStyle: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpCenterRow(BuildContext context) {
    return InkWell(
      onTap: () => _showComingSoon(context, AppStrings.helpCenterLink),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14)),
        child: Row(
          children: [
            const Icon(Icons.info_outline, size: 18, color: AppColors.textSecondary),
            const SizedBox(width: 10),
            Expanded(
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
                  children: [
                    TextSpan(text: AppStrings.helpCenterPrompt),
                    TextSpan(text: AppStrings.helpCenterLink, style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                    TextSpan(text: AppStrings.helpCenterSuffix),
                  ],
                ),
              ),
            ),
            const Icon(Icons.chevron_right, size: 18, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final HowToStepData step;
  const _StepItem({required this.step});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
              child: Icon(step.icon, size: 24, color: AppColors.primary),
            ),
            Positioned(
              top: -6,
              left: -6,
              child: Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: AppColors.white, shape: BoxShape.circle, border: Border.all(color: AppColors.primary)),
                child: Text('${step.number}', style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: AppColors.primary)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(step.title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.textDark)),
        const SizedBox(height: 4),
        Text(step.description, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary, height: 1.3)),
      ],
    );
  }
}