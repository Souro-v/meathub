class RatingUtils {
  RatingUtils._();

  static Map<int, int> estimateBreakdown(double rating, int totalReviews) {
    List<double> weights;
    if (rating >= 4.5) {
      weights = [0.70, 0.20, 0.06, 0.02, 0.02];
    } else if (rating >= 4.0) {
      weights = [0.55, 0.30, 0.09, 0.03, 0.03];
    } else if (rating >= 3.5) {
      weights = [0.40, 0.35, 0.15, 0.06, 0.04];
    } else {
      weights = [0.25, 0.30, 0.25, 0.12, 0.08];
    }

    final counts = <int, int>{};
    int assigned = 0;
    for (int i = 0; i < 5; i++) {
      final star = 5 - i;
      final count = (totalReviews * weights[i]).round();
      counts[star] = count;
      assigned += count;
    }
    counts[5] = (counts[5] ?? 0) + (totalReviews - assigned);
    return counts;
  }
}
