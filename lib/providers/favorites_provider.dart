import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider extends ChangeNotifier {
  // Key used to store the list of favorite cities in SharedPreferences
  static const String _prefsKey = 'favorite_cities';

  List<String> _favorites = [];
  // Expose favorites as an unmodifiable list to prevent external editing
  List<String> get favorites => List.unmodifiable(_favorites);

  // Constructor → loads saved favorites when the provider is created
  FavoritesProvider() {
    _loadFavorites();
  }

  // Load favorite cities from SharedPreferences (persistent local storage)
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    _favorites = prefs.getStringList(_prefsKey) ?? [];
    notifyListeners(); // Notify UI to update after loading
  }

  // Save the updated list of favorites to SharedPreferences
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefsKey, _favorites);
  }

  // Check if a specific city is already in the favorites list
  bool isFavorite(String city) {
    return _favorites.contains(city);
  }

  // Add a city to favorites (only if not empty and not already saved)
  Future<void> addFavorite(String city) async {
    if (city.isEmpty || _favorites.contains(city)) return;
    _favorites.add(city);        // Add city to the list
    await _saveFavorites();      // Save changes
    notifyListeners();           // Update UI
  }

  // Remove a city from favorites
  Future<void> removeFavorite(String city) async {
    _favorites.remove(city);
    await _saveFavorites();
    notifyListeners();           // Trigger UI update
  }
}
