import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/core/routes/app_routes.dart';
import 'package:meathub/data/dummy_data.dart';
import 'package:meathub/models/category_model.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.categories,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Browse fresh meat by category',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: DummyData.categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 1.05,
                ),
                itemBuilder: (context, index) {
                  final category = DummyData.categories[index];
                  final count = DummyData.allProducts
                      .where((p) => p.category == category.name)
                      .length;
                  return _CategoryGridCard(
                    category: category,
                    count: count,
                    onTap: () => Navigator.of(
                      context,
                    ).push(AppRoutes.categoryProductsRoute(category.name)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryGridCard extends StatelessWidget {
  final CategoryModel category;
  final int count;
  final VoidCallback onTap;

  const _CategoryGridCard({
    required this.category,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: AppColors.primarySoft,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Image.asset(category.icon, fit: BoxFit.contain),
              ),
            ),
            const Spacer(),
            Text(
              category.name,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              '$count ${AppStrings.productsCountSuffix}',
              style: const TextStyle(fontSize: 12, color: AppColors.textHint),
            ),
          ],
        ),
      ),
    );
  }
}
