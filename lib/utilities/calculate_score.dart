Map<String, int> calculateScore(Map<String, dynamic> feedback) {
  const double maxScore = 100;
  double totalWeight = 0;
  double weightedSum = 0;

  Map<String, double> weights = {
    'Right Shoulder': 1.0,
    'Left Shoulder': 1.0,
    'Right Hip': 1.0,
    'Left Hip': 1.0,
    'Right Knee': 1.0,
    'Left Knee': 1.0,
    'Right Elbow': 1.0,
    'Left Elbow': 1.0,
    'Right Wrist': 1.0,
    'Left Wrist': 1.0,
    'Right Ankle': 1.0,
    'Left Ankle': 1.0,
  };

  feedback.forEach((angle, data) {
    int deviationCount = data['count']!;
    int totalFrames = data['total']!;
    double deviationRatio = deviationCount / totalFrames;
    double weightedDeviation = deviationRatio * weights[angle]!;
    weightedSum += weightedDeviation;
    totalWeight += weights[angle]!;
  });

  double averageWeightedDeviation = weightedSum / totalWeight;
  double score = maxScore * (1 - averageWeightedDeviation);

  if (score < 0) score = 0;
  if (score > maxScore) score = maxScore;

  return {
    'score': score.round(),
    'maxScore': maxScore.toInt(),
  };
}
