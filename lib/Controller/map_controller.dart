import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:moviezone/repository/map_repository.dart';

import '../utils/appConfig.dart';

class MapController extends GetxController{
  late GoogleMapController mapController;

  var initialPosition =  LatLng(37.7749, -122.4194).obs;
  var allMarkers = <Marker>{}.obs;


  @override
  void onInit() {
    getUserLocation();
    super.onInit();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }


  var userLocationPicking = false.obs;
  void getUserLocation() async {
    userLocationPicking.value = true;
    log("getUserLocation called");
    try {
      Position position = await getCurrentLocation();
      initialPosition.value = LatLng(position.latitude, position.longitude);
      mapController.animateCamera(
        CameraUpdate.newLatLng(initialPosition.value),
      );
      userLocationPicking.value = false;
    } catch (e) {
      userLocationPicking.value = false;
      log('Failed to get location: $e');
    }
    getNearbyTheaters();
  }

  var theaters=[].obs;
  var searchingTheater=false.obs;
  Future<void> getNearbyTheaters() async {
    searchingTheater.value=true;
    theaters.clear();
    try {
      final Position currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
       theaters.value = await MapRepo().fetchNearbyTheaters(currentPosition);
      for (var theater in theaters) {
        log('Theater: ${theater.name}, Distance: ${theater.distance} km, Image: ${theater.imageUrl}');
      }
      await createMarkers();
    } catch (e) {
      log('Error: $e');
    }
    searchingTheater.value=false;
  }
var selectedMarker=[].obs;
  Future<void> createMarkers() async {
    List<Marker> markerList = [];

    final BitmapDescriptor markerIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(25, 25)),
      'assets/images/marker.png', // Path to your custom marker image
    );

    for (var theater in theaters) {
      LatLng position = LatLng(theater.location.latitude, theater.location.longitude);

      log("location: $position");

      Marker marker = Marker(
        markerId: MarkerId(theater.name),
        position: position,
        infoWindow: InfoWindow(
          title: theater.name,
          snippet: '${theater.distance.toStringAsFixed(2)} km away',
        ),
        onTap: (){
          polylineCoordinates.clear();
          polyLines.clear();
          selectedMarker.clear();
          selectedMarker.add(theater);
        },
        icon: markerIcon,              // Custom icon for the marker
      );

      markerList.add(marker);
    }
    allMarkers.addAll(markerList);
    log('Markers created: ${markerList.length}');
  }

  Future<Position> getCurrentLocation() async {
    log("getCurrentLocation called");

    await checkLocationServiceAndPermission();
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When permissions are granted, get the current position.
    return await Geolocator.getCurrentPosition();
  }

  Future<void> checkLocationServiceAndPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }
  }

  Map<PolylineId, Polyline> polyLines = {};
  var polylineCoordinates = [].obs;
  var findingRoutes = false.obs;
  getPolyline() async {
    findingRoutes.value = true;
    polyLines.clear();
    polylineCoordinates.clear;
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      AppConfig.mapApiKey,
      PointLatLng(
          initialPosition.value.latitude, initialPosition.value.longitude),
      PointLatLng(selectedMarker[0].location.latitude,
          selectedMarker[0].location.longitude),
      travelMode: TravelMode.driving,
    );
    log("polyLineResponse: ${result.points.length}");
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    } else {
      log("${result.errorMessage}");
    }

    addPolyLine(
      polylineCoordinates
          .map((geoPoint) => LatLng(geoPoint.latitude, geoPoint.longitude))
          .toList(),
    );
    findingRoutes.value = false;

  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.deepPurpleAccent,
      points: polylineCoordinates,
      width: 8,
    );
    polyLines[id] = polyline;
    moveCameraToPolyline();
  }
  void moveCameraToPolyline() {
    if (polylineCoordinates.isEmpty) return;

    double minLat = polylineCoordinates[0].latitude;
    double maxLat = polylineCoordinates[0].latitude;
    double minLng = polylineCoordinates[0].longitude;
    double maxLng = polylineCoordinates[0].longitude;

    for (var point in polylineCoordinates) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 30));
  }

}