import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/core/utils/pricing_utils.dart';
import 'package:meathub/core/utils/rating_utils.dart';
import 'package:meathub/core/widgets/product_card.dart';
import 'package:meathub/core/widgets/product_image_gallery.dart';
import 'package:meathub/core/widgets/quantity_selector.dart';
import 'package:meathub/core/widgets/rating_summary_card.dart';
import 'package:meathub/core/widgets/section_header.dart';
import 'package:meathub/core/widgets/weight_selector.dart';
import 'package:meathub/data/dummy_data.dart';
import 'package:meathub/models/product_model.dart';
import 'package:meathub/providers/wishlist_provider.dart';

import '../../core/routes/app_routes.dart';
import '../../models/cart_item_model.dart';
import '../../providers/cart_provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  static const List<double> _weightOptions = [500, 1000, 2000, 3000];

  late double _baseGrams;
  late double _selectedGrams;
  int _quantity = 1;
  bool _descriptionExpanded = false;

  @override
  void initState() {
    super.initState();
    _baseGrams = PricingUtils.unitToGrams(widget.product.unit);
    _selectedGrams = _weightOptions.contains(_baseGrams) ? _baseGrams : 1000;
  }

  double get _basePrice => double.tryParse(widget.product.price) ?? 0;

  double get _baseOriginalPrice =>
      double.tryParse(widget.product.originalPrice) ?? _basePrice;

  double get _unitTotal => PricingUtils.priceForWeight(
    basePrice: _basePrice,
    baseGrams: _baseGrams,
    targetGrams: _selectedGrams,
  );

  double get _total => _unitTotal * _quantity;

  List<ProductModel> get _related {
    final all = [...DummyData.popularToday, ...DummyData.todaysFreshPicks];
    return all
        .where(
          (p) =>
              p.category == widget.product.category &&
              p.id != widget.product.id,
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final isWishlisted = context.watch<WishlistProvider>().isWishlisted(
      product.id,
    );
    final breakdown = RatingUtils.estimateBreakdown(
      product.rating,
      product.reviewCount,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context, isWishlisted),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProductImageGallery(
                      images: product.images,
                      isFreshToday: product.isFreshToday,
                      discountPercent: product.discountPercent,
                    ),
                    const SizedBox(height: 18),
                    Text(
                      product.category,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ...List.generate(
                          5,
                          (i) => Icon(
                            i < product.rating.round()
                                ? Icons.star
                                : Icons.star_border,
                            size: 15,
                            color: const Color(0xFFFFA726),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${product.rating} (${product.reviewCount} ${AppStrings.reviews})',
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: AppColors.textHint,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: product.inStock
                                ? AppColors.success
                                : AppColors.error,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          product.inStock
                              ? AppStrings.inStockLabel
                              : AppStrings.outOfStockLabel,
                          style: TextStyle(
                            fontSize: 12.5,
                            color: product.inStock
                                ? AppColors.success
                                : AppColors.error,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '৳${product.price}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          '/${product.unit}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textHint,
                          ),
                        ),
                        if (product.hasDiscount) ...[
                          const SizedBox(width: 8),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: Text(
                              '৳${product.originalPrice}/${product.unit}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textHint,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ),
                        ],
                        const Spacer(),
                        if (product.hasDiscount)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primarySoft,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Save ৳${(_baseOriginalPrice - _basePrice).toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          AppStrings.chooseWeight,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _showHowMuchDialog(context),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.help_outline,
                                size: 15,
                                color: AppColors.primary,
                              ),
                              SizedBox(width: 4),
                              Text(
                                AppStrings.howMuchDoINeed,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    WeightSelector(
                      options: _weightOptions,
                      selectedGrams: _selectedGrams,
                      onChanged: (grams) =>
                          setState(() => _selectedGrams = grams),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          AppStrings.quantity,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                        ),
                        QuantitySelector(
                          quantity: _quantity,
                          onChanged: (q) => setState(() => _quantity = q),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    const Divider(color: AppColors.divider),
                    const SizedBox(height: 18),
                    const Text(
                      AppStrings.productDescription,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.fullDescription,
                      maxLines: _descriptionExpanded ? null : 2,
                      overflow: _descriptionExpanded
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () => setState(
                        () => _descriptionExpanded = !_descriptionExpanded,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _descriptionExpanded
                                ? AppStrings.showLess
                                : AppStrings.readMore,
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                          Icon(
                            _descriptionExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            size: 16,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    RatingSummaryCard(
                      rating: product.rating,
                      reviewCount: product.reviewCount,
                      breakdown: breakdown,
                    ),
                    if (_related.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      SectionHeader(
                        title: AppStrings.youMayAlsoLike,
                        onAction: () {},
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 220,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _related.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 12),
                          itemBuilder: (context, index) => SizedBox(
                            width: 150,
                            child: ProductCard(
                              product: _related[index],
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ProductDetailsScreen(
                                    product: _related[index],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            _buildBottomBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, bool isWishlisted) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
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
          const Expanded(
            child: Text(
              AppStrings.productDetails,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
          ),
          InkWell(
            onTap: () =>
                context.read<WishlistProvider>().toggle(widget.product),
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(
                isWishlisted ? Icons.favorite : Icons.favorite_border,
                size: 21,
                color: AppColors.primary,
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(20),
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(
                Icons.share_outlined,
                size: 21,
                color: AppColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                AppStrings.totalPrice,
                style: TextStyle(fontSize: 11.5, color: AppColors.textHint),
              ),
              Text(
                '৳${_total.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                context.read<CartProvider>().addItem(
                  widget.product,
                  _selectedGrams,
                  _quantity,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${widget.product.name} added to cart'),
                    backgroundColor: AppColors.primary,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              icon: const Icon(Icons.shopping_cart_outlined, size: 16),
              label: const Text(AppStrings.addToCart),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                minimumSize: const Size(0, 50),
                textStyle: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                final item = CartItemModel(
                  product: widget.product,
                  weightGrams: _selectedGrams,
                  quantity: _quantity,
                );
                Navigator.of(context).push(AppRoutes.checkoutRoute([item]));
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                minimumSize: const Size(0, 50),
                textStyle: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(AppStrings.buyNow),
            ),
          ),
        ],
      ),
    );
  }

  void _showHowMuchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.howMuchDoINeed),
        content: const Text(
          '• 1 person: ~250-300 g per meal\n• Family of 4: 1-1.5 kg\n• Small gathering (8-10 people): 2-3 kg\n\nAdjust based on your recipe and side dishes.',
          style: TextStyle(fontSize: 13, height: 1.6),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
