import 'package:cloud_firestore/cloud_firestore.dart';

class Theater {
  final String name;
  final GeoPoint location;
  final double distance;
  final String imageUrl;

  Theater({
    required this.name,
    required this.location,
    required this.distance,
    required this.imageUrl,
  });
}