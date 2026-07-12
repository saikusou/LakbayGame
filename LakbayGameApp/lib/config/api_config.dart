class ApiConfig {
<<<<<<< Updated upstream
  static const String ip = '187.127.123.121';
=======
  static const String ip = '187.127.123.121'; // live server
  // static const String ip = '192.168.1.24'; // local server
>>>>>>> Stashed changes
  static const int port = 5211;

  static String get baseUrl => 'http://$ip:$port';
}
