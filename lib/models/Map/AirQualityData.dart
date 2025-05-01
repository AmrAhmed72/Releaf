class AirQualityData {
  final int aqi;
  final double temperature;
  final int humidity;
  final double windSpeed;
  final double desertificationIndex;

  AirQualityData({
    required this.aqi,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.desertificationIndex,
  });

  factory AirQualityData.fromJson(Map<String, dynamic> json) {
    final current = json['current'];
    final aqi = current['pollution']['aqius'];
    final temperature = current['weather']['tp'].toDouble();
    final humidity = current['weather']['hu'];
    final windSpeed = current['weather']['ws'].toDouble();

    final desertificationIndex = _calculateDesertificationIndex(
      aqi: aqi,
      temperature: temperature,
      humidity: humidity,
      windSpeed: windSpeed,
    );

    return AirQualityData(
      aqi: aqi,
      temperature: temperature,
      humidity: humidity,
      windSpeed: windSpeed,
      desertificationIndex: desertificationIndex,
    );
  }

  static double _calculateDesertificationIndex({
    required int aqi,
    required double temperature,
    required int humidity,
    required double windSpeed,
  }) {
    final tempScore = temperature < 20
        ? 10.0
        : temperature <= 30
        ? 50.0
        : 90.0;

    final humidityScore = humidity > 60
        ? 10.0
        : humidity >= 30
        ? 50.0
        : 90.0;

    final windScore = windSpeed < 5
        ? 10.0
        : windSpeed <= 10
        ? 50.0
        : 90.0;

    final aqiScore = aqi < 50
        ? 10.0
        : aqi <= 100
        ? 50.0
        : 90.0;

    return (0.3 * tempScore) + (0.3 * humidityScore) + (0.2 * windScore) + (0.2 * aqiScore);
  }
}