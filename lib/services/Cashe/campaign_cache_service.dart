import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/campaign.dart';

class CampaignCacheService {
  static const String _campaignsKey = 'cached_campaigns';
  static const int _cacheDurationHours = 24; // Cache duration in hours

  Future<void> cacheCampaigns(List<Campaign> campaigns) async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final data = {
      'timestamp': timestamp,
      'campaigns': campaigns.map((c) => c.toJson()).toList(),
    };
    await prefs.setString(_campaignsKey, jsonEncode(data));
  }

  Future<List<Campaign>?> getCachedCampaigns() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString(_campaignsKey);
    
    if (cachedData == null) return null;

    final data = jsonDecode(cachedData) as Map<String, dynamic>;
    final timestamp = data['timestamp'] as int;
    final now = DateTime.now().millisecondsSinceEpoch;
    
    // Check if cache is still valid (less than 24 hours old)
    if ((now - timestamp) > (_cacheDurationHours * 60 * 60 * 1000)) {
      return null; // Cache expired
    }

    final campaignsJson = data['campaigns'] as List<dynamic>;
    return campaignsJson.map((json) => Campaign.fromJson(json)).toList();
  }
} 