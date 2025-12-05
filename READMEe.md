# Flutter Weather App 🌤️

A multi-page Flutter application that displays **real-time current weather** data using the **OpenWeatherMap Current Weather API**.

Users can:

- Search for any city
- View detailed weather information
- Save favorite cities
- Change temperature units between **Celsius (°C)** and **Fahrenheit (°F)**

This project was built to practice:

- REST API integration
- Flutter UI development
- Routing & navigation
- State management with `provider`
- Local storage with `shared_preferences`

---

## 📝 App Description

The Flutter Weather App is a simple, clean, and responsive mobile application that fetches **live current weather data** from the OpenWeatherMap API.

The app allows users to:

- Search for city weather
- View detailed weather information (temperature, description, sunrise, sunset, etc.)
- Save cities as favorites
- Configure temperature units (°C / °F) from a Settings screen

The architecture is organized into **pages, providers, services, models, config**, and **widgets** folders to keep the code modular and scalable.

---

## ✨ Features

### 1. Home / Search Screen

- Text field to **search weather by city name**
- Clean UI with Search button
- On search → navigates to **Weather Details Screen**

### 2. Weather Details Screen

Displays data from the OpenWeatherMap **Current Weather API**:

- City name
- Current temperature
- Weather description
- “Feels like” temperature
- Humidity
- Wind speed
- Sunrise & Sunset times (using timezone offset)
- Local time in the city (using timezone offset)
- Weather icon from OpenWeatherMap icon URL
- Favorite icon (heart) to **add/remove** city to/from favorites

### 3. Favorites Screen

- Displays a list of **saved favorite cities**
- Favorites are stored locally using **`shared_preferences`**
- Tapping a city navigates to its **Weather Details Screen**
- Delete button to remove a city from favorites

### 4. Settings Screen

- Allows user to change the **temperature unit**:
  - Metric (°C)
  - Imperial (°F)
- The selected unit is stored using `shared_preferences`
- New weather requests use the selected unit

---

## 🧱 Folder Structure (Source Code)

The project follows a simple and clear folder structure:

```text
lib/
  main.dart
  config/
    api_config.dart           # API base URL + API key (local, not committed)
  models/
    weather.dart              # Weather model (maps JSON -> Dart object)
  services/
    weather_api_service.dart  # HTTP calls to OpenWeatherMap
  providers/
    weather_provider.dart     # Manages weather state + units (°C/°F)
    favorites_provider.dart   # Manages favorite cities list + local storage
  pages/
    home_page.dart            # Search screen
    weather_details_page.dart # Weather details + favorite button
    favorites_page.dart       # List of favorite cities
    settings_page.dart        # Temperature unit settings
  widgets/
    # Optional reusable widgets (if added)
State management: provider (ChangeNotifier, ChangeNotifierProvider, MultiProvider)

HTTP: http

Local storage: shared_preferences

Time formatting: intl (for local time / sunrise / sunset)

⚙️ Setup Steps
1. Prerequisites
You need:

Flutter SDK installed

Dart SDK (included with Flutter)

Android SDK (via Android Studio) to build the APK

An OpenWeatherMap account + API key:
https://openweathermap.org/

Required Dart packages (already in pubspec.yaml):

http

provider

shared_preferences

intl

2. Clone the Repository
bash
Copy code
git clone https://github.com/<your-username>/weather_app.git
cd weather_app
Replace <your-username> with your GitHub username.

3. Install Dependencies
bash
Copy code
flutter pub get
On Windows (using the direct path):

bash
Copy code
C:\src\flutter\bin\flutter.bat pub get
4. Configure the OpenWeatherMap API Key
❗ The API key must NOT be hardcoded in public repositories.
Use a local api_config.dart file that is not committed.

Create:

text
Copy code
lib/config/api_config.dart
Add:

dart
Copy code
class ApiConfig {
  static const String openWeatherBaseUrl =
      'https://api.openweathermap.org/data/2.5';

  // Insert your OpenWeatherMap API key here (local only)
  static const String openWeatherApiKey = 'YOUR_API_KEY_HERE';
}
For public repos, you can commit an example file instead:

text
Copy code
lib/config/api_config.example.dart
dart
Copy code
class ApiConfig {
  static const String openWeatherBaseUrl =
      'https://api.openweathermap.org/data/2.5';

  // Replace with your own API key in a local file (api_config.dart)
  static const String openWeatherApiKey = 'REPLACE_WITH_YOUR_KEY';
}
Then instruct users to copy:

bash
Copy code
cp lib/config/api_config.example.dart lib/config/api_config.dart
Also add to .gitignore:

gitignore
Copy code
lib/config/api_config.dart
🏗️ Application Build
✅ Android APK (required)
To generate an Android APK:

Make sure that:

Android Studio + Android SDK are installed

flutter doctor shows a valid Android toolchain

From the project root, run (for a release APK):

bash
Copy code
flutter build apk --release
On Windows:

bash
Copy code
C:\src\flutter\bin\flutter.bat build apk --release
After a successful build, the APK will be located at:

text
Copy code
build/app/outputs/flutter-apk/app-release.apk
This app-release.apk file is the one you can submit as the final build.

For quick testing, you can also use a debug APK:

bash
Copy code
flutter build apk --debug
🍏 iOS Build (optional – instructions only)
Requires macOS, Xcode, and an Apple Developer account.

On a Mac:

bash
Copy code
flutter pub get
flutter build ios --release
Open the iOS project in Xcode:

bash
Copy code
open ios/Runner.xcworkspace
In Xcode:

Set a valid Team & Bundle Identifier (Signing & Capabilities)

Choose Any iOS Device as the run destination

From the menu: Product → Archive

From the Organizer window, you can:

Export an .ipa file

Or upload to TestFlight / App Store

For this assignment, only Android APK is required. iOS build is optional.

🌐 API Usage (OpenWeatherMap)
This app uses the Current Weather Data API:

Endpoint:

text
Copy code
GET https://api.openweathermap.org/data/2.5/weather
Request (by city name)
text
Copy code
https://api.openweathermap.org/data/2.5/weather
    ?q={CITY_NAME}
    &appid={API_KEY}
    &units={UNITS}
Parameters:

q: city name (e.g. Berlin, Cairo)

appid: your OpenWeatherMap API key

units:

metric → temperature in °C

imperial → temperature in °F

Example
text
Copy code
https://api.openweathermap.org/data/2.5/weather?q=Berlin&appid=YOUR_API_KEY&units=metric
JSON Fields Used in the App
The app reads:

name → city name

main.temp → current temperature

main.feels_like → feels like

main.humidity → humidity (%)

weather[0].description → weather description

weather[0].icon → icon code

Used as:

text
Copy code
https://openweathermap.org/img/wn/{icon}@4x.png
wind.speed → wind speed

sys.sunrise / sys.sunset → UNIX timestamps for sunrise & sunset

timezone → offset in seconds from UTC

dt → time of data calculation

These are mapped into the Weather model (lib/models/weather.dart) and used to:

Display city name, temperature, etc.

Calculate local time, sunrise, sunset (with timezone offset)

Load the correct weather icon