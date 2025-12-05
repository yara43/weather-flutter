import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/weather_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Access WeatherProvider to get and update the selected temperature unit
    final weatherProvider = context.watch<WeatherProvider>();
    final currentUnits = weatherProvider.units; // 'metric' or 'imperial'

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Section title for temperature unit settings
          const Text(
            'Temperature Unit',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          // Option for Celsius (°C)
          RadioListTile<String>(
            title: const Text('Celsius (°C)'),
            value: 'metric',            // Metric = Celsius
            groupValue: currentUnits,    // Currently selected value
            onChanged: (value) {
              // Update temperature unit if the user selects a new one
              if (value != null) {
                weatherProvider.setUnits(value);
              }
            },
          ),

          // Option for Fahrenheit (°F)
          RadioListTile<String>(
            title: const Text('Fahrenheit (°F)'),
            value: 'imperial',          // Imperial = Fahrenheit
            groupValue: currentUnits,
            onChanged: (value) {
              if (value != null) {
                weatherProvider.setUnits(value);
              }
            },
          ),

          const SizedBox(height: 24),

          // Small info text showing the impact of changing units
          const Text(
            'New searches will use the selected unit.',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
