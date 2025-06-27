import 'dart:convert';
import 'package:http/http.dart' as http;

class PlantApiService {
  // Replace with your actual Gemini API key
  static final String apiKey = "AIzaSyBtxMlJW2ysEH0zqLZ16qpNIghnrh9Mmb4";
  static final String baseUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent";

  // Plant expert system prompt
  static final String systemPrompt = """
You are a highly knowledgeable and experienced plant expert specializing in various types of plants, including indoor and outdoor plants, flowers, trees, shrubs, and crops. You have extensive expertise in plant care, propagation, soil types, watering schedules, light requirements, pest control, fertilization, and seasonal planting techniques.

When answering questions, provide clear, detailed, and actionable advice tailored to the specific type of plant mentioned. Include information about optimal planting conditions, common issues and how to address them, and tips for maximizing plant health and growth. If the user is a beginner, simplify complex concepts and explain them in a step-by-step manner.

For example, if asked about growing tomatoes, provide instructions on selecting the best soil, planting depth, watering frequency, sun exposure, pest prevention, and tips for maximizing fruit yield.

Adopt a friendly, educational, and encouraging tone to make the information approachable and easy to follow.

IMPORTANT: Do not use any Markdown formatting in your responses. Do not use asterisks, underscores, or any special characters for formatting.
""";

  // Clean response text by removing Markdown formatting
  static String cleanResponseText(String text) {
    // Remove Markdown formatting for bold/italic (asterisks)
    String cleaned = text.replaceAll(RegExp(r'\*{1,3}'), '');
    
    // Remove Markdown formatting for italic (underscores)
    cleaned = cleaned.replaceAll(RegExp(r'_{1,3}'), '');
    
    // Remove other Markdown elements as needed
    cleaned = cleaned.replaceAll(RegExp(r'#{1,6}\s'), ''); // Headers
    cleaned = cleaned.replaceAll(RegExp(r'`{1,3}'), ''); // Code blocks
    
    return cleaned;
  }

  static Future<String> generateContent(String userPrompt) async {
    final uri = Uri.parse("$baseUrl?key=$apiKey");

    final headers = {
      "Content-Type": "application/json",
    };

    final body = json.encode({
      "contents": [
        {
          "parts": [
            {"text": systemPrompt},
            {"text": userPrompt}
          ]
        }
      ]
    });

    try {
      final response = await http.post(uri, headers: headers, body: body);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        // Fix the JSON path to match Gemini API response structure
        if (jsonData.containsKey('candidates') &&
            jsonData['candidates'].isNotEmpty &&
            jsonData['candidates'][0].containsKey('content') &&
            jsonData['candidates'][0]['content']['parts'].isNotEmpty) {
          String responseText = jsonData['candidates'][0]['content']['parts'][0]['text'];
          // Clean the response text before returning
          return cleanResponseText(responseText);
        } else {
          print("Unexpected response structure: $jsonData");
          return "Error: Unexpected API response structure";
        }
      } else {
        print("Error: ${response.statusCode}");
        print(response.body);
        return "Error: ${response.statusCode}";
      }
    } catch (e) {
      print("Exception: $e");
      return "Exception: $e";
    }
  }
}
/*
* "Act as a knowledgeable and supportive physical therapist with expertise in rehabilitation and injury prevention.
* Provide clear, evidence-based guidance to address my physical concerns, such as pain, mobility issues, or recovery goals.
* Offer tailored exercises, stretches, or techniques with step-by-step instructions, considering my fitness level and any limitations I describe.
* Ask clarifying questions to understand my condition and needs.
*  Avoid medical diagnoses or prescribing treatments beyond your scope.
* Respond with encouragement and practical advice to promote my physical well-being."*/