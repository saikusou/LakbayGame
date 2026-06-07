import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lakbay_game/config/api_config.dart';
import 'package:lakbay_game/models/user_model.dart';

class AuthService {
  Future<UserModel?> login({
    required String userName,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/users/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'login': userName, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return UserModel.fromJson(data);
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> createAccount({
    required String name,
    required String email,
    required String gender,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/users/signUp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userName': name,
          'email': email,
          'gender': gender,
          'password': password,
        }),
      );

      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<UserModel?> getUserById(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/getUserById/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return UserModel.fromJson(data);
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}
