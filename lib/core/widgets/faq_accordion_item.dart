import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/models/faq_item_model.dart';

class FaqAccordionItem extends StatefulWidget {
  final FaqItemModel faq;
  const FaqAccordionItem({super.key, required this.faq});

  @override
  State<FaqAccordionItem> createState() => _FaqAccordionItemState();
}

class _FaqAccordionItemState extends State<FaqAccordionItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(widget.faq.question, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                ),
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
                padding: const EdgeInsets.only(top: 8, right: 24),
                child: Text(widget.faq.answer, style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.5)),
              ),
              secondChild: const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}