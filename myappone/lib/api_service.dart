import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // The URL of your Flask API endpoint
  final String apiUrl = "http://192.168.8.120:5000/predict";


  Future<Map<String, dynamic>> predictLoanStatus(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print('Response: ${response.body}');
        return jsonDecode(response.body);
      } else {
        // Debugging the error response
        print('Failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load loan prediction');
      }
    } catch (e) {
      print('Error occurred: $e');
      throw Exception('Error occurred during API call');
    }
  }

}
