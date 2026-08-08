class PricingUtils {
  PricingUtils._();

  static double unitToGrams(String unit) {
    final match = RegExp(
      r'([\d.]+)\s*(kg|g)',
      caseSensitive: false,
    ).firstMatch(unit);
    if (match == null) return 1000;
    final value = double.tryParse(match.group(1) ?? '1') ?? 1;
    final isKg = match.group(2)!.toLowerCase() == 'kg';
    return isKg ? value * 1000 : value;
  }

  static String formatWeight(double grams) {
    if (grams >= 1000) {
      final kg = grams / 1000;
      return kg == kg.roundToDouble()
          ? '${kg.toInt()} kg'
          : '${kg.toStringAsFixed(1)} kg';
    }
    return '${grams.toInt()} g';
  }

  static double priceForWeight({
    required double basePrice,
    required double baseGrams,
    required double targetGrams,
  }) {
    if (baseGrams <= 0) return 0;
    return (basePrice / baseGrams) * targetGrams;
  }
}
