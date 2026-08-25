import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/core/routes/app_routes.dart';
import 'package:meathub/core/utils/pricing_utils.dart';
import 'package:meathub/core/widgets/category_product_card.dart';
import 'package:meathub/core/widgets/subcategory_chip_row.dart';
import 'package:meathub/data/dummy_category_config.dart';
import 'package:meathub/data/dummy_data.dart';
import 'package:meathub/models/category_config_model.dart';
import 'package:meathub/models/product_model.dart';
import 'package:meathub/providers/cart_provider.dart';

enum _SortOption { popular, priceLowHigh, priceHighLow }

class CategoryProductsScreen extends StatefulWidget {
  final String categoryKey;

  const CategoryProductsScreen({super.key, required this.categoryKey});

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String _selectedChip = 'All';
  _SortOption _sort = _SortOption.popular;

  late final CategoryConfigModel _config;
  late final List<ProductModel> _categoryProducts;

  @override
  void initState() {
    super.initState();
    _config = DummyCategoryConfig.configs[widget.categoryKey]!;
    _categoryProducts = DummyData.allProducts
        .where((p) => p.category == widget.categoryKey)
        .toList();
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

  List<ProductModel> get _filtered {
    var list = _categoryProducts.where((p) {
      final matchesChip =
          _selectedChip == 'All' || p.subCategory == _selectedChip;
      if (!matchesChip) return false;
      if (_query.isEmpty) return true;
      return p.name.toLowerCase().contains(_query);
    }).toList();

    switch (_sort) {
      case _SortOption.popular:
        list.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
        break;
      case _SortOption.priceLowHigh:
        list.sort(
          (a, b) => (double.tryParse(a.price) ?? 0).compareTo(
            double.tryParse(b.price) ?? 0,
          ),
        );
        break;
      case _SortOption.priceHighLow:
        list.sort(
          (a, b) => (double.tryParse(b.price) ?? 0).compareTo(
            double.tryParse(a.price) ?? 0,
          ),
        );
        break;
    }
    return list;
  }

  String get _sortLabel {
    switch (_sort) {
      case _SortOption.popular:
        return AppStrings.popularSort;
      case _SortOption.priceLowHigh:
        return AppStrings.priceLowHigh;
      case _SortOption.priceHighLow:
        return AppStrings.priceHighLow;
    }
  }

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  AppStrings.sortByPrefix,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                RadioGroup<_SortOption>(
                  groupValue: _sort,
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() => _sort = value);
                    Navigator.pop(sheetContext);
                  },
                  child: Column(
                    children: [
                      RadioListTile<_SortOption>(
                        value: _SortOption.popular,
                        contentPadding: EdgeInsets.zero,
                        title: const Text(AppStrings.popularSort),
                      ),
                      RadioListTile<_SortOption>(
                        value: _SortOption.priceLowHigh,
                        contentPadding: EdgeInsets.zero,
                        title: const Text(AppStrings.priceLowHigh),
                      ),
                      RadioListTile<_SortOption>(
                        value: _SortOption.priceHighLow,
                        contentPadding: EdgeInsets.zero,
                        title: const Text(AppStrings.priceHighLow),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showComingSoon(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label — ${AppStrings.comingSoon}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final products = _filtered;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context, cart),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(child: _buildSearchBar()),
                  const SizedBox(width: 10),
                  _buildFilterButton(),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SubCategoryChipRow(
                chips: _config.chips,
                selected: _selectedChip,
                onSelected: (c) => setState(() => _selectedChip = c),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${products.length} ${AppStrings.itemsSuffix}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _showSortSheet,
                        child: Row(
                          children: [
                            Text(
                              '${AppStrings.sortByPrefix}: ',
                              style: const TextStyle(
                                fontSize: 12.5,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              _sortLabel,
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                            const Icon(
                              Icons.keyboard_arrow_down,
                              size: 16,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () => _showComingSoon('List view'),
                        child: const Icon(
                          Icons.grid_view_outlined,
                          size: 20,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: products.isEmpty
                  ? _buildEmptyState()
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemCount: products.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.62,
                          ),
                      itemBuilder: (context, index) => CategoryProductCard(
                        product: products[index],
                        onTap: () => Navigator.of(
                          context,
                        ).push(AppRoutes.productDetailsRoute(products[index])),
                        onAdd: () {
                          context.read<CartProvider>().addItem(
                            products[index],
                            PricingUtils.unitToGrams(products[index].unit),
                            1,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${products[index].name} added to cart',
                              ),
                              backgroundColor: AppColors.primary,
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, CartProvider cart) {
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
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Color(_config.themeBgValue),
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Image.asset(_config.icon, fit: BoxFit.contain),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _config.label,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                Text(
                  _config.tagline,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => Navigator.of(context).pushNamed(AppRoutes.cart),
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Badge(
                label: Text('${cart.lineItemCount}'),
                isLabelVisible: cart.lineItemCount > 0,
                backgroundColor: AppColors.primary,
                child: const Icon(
                  Icons.shopping_cart_outlined,
                  size: 22,
                  color: AppColors.textDark,
                ),
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
              decoration: InputDecoration(
                hintText:
                    '${AppStrings.searchCategoryHintPrefix} ${_config.label.toLowerCase()} products...',
                hintStyle: const TextStyle(
                  color: AppColors.textHint,
                  fontSize: 13,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton() {
    return InkWell(
      onTap: () => _showComingSoon(AppStrings.filter),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.tune, size: 16, color: AppColors.textDark),
            SizedBox(width: 6),
            Text(
              AppStrings.filter,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
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
              AppStrings.noProductsFoundTitle,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              AppStrings.noProductsFoundDesc,
              style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
