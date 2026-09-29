import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  Future<void> playTapSound() async {
    await _audioPlayer.play(AssetSource('tap.wav'));
  }

  Future<void> playGameOverSound() async {
    await _audioPlayer.play(AssetSource('game_over.wav'));
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
