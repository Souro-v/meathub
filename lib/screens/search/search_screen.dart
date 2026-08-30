import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/core/routes/app_routes.dart';
import 'package:meathub/core/utils/pricing_utils.dart';
import 'package:meathub/core/utils/search_utils.dart';
import 'package:meathub/core/widgets/popular_search_chip.dart';
import 'package:meathub/core/widgets/removable_search_chip.dart';
import 'package:meathub/core/widgets/search_category_row.dart';
import 'package:meathub/core/widgets/search_no_results.dart';
import 'package:meathub/core/widgets/search_product_row.dart';
import 'package:meathub/data/dummy_data.dart';
import 'package:meathub/data/dummy_search_data.dart';
import 'package:meathub/models/category_model.dart';
import 'package:meathub/models/product_model.dart';
import 'package:meathub/providers/cart_provider.dart';
import 'package:meathub/providers/search_history_provider.dart';

enum _SearchTab { all, products, categories }

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String _query = '';
  _SearchTab _tab = _SearchTab.all;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() => _query = _controller.text));
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _focusNode.requestFocus(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _runSearch(String term) {
    _controller.text = term;
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: term.length),
    );
    setState(() {
      _query = term;
      _tab = _SearchTab.all;
    });
  }

  void _submit(String term) {
    if (term.trim().isEmpty) return;
    context.read<SearchHistoryProvider>().add(term.trim());
  }

  void _clearSearch() {
    _controller.clear();
    setState(() => _query = '');
    _focusNode.requestFocus();
  }

  void _onSelectProduct(ProductModel product) {
    _submit(_query);
    Navigator.of(context).push(AppRoutes.productDetailsRoute(product));
  }

  void _onSelectCategory(CategoryModel category) {
    _submit(_query);
    Navigator.of(context).push(AppRoutes.categoryProductsRoute(category.name));
  }

  void _quickAdd(CartProvider cart, ProductModel product) {
    cart.addItem(product, PricingUtils.unitToGrams(product.unit), 1);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart'),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final history = context.watch<SearchHistoryProvider>();
    final isSearching = _query.trim().isNotEmpty;

    final products = isSearching
        ? SearchUtils.searchProducts(_query)
        : <ProductModel>[];
    final categories = isSearching
        ? SearchUtils.searchCategories(_query)
        : <CategoryModel>[];
    final didYouMean = isSearching
        ? SearchUtils.didYouMeanSuggestions(_query)
        : <String>[];
    final hasAnyResult = products.isNotEmpty || categories.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            if (isSearching) ...[
              const SizedBox(height: 12),
              _buildTabs(products.length, categories.length),
            ],
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                child: !isSearching
                    ? _buildInitialState(history)
                    : !hasAnyResult
                    ? SearchNoResults(
                        query: _query,
                        onClearSearch: _clearSearch,
                      )
                    : _buildResults(products, categories, didYouMean),
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
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: AppColors.textHint, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      textInputAction: TextInputAction.search,
                      onSubmitted: _submit,
                      decoration: const InputDecoration(
                        hintText: AppStrings.searchForMeatCutsHint,
                        hintStyle: TextStyle(
                          color: AppColors.textHint,
                          fontSize: 13,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  if (_query.isNotEmpty)
                    InkWell(
                      onTap: _clearSearch,
                      borderRadius: BorderRadius.circular(16),
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.close,
                          size: 18,
                          color: AppColors.textHint,
                        ),
                      ),
                    )
                  else
                    InkWell(
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Voice search — ${AppStrings.comingSoon}',
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      ),
                      borderRadius: BorderRadius.circular(16),
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.mic_none,
                          size: 20,
                          color: AppColors.textHint,
                        ),
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

  Widget _buildTabs(int productCount, int categoryCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _TabPill(
            label: AppStrings.allTab,
            selected: _tab == _SearchTab.all,
            onTap: () => setState(() => _tab = _SearchTab.all),
          ),
          const SizedBox(width: 20),
          _TabPill(
            label: '${AppStrings.productsTabLabel} ($productCount)',
            selected: _tab == _SearchTab.products,
            onTap: () => setState(() => _tab = _SearchTab.products),
          ),
          const SizedBox(width: 20),
          _TabPill(
            label: '${AppStrings.categoriesTabLabel} ($categoryCount)',
            selected: _tab == _SearchTab.categories,
            onTap: () => setState(() => _tab = _SearchTab.categories),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialState(SearchHistoryProvider history) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        if (history.recent.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                AppStrings.recentSearchesTitle,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
              GestureDetector(
                onTap: () => context.read<SearchHistoryProvider>().clear(),
                child: const Text(
                  AppStrings.clearAllLabel,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: history.recent
                .map(
                  (term) => RemovableSearchChip(
                    label: term,
                    onTap: () => _runSearch(term),
                    onRemove: () =>
                        context.read<SearchHistoryProvider>().remove(term),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 22),
        ],
        const Text(
          AppStrings.popularSearchesTitle,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: DummySearchData.popularSearches
              .map(
                (term) => PopularSearchChip(
                  label: term,
                  onTap: () => _runSearch(term),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 22),
        const Text(
          AppStrings.searchSuggestionsTitle,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 6),
        ...DummySearchData.searchSuggestions.map(
          (term) => InkWell(
            onTap: () => _runSearch(term),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  const Icon(Icons.search, size: 16, color: AppColors.textHint),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      term,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.north_west,
                    size: 15,
                    color: AppColors.textHint,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          AppStrings.searchByCategoryTitle,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 84,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: DummyData.categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final category = DummyData.categories[index];
              return InkWell(
                onTap: () => _onSelectCategory(category),
                borderRadius: BorderRadius.circular(30),
                child: Column(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: const BoxDecoration(
                        color: AppColors.primarySoft,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(11),
                        child: Image.asset(category.icon, fit: BoxFit.contain),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      category.name,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primarySoft,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      AppStrings.findBestMeatsTitle,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      AppStrings.findBestMeatsDesc,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.travel_explore,
                size: 36,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResults(
    List<ProductModel> products,
    List<CategoryModel> categories,
    List<String> didYouMean,
  ) {
    final cart = context.read<CartProvider>();

    switch (_tab) {
      case _SearchTab.all:
        final previewProducts = products.take(4).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (didYouMean.isNotEmpty) ...[
              const Text(
                AppStrings.didYouMeanLabel,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: didYouMean
                    .map(
                      (s) =>
                          _SuggestionChip(label: s, onTap: () => _runSearch(s)),
                    )
                    .toList(),
              ),
              const SizedBox(height: 18),
            ],
            if (products.isNotEmpty) ...[
              Text(
                '${AppStrings.productsTabLabel} (${products.length})',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 12),
              ...previewProducts.map(
                (p) => SearchProductRow(
                  product: p,
                  onTap: () => _onSelectProduct(p),
                  onAdd: () => _quickAdd(cart, p),
                ),
              ),
              if (products.length > 4)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => setState(() => _tab = _SearchTab.products),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      minimumSize: const Size(0, 46),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      '${AppStrings.viewAllResultsPrefix} ${products.length} ${AppStrings.resultsSuffix}',
                    ),
                  ),
                ),
            ],
            if (categories.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text(
                '${AppStrings.categoriesTabLabel} (${categories.length})',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 12),
              ...categories.map(
                (c) => SearchCategoryRow(
                  category: c,
                  productCount: DummyData.allProducts
                      .where((p) => p.category == c.name)
                      .length,
                  onTap: () => _onSelectCategory(c),
                ),
              ),
            ],
          ],
        );

      case _SearchTab.products:
        return Column(
          children: products
              .map(
                (p) => SearchProductRow(
                  product: p,
                  onTap: () => _onSelectProduct(p),
                  onAdd: () => _quickAdd(cart, p),
                ),
              )
              .toList(),
        );

      case _SearchTab.categories:
        return Column(
          children: categories
              .map(
                (c) => SearchCategoryRow(
                  category: c,
                  productCount: DummyData.allProducts
                      .where((p) => p.category == c.name)
                      .length,
                  onTap: () => _onSelectCategory(c),
                ),
              )
              .toList(),
        );
    }
  }
}

class _TabPill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
              color: selected ? AppColors.primary : AppColors.textHint,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 2.4,
            width: 30,
            color: selected ? AppColors.primary : Colors.transparent,
          ),
        ],
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SuggestionChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: AppColors.primarySoft,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
