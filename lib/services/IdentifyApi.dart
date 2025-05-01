import 'package:http/http.dart' as http;
import 'dart:convert';

class IdentifyApi {
  // Function to identify the flower using the provided API
  static Future<Map<String, dynamic>> identifyFlower(String imagePath) async {
    try {
      // Create a multipart request to send the image to the flower identification API
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://flower-identification-80t9.onrender.com/predictFlower'),
      );

      // Add the image file to the request with the key 'image'
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));

      // Send the request
      var response = await request.send();

      var responseData = await response.stream.bytesToString();
      var result = jsonDecode(responseData);

      // Check the response status
      if (response.statusCode == 200) {
        // Parse the result from the API response
        var flowerInfoPrimary = result['result'][0]; // Primary identification
        var flowerInfoSecondary = result['result'].length > 1
            ? result['result'][1]
            : "No secondary identification available"; // Secondary identification or fallback message

        return {
          'primary': flowerInfoPrimary,
          'secondary': flowerInfoSecondary,
        };
      } else {
        throw Exception('Error identifying flower: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error identifying flower: $e');
    }
  }

  // Function to predict plant disease using the provided API
  static Future<Map<String, dynamic>> predictDisease(String imagePath) async {
    try {
      // Create a multipart request to send the image to the disease prediction API
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://flower-identification-80t9.onrender.com/predictDisease'),
      );

      // Add the image file to the request with the key 'image'
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));

      // Send the request
      var response = await request.send();

      var responseData = await response.stream.bytesToString();
      var result = jsonDecode(responseData);

      // Check the response status
      if (response.statusCode == 200) {
        // Parse the result from the API response
        var diseaseName = result['result'][0] ?? 'Unknown'; // Primary: Disease name
        var diseaseDescription = result['result'].length > 1
            ? result['result'][1]
            : 'No description available'; // Secondary: Disease description or fallback

        return {
          'primary': diseaseName,
          'secondary': diseaseDescription,
        };
      } else {
        throw Exception('Error predicting disease: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error predicting disease: $e');
    }
  }
}