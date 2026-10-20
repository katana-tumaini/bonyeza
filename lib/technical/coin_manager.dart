import 'package:shared_preferences/shared_preferences.dart';

class CoinManager {
  static const String _coinsKey = 'coins';
  static const String _selectedButtonIdKey = 'selected_button_id';
  static const String _purchasedButtonsKey = 'purchased_buttons';

  // Save coins
  static Future<void> saveCoins(int coins) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_coinsKey, coins);
  }

  // Get coins
  static Future<int> getCoins() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_coinsKey) ?? 0;
  }

  // Add coins
  static Future<void> addCoins(int amount) async {
    final currentCoins = await getCoins();
    await saveCoins(currentCoins + amount);
  }

  // Deduct coins (returns true if successful, false if not enough coins)
  static Future<bool> deductCoins(int amount) async {
    final currentCoins = await getCoins();
    if (currentCoins >= amount) {
      await saveCoins(currentCoins - amount);
      return true;
    }
    return false;
  }

  // Save selected button ID
  static Future<void> setSelectedButtonId(String buttonId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedButtonIdKey, buttonId);
  }

  // Get selected button ID
  static Future<String> getSelectedButtonId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_selectedButtonIdKey) ?? 'default';
  }

  // Save purchased button IDs
  static Future<void> savePurchasedButtons(List<String> buttonIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_purchasedButtonsKey, buttonIds);
  }

  // Get purchased button IDs
  static Future<List<String>> getPurchasedButtons() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_purchasedButtonsKey) ?? ['default'];
  }

  // Check if a button is purchased
  static Future<bool> isButtonPurchased(String buttonId) async {
    final purchasedButtons = await getPurchasedButtons();
    return purchasedButtons.contains(buttonId);
  }

  // Purchase a button (returns true if successful)
  static Future<bool> purchaseButton(String buttonId, int cost) async {
    final canPurchase = await deductCoins(cost);
    if (canPurchase) {
      final purchasedButtons = await getPurchasedButtons();
      if (!purchasedButtons.contains(buttonId)) {
        purchasedButtons.add(buttonId);
        await savePurchasedButtons(purchasedButtons);
      }
      return true;
    }
    return false;
  }

  // Reset all data (for testing)
  static Future<void> resetAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_coinsKey);
    await prefs.remove(_selectedButtonIdKey);
    await prefs.remove(_purchasedButtonsKey);
  }
}
