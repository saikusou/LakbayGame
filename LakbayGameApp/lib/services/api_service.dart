import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lakbay_game/config/api_config.dart';

class ApiService {
  static Future<List<dynamic>> fetchWeather() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/weatherforecast'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load weather');
    }
  }

  static Future<List<dynamic>> savePoints({
    required int? userId,
    required int countedPoints,
    required String lesson,
    required String day,
    required String act,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/points/savePoints'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'countedPoints': countedPoints,
        'lesson': lesson,
        'day': day,
        'act': act,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to save points');
    }
  }
}
