import 'package:flutter/material.dart';
import 'package:lakbay_game/services/api_service.dart';

class UserService {
  static Future<int> getUserTotalPoints(int userId) async {
    try {
      return await ApiService.getTotalPoints(userId);
    } catch (e) {
      debugPrint('Error loading points: $e');
      return 0;
    }
  }
}
