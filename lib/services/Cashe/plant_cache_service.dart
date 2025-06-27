import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/plant.dart';

class PlantCacheService {
  static const String _plantsKey = 'cached_plants';
  static const int _cacheDurationHours = 24; // Cache duration in hours

  Future<void> cachePlants(List<Plant> plants) async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final data = {
      'timestamp': timestamp,
      'plants': plants.map((p) => p.toJson()).toList(),
    };
    await prefs.setString(_plantsKey, jsonEncode(data));
  }

  Future<List<Plant>?> getCachedPlants() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString(_plantsKey);
    
    if (cachedData == null) return null;

    final data = jsonDecode(cachedData) as Map<String, dynamic>;
    final timestamp = data['timestamp'] as int;
    final now = DateTime.now().millisecondsSinceEpoch;
    
    // Check if cache is still valid (less than 24 hours old)
    if ((now - timestamp) > (_cacheDurationHours * 60 * 60 * 1000)) {
      return null; // Cache expired
    }

    final plantsJson = data['plants'] as List<dynamic>;
    return plantsJson.map((json) => Plant.fromJson(json)).toList();
  }
} 