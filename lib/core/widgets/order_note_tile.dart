import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/providers/cart_provider.dart';

class OrderNoteTile extends StatelessWidget {
  final String title;
  final String placeholder;

  const OrderNoteTile({
    super.key,
    this.title = AppStrings.addOrderNote,
    this.placeholder = AppStrings.orderNoteSubtitle,
  });

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    return InkWell(
      onTap: () => _showDialog(context),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(color: AppColors.primarySoft, shape: BoxShape.circle),
              child: const Icon(Icons.description_outlined, color: AppColors.primary, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                  const SizedBox(height: 2),
                  Text(
                    cart.orderNote.isEmpty ? placeholder : cart.orderNote,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: AppColors.textHint),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 20, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    final cart = context.read<CartProvider>();
    final controller = TextEditingController(text: cart.orderNote);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: InputDecoration(hintText: placeholder),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text(AppStrings.cancel)),
          TextButton(
            onPressed: () {
              cart.setOrderNote(controller.text.trim());
              Navigator.pop(dialogContext);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}