class LeaderboardModel {
  final int id;
  final String userName;
  final int totalPoints;

  LeaderboardModel({
    required this.id,
    required this.userName,
    required this.totalPoints,
  });

  factory LeaderboardModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardModel(
      id: json['userId'],
      userName: json['userName'],
      totalPoints: json['totalCountedPoints'],
    );
  }
}
