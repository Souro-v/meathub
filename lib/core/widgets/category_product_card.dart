import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/models/product_model.dart';
import 'package:meathub/providers/wishlist_provider.dart';

class CategoryProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;
  final VoidCallback? onAdd;

  const CategoryProductCard({super.key, required this.product, this.onTap, this.onAdd});

  @override
  Widget build(BuildContext context) {
    final isWishlisted = context.watch<WishlistProvider>().isWishlisted(product.id);
    final badge = product.computedBadge;
    final isBestSeller = product.badgeLabel == 'BEST SELLER';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.divider)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(aspectRatio: 1.15, child: Image.asset(product.image, fit: BoxFit.cover, width: double.infinity)),
                if (badge != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: isBestSeller ? AppColors.textDark : AppColors.primary, borderRadius: BorderRadius.circular(6)),
                      child: Text(badge, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.white)),
                    ),
                  ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: InkWell(
                    onTap: () => context.read<WishlistProvider>().toggle(product),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.white),
                      child: Icon(isWishlisted ? Icons.favorite : Icons.favorite_border, size: 15, color: AppColors.primary),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                  const SizedBox(height: 2),
                  Text('${product.category} • ${product.unit}', style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 12, color: Color(0xFFFFA726)),
                      const SizedBox(width: 3),
                      Text('${product.rating} (${product.reviewCount})', style: const TextStyle(fontSize: 10.5, color: AppColors.textHint)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text('৳${product.price}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.primary)),
                          if (product.hasDiscount) ...[
                            const SizedBox(width: 5),
                            Text('৳${product.originalPrice}', style: const TextStyle(fontSize: 10.5, color: AppColors.textHint, decoration: TextDecoration.lineThrough)),
                          ],
                        ],
                      ),
                      InkWell(
                        onTap: onAdd,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primary),
                          child: const Icon(Icons.add, size: 15, color: AppColors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}