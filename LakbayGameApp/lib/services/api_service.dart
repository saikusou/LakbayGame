import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lakbay_game/User/models/leaderboard.dart';
import 'package:lakbay_game/config/api_config.dart';

class ApiService {
  static Future<Map<String, dynamic>> savePoints({
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

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else if (response.statusCode == 409) {
      return data; // Activity already completed
    } else {
      throw Exception('Failed to save points: ${response.body}');
    }
  }

  static Future<int> getTotalPoints(int userId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/points/totalpoints/$userId'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return int.parse(data['totalPoints'].toString());
    } else {
      throw Exception('Failed to fetch total points');
    }
  }

  static Future<bool> hasClaimedToday(int userId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/points/daily-reward-status/$userId'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['alreadyClaimed'] ?? false;
    }

    throw Exception('Failed to check daily reward status');
  }

  static Future<Map<String, dynamic>> claimDailyReward(int userId) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/points/claim-daily-reward'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else if (response.statusCode == 409) {
      return data;
    } else {
      throw Exception('Failed to claim daily reward: ${response.body}');
    }
  }

  static Future<List<LeaderboardModel>> getUsersLeaderboard() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/users/getAllUsersLeaderboard'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data.map((json) => LeaderboardModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch leaderboard data');
    }
  }
}
