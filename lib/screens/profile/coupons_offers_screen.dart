import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/core/routes/app_routes.dart';
import 'package:meathub/core/utils/coupon_utils.dart';
import 'package:meathub/core/widgets/coupon_list_card.dart';
import 'package:meathub/core/widgets/featured_coupon_card.dart';
import 'package:meathub/data/dummy_coupons.dart';
import 'package:meathub/models/coupon_model.dart';
import 'package:meathub/providers/cart_provider.dart';
import 'package:meathub/providers/coupon_provider.dart';

enum _CouponTab { all, available, usedExpired }

class CouponsOffersScreen extends StatefulWidget {
  const CouponsOffersScreen({super.key});

  @override
  State<CouponsOffersScreen> createState() => _CouponsOffersScreenState();
}

class _CouponsOffersScreenState extends State<CouponsOffersScreen> {
  _CouponTab _selectedTab = _CouponTab.all;
  late final List<CouponModel> _allCoupons;

  @override
  void initState() {
    super.initState();
    _allCoupons = DummyCoupons.all;
  }

  List<CouponModel> get _filtered {
    switch (_selectedTab) {
      case _CouponTab.all:
        return _allCoupons;
      case _CouponTab.available:
        return _allCoupons
            .where((c) => c.status == CouponStatus.available)
            .toList();
      case _CouponTab.usedExpired:
        return _allCoupons
            .where((c) => c.status != CouponStatus.available)
            .toList();
    }
  }

  CouponModel? get _featured {
    if (_selectedTab == _CouponTab.usedExpired) return null;
    for (final c in _allCoupons) {
      if (c.isFeatured && c.status == CouponStatus.available) return c;
    }
    return null;
  }

  List<CouponModel> get _listItems {
    final featured = _featured;
    if (featured == null) return _filtered;
    return _filtered.where((c) => c.code != featured.code).toList();
  }

  void _handleUseNow(CouponModel coupon) {
    final cart = context.read<CartProvider>();
    final error = CouponUtils.validate(coupon, cart.items, cart.subtotal);

    if (error.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: AppColors.error),
      );
      return;
    }

    context.read<CouponProvider>().apply(coupon);
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.main, (route) => false, arguments: 2);
  }

  void _showEnterCodeSheet() {
    final controller = TextEditingController();
    String? errorText;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: AppColors.divider,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const Text(
                      AppStrings.haveACouponCode,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: controller,
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                        hintText: AppStrings.enterCouponCodeHint,
                        errorText: errorText,
                        filled: true,
                        fillColor: AppColors.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final code = controller.text.trim().toUpperCase();
                          final matches = _allCoupons
                              .where((c) => c.code == code)
                              .toList();
                          if (matches.isEmpty) {
                            setSheetState(
                              () => errorText = AppStrings.invalidCouponCode,
                            );
                            return;
                          }
                          Navigator.pop(sheetContext);
                          _handleUseNow(matches.first);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          minimumSize: const Size(0, 52),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(AppStrings.apply),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showTerms() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(AppStrings.termsConditions),
        content: const Text(
          AppStrings.couponTermsBody,
          style: TextStyle(fontSize: 13, height: 1.7),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final available = _allCoupons
        .where((c) => c.status == CouponStatus.available)
        .length;
    final usedExpired = _allCoupons.length - available;
    final featured = _featured;
    final listItems = _listItems;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            const SizedBox(height: 10),
            _buildTabs(available, usedExpired),
            const SizedBox(height: 14),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                children: [
                  _buildEnterCodeBanner(),
                  if (featured != null) ...[
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          AppStrings.bestOffersForYou,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(
                            context,
                          ).pushNamed(AppRoutes.allOffers),
                          child: Row(
                            children: const [
                              Text(
                                AppStrings.viewAll,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                              Icon(
                                Icons.chevron_right,
                                size: 16,
                                color: AppColors.primary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    FeaturedCouponCard(
                      coupon: featured,
                      onUseNow: () => _handleUseNow(featured),
                    ),
                  ],
                  const SizedBox(height: 22),
                  Text(
                    _selectedTab == _CouponTab.usedExpired
                        ? AppStrings.usedExpiredTab
                        : AppStrings.availableCouponsSectionTitle,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (listItems.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          'No coupons here',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textHint,
                          ),
                        ),
                      ),
                    )
                  else
                    ...listItems.map(
                      (c) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: CouponListCard(
                          coupon: c,
                          onUseNow: () => _handleUseNow(c),
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  _buildTermsCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    AppStrings.couponsOffersTitle,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    AppStrings.couponsOffersSubtitle,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: InkWell(
              onTap: () => setState(() => _selectedTab = _CouponTab.available),
              child: Row(
                children: const [
                  Icon(
                    Icons.confirmation_num_outlined,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 5),
                  Text(
                    AppStrings.myCoupons,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(int available, int usedExpired) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _TabPill(
              label: '${AppStrings.allTab} (${_allCoupons.length})',
              selected: _selectedTab == _CouponTab.all,
              onTap: () => setState(() => _selectedTab = _CouponTab.all),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _TabPill(
              label: '${AppStrings.availableTab} ($available)',
              selected: _selectedTab == _CouponTab.available,
              onTap: () => setState(() => _selectedTab = _CouponTab.available),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _TabPill(
              label: '${AppStrings.usedExpiredTab} ($usedExpired)',
              selected: _selectedTab == _CouponTab.usedExpired,
              onTap: () =>
                  setState(() => _selectedTab = _CouponTab.usedExpired),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnterCodeBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.successSoft,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_offer_outlined,
              color: AppColors.success,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.haveACouponCode,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  AppStrings.enterCodeToUnlock,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: _showEnterCodeSheet,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.success,
              side: const BorderSide(color: AppColors.success),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              textStyle: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(AppStrings.enterCode),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsCard() {
    return InkWell(
      onTap: _showTerms,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                color: AppColors.primarySoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shield_outlined,
                color: AppColors.primary,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.termsConditions,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    AppStrings.couponTermsBody,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 18,
              color: AppColors.textHint,
            ),
          ],
        ),
      ),
    );
  }
}

class _TabPill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primarySoft : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.divider,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: selected ? AppColors.primary : AppColors.textHint,
          ),
        ),
      ),
    );
  }
}
