import 'package:audioplayers/audioplayers.dart';
import 'package:bonyeza/technical/settings_manager.dart';

class AudioManager {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _audioEnabled = true;

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
    if (_audioEnabled) {
      await _audioPlayer.play(AssetSource('tap.wav'));
    }
  }

  Future<void> playGameOverSound() async {
    if (_audioEnabled) {
      await _audioPlayer.play(AssetSource('game_over.wav'));
    }
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
