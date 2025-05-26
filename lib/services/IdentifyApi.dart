import 'package:http/http.dart' as http;
import 'dart:convert';

class IdentifyApi {
  static Future<Map<String, dynamic>> identifyFlower(String imagePath) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://flower-identification-mija.onrender.com/predictFlower100edit'),
      );

      request.files.add(await http.MultipartFile.fromPath('image', imagePath));

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var result = jsonDecode(responseData);

      if (response.statusCode == 200) {
        List<String> flowerResults = List.generate(6, (index) {
          return result['result'].length > index
              ? result['result'][index].toString()
              : "No data available for index $index";
        });

        return {
          'results': flowerResults,
        };
      } else {
        throw Exception('Error identifying flower: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error identifying flower: $e');
    }
  }

  static Future<Map<String, dynamic>> predictDisease(String imagePath) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://flower-identification-mija.onrender.com/predictDisease'),
      );

      request.files.add(await http.MultipartFile.fromPath('image', imagePath));

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var result = jsonDecode(responseData);

      if (response.statusCode == 200) {
        var diseaseName = result['result'][0] ?? 'Unknown';
        var diseaseDescription = result['result'].length > 1
            ? result['result'][1]
            : 'No description available';

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