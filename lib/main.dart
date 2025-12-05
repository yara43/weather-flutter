import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/home_page.dart';
import 'pages/weather_details_page.dart';
import 'pages/favorites_page.dart';
import 'pages/settings_page.dart';
import 'providers/weather_provider.dart';
import 'providers/favorites_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // WeatherProvider: handles weather API calls and state management
        ChangeNotifierProvider(create: (_) => WeatherProvider()),

        // FavoritesProvider: manages user's list of favorite cities
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],

      // Wrap the whole application with the providers
      child: const WeatherApp(),
    ),
  );
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // App name shown in system task switcher
      title: 'Weather App',

      // Removes the debug banner
      debugShowCheckedModeBanner: false,

      // App theme configuration
      theme: ThemeData(
        useMaterial3: true,           // Enable Material 3 UI
        colorSchemeSeed: Colors.blue, // Generate color palette from blue
        brightness: Brightness.light, // Light mode theme
      ),

      // First route when app launches
      initialRoute: '/',

      // App routes for navigation
      routes: {
        '/': (context) => const HomePage(),               // Main home screen
        '/details': (context) => const WeatherDetailsPage(), // Weather details screen
        '/favorites': (context) => const FavoritesPage(), // List of favorite locations
        '/settings': (context) => const SettingsPage(),   // Settings screen
      },
    );
  }
}
