import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:moviezone/utils/appConfig.dart';

import '../Model/theater_model.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class MapRepo{

  Future<List<Theater>> fetchNearbyTheaters(Position currentPosition) async {
    final apiKey = AppConfig.mapApiKey;
    const radius =  10000;
    final lat = currentPosition.latitude;
    final lng = currentPosition.longitude;

    final url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&radius=$radius&type=movie_theater&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];

      // Map the API data to a List of Theater objects
      List<Theater> theaters = results.map((result) {
        String name = result['name'];
        double theaterLat = result['geometry']['location']['lat'];
        double theaterLng = result['geometry']['location']['lng'];
        GeoPoint location = GeoPoint(theaterLat, theaterLng);

        // Calculate the distance
        double distance = calculateDistance(lat, lng, theaterLat, theaterLng);

        // Get the image URL (photo reference)
        String imageUrl = '';
        if (result['photos'] != null && result['photos'].isNotEmpty) {
          final photoReference = result['photos'][0]['photo_reference'];
          imageUrl =
          'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$apiKey';
        }

        // Return Theater object
        return Theater(
          name: name,
          location: location,
          distance: distance / 1000, // Convert to kilometers
          imageUrl: imageUrl,
        );
      }).toList();

      return theaters;
    } else {
      throw Exception('Failed to load nearby theaters');
    }
  }
  double calculateDistance(double startLat, double startLng, double endLat, double endLng) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng); // returns distance in meters
  }

}