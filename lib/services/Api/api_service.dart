import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../data/Shared_Prefs/Shared_Prefs.dart';
import '../../models/campaign.dart';
import '../../models/category.dart';
import '../../models/plant.dart';


class ApiService {
  static const String baseUrl = 'https://releaf.runasp.net/api';
  static const String authBaseUrl = 'https://releaf.runasp.net';

  Future<Map<String, dynamic>> register(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$authBaseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return {'success': true};
      } else {
        final errorData = json.decode(response.body);
        String errorMessage = 'Registration failed';

        if (errorData['errors'] != null &&
            errorData['errors']['DuplicateUserName'] != null) {
          errorMessage = errorData['errors']['DuplicateUserName'][0];
        } else if (errorData['title'] != null) {
          errorMessage = errorData['title'];
        }

        return {'success': false, 'error': errorMessage};
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Network error occurred. Please check your connection.'
      };
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$authBaseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return {
          'success': true,
          'tokenType': responseData['tokenType'],
          'accessToken': responseData['accessToken'],
          'expiresIn': responseData['expiresIn'],
          'refreshToken': responseData['refreshToken'],
        };
      } else {
        return {'success': false, 'error': 'Invalid email or password'};
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Network error occurred. Please check your connection.'
      };
    }
  }

  Future<List<Campaign>> getAllCampaigns() async {
    try {
      final tokens = await SharedPrefs.loadAuthTokens();
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      if (tokens['accessToken'] != null && tokens['tokenType'] != null) {
        headers['Authorization'] = '${tokens['tokenType']} ${tokens['accessToken']}';
      }

      print('Attempting to fetch campaigns from: $baseUrl/Campaing/GetAllCampaigns');

      final response = await http.get(
        Uri.parse('$baseUrl/Campaing/GetAllCampaigns'),
        headers: headers,
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
      throw Exception('Network error while fetching campaigns');
    }
  }

  Future<List<Category>> getAllCategories() async {
    try {
      final tokens = await SharedPrefs.loadAuthTokens();
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      if (tokens['accessToken'] != null && tokens['tokenType'] != null) {
        headers['Authorization'] = '${tokens['tokenType']} ${tokens['accessToken']}';
      }

      final response = await http.get(
        Uri.parse('$baseUrl/Category/GetAllCategories'),
        headers: headers,
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
      final tokens = await SharedPrefs.loadAuthTokens();
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      if (tokens['accessToken'] != null && tokens['tokenType'] != null) {
        headers['Authorization'] = '${tokens['tokenType']} ${tokens['accessToken']}';
      }

      final response = await http.get(
        Uri.parse('$baseUrl/Category/GetById/$id'),
        headers: headers,
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
      final tokens = await SharedPrefs.loadAuthTokens();
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      if (tokens['accessToken'] != null && tokens['tokenType'] != null) {
        headers['Authorization'] = '${tokens['tokenType']} ${tokens['accessToken']}';
      }

      print('Fetching plants for category ID: $categoryId');
      final response = await http.get(
        Uri.parse('$baseUrl/Plant/GetAllPlantsByCategoryId/$categoryId'),
        headers: headers,
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
      final tokens = await SharedPrefs.loadAuthTokens();
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      if (tokens['accessToken'] != null && tokens['tokenType'] != null) {
        headers['Authorization'] = '${tokens['tokenType']} ${tokens['accessToken']}';
      }

      print('Fetching all plants');
      final response = await http.get(
        Uri.parse('$baseUrl/Plant/GetAllPlants'),
        headers: headers,
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
      throw Exception('Error fetching plants: ');
    }
  }
}