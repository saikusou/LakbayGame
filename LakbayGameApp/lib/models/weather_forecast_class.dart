class WeatherForecast {
  final String date;
  final int temperatureC;
  final int temperatureF;
  final String summary;

  WeatherForecast({
    required this.date,
    required this.temperatureC,
    required this.temperatureF,
    required this.summary,
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    return WeatherForecast(
      date: json['date'],
      temperatureC: json['temperatureC'],
      temperatureF: json['temperatureF'],
      summary: json['summary'],
    );
  }
}