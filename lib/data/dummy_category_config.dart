import 'package:meathub/core/constants/app_assets.dart';
import 'package:meathub/models/category_config_model.dart';

class DummyCategoryConfig {
  DummyCategoryConfig._();

  static const Map<String, CategoryConfigModel> configs = {
    'Beef': CategoryConfigModel(
      label: 'Beef',
      icon: AppAssets.categoryBeef,
      themeColorValue: 0xFFB71C1C,
      themeBgValue: 0xFFFBE8E8,
      tagline: 'Premium quality beef',
      chips: ['All', 'Curry Cut', 'Boneless', 'Mince', 'Liver', 'Bone'],
    ),
    'Mutton': CategoryConfigModel(
      label: 'Mutton',
      icon: AppAssets.categoryMutton,
      themeColorValue: 0xFFB71C1C,
      themeBgValue: 0xFFFBE8E8,
      tagline: 'Tender & premium quality mutton',
      chips: ['All', 'Curry Cut', 'Ribs', 'Leg', 'Liver', 'Mince'],
    ),
    'Chicken': CategoryConfigModel(
      label: 'Chicken',
      icon: AppAssets.categoryChicken,
      themeColorValue: 0xFFB2560A,
      themeBgValue: 0xFFFFEFDD,
      tagline: 'Fresh & hygienic chicken',
      chips: ['All', 'Curry Cut', 'Whole', 'Boneless', 'Liver', 'Wings'],
    ),
    'Fish': CategoryConfigModel(
      label: 'Fish',
      icon: AppAssets.categoryFish,
      themeColorValue: 0xFF3F5FBF,
      themeBgValue: 0xFFE8EEFB,
      tagline: 'Fresh water & sea fish',
      chips: ['All', 'Rui', 'Katla', 'Hilsa', 'Pangas', 'Tilapia'],
    ),
    'Prawn': CategoryConfigModel(
      label: 'Prawn',
      icon: AppAssets.categoryPrawn,
      themeColorValue: 0xFFE2136E,
      themeBgValue: 0xFFFCE4EF,
      tagline: 'Fresh & delicious prawns',
      chips: ['All', 'Golda', 'Bagda', 'Tiger', 'Medium', 'Small'],
    ),
    'Egg': CategoryConfigModel(
      label: 'Egg',
      icon: AppAssets.categoryEgg,
      themeColorValue: 0xFFB8860B,
      themeBgValue: 0xFFFFF3D6,
      tagline: 'Farm fresh eggs',
      chips: ['All', 'White', 'Brown', 'Deshi', 'Organic', 'Duck'],
    ),
  };
}