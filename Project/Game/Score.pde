class Score {
  private LinkedList<Float> scoreList;
  private float score;
  private float lastScore;
  private float minValue;
  private float maxValue;

  Score() {
    score = 0;
    lastScore = 0;
    minValue = 0;
    maxValue = 0;
    scoreList = new LinkedList<Float>();
    scoreList.add(score);
    scoreList.add(score);
  }

  void addThis(PVector velocity) {
    lastScore = velocity.mag();
    score += lastScore;
    updateMinMax();
    scoreList.add(score);
  }

  void subThis(PVector velocity) {
    lastScore = - velocity.mag();
    score += lastScore;
    updateMinMax();
    scoreList.add(score);
  }

  float getValue() {
    return score;
  }

  float getLast() {
    return lastScore;
  }

  float getMin() {
    return minValue;
  }
  
  float getMax() {
    return maxValue;  
  }

  LinkedList<Float> getList() {
    return scoreList;
  }

  private void updateMinMax() {
    if (score < minValue) {
      minValue = score;
    }
    if (score > maxValue) {
      maxValue = score;
    }
  }
}