import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/weather.dart';
import '../services/weather_api_service.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherApiService _apiService;

  // Key used to save and load the temperature unit from SharedPreferences
  static const String _unitsKey = 'temperature_units';

  // Constructor → initializes API service and loads saved temperature units
  WeatherProvider({WeatherApiService? apiService})
      : _apiService = apiService ?? WeatherApiService() {
    _loadUnits();
  }

  Weather? _weather;
  // Current weather data returned from the API
  Weather? get weather => _weather;

  bool _isLoading = false;
  // True when the app is waiting for API response
  bool get isLoading => _isLoading;

  String? _errorMessage;
  // Error message if request fails
  String? get errorMessage => _errorMessage;

  String _units = 'metric'; // 'metric' = Celsius, 'imperial' = Fahrenheit
  // Current selected temperature unit
  String get units => _units;

  // Load temperature units from persistent storage
  Future<void> _loadUnits() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedUnits = prefs.getString(_unitsKey);

    // Validate saved units → only accept 'metric' or 'imperial'
    if (savedUnits != null &&
        (savedUnits == 'metric' || savedUnits == 'imperial')) {
      _units = savedUnits; // Safe assignment because we already checked value
      notifyListeners();   // Update UI after loading units
    }
  }

  // Save temperature units to SharedPreferences
  Future<void> _saveUnits() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_unitsKey, _units);
  }

  // Change temperature unit and update UI + local storage
  void setUnits(String newUnits) {
    if (newUnits == _units) return; // No change → do nothing
    _units = newUnits;
    _saveUnits();
    notifyListeners();
  }

  // Request weather data for a given city using the API service
  Future<void> fetchWeatherForCity(String city) async {
    if (city.isEmpty) return; // Prevent invalid requests

    _isLoading = true;     // Start loading state
    _errorMessage = null;  // Clear previous errors
    notifyListeners();

    try {
      // Fetch weather based on selected temperature unit
      final w = await _apiService.getWeatherByCity(city, units: _units);
      _weather = w;        // Save weather data
    } catch (e) {
      _weather = null;
      _errorMessage = e.toString(); // Save error message
    } finally {
      _isLoading = false;  // End loading state
      notifyListeners();   // Update UI after finishing request
    }
  }
}
