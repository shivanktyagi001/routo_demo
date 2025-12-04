A lightweight Flutter maps prototype that demonstrates essential location-based features without any backend. The app includes live GPS tracking, weather-on-tap, distance measurement, favorites saving, and dark mode — all built using clean architecture and simple APIs.

1. Key Features (Short & Precise)

        Live Location: Displays the user’s current position on the map.
        
        Weather on Tap: Tap anywhere to see real-time weather for that location.
        
        Distance Measure: Tap two points to instantly calculate the distance.
        
        Favorites: Long-press to save a location and access it later.
        
        Dark Mode: One-tap toggle between light and dark themes.

2. Setup Instructions (Quick)

        Clone the project
        
        git clone <repo-url>


3.Add your API keys in lib/core/env.dart

        class Env {
          static const String openWeatherKey = "YOUR_OPENWEATHER_KEY";
          static const String mapsKey = "YOUR_GOOGLE_MAPS_KEY";
        }


3.Add Google Maps key inside
android/app/src/main/AndroidManifest.xml

        <meta-data
            android:name="com.google.android.geo.API_KEY"
            android:value="YOUR_GOOGLE_MAPS_KEY"/>


4.Install dependencies

      flutter pub get
      
      
      Run the app
      
      flutter run

