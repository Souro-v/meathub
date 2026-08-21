import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/core/routes/app_routes.dart';
import 'package:meathub/core/utils/contact_link_utils.dart';
import 'package:meathub/core/widgets/contact_channel_card.dart';
import 'package:meathub/core/widgets/faq_accordion_item.dart';
import 'package:meathub/core/widgets/help_topic_card.dart';
import 'package:meathub/data/dummy_help_data.dart';
import 'package:meathub/models/faq_item_model.dart';
import 'package:meathub/models/help_topic_model.dart';
import 'package:meathub/screens/address/manage_addresses_screen.dart';
import 'package:meathub/screens/profile/coupons_offers_screen.dart';
import 'package:meathub/screens/profile/edit_profile_screen.dart';

import '../help/faq_screen.dart';
import '../help/live_chat_screen.dart';
import '../help/ticket_list_screen.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  static const String _whatsappNumber = '8801234567890';
  static const String _supportEmail = 'support@meathub.com';
  static const String _supportPhone = '+8801234567890';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(
      () =>
          setState(() => _query = _searchController.text.trim().toLowerCase()),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showComingSoon(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label — ${AppStrings.comingSoon}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  List<HelpTopicModel> get _filteredTopics {
    if (_query.isEmpty) return DummyHelpData.topics;
    return DummyHelpData.topics
        .where(
          (t) => t.title.toLowerCase().replaceAll('\n', ' ').contains(_query),
        )
        .toList();
  }

  List<FaqItemModel> get _filteredFaqs {
    if (_query.isEmpty) return DummyHelpData.faqs;
    return DummyHelpData.faqs
        .where(
          (f) =>
              f.question.toLowerCase().contains(_query) ||
              f.answer.toLowerCase().contains(_query),
        )
        .toList();
  }

  void _handleTopicTap(HelpTopicModel topic) {
    switch (topic.key) {
      case 'orders':
      case 'product':
      case 'payments':
        Navigator.of(context).push(AppRoutes.helpCategoryRoute(topic.key));
        break;
      case 'coupons':
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const CouponsOffersScreen()));
        break;
      case 'account':
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const EditProfileScreen()));
        break;
      case 'addresses':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ManageAddressesScreen()),
        );
        break;
      case 'wallet':
        _showComingSoon(topic.title.replaceAll('\n', ' '));
        break;
      default:
        Navigator.of(context).push(AppRoutes.reportIssueRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    final topics = _filteredTopics;
    final faqs = _filteredFaqs;
    final noResults = _query.isNotEmpty && topics.isEmpty && faqs.isEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildSearchBar(),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                children: [
                  _buildImmediateHelpBanner(),
                  if (noResults)
                    _buildNoResultsState()
                  else ...[
                    if (topics.isNotEmpty) ...[
                      const SizedBox(height: 22),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            AppStrings.quickHelpTopics,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                            ),
                          ),
                          GestureDetector(
                            onTap: () =>
                                _showComingSoon(AppStrings.quickHelpTopics),
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
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: topics.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 0.82,
                            ),
                        itemBuilder: (context, index) => HelpTopicCard(
                          topic: topics[index],
                          onTap: () => _handleTopicTap(topics[index]),
                        ),
                      ),
                    ],
                    if (faqs.isNotEmpty) ...[
                      const SizedBox(height: 22),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            AppStrings.popularQuestions,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const FaqScreen(),
                              ),
                            ),
                            child: Row(
                              children: const [
                                Text(
                                  AppStrings.viewAllFaqs,
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
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: Column(
                          children: List.generate(faqs.length, (index) {
                            final isLast = index == faqs.length - 1;
                            return Column(
                              children: [
                                FaqAccordionItem(
                                  key: ValueKey(faqs[index].question),
                                  faq: faqs[index],
                                ),
                                if (!isLast)
                                  const Divider(
                                    color: AppColors.divider,
                                    height: 1,
                                  ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ],
                  ],
                  const SizedBox(height: 24),
                  const Text(
                    AppStrings.otherWaysToReachUs,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ContactChannelCard(
                          icon: Icons.chat,
                          color: const Color(0xFF25913F),
                          bg: const Color(0xFFE7F5EA),
                          title: AppStrings.whatsappSupport,
                          description: AppStrings.whatsappSupportDesc,
                          buttonLabel: AppStrings.chatNow,
                          buttonIcon: Icons.open_in_new,
                          onTap: () => ContactLinkUtils.openWhatsApp(
                            context,
                            _whatsappNumber,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ContactChannelCard(
                          icon: Icons.mail_outline,
                          color: const Color(0xFF6A4FBF),
                          bg: const Color(0xFFEEE9FB),
                          title: AppStrings.emailSupport,
                          description: AppStrings.emailSupportDesc,
                          buttonLabel: AppStrings.sendEmail,
                          buttonIcon: Icons.open_in_new,
                          onTap: () => ContactLinkUtils.sendEmail(
                            context,
                            _supportEmail,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ContactChannelCard(
                          icon: Icons.call_outlined,
                          color: const Color(0xFFB2560A),
                          bg: const Color(0xFFFFEFDD),
                          title: AppStrings.callSupport,
                          description: AppStrings.callSupportDesc,
                          buttonLabel: _supportPhone,
                          buttonIcon: Icons.call,
                          onTap: () => ContactLinkUtils.callPhone(
                            context,
                            _supportPhone,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildMyTicketsBanner(),
                  const SizedBox(height: 16),
                  _buildFooterBanner(),
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
                    AppStrings.helpSupportTitle,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    AppStrings.helpSupportSubtitle,
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
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const TicketListScreen()),
              ),
              child: Row(
                children: const [
                  Icon(
                    Icons.confirmation_number_outlined,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 5),
                  Text(
                    AppStrings.myTickets,
                    style: TextStyle(
                      fontSize: 12.5,
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

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppColors.textHint, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: AppStrings.searchHelpHint,
                hintStyle: TextStyle(color: AppColors.textHint, fontSize: 13),
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

  Widget _buildImmediateHelpBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.headset_mic_outlined,
              color: AppColors.primary,
              size: 21,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  AppStrings.needImmediateHelp,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  AppStrings.needImmediateHelpDesc,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const LiveChatScreen()),
                  ),
                  icon: const Icon(Icons.chat_bubble_outline, size: 15),
                  label: const Text(AppStrings.chatWithUs),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  AppStrings.supportAvailableHours,
                  style: TextStyle(fontSize: 11, color: AppColors.textHint),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 36),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface,
            ),
            child: const Icon(
              Icons.search_off,
              size: 30,
              color: AppColors.textHint,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            AppStrings.noHelpResultsTitle,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            AppStrings.noHelpResultsDesc,
            style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildMyTicketsBanner() {
    return InkWell(
      onTap: () => Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const TicketListScreen())),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: AppColors.primarySoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.confirmation_number_outlined,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.mySupportTickets,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    AppStrings.mySupportTicketsDesc,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            OutlinedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const TicketListScreen()),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                textStyle: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(AppStrings.viewMyTickets),
                  Icon(Icons.chevron_right, size: 15),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(18),
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
              Icons.verified_user,
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
                  AppStrings.committedToSatisfaction,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  AppStrings.committedToSatisfactionDesc,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
