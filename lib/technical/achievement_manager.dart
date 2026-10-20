import 'package:shared_preferences/shared_preferences.dart';
import 'package:bonyeza/models/achievement.dart';

class AchievementManager {
  static const String _unlockedAchievementsKey = 'unlocked_achievements';
  static const String _totalTapsKey = 'total_taps';
  static const String _totalCoinsEarnedKey = 'total_coins_earned';
  static const String _totalPurchasesKey = 'total_purchases';
  static const String _highestScoreKey = 'highest_score_achievement';

  // Track current game stats
  static int _currentGameScore = 0;

  // Get unlocked achievements
  static Future<List<String>> getUnlockedAchievements() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_unlockedAchievementsKey) ?? [];
  }

  // Check if achievement is unlocked
  static Future<bool> isAchievementUnlocked(String achievementId) async {
    final unlocked = await getUnlockedAchievements();
    return unlocked.contains(achievementId);
  }

  // Unlock achievement
  static Future<bool> unlockAchievement(String achievementId) async {
    final unlocked = await getUnlockedAchievements();
    if (unlocked.contains(achievementId)) {
      return false; // Already unlocked
    }

    unlocked.add(achievementId);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_unlockedAchievementsKey, unlocked);
    return true;
  }

  // Get total taps
  static Future<int> getTotalTaps() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_totalTapsKey) ?? 0;
  }

  // Increment total taps
  static Future<void> incrementTotalTaps(int count) async {
    final current = await getTotalTaps();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_totalTapsKey, current + count);
    await checkTapAchievements(current + count);
  }

  // Get total coins earned
  static Future<int> getTotalCoinsEarned() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_totalCoinsEarnedKey) ?? 0;
  }

  // Add to total coins earned
  static Future<void> addTotalCoinsEarned(int amount) async {
    final current = await getTotalCoinsEarned();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_totalCoinsEarnedKey, current + amount);
    await checkCoinAchievements(current + amount);
  }

  // Get total purchases
  static Future<int> getTotalPurchases() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_totalPurchasesKey) ?? 0;
  }

  // Increment total purchases
  static Future<void> incrementTotalPurchases() async {
    final current = await getTotalPurchases();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_totalPurchasesKey, current + 1);
    await checkPurchaseAchievements(current + 1);
  }

  // Get highest score
  static Future<int> getHighestScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_highestScoreKey) ?? 0;
  }

  // Update highest score
  static Future<void> updateHighestScore(int score) async {
    final current = await getHighestScore();
    if (score > current) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_highestScoreKey, score);
      await checkScoreAchievements(score);
    }
  }

  // Set current game score (for tracking single game achievements)
  static void setCurrentGameScore(int score) {
    _currentGameScore = score;
  }

  // Check and unlock tap achievements
  static Future<void> checkTapAchievements(int totalTaps) async {
    final tapAchievements = Achievement.getByType(AchievementType.taps);
    for (final achievement in tapAchievements) {
      if (totalTaps >= achievement.target) {
        await unlockAchievement(achievement.id);
      }
    }
  }

  // Check and unlock score achievements
  static Future<void> checkScoreAchievements(int score) async {
    final scoreAchievements = Achievement.getByType(AchievementType.score);
    for (final achievement in scoreAchievements) {
      if (score >= achievement.target) {
        await unlockAchievement(achievement.id);
      }
    }

    // Check special high score achievement
    final highScoreAchievement = Achievement.getById('special_high_score');
    if (highScoreAchievement != null && score >= highScoreAchievement.target) {
      await unlockAchievement(highScoreAchievement.id);
    }

    // Check speed demon achievement (score 50 in one game)
    final speedDemonAchievement = Achievement.getById('special_speed_demon');
    if (speedDemonAchievement != null && _currentGameScore >= speedDemonAchievement.target) {
      await unlockAchievement(speedDemonAchievement.id);
    }
  }

  // Check and unlock coin achievements
  static Future<void> checkCoinAchievements(int totalCoins) async {
    final coinAchievements = Achievement.getByType(AchievementType.coins);
    for (final achievement in coinAchievements) {
      if (totalCoins >= achievement.target) {
        await unlockAchievement(achievement.id);
      }
    }
  }

  // Check and unlock purchase achievements
  static Future<void> checkPurchaseAchievements(int totalPurchases) async {
    final purchaseAchievements = Achievement.getByType(AchievementType.purchases);
    for (final achievement in purchaseAchievements) {
      if (totalPurchases >= achievement.target) {
        await unlockAchievement(achievement.id);
      }
    }
  }

  // Get achievement progress
  static Future<double> getAchievementProgress(Achievement achievement) async {
    switch (achievement.type) {
      case AchievementType.taps:
        final taps = await getTotalTaps();
        return taps / achievement.target;
      case AchievementType.score:
        final highestScore = await getHighestScore();
        return highestScore / achievement.target;
      case AchievementType.coins:
        final coins = await getTotalCoinsEarned();
        return coins / achievement.target;
      case AchievementType.purchases:
        final purchases = await getTotalPurchases();
        return purchases / achievement.target;
      case AchievementType.special:
        final highestScore = await getHighestScore();
        return highestScore / achievement.target;
    }
  }

  // Get current value for achievement type
  static Future<int> getCurrentValue(AchievementType type) async {
    switch (type) {
      case AchievementType.taps:
        return await getTotalTaps();
      case AchievementType.score:
        return await getHighestScore();
      case AchievementType.coins:
        return await getTotalCoinsEarned();
      case AchievementType.purchases:
        return await getTotalPurchases();
      case AchievementType.special:
        return await getHighestScore();
    }
  }

  // Reset all data (for testing)
  static Future<void> resetAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_unlockedAchievementsKey);
    await prefs.remove(_totalTapsKey);
    await prefs.remove(_totalCoinsEarnedKey);
    await prefs.remove(_totalPurchasesKey);
    await prefs.remove(_highestScoreKey);
  }
}
