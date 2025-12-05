class Weather {
  // Basic weather information
  final String cityName;
  final double temperature;
  final String description;
  final double feelsLike;
  final int humidity;
  final double windSpeed;

  // Time-related data (converted from UNIX timestamps)
  final DateTime localTime;
  final DateTime sunrise;
  final DateTime sunset;

  // Icon code provided by OpenWeather API
  final String iconCode;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.localTime,
    required this.sunrise,
    required this.sunset,
    required this.iconCode,
  });

  // Factory constructor: creates a Weather object from JSON API response
  factory Weather.fromJson(Map<String, dynamic> json) {
    final main = json['main'] ?? {}; // Contains temp, feels_like, humidity
    final weatherList = json['weather'] as List<dynamic>? ?? [];
    final weather0 =
        weatherList.isNotEmpty ? weatherList[0] as Map<String, dynamic> : {};
    final wind = json['wind'] ?? {}; // Contains wind speed
    final sys = json['sys'] ?? {};   // Contains sunrise & sunset

    // Extract timezone offset (seconds) and timestamps
    final int timezone = (json['timezone'] ?? 0) as int;
    final int dt = (json['dt'] ?? 0) as int;
    final int sunriseUnix = (sys['sunrise'] ?? 0) as int;
    final int sunsetUnix = (sys['sunset'] ?? 0) as int;

    // Convert UNIX timestamps + timezone offset to DateTime
    final DateTime localTime = DateTime.fromMillisecondsSinceEpoch(
      (dt + timezone) * 1000,
      isUtc: true,
    );

    final DateTime sunrise = DateTime.fromMillisecondsSinceEpoch(
      (sunriseUnix + timezone) * 1000,
      isUtc: true,
    );

    final DateTime sunset = DateTime.fromMillisecondsSinceEpoch(
      (sunsetUnix + timezone) * 1000,
      isUtc: true,
    );

    return Weather(
      cityName: (json['name'] ?? '') as String,
      temperature: (main['temp'] ?? 0).toDouble(),
      description: (weather0['description'] ?? '') as String,
      feelsLike: (main['feels_like'] ?? 0).toDouble(),
      humidity: (main['humidity'] ?? 0) is int
          ? main['humidity'] as int
          : (main['humidity'] ?? 0).toInt(),
      windSpeed: (wind['speed'] ?? 0).toDouble(),
      localTime: localTime,
      sunrise: sunrise,
      sunset: sunset,
      iconCode: (weather0['icon'] ?? '') as String,
    );
  }

  // Convert iconCode to full image URL from OpenWeather
  String get iconUrl => 'https://openweathermap.org/img/wn/$iconCode@4x.png';
}
