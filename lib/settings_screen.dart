import 'package:flutter/material.dart';
import 'package:bonyeza/technical/settings_manager.dart';
import 'package:bonyeza/technical/background_music.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback onBack;

  const SettingsScreen({
    super.key,
    required this.onBack,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _audioEnabled = true;
  bool _hapticsEnabled = true;
  bool _musicEnabled = true;

  // music manager - use singleton
  final BackgroundMusic _backgroundMusic = BackgroundMusic();

  @override
  void initState() {
    super.initState();
    _loadSettings();
    // Initialize music first, then load settings
    _backgroundMusic.initialize().then((_) {
      _loadMusicSetting();
    });
  }

  Future<void> _loadSettings() async {
    final audioEnabled = await SettingsManager.getAudioEnabled();
    final hapticsEnabled = await SettingsManager.getHapticsEnabled();

    setState(() {
      _audioEnabled = audioEnabled;
      _hapticsEnabled = hapticsEnabled;
    });
  }

  // Load saved music setting
  Future<void> _loadMusicSetting() async {
    final musicEnabled = _backgroundMusic.isMusicEnabled;
    print('Loading music setting: $musicEnabled');

    setState(() {
      _musicEnabled = musicEnabled;
    });
  }

  Future<void> _toggleAudio(bool value) async {
    await SettingsManager.setAudioEnabled(value);

    setState(() {
      _audioEnabled = value;
    });
  }

  Future<void> _toggleHaptics(bool value) async {
    await SettingsManager.setHapticsEnabled(value);

    setState(() {
      _hapticsEnabled = value;
    });
  }

  Future<void> _toggleMusic(bool value) async {
    print('Toggle music called with value: $value');
    await _backgroundMusic.setMusicEnabled(value);

    setState(() {
      _musicEnabled = value;
    });
    print('Music enabled state updated to: $_musicEnabled');
  }

  @override
  Widget build(BuildContext context) {
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
          'Settings',
          style: TextStyle(
            fontFamily: 'PressStart',
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            Container(
              width: 300,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.black, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(4, 4),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Music',
                    style: TextStyle(
                      fontFamily: 'PressStart',
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                  Switch(
                    value: _musicEnabled,
                    onChanged: _toggleMusic,
                    activeColor: const Color(0xFF4ECDC4),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Audio Setting
            Container(
              width: 300,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.black, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(4, 4),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Sound',
                    style: TextStyle(
                      fontFamily: 'PressStart',
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                  Switch(
                    value: _audioEnabled,
                    onChanged: _toggleAudio,
                    activeColor: const Color(0xFF4ECDC4),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Haptics Setting
            Container(
              width: 300,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.black, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(4, 4),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Haptics',
                    style: TextStyle(
                      fontFamily: 'PressStart',
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                  Switch(
                    value: _hapticsEnabled,
                    onChanged: _toggleHaptics,
                    activeColor: const Color(0xFF4ECDC4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}