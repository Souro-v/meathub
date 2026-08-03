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
    ProductModel(name: 'Premium Beef', image: AppAssets.premiumBeef, price: '650', unit: '1 kg'),
    ProductModel(name: 'Chicken Curry Cut', image: AppAssets.chickenCurryCut, price: '220', unit: '1 kg'),
    ProductModel(name: 'Mutton', image: AppAssets.mutton, price: '950', unit: '1 kg'),
  ];

  static const List<ProductModel> todaysFreshPicks = [
    ProductModel(name: 'Rui Fish', image: AppAssets.ruiFish, price: '380', unit: '1 kg'),
    ProductModel(name: 'Beef Mince', image: AppAssets.beefMince, price: '680', unit: '1 kg'),
    ProductModel(name: 'Beef Liver', image: AppAssets.beefLiver, price: '420', unit: '500 g'),
    ProductModel(name: 'Chicken Wings', image: AppAssets.chickenWings, price: '280', unit: '1 kg'),
    ProductModel(name: 'Chicken Liver', image: AppAssets.chickenLiver, price: '180', unit: '500 g'),
  ];
}