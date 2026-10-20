import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackgroundMusic {
  static final BackgroundMusic _instance = BackgroundMusic._internal();

  factory BackgroundMusic() => _instance;

  BackgroundMusic._internal();

  AudioPlayer? _player;

  final List<String> _tracks = [
    'pure.mp3',
  ];

  int _currentTrack = 0;
  bool _musicEnabled = true;
  bool _isInitialized = false;
  bool _isDisposed = false;

  // Audio context that allows audio to mix
  final AudioContext _audioContext = AudioContext(
    android: AudioContextAndroid(
      audioFocus: AndroidAudioFocus.none,
      contentType: AndroidContentType.music,
      usageType: AndroidUsageType.media,
    ),
  );

  Future<void> initialize() async {
    if (_isDisposed) {
      print('Background music is disposed, cannot initialize');
      return;
    }

    if (_isInitialized) {
      print('Background music already initialized');
      return;
    }

    print('Initializing background music...');

    // Create player if it doesn't exist
    _player ??= AudioPlayer();

    final prefs = await SharedPreferences.getInstance();

    _musicEnabled = prefs.getBool('musicEnabled') ?? true;

    print('Music enabled from settings: $_musicEnabled');

    // Configure the player BEFORE playback
    await _player!.setAudioContext(_audioContext);

    await _player!.setReleaseMode(ReleaseMode.loop);

    // When a track finishes, play the next track
    _player!.onPlayerComplete.listen((event) {
      print('Track completed, playing next track');
      _playNextTrack();
    });

    _isInitialized = true;

    if (_musicEnabled) {
      print('Music is enabled, starting playback...');
      await _playCurrentTrack();
    } else {
      print('Music is disabled by settings, not starting');
    }
  }

  Future<void> _playCurrentTrack() async {
    if (_isDisposed || _player == null) {
      print('Player is disposed or null, cannot play');
      return;
    }

    if (!_musicEnabled) {
      print('Music is disabled, not playing');
      return;
    }

    try {
      print('Playing track: ${_tracks[_currentTrack]}');

      // Don't stop/release the player every time.
      // Just start the requested track.
      await _player!.play(
        AssetSource(_tracks[_currentTrack]),
        ctx: _audioContext,
      );

      print('Track started successfully');

      await Future.delayed(const Duration(milliseconds: 500));

      final position = await _player!.getCurrentPosition();

      print('Music position after 500ms: $position');
    } catch (e) {
      print('Error playing music: $e');
      // Try to recover by reinitializing
      _isInitialized = false;
    }
  }

  Future<void> _playNextTrack() async {
    if (!_musicEnabled) return;

    _currentTrack++;

    if (_currentTrack >= _tracks.length) {
      _currentTrack = 0;
    }

    await _playCurrentTrack();
  }

  Future<void> setMusicEnabled(bool enabled) async {
    print('Setting music enabled to: $enabled');

    _musicEnabled = enabled;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('musicEnabled', enabled);

    if (enabled) {
      print('Music enabled, starting playback...');

      if (_isDisposed) {
        print('Player is disposed, cannot enable music');
        return;
      }

      if (!_isInitialized) {
        await initialize();
      } else {
        await _playCurrentTrack();
      }
    } else {
      print('Music disabled, stopping playback...');

      if (_player != null && !_isDisposed) {
        try {
          await _player!.stop();
        } catch (e) {
          print('Error stopping music: $e');
        }
      }

      print('Music stopped');
    }
  }

  Future<void> resetToEnabled() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('musicEnabled', true);

    _musicEnabled = true;

    if (!_isInitialized) {
      await initialize();
    } else {
      await _playCurrentTrack();
    }

    print('Music reset to enabled');
  }

  bool get isMusicEnabled => _musicEnabled;

  Future<void> dispose() async {
    _isDisposed = true;
    _isInitialized = false;

    if (_player != null) {
      try {
        await _player!.dispose();
      } catch (e) {
        print('Error disposing player: $e');
      }
      _player = null;
    }

    print('Background music disposed');
  }
}