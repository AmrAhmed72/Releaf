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
  static const String _keyRecentSearches = 'recentSearches';

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

  static Future<Map<String, String?>> loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString(_keyName),
      'username': prefs.getString(_keyUsername),
      'quote': prefs.getString(_keyQuote),
      'profileImage': prefs.getString(_keyProfileImage),
    };
  }

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

  static Future<Map<String, dynamic>> loadAuthTokens() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'accessToken': prefs.getString(_keyAccessToken),
      'refreshToken': prefs.getString(_keyRefreshToken),
      'expiresIn': prefs.getInt(_keyExpiresIn),
      'tokenType': prefs.getString(_keyTokenType),
    };
  }

  static Future<bool> isLoggedIn() async {
    final tokens = await loadAuthTokens();
    return tokens['accessToken'] != null && tokens['tokenType'] != null;
  }

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
    await prefs.remove(_keyRecentSearches);
  }

  static Future<void> saveRecentSearches(List<String> searches) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyRecentSearches, searches);
  }

  static Future<List<String>> loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyRecentSearches) ?? [];
  }

  static Future<void> clearRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyRecentSearches);
  }
}