import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/data/dummy_faq_full.dart';
import 'package:meathub/models/faq_full_item_model.dart';
import 'package:meathub/screens/help/live_chat_screen.dart';

class FaqCategoryScreen extends StatelessWidget {
  final String categoryKey;
  const FaqCategoryScreen({super.key, required this.categoryKey});

  @override
  Widget build(BuildContext context) {
    final config = DummyFaqCategories.all.firstWhere((c) => c.key == categoryKey);
    final faqs = DummyFaqFull.all.where((f) => f.category == categoryKey).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context, config, faqs.length),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                itemCount: faqs.length + 1,
                itemBuilder: (context, index) {
                  if (index == faqs.length) {
                    return Padding(padding: const EdgeInsets.only(top: 8), child: _buildStillNeedHelp(context));
                  }
                  return _FaqCategoryTile(faq: faqs[index], expandByDefault: index == 0);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, FaqCategoryConfigModel config, int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () => Navigator.of(context).maybePop(),
            borderRadius: BorderRadius.circular(20),
            child: const Padding(padding: EdgeInsets.all(8), child: Icon(Icons.arrow_back, size: 22, color: AppColors.textDark)),
          ),
          Expanded(child: Text(config.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textDark))),
          Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: config.bg, shape: BoxShape.circle),
                child: Icon(config.icon, size: 19, color: config.color),
              ),
              const SizedBox(height: 3),
              Text('$count Questions', style: const TextStyle(fontSize: 10.5, color: AppColors.textHint)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStillNeedHelp(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LiveChatScreen())),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
              child: const Icon(Icons.mail_outline, color: AppColors.primary, size: 19),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppStrings.stillNeedHelp, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                  SizedBox(height: 2),
                  Text(AppStrings.chatWithSupportTeam, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 18, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}

class _FaqCategoryTile extends StatefulWidget {
  final FaqFullItemModel faq;
  final bool expandByDefault;
  const _FaqCategoryTile({required this.faq, required this.expandByDefault});

  @override
  State<_FaqCategoryTile> createState() => _FaqCategoryTileState();
}

class _FaqCategoryTileState extends State<_FaqCategoryTile> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.expandByDefault;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: _expanded ? AppColors.primarySoft : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _expanded ? AppColors.primary : AppColors.divider),
      ),
      child: InkWell(
        onTap: () => setState(() => _expanded = !_expanded),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(widget.faq.question, style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: _expanded ? AppColors.primary : AppColors.textDark)),
                  ),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(Icons.keyboard_arrow_down, size: 20, color: _expanded ? AppColors.primary : AppColors.textHint),
                  ),
                ],
              ),
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 200),
                crossFadeState: _expanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                firstChild: Padding(
                  padding: const EdgeInsets.only(top: 8, right: 20),
                  child: Text(widget.faq.answer, style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.5)),
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