import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/campaign.dart';
import '../models/category.dart';
import '../models/plant.dart';

class ApiService {
  static const String baseUrl = 'https://releaf.runasp.net/api';

  Future<List<Campaign>> getAllCampaigns() async {
    try {
      print('Attempting to fetch campaigns from: $baseUrl/Campaign/GetAllCampaigns');
      
      final response = await http.get(
        Uri.parse('$baseUrl/Campaign/GetAllCampaigns'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        print('Parsed JSON data: $jsonData');
        return jsonData.map((json) => Campaign.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load campaigns - Status Code: ${response.statusCode}, Body: ${response.body}');
      }
    } on FormatException catch (e) {
      print('JSON parsing error: $e');
      throw Exception('Error parsing campaign data: $e');
    } catch (e) {
      print('Detailed error while fetching campaigns: $e');
      throw Exception('Network error while fetching campaigns: $e');
    }
  }

  Future<List<Category>> getAllCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Category/GetAllCategories'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      
      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Category.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  Future<Category> getCategoryById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Category/GetById/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        return Category.fromJson(jsonData);
      } else {
        throw Exception('Failed to load category');
      }
    } catch (e) {
      throw Exception('Error fetching category: $e');
    }
  }

  Future<List<Plant>> getPlantsByCategoryId(int categoryId) async {
    try {
      print('Fetching plants for category ID: $categoryId');
      final response = await http.get(
        Uri.parse('$baseUrl/Plant/GetAllPlantsByCategoryId/$categoryId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        print('Parsed JSON data: $jsonData');
        return jsonData.map((json) => Plant.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load plants');
      }
    } catch (e) {
      print('Error in getPlantsByCategoryId: $e');
      throw Exception('Error fetching plants: $e');
    }
  }

  Future<List<Plant>> getAllPlants() async {
    try {
      print('Fetching all plants');
      final response = await http.get(
        Uri.parse('$baseUrl/Plant/GetAllPlants'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        print('Parsed JSON data: $jsonData');
        return jsonData.map((json) => Plant.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load plants');
      }
    } catch (e) {
      print('Error in getAllPlants: $e');
      throw Exception('Error fetching plants: $e');
    }
  }
}