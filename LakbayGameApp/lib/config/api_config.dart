class ApiConfig {
  static const String ip =
      '192.168.0.106'; // Replace with your machine's local IP address
  static const int port = 5211;

  static String get baseUrl => 'http://$ip:$port';
}
