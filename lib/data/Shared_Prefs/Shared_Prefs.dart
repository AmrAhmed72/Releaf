import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const String _keyName = 'name';
  static const String _keyUsername = 'username';
  static const String _keyQuote = 'quote';
  static const String _keyProfileImage = 'profileImage';
  static const String _keyAccessToken = 'accessToken';
  static const String _keyRefreshToken = 'refreshToken';
  static const String _keyExpiresIn = 'expiresIn';
  static const String _keyTokenType = 'tokenType';

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

  // Save authentication tokens
  static Future<void> saveAuthTokens({
    required String accessToken,
    required String refreshToken,
    required int expiresIn,
    required String tokenType,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAccessToken, accessToken);
    await prefs.setString(_keyRefreshToken, refreshToken);
    await prefs.setInt(_keyExpiresIn, expiresIn);
    await prefs.setString(_keyTokenType, tokenType);
  }

  // Load authentication tokens
  static Future<Map<String, dynamic>> loadAuthTokens() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'accessToken': prefs.getString(_keyAccessToken),
      'refreshToken': prefs.getString(_keyRefreshToken),
      'expiresIn': prefs.getInt(_keyExpiresIn),
      'tokenType': prefs.getString(_keyTokenType),
    };
  }

  // Check if user is logged in (has valid tokens)
  static Future<bool> isLoggedIn() async {
    final tokens = await loadAuthTokens();
    return tokens['accessToken'] != null && tokens['tokenType'] != null;
  }

  // Clear all data (for logout or reset)
  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyName);
    await prefs.remove(_keyUsername);
    await prefs.remove(_keyQuote);
    await prefs.remove(_keyProfileImage);
    await prefs.remove(_keyAccessToken);
    await prefs.remove(_keyRefreshToken);
    await prefs.remove(_keyExpiresIn);
    await prefs.remove(_keyTokenType);
  }
}