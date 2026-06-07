class UserModel {
  final int? id;
  final String userName;
  final String email;
  final String gender;

  UserModel({
    this.id,
    required this.userName,
    required this.email,
    required this.gender,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      userName: json['userName'],
      email: json['email'],
      gender: json['gender'],
    );
  }
}
