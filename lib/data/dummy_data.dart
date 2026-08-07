import 'package:meathub/core/constants/app_assets.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/models/category_model.dart';
import 'package:meathub/models/product_model.dart';

class DummyData {
  DummyData._();

  static const List<String> banners = [
    AppAssets.banner1,
    AppAssets.banner2,
    AppAssets.banner3,
    AppAssets.banner4,
    AppAssets.banner5,
  ];

  static const List<CategoryModel> categories = [
    CategoryModel(name: AppStrings.categoryBeefLabel, icon: AppAssets.categoryBeef),
    CategoryModel(name: AppStrings.categoryMuttonLabel, icon: AppAssets.categoryMutton),
    CategoryModel(name: AppStrings.categoryChickenLabel, icon: AppAssets.categoryChicken),
    CategoryModel(name: AppStrings.categoryFishLabel, icon: AppAssets.categoryFish),
    CategoryModel(name: AppStrings.categoryEggLabel, icon: AppAssets.categoryEgg),
  ];

  static const List<ProductModel> popularToday = [
    ProductModel(
      id: 'premium_beef',
      name: 'Premium Beef',
      image: AppAssets.premiumBeef,
      category: 'Beef',
      price: '850',
      originalPrice: '950',
      unit: '1 kg',
      rating: 4.9,
      reviewCount: 128,
    ),
    ProductModel(
      id: 'chicken_curry_cut',
      name: 'Chicken Curry Cut',
      image: AppAssets.chickenCurryCut,
      category: 'Chicken',
      price: '220',
      originalPrice: '220',
      unit: '1 kg',
      rating: 4.7,
      reviewCount: 156,
    ),
    ProductModel(
      id: 'mutton',
      name: 'Mutton Curry Cut',
      image: AppAssets.mutton,
      category: 'Mutton',
      price: '980',
      originalPrice: '1150',
      unit: '1 kg',
      rating: 4.8,
      reviewCount: 96,
    ),
  ];

  static const List<ProductModel> todaysFreshPicks = [
    ProductModel(
      id: 'rui_fish',
      name: 'Rui Fish',
      image: AppAssets.ruiFish,
      category: 'Fish',
      price: '380',
      originalPrice: '380',
      unit: '1 kg',
      rating: 4.5,
      reviewCount: 64,
    ),
    ProductModel(
      id: 'beef_mince',
      name: 'Beef Mince',
      image: AppAssets.beefMince,
      category: 'Beef',
      price: '680',
      originalPrice: '680',
      unit: '1 kg',
      rating: 4.6,
      reviewCount: 82,
    ),
    ProductModel(
      id: 'beef_liver',
      name: 'Beef Liver',
      image: AppAssets.beefLiver,
      category: 'Beef',
      price: '260',
      originalPrice: '320',
      unit: '500 g',
      rating: 4.6,
      reviewCount: 74,
    ),
    ProductModel(
      id: 'chicken_wings',
      name: 'Chicken Wings',
      image: AppAssets.chickenWings,
      category: 'Chicken',
      price: '280',
      originalPrice: '280',
      unit: '1 kg',
      rating: 4.7,
      reviewCount: 210,
    ),
    ProductModel(
      id: 'chicken_liver',
      name: 'Chicken Liver',
      image: AppAssets.chickenLiver,
      category: 'Chicken',
      price: '180',
      originalPrice: '180',
      unit: '500 g',
      rating: 4.4,
      reviewCount: 51,
    ),
  ];
}