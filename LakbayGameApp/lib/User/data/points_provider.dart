import 'package:flutter/material.dart';
import 'package:lakbay_game/services/api_service.dart';

class PointsProvider extends ChangeNotifier {
  int _totalPoints = 0;

  int get totalPoints => _totalPoints;

  Future<void> loadPoints(int userId) async {
    _totalPoints = await ApiService.getTotalPoints(userId);
    notifyListeners();
  }

  void addPoints(int points) {
    _totalPoints += points;
    notifyListeners();
  }

  void setPoints(int points) {
    _totalPoints = points;
    notifyListeners();
  }
}
