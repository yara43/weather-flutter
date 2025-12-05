# weather_app

A new Flutter project.
# Flutter Weather App 🌤️


A multi-page Flutter application that displays **real-time current weather data** using the **OpenWeatherMap Current Weather API**.

The app allows the user to:

- Search for weather by **city name**
- View detailed current weather information
- Save and manage **favorite cities**
- Change **temperature units** (°C / °F) from the Settings screen
- See **local time**, **sunrise**, **sunset**, and other details calculated using the API timezone offset

This project is built to practice REST API integration, Flutter UI development, routing, state management, local storage, and clean code organization.

---

## 1. App Description

This app is a simple but complete example of a weather client built with **Flutter**.  
It consumes the **OpenWeatherMap – Current Weather Data** API to retrieve the current weather for any city.

The user can:

- Type a city name in the search bar on the **Home** screen
- Navigate to a **Weather Details** screen that shows:
  - City name
  - Temperature
  - Weather description
  - "Feels like" temperature
  - Humidity
  - Wind speed
  - Sunrise & Sunset
  - Weather icon from OpenWeatherMap
  - Local time (using `timezone` offset from the API)
- Mark cities as **favorites** and open them from the Favorites screen
- Change the **temperature units** (metric / imperial) in the Settings screen

The state of favorites and selected temperature unit is stored locally using **SharedPreferences**.

---

## 2. Features

### Core Features

- 🔍 **Search by city name**
  - Home screen with a search bar
  - Navigation to the Weather Details screen with the selected city
- 📄 **Weather Details Screen** (from API response)
  - City name
  - Temperature
  - Weather description
  - "Feels like" temperature
  - Humidity
  - Wind speed
  - Sunrise / Sunset (using timezone offset)
  - Weather icon from OpenWeatherMap (`icon` code)
  - Local time (calculated from `dt + timezone`)
- ❤️ **Favorites Screen**
  - Add/remove cities to/from favorites
  - Persist favorite cities using `shared_preferences`
  - Tap a favorite city to open its Weather Details
- ⚙️ **Settings Screen**
  - Choose temperature unit:
    - Metric (°C)
    - Imperial (°F)
  - Selected unit is saved locally and used for new searches

### Technical Features

- 🌐 **API Integration**
  - Uses `http` package to perform GET requests
  - Calls: `https://api.openweathermap.org/data/2.5/weather`
- 🧠 **State Management**
  - Uses **Provider**:
    - `WeatherProvider` for:
      - current weather
      - loading / error states
      - units (metric / imperial)
    - `FavoritesProvider` for:
      - favorite cities list
      - local storage (SharedPreferences)
- 💾 **Local Storage**
  - `SharedPreferences` to store:
    - favorite city names
    - selected temperature units
- ❗ **Error Handling**
  - Handles:
    - No internet / network issues
    - Invalid city (404 "City not found")
    - Invalid API key (401)
    - Other API errors (non-200 status codes)
  - Shows a loading indicator while fetching data
  - Displays error messages in the UI instead of crashing
- 🎨 **UI / UX**
  - Clean and responsive layout
  - Material 3 theme
  - Weather icon loaded from OpenWeatherMap icon URL

---

## 3. Folder Structure

The project follows a clean and modular folder structure:

