import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Controller to read the text typed by the user (city name)
  final TextEditingController _cityController = TextEditingController();

  @override
  void dispose() {
    // Dispose controller to free memory when the widget is destroyed
    _cityController.dispose();
    super.dispose();
  }

  // Triggered when the user presses the search button or submits the text
  void _onSearch() {
    final city = _cityController.text.trim(); // Remove spaces
    if (city.isEmpty) return; // Prevent empty search

    // Navigate to Weather Details page and pass the city name as argument
    Navigator.pushNamed(
      context,
      '/details',
      arguments: city,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        actions: [
          // Go to Favorites Page
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => Navigator.pushNamed(context, '/favorites'),
          ),

          // Go to Settings Page
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Text field where the user types the city name
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                hintText: 'Enter city name',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onSubmitted: (_) => _onSearch(), // Trigger search when pressing enter
            ),

            const SizedBox(height: 16),

            // Search button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onSearch,
                child: const Text('Search'),
              ),
            ),

            const SizedBox(height: 32),

            // Placeholder message before searching
            const Expanded(
              child: Center(
                child: Text(
                  'Search for a city to see its weather 🌤️',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
