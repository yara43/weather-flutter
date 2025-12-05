import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/api_config_real.dart';
import '../models/weather.dart';

class WeatherApiService {
  final http.Client _client;

  // Constructor allows injecting a custom HTTP client (useful for testing)
  WeatherApiService({http.Client? client}) : _client = client ?? http.Client();

  // Fetch weather data for a given city name from OpenWeather API
  Future<Weather> getWeatherByCity(
    String city, {
    String units = 'metric', // 'metric' = °C, 'imperial' = °F
  }) async {
    // Build the API request URL with query parameters
    final uri = Uri.parse(
      '${ApiConfig.openWeatherBaseUrl}/weather?q=$city'
      '&appid=${ApiConfig.openWeatherApiKey}'
      '&units=$units',
    );

    // Send GET request to OpenWeather API
    final response = await _client.get(uri);

    // Status code 200 = success → parse JSON and return Weather model
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return Weather.fromJson(data);

    // Status code 401 = invalid or missing API key
    } else if (response.statusCode == 401) {
      throw Exception('Invalid API key (401)');

    // Status code 404 = city name not found
    } else if (response.statusCode == 404) {
      throw Exception('City not found (404)');

    // Any other status code → throw general error message
    } else {
      throw Exception(
        'Failed to load weather: '
        '${response.statusCode} ${response.reasonPhrase}',
      );
    }
  }
}
