class GameLogic {
  int score = 0;
  
  void incrementScore() {
    score++;
  }
  
  void resetScore() {
    score = 0;
  }
  
  int getScore() {
    return score;
  }
}
