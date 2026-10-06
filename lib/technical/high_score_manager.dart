import 'package:shared_preferences/shared_preferences.dart';

class HighScoreManager {
  static const String _highScoreKey = 'high_score';

  // Save high score
  static Future<void> saveHighScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    final currentHighScore = await getHighScore();
    
    if (score > currentHighScore) {
      await prefs.setInt(_highScoreKey, score);
    }
  }

  // Get high score
  static Future<int> getHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_highScoreKey) ?? 0;
  }

  // Reset high score (for testing)
  static Future<void> resetHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_highScoreKey);
  }
}