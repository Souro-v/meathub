class PointsUtils {
  PointsUtils._();

  static const int milestoneSize = 500;
  static const int pointsPerTaka = 10;

  static double discountValue(int points) => points / pointsPerTaka;

  static int nextMilestone(int currentPoints) {
    return ((currentPoints ~/ milestoneSize) + 1) * milestoneSize;
  }

  static int pointsToNextMilestone(int currentPoints) {
    return nextMilestone(currentPoints) - currentPoints;
  }

  static double progressToNextMilestone(int currentPoints) {
    final milestone = nextMilestone(currentPoints);
    if (milestone == 0) return 0;
    return (currentPoints / milestone).clamp(0, 1);
  }
}