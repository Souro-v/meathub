import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/core/routes/app_routes.dart';
import 'package:meathub/core/widgets/cart_item_card.dart';
import 'package:meathub/core/widgets/free_delivery_progress_card.dart';
import 'package:meathub/providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context, cart),
            if (cart.items.isEmpty)
              Expanded(child: _buildEmptyState())
            else ...[
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FreeDeliveryProgressCard(
                        amountLeft: cart.amountLeftForFreeDelivery,
                        progress: cart.freeDeliveryProgress,
                        qualifies: cart.qualifiesForFreeDelivery,
                      ),
                      const SizedBox(height: 16),
                      ...cart.items.map(
                        (item) => CartItemCard(
                          item: item,
                          onQuantityChanged: (q) => context
                              .read<CartProvider>()
                              .updateQuantity(item.cartId, q),
                          onRemove: () => context
                              .read<CartProvider>()
                              .removeItem(item.cartId),
                        ),
                      ),
                      _buildOrderNoteTile(context, cart),
                    ],
                  ),
                ),
              ),
              _buildOrderSummary(context, cart),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, CartProvider cart) {
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
                    AppStrings.yourCart,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    AppStrings.reviewCartSubtitle,
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
            padding: const EdgeInsets.only(top: 6),
            child: InkWell(
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.wishlist),
              borderRadius: BorderRadius.circular(20),
              child: const Padding(
                padding: EdgeInsets.all(6),
                child: Icon(
                  Icons.favorite_border,
                  size: 22,
                  color: AppColors.textDark,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Badge(
              label: Text('${cart.lineItemCount}'),
              isLabelVisible: cart.lineItemCount > 0,
              backgroundColor: AppColors.primary,
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 22,
                color: AppColors.textDark,
              ),
            ),
          ),
        ],
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
              width: 90,
              height: 90,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primarySoft,
              ),
              child: const Icon(
                Icons.shopping_cart_outlined,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              AppStrings.cartEmptyTitle,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              AppStrings.cartEmptyDesc,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderNoteTile(BuildContext context, CartProvider cart) {
    return InkWell(
      onTap: () => _showOrderNoteDialog(context, cart),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(top: 4, bottom: 4),
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
              decoration: const BoxDecoration(
                color: AppColors.primarySoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.description_outlined,
                color: AppColors.primary,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    AppStrings.addOrderNote,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    cart.orderNote.isEmpty
                        ? AppStrings.orderNoteSubtitle
                        : cart.orderNote,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 20,
              color: AppColors.textHint,
            ),
          ],
        ),
      ),
    );
  }

  void _showOrderNoteDialog(BuildContext context, CartProvider cart) {
    final controller = TextEditingController(text: cart.orderNote);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(AppStrings.addOrderNote),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: AppStrings.orderNoteSubtitle,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              context.read<CartProvider>().setOrderNote(controller.text.trim());
              Navigator.pop(dialogContext);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context, CartProvider cart) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _summaryRow(
                  '${AppStrings.subtotal} (${cart.totalQuantity} ${AppStrings.itemsLabel})',
                  '৳${cart.subtotal.toStringAsFixed(0)}',
                ),
                const SizedBox(height: 6),
                _summaryRow(
                  AppStrings.deliveryFee,
                  cart.deliveryFee == 0
                      ? 'FREE'
                      : '৳${cart.deliveryFee.toStringAsFixed(0)}',
                ),
                const SizedBox(height: 6),
                _summaryRow(
                  AppStrings.platformFee,
                  '৳${cart.platformFee.toStringAsFixed(0)}',
                ),
                const SizedBox(height: 8),
                const Divider(color: AppColors.divider),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      AppStrings.total,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      '৳${cart.total.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.successSoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.success,
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 11,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.safeSecureTitle,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark,
                              ),
                            ),
                            Text(
                              AppStrings.safeSecureDesc,
                              style: TextStyle(
                                fontSize: 9.5,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      minimumSize: const Size(0, 46),
                      textStyle: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(AppStrings.proceedToCheckout),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward, size: 15),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12.5,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }
}
