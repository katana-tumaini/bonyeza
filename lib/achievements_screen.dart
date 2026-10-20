import 'package:flutter/material.dart';
import 'package:bonyeza/models/achievement.dart';
import 'package:bonyeza/technical/achievement_manager.dart';

class AchievementsScreen extends StatefulWidget {
  final VoidCallback onBack;

  const AchievementsScreen({super.key, required this.onBack});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  List<String> _unlockedAchievements = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAchievements();
  }

  Future<void> _loadAchievements() async {
    final unlocked = await AchievementManager.getUnlockedAchievements();
    setState(() {
      _unlockedAchievements = unlocked;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.blue[50],
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: widget.onBack,
            color: Colors.black,
          ),
          title: const Text(
            'Achievements',
            style: TextStyle(
              fontFamily: 'PressStart',
              fontSize: 10,
            ),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
          color: Colors.black,
        ),
        title: const Text(
          'Achievements',
          style: TextStyle(
            fontFamily: 'PressStart',
            fontSize: 10,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.amber[400],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Row(
              children: [
                const Icon(Icons.emoji_events, size: 18, color: Colors.black),
                const SizedBox(width: 4),
                Text(
                  '${_unlockedAchievements.length}/${Achievement.achievements.length}',
                  style: const TextStyle(
                    fontFamily: 'PressStart',
                    fontSize: 8,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: Achievement.achievements.length,
        itemBuilder: (context, index) {
          final achievement = Achievement.achievements[index];
          final isUnlocked = _unlockedAchievements.contains(achievement.id);

          return _AchievementCard(
            achievement: achievement,
            isUnlocked: isUnlocked,
          );
        },
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final Achievement achievement;
  final bool isUnlocked;

  const _AchievementCard({
    required this.achievement,
    required this.isUnlocked,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<double>(
      future: AchievementManager.getAchievementProgress(achievement),
      builder: (context, snapshot) {
        final progress = snapshot.data ?? 0.0;
        final progressPercent = (progress * 100).clamp(0.0, 100.0);

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: isUnlocked ? Colors.white : Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isUnlocked ? achievement.color : Colors.grey,
              width: isUnlocked ? 3 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isUnlocked ? achievement.color : Colors.grey[400],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: Icon(
                    achievement.icon,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        achievement.name,
                        style: TextStyle(
                          fontFamily: 'PressStart',
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: isUnlocked ? Colors.black : Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        achievement.description,
                        style: TextStyle(
                          fontSize: 10,
                          color: isUnlocked ? Colors.black87 : Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (!isUnlocked)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: LinearProgressIndicator(
                                    value: progress,
                                    backgroundColor: Colors.grey[300],
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      achievement.color,
                                    ),
                                    minHeight: 6,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${progressPercent.toStringAsFixed(0)}%',
                                  style: const TextStyle(
                                    fontFamily: 'PressStart',
                                    fontSize: 8,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'UNLOCKED',
                            style: TextStyle(
                              fontFamily: 'PressStart',
                              fontSize: 6,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
