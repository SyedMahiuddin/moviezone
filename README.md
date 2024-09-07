MovieZone
MovieZone is a Flutter-based mobile application that provides users with movie details by integrating with The Movie Database (TMDb) API. The app allows users to browse upcoming and popular movies, view movie details, and manage favorite lists. It also features local storage using SQLite (via sqflite) for saving movies offline.

Features:
Display upcoming and popular movies.
Add Genre Choose to local DB and use for filtering.
View detailed information about individual movies (release date, overview, ratings, etc.).
Save favorite movies locally using SQLite.
Auto-scroll movie lists and manage genres.

Table of Contents:
Introduction
Setup Instructions
Code Structure
Testing
Introduction
MovieZone is designed to allow users to browse movie information from TMDb and store their favorites locally for offline access. The app fetches data via API requests, processes movie genres, and uses a clean, responsive UI. It's built using Flutter, making it cross-platform for both Android and iOS devices.

Setup Instructions
Prerequisites
Ensure you have the following installed:

Flutter SDK
Android Studio (for Android development)
Xcode (for iOS development)
1. Clone the Repository
   bash

   git clone https://github.com/SyedMahiuddin/moviezone.git
   cd moviezone
2. Install Dependencies
   bash

   flutter pub get
3. Configure TMDb API Key
   Create an account at The Movie Database.
   Get your API key.
   Add the API key to AppConfig.dart:
   dart
   class AppConfig {
   static const String apiKey = 'YOUR_API_KEY';
   static const String baseUrl = 'https://api.themoviedb.org/3/';
   }
4. Running the App
   For Android:

   flutter run
   For iOS:

   flutter run -d ios
   Code Structure
   Here's an overview of the key components and the general structure of the MovieZone app:


moviezone/
├── lib/
│   ├── Model/                       # Data models (e.g., Movie, Genre)
│   ├── Services/                    # API calls and data fetching logic
│   ├── Database/                    # SQLite database handling (e.g., MovieDatabase class)
│   ├── Controllers/                 # GetX controllers for state management
│   ├── Pages/                       # Screens and UI components (e.g., HomePage, DetailsPage)
│   ├── Widgets/                     # Reusable UI components (e.g., MovieCard, MoviePoster)
│   ├── main.dart                    # Entry point of the app
├── pubspec.yaml                     # Project configuration and dependencies
└── README.md                        # Project documentation (this file)
Key Components
Model: Contains data classes like Movie and Genre, which represent the API data structures and how the app interacts with them.

movie_model.dart: Defines the Movie model, handles parsing of API responses.
genre_model.dart: Defines the Genre model for managing movie genres.
Services: Contains methods to fetch data from TMDb using http.

movie_service.dart: Fetches movie data like upcoming and popular movies.
genre_service.dart: Fetches genre data.
Database: Manages the local SQLite database using sqflite for storing movies.

movie_database.dart: Handles inserting, fetching, and deleting movie data in the local database.
Controllers: GetX controllers for state management, handling the logic of loading data and interacting between UI and services.

movie_controller.dart: Manages movie-related data flow and user interactions.
Widgets: Reusable UI components like movie posters, cards, and list views.

movie_card.dart: A card widget that displays a movie's image and details.
movie_poster.dart: Displays the movie poster image.
Testing
Running Tests
You can write and run unit tests to ensure the functionality of individual components. To run tests:

Navigate to the root of the project:
bash
Copy code
cd moviezone
Run the Flutter test command:
bash
Copy code
flutter test
Make sure that the test cases are written inside the test/ folder, and they cover critical parts like data models, API calls, and database operations.

Conclusion
MovieZone is a powerful and simple-to-use Flutter app for discovering and managing movie information. Its clean architecture, integration with TMDb, and local SQLite storage make it a versatile project for anyone interested in movie-related apps. Feel free to explore the code, add more features, and contribute to the project!