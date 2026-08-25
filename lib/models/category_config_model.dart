class CategoryConfigModel {
  final String label;
  final String icon;
  final int themeColorValue;
  final int themeBgValue;
  final String tagline;
  final List<String> chips;

  const CategoryConfigModel({
    required this.label,
    required this.icon,
    required this.themeColorValue,
    required this.themeBgValue,
    required this.tagline,
    required this.chips,
  });
}