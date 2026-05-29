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
}