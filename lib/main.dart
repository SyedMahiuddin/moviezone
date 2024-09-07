import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:moviezone/Views/bottom_navigation.dart';

import 'package:http/http.dart' as http;

void main() async{
  final String apiKey = '9b4ced201079b3f778dd56e92ceca7a4'; // Your TMDB API key
  final String url = 'https://api.themoviedb.org/3/movie/popular?api_key=$apiKey';

  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // Parsing the JSON response body
      final data = json.decode(response.body);
      // Printing the entire JSON response
      print('Response data: ${data['results']}');
    } else {
      // Printing an error message if the request fails
      print('Failed to load movies. Status code: ${response.statusCode}');
    }
  } catch (e) {
    // Printing an error message if an exception is thrown
    print('Failed to fetch movies: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {

    return ScreenUtilInit(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        home:  OpalBottomNavBar(),
      ),
    );
  }
}

