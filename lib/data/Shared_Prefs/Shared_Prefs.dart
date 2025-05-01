import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const String _keyName = 'name';
  static const String _keyUsername = 'username';
  static const String _keyQuote = 'quote';
  static const String _keyProfileImage = 'profileImage';

  // Save profile data
  static Future<void> saveProfileData(Map<String, String?> details) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyName, details['name'] ?? '');
    await prefs.setString(_keyUsername, details['username'] ?? '');
    await prefs.setString(_keyQuote, details['quote'] ?? '');
    if (details['profileImage'] != null && details['profileImage']!.isNotEmpty) {
      await prefs.setString(_keyProfileImage, details['profileImage']!);
    } else {
      await prefs.remove(_keyProfileImage);
    }
  }

  // Load profile data
  static Future<Map<String, String?>> loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString(_keyName),
      'username': prefs.getString(_keyUsername),
      'quote': prefs.getString(_keyQuote),
      'profileImage': prefs.getString(_keyProfileImage),
    };
  }

  // Clear profile data (optional, for logout or reset)
  static Future<void> clearProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyName);
    await prefs.remove(_keyUsername);
    await prefs.remove(_keyQuote);
    await prefs.remove(_keyProfileImage);
  }
}