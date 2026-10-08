import 'package:audioplayers/audioplayers.dart';
import 'package:bonyeza/technical/settings_manager.dart';

class AudioManager {
  final AudioPlayer _soundEffectPlayer = AudioPlayer();

  bool _audioEnabled = true;

  final AudioContext _audioContext = AudioContext(
    android: AudioContextAndroid(
      audioFocus: AndroidAudioFocus.none,
      contentType: AndroidContentType.sonification,
      usageType: AndroidUsageType.assistanceSonification,
    ),
  );

  AudioManager() {
    _loadAudioSetting();
  }

  Future<void> _loadAudioSetting() async {
    _audioEnabled = await SettingsManager.getAudioEnabled();
  }

  Future<void> reloadSettings() async {
    await _loadAudioSetting();
  }

  Future<void> playTapSound() async {
    if (!_audioEnabled) return;

    final player = AudioPlayer();

    try {
      await player.play(
        AssetSource('tap.wav'),
        ctx: _audioContext,
      );

      Future.delayed(const Duration(milliseconds: 500), () {
        player.dispose();
      });
    } catch (e) {
      print('Error playing tap sound: $e');

      await player.dispose();
    }
  }

  Future<void> playGameOverSound() async {
    if (!_audioEnabled) return;

    final player = AudioPlayer();

    try {
      await player.play(
        AssetSource('game_over.wav'),
        ctx: _audioContext,
      );

      Future.delayed(const Duration(seconds: 2), () {
        player.dispose();
      });
    } catch (e) {
      print('Error playing game over sound: $e');

      await player.dispose();
    }
  }

  void dispose() {
    _soundEffectPlayer.dispose();
  }
}