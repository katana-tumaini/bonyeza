import 'package:shared_preferences/shared_preferences.dart';

class SettingsManager {
  static const String _audioEnabledKey = 'audio_enabled';
  static const String _hapticsEnabledKey = 'haptics_enabled';

  // Save audio enabled setting
  static Future<void> setAudioEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_audioEnabledKey, enabled);
  }

  // Get audio enabled setting
  static Future<bool> getAudioEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_audioEnabledKey) ?? true; // Default to true
  }

  // Save haptics enabled setting
  static Future<void> setHapticsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hapticsEnabledKey, enabled);
  }

  // Get haptics enabled setting
  static Future<bool> getHapticsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hapticsEnabledKey) ?? true; // Default to true
  }
}