import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/core/routes/app_routes.dart';
import 'package:meathub/data/dummy_faq_full.dart';
import 'package:meathub/models/faq_full_item_model.dart';
import 'package:meathub/providers/orders_provider.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String _selectedCategory = 'all';

  static const List<Map<String, String>> _tabs = [
    {'key': 'all', 'label': 'All'},
    {'key': 'orders', 'label': 'Orders'},
    {'key': 'payments', 'label': 'Payments'},
    {'key': 'products', 'label': 'Products'},
    {'key': 'account', 'label': 'Account'},
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() => _query = _searchController.text.trim().toLowerCase()));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<FaqFullItemModel> get _filtered {
    return DummyFaqFull.all.where((f) {
      final matchesCategory = _selectedCategory == 'all' || f.category == _selectedCategory;
      if (!matchesCategory) return false;
      if (_query.isEmpty) return true;
      return f.question.toLowerCase().contains(_query) || f.answer.toLowerCase().contains(_query);
    }).toList();
  }

  void _trackOrder(BuildContext context) {
    final order = context.read<OrdersProvider>().mostRelevantOrder;
    if (order == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No active orders currently.')));
      return;
    }
    Navigator.of(context).push(AppRoutes.trackOrderRoute(
      orderId: order.orderId,
      placedAt: order.placedAt,
      items: order.items,
      address: order.address,
      deliveryOption: order.deliveryOption,
      paymentMethod: order.paymentMethod,
      platformFee: order.platformFee,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final faqs = _filtered;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            const SizedBox(height: 10),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: _buildSearchBar()),
            const SizedBox(height: 12),
            _buildCategoryTabs(),
            const SizedBox(height: 12),
            Expanded(
              child: faqs.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                itemCount: faqs.length,
                itemBuilder: (context, index) => _FaqTile(
                  key: ValueKey(faqs[index].question),
                  faq: faqs[index],
                  initiallyExpanded: index == 0 && _query.isEmpty && _selectedCategory == 'all',
                  onTrackOrder: () => _trackOrder(context),
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
                  Text(AppStrings.allFaqsTitle, style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: AppColors.textDark)),
                  SizedBox(height: 2),
                  Text(AppStrings.allFaqsSubtitle, style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
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
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.divider)),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppColors.textHint, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: AppStrings.searchFaqsHint,
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

  Widget _buildCategoryTabs() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _tabs.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final tab = _tabs[index];
          final selected = _selectedCategory == tab['key'];
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = tab['key']!),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(color: selected ? AppColors.primary : AppColors.surface, borderRadius: BorderRadius.circular(20)),
              child: Text(tab['label']!, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: selected ? AppColors.white : AppColors.textDark)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.surface),
              child: const Icon(Icons.search_off, size: 30, color: AppColors.textHint),
            ),
            const SizedBox(height: 14),
            const Text(AppStrings.noHelpResultsTitle, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            const SizedBox(height: 4),
            const Text(AppStrings.noHelpResultsDesc, style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class _FaqTile extends StatefulWidget {
  final FaqFullItemModel faq;
  final bool initiallyExpanded;
  final VoidCallback onTrackOrder;

  const _FaqTile({super.key, required this.faq, required this.initiallyExpanded, required this.onTrackOrder});

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.divider)),
      child: InkWell(
        onTap: () => setState(() => _expanded = !_expanded),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(widget.faq.question, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.textDark))),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.keyboard_arrow_down, size: 20, color: AppColors.textHint),
                  ),
                ],
              ),
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 200),
                crossFadeState: _expanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                firstChild: Padding(
                  padding: const EdgeInsets.only(top: 8, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.faq.answer, style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.5)),
                      if (widget.faq.showTrackOrderCta) ...[
                        const SizedBox(height: 10),
                        OutlinedButton.icon(
                          onPressed: widget.onTrackOrder,
                          icon: const Icon(Icons.open_in_new, size: 13),
                          label: const Text('Track My Order'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(color: AppColors.primary),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                secondChild: const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}