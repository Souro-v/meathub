import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/core/widgets/custom_button.dart';
import 'package:meathub/core/widgets/dashed_add_button.dart';
import 'package:meathub/core/widgets/recent_address_tile.dart';
import 'package:meathub/core/widgets/saved_address_card.dart';
import 'package:meathub/core/widgets/section_header.dart';
import 'package:meathub/data/dummy_addresses.dart';
import 'package:meathub/screens/address/use_current_location_sheet.dart';

import '../../core/routes/app_routes.dart';

class AddressSelectionScreen extends StatefulWidget {
  const AddressSelectionScreen({super.key});

  @override
  State<AddressSelectionScreen> createState() => _AddressSelectionScreenState();
}

class _AddressSelectionScreenState extends State<AddressSelectionScreen> {
  int _selectedRecentIndex = 0;

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
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCurrentLocationCard(),
                    const SizedBox(height: 16),
                    _buildSearchBar(),
                    const SizedBox(height: 22),
                    SectionHeader(
                      title: AppStrings.recentAddresses,
                      onAction: () => Navigator.of(
                        context,
                      ).pushNamed(AppRoutes.recentAddressesFull),
                    ),
                    const SizedBox(height: 10),
                    _buildRecentAddressesCard(),
                    const SizedBox(height: 22),
                    SectionHeader(
                      title: AppStrings.savedAddresses,
                      actionLabel: AppStrings.manage,
                      onAction: () => Navigator.of(
                        context,
                      ).pushNamed(AppRoutes.manageAddresses),
                    ),
                    const SizedBox(height: 10),
                    ...DummyAddresses.saved.map(
                      (a) => SavedAddressCard(data: a, onEdit: () {}),
                    ),
                    DashedAddButton(
                      label: AppStrings.addNewAddress,
                      onTap: () {},
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      AppStrings.nearbyOnMap,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildMapPreview(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: CustomButton(
                label: AppStrings.confirmDeliveryAddress,
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: () => Navigator.of(context).maybePop(),
              borderRadius: BorderRadius.circular(20),
              child: const Icon(
                Icons.arrow_back,
                size: 22,
                color: AppColors.textDark,
              ),
            ),
          ),
          const Column(
            children: [
              Text(
                AppStrings.deliverTo,
                style: TextStyle(fontSize: 12, color: AppColors.textHint),
              ),
              SizedBox(height: 2),
              Text(
                AppStrings.selectDeliveryLocation,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentLocationCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
              color: AppColors.primarySoft,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.my_location,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  AppStrings.currentLocationTitle,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  AppStrings.currentLocationSubtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.success,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      AppStrings.accuracyHigh,
                      style: TextStyle(fontSize: 11, color: AppColors.textHint),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => const UseCurrentLocationSheet(),
            ),
            icon: const Icon(Icons.navigation_outlined, size: 15),
            label: const Text(AppStrings.useCurrentLocation),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              textStyle: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        children: [
          Icon(Icons.search, color: AppColors.textHint, size: 20),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: AppStrings.searchAreaHint,
                hintStyle: TextStyle(color: AppColors.textHint, fontSize: 13.5),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentAddressesCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        children: List.generate(DummyAddresses.recent.length, (index) {
          final isLast = index == DummyAddresses.recent.length - 1;
          return Container(
            decoration: BoxDecoration(
              border: isLast
                  ? null
                  : const Border(bottom: BorderSide(color: AppColors.divider)),
            ),
            child: RecentAddressTile(
              data: DummyAddresses.recent[index],
              selected: _selectedRecentIndex == index,
              onTap: () => setState(() => _selectedRecentIndex = index),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildMapPreview() {
    final selected = DummyAddresses.recent[_selectedRecentIndex];
    return Stack(
      children: [
        Container(
          height: 190,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFE9E9EA),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        Positioned(
          top: 36,
          left: 40,
          right: 40,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      selected.area,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      selected.note,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 2),
              const Icon(Icons.location_on, color: AppColors.primary, size: 32),
            ],
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            child: const Icon(
              Icons.my_location,
              size: 17,
              color: AppColors.textDark,
            ),
          ),
        ),
      ],
    );
  }
}
