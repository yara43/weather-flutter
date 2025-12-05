import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/favorites_provider.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Access FavoritesProvider to read the list of favorite cities
    final favoritesProvider = context.watch<FavoritesProvider>();
    final favorites = favoritesProvider.favorites; // Unmodifiable list

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Cities'),
      ),

      // If there are no favorite cities → show placeholder message
      body: favorites.isEmpty
          ? const Center(
              child: Text(
                'No favorite cities yet.\nAdd some from the weather page ❤️',
                textAlign: TextAlign.center,
              ),
            )

          // Otherwise show a list of saved cities
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final city = favorites[index];

                return ListTile(
                  // City name
                  title: Text(city),

                  // Delete icon to remove from favorites
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () =>
                        favoritesProvider.removeFavorite(city),
                  ),

                  // Tap city to navigate to its weather details
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/details',
                      arguments: city, // Pass city name to details page
                    );
                  },
                );
              },
            ),
    );
  }
}
