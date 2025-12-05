import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/weather_provider.dart';
import '../providers/favorites_provider.dart';
import '../models/weather.dart';

class WeatherDetailsPage extends StatefulWidget {
  const WeatherDetailsPage({super.key});

  @override
  State<WeatherDetailsPage> createState() => _WeatherDetailsPageState();
}

class _WeatherDetailsPageState extends State<WeatherDetailsPage> {
  String? _city; // Holds the city name passed through navigation arguments

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Only run once when the page is first built
    if (_city == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      _city = args is String ? args : null;

      // If a city was passed → fetch its weather data
      if (_city != null) {
        final provider = context.read<WeatherProvider>();
        provider.fetchWeatherForCity(_city!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to WeatherProvider updates
    final provider = context.watch<WeatherProvider>();
    final Weather? weather = provider.weather;
    final bool isLoading = provider.isLoading;
    final String? error = provider.errorMessage;

    // Favorites provider (to check/add/remove favorite cities)
    final favoritesProvider = context.watch<FavoritesProvider>();
    final bool isFav = weather != null &&
        favoritesProvider.isFavorite(weather.cityName);

    return Scaffold(
      appBar: AppBar(
        // AppBar title = city name or fallback text
        title: Text(_city ?? weather?.cityName ?? 'Weather Details'),
        actions: [
          // Favorite button only appears when weather data exists
          if (weather != null)
            IconButton(
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
              ),
              onPressed: () {
                // Toggle favorite status
                if (isFav) {
                  favoritesProvider.removeFavorite(weather.cityName);
                } else {
                  favoritesProvider.addFavorite(weather.cityName);
                }
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Builder(
          builder: (_) {
            // Show loading spinner while fetching data
            if (isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            // Show error message if API call failed
            if (error != null) {
              return Center(
                child: Text(
                  error,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              );
            }

            // No data available (edge case)
            if (weather == null) {
              return const Center(
                child: Text('No weather data'),
              );
            }

            // Time formatter (HH:mm)
            final timeFormat = DateFormat.Hm();

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // City name
                  Text(
                    weather.cityName,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Weather description (e.g., clear sky)
                  Text(
                    weather.description,
                    style: const TextStyle(fontSize: 18),
                  ),

                  const SizedBox(height: 16),

                  // Weather icon from OpenWeather API
                  Image.network(
                    weather.iconUrl,
                    height: 120,
                    fit: BoxFit.contain,
                  ),

                  const SizedBox(height: 8),

                  // Temperature main value
                  Text(
                    '${weather.temperature.toStringAsFixed(1)}°',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Feels like temperature
                  Text(
                    'Feels like ${weather.feelsLike.toStringAsFixed(1)}°',
                  ),

                  const SizedBox(height: 16),

                  // Local time converted from timezone offset
                  Text(
                    'Local time: ${timeFormat.format(weather.localTime)}',
                  ),

                  const SizedBox(height: 16),

                  // Humidity and wind info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _InfoTile(
                        label: 'Humidity',
                        value: '${weather.humidity}%',
                      ),
                      _InfoTile(
                        label: 'Wind',
                        value: '${weather.windSpeed} m/s',
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Sunrise and sunset times
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _InfoTile(
                        label: 'Sunrise',
                        value: timeFormat.format(weather.sunrise),
                      ),
                      _InfoTile(
                        label: 'Sunset',
                        value: timeFormat.format(weather.sunset),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label; // Name of the weather attribute
  final String value; // Value to display

  const _InfoTile({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Small grey label
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 4),

        // Bold value below the label
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