```text
lib/
  main.dart                  # Entry point + routing + providers setup

  config/
    api_config.dart          # Contains base URL + API key (local, DO NOT commit real key)
    api_config.example.dart  # Example config file with placeholder key

  models/
    weather.dart             # Weather model and JSON parsing

  services/
    weather_api_service.dart # HTTP calls to OpenWeatherMap Current Weather API

  providers/
    weather_provider.dart    # Manages current weather data, units, loading & error
    favorites_provider.dart  # Manages favorite cities + SharedPreferences

  pages/
    home_page.dart           # Home/Search screen
    weather_details_page.dart# Weather details + add/remove favorite
    favorites_page.dart      # Favorites list screen
    settings_page.dart       # Settings (temperature units)

  widgets/
    # (Optional) reusable UI widgets such as small info tiles
Other important files:

pubspec.yaml – dependencies (http, provider, shared_preferences, intl, etc.)

android/app/src/main/AndroidManifest.xml – includes Internet permission:

xml

<uses-permission android:name="android.permission.INTERNET" />
4. Setup Steps
4.1 Prerequisites
Make sure you have:

Flutter SDK installed and configured

A valid OpenWeatherMap API key
(Sign up at https://openweathermap.org/ if you don't have one)

Optional but recommended:

An emulator or a physical Android device

Chrome browser for running Flutter web

4.2 Clone the Repository

git clone https://github.com/yara43/weather_app.git
cd weather_app
(Replace the URL with your own fork if needed.)

4.3 Install Dependencies
Run:

flutter pub get
This will download all required Dart & Flutter packages.

5. API Key Configuration (IMPORTANT) 🔑
⚠️ The real API key must NOT be hardcoded in code uploaded online.
The repository contains only a placeholder in api_config.dart so that no real key is exposed.

Option 1 (simple, current setup)
Open the file:


lib/config/api_config.dart
Replace the placeholder string with your own API key:

class ApiConfig {
  static const String openWeatherBaseUrl =
      'https://api.openweathermap.org/data/2.5';

  // IMPORTANT: Replace this with your own OpenWeatherMap API key
  // Do NOT commit your real key to a public repository.
  static const String openWeatherApiKey =
      'REPLACE_WITH_YOUR_API_KEY'; // <-- put your key here locally
}
Do not commit your real API key to GitHub.
Before pushing, make sure the public repo still has 'REPLACE_WITH_YOUR_API_KEY' (or a dummy value), not your real key.

Option 2 (recommended for stricter security)
Leave api_config.example.dart in the repo.

Add the real api_config.dart to .gitignore:


lib/config/api_config.dart
Create a local lib/config/api_config.dart on your machine (not committed) with your real key.

In the README, instruct other developers to create their own local api_config.dart based on the .example file.

6. Running the App
From the project root:

6.1 Run on Chrome (Web)

flutter run -d chrome
6.2 Run on Android Device / Emulator
Make sure an Android device or emulator is connected, then run:


flutter devices   # to list devices
flutter run       # will run on the selected device
If you have multiple devices, you can specify:


flutter run -d <device_id>
7. Building the Android APK (Release)
7.1 Local Build (if Android SDK is installed)
From the project root:


flutter build apk --release
The generated APK will be located at:


build/app/outputs/flutter-apk/app-release.apk
You can transfer this file to an Android phone and install it manually.

7.2 GitHub Actions (CI) – Optional
A GitHub Actions workflow can be used to build the APK automatically:

Workflow file (example):


.github/workflows/android-build.yml
This workflow:

Checks out the repository

Installs Flutter

Runs flutter pub get

Runs flutter build apk --release

Uploads app-release.apk as a build artifact

You can then download the APK directly from the GitHub Actions Artifacts section.

8. API Usage
The app uses the OpenWeatherMap Current Weather Data API.

Endpoint Used
By city name:


GET https://api.openweathermap.org/data/2.5/weather
    ?q={city_name}
    &appid={API_KEY}
    &units={units}
q – city name (e.g., Berlin, Cairo)

appid – your OpenWeatherMap API key

units – 'metric' (°C) or 'imperial' (°F)

Example URL

https://api.openweathermap.org/data/2.5/weather?q=Berlin&appid=YOUR_API_KEY&units=metric
Fields Used in the App
From the JSON response, the app uses:

name → city name

main.temp → temperature

main.feels_like → feels like temperature

main.humidity → humidity

weather[0].description → description

weather[0].icon → icon code for weather icon

wind.speed → wind speed

sys.sunrise → sunrise time (Unix seconds)

sys.sunset → sunset time (Unix seconds)

dt → data time (Unix seconds)

timezone → offset from UTC in seconds

Local time and sunrise/sunset are calculated as:

DateTime localTime = DateTime.fromMillisecondsSinceEpoch(
  (dt + timezone) * 1000,
  isUtc: true,
);
Same idea for sunrise and sunset.

9. How It All Works (Short Technical Summary)
State Management:

WeatherProvider:

Holds Weather? weather, bool isLoading, String? errorMessage, and String units.

Exposes fetchWeatherForCity(String city) which:

sets loading state

calls WeatherApiService

updates weather or error accordingly

FavoritesProvider:

Manages a list of city names (List<String> _favorites)

Uses SharedPreferences to load and save favorites

Persistence:

SharedPreferences stores:

'favorite_cities': List of strings

'temperature_units': 'metric' or 'imperial'

Routing:

main.dart uses MaterialApp with named routes:

'/' → HomePage

'/details' → WeatherDetailsPage

'/favorites' → FavoritesPage

'/settings' → SettingsPage

Error Handling & Loading:

Loading state:

CircularProgressIndicator shown while data is being fetched

Error state:

Readable error message is displayed if:

invalid city → 404

invalid API key → 401

other HTTP error or network issue


## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
