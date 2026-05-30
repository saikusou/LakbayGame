import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lakbay_game/config/api_config.dart';

class AuthService {
  Future<bool> login({
    required String userName,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/users/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'login': userName,
          'password': password,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}