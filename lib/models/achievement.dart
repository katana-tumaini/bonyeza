import 'package:flutter/material.dart';

enum AchievementType {
  taps,
  score,
  coins,
  purchases,
  special,
}

class Achievement {
  final String id;
  final String name;
  final String description;
  final AchievementType type;
  final int target;
  final IconData icon;
  final Color color;

  const Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.target,
    required this.icon,
    required this.color,
  });

  // Predefined achievements
  static const List<Achievement> achievements = [
    // Tap achievements
    Achievement(
      id: 'taps_100',
      name: 'First Steps',
      description: 'Tap 100 buttons',
      type: AchievementType.taps,
      target: 100,
      icon: Icons.touch_app,
      color: Colors.blue,
    ),
    Achievement(
      id: 'taps_500',
      name: 'Getting Warmer',
      description: 'Tap 500 buttons',
      type: AchievementType.taps,
      target: 500,
      icon: Icons.touch_app,
      color: Colors.green,
    ),
    Achievement(
      id: 'taps_1000',
      name: 'Tap Master',
      description: 'Tap 1,000 buttons',
      type: AchievementType.taps,
      target: 1000,
      icon: Icons.touch_app,
      color: Colors.orange,
    ),
    Achievement(
      id: 'taps_5000',
      name: 'Tap Legend',
      description: 'Tap 5,000 buttons',
      type: AchievementType.taps,
      target: 5000,
      icon: Icons.touch_app,
      color: Colors.purple,
    ),
    Achievement(
      id: 'taps_10000',
      name: 'Tap God',
      description: 'Tap 10,000 buttons',
      type: AchievementType.taps,
      target: 10000,
      icon: Icons.touch_app,
      color: Colors.red,
    ),

    // Score achievements
    Achievement(
      id: 'score_10',
      name: 'Getting Started',
      description: 'Score 10 points',
      type: AchievementType.score,
      target: 10,
      icon: Icons.star,
      color: Colors.yellow,
    ),
    Achievement(
      id: 'score_50',
      name: 'Rising Star',
      description: 'Score 50 points',
      type: AchievementType.score,
      target: 50,
      icon: Icons.star,
      color: Colors.orange,
    ),
    Achievement(
      id: 'score_100',
      name: 'Century',
      description: 'Score 100 points',
      type: AchievementType.score,
      target: 100,
      icon: Icons.star,
      color: Colors.red,
    ),
    Achievement(
      id: 'score_500',
      name: 'Half Grand',
      description: 'Score 500 points',
      type: AchievementType.score,
      target: 500,
      icon: Icons.star,
      color: Colors.purple,
    ),
    Achievement(
      id: 'score_1000',
      name: 'Grand Master',
      description: 'Score 1,000 points',
      type: AchievementType.score,
      target: 1000,
      icon: Icons.star,
      color: Colors.blue,
    ),

    // Coin achievements
    Achievement(
      id: 'coins_100',
      name: 'First Coin',
      description: 'Earn 100 coins',
      type: AchievementType.coins,
      target: 100,
      icon: Icons.monetization_on,
      color: Colors.yellow,
    ),
    Achievement(
      id: 'coins_500',
      name: 'Coin Collector',
      description: 'Earn 500 coins',
      type: AchievementType.coins,
      target: 500,
      icon: Icons.monetization_on,
      color: Colors.orange,
    ),
    Achievement(
      id: 'coins_1000',
      name: 'Coin Hoarder',
      description: 'Earn 1,000 coins',
      type: AchievementType.coins,
      target: 1000,
      icon: Icons.monetization_on,
      color: Colors.red,
    ),
    Achievement(
      id: 'coins_5000',
      name: 'Coin Tycoon',
      description: 'Earn 5,000 coins',
      type: AchievementType.coins,
      target: 5000,
      icon: Icons.monetization_on,
      color: Colors.purple,
    ),
    Achievement(
      id: 'coins_10000',
      name: 'Coin King',
      description: 'Earn 10,000 coins',
      type: AchievementType.coins,
      target: 10000,
      icon: Icons.monetization_on,
      color: Colors.blue,
    ),

    // Purchase achievements
    Achievement(
      id: 'purchase_1',
      name: 'First Purchase',
      description: 'Buy your first button',
      type: AchievementType.purchases,
      target: 1,
      icon: Icons.shopping_cart,
      color: Colors.green,
    ),
    Achievement(
      id: 'purchase_5',
      name: 'Collector',
      description: 'Buy 5 buttons',
      type: AchievementType.purchases,
      target: 5,
      icon: Icons.shopping_cart,
      color: Colors.blue,
    ),
    Achievement(
      id: 'purchase_10',
      name: 'Hoarder',
      description: 'Buy 10 buttons',
      type: AchievementType.purchases,
      target: 10,
      icon: Icons.shopping_cart,
      color: Colors.purple,
    ),
    Achievement(
      id: 'purchase_15',
      name: 'Enthusiast',
      description: 'Buy 15 buttons',
      type: AchievementType.purchases,
      target: 15,
      icon: Icons.shopping_cart,
      color: Colors.orange,
    ),
    Achievement(
      id: 'purchase_20',
      name: 'Completionist',
      description: 'Buy all 20 buttons',
      type: AchievementType.purchases,
      target: 20,
      icon: Icons.shopping_cart,
      color: Colors.red,
    ),

    // Special achievements
    Achievement(
      id: 'special_high_score',
      name: 'High Scorer',
      description: 'Reach a high score of 100',
      type: AchievementType.special,
      target: 100,
      icon: Icons.emoji_events,
      color: Colors.amber,
    ),
    Achievement(
      id: 'special_speed_demon',
      name: 'Speed Demon',
      description: 'Score 50 points in one game',
      type: AchievementType.special,
      target: 50,
      icon: Icons.speed,
      color: Colors.red,
    ),
  ];

  // Get achievement by ID
  static Achievement? getById(String id) {
    try {
      return achievements.firstWhere((achievement) => achievement.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get achievements by type
  static List<Achievement> getByType(AchievementType type) {
    return achievements.where((achievement) => achievement.type == type).toList();
  }
}
