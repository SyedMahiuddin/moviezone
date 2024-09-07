import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:moviezone/utils/appConfig.dart';
import '../Model/genre_model.dart';
import '../Model/movie_model.dart';

class MovieRepository {

  Future<List<Movie>> fetchPopularMovies() async {
    final String url = '${AppConfig.baseUrl}movie/popular?api_key=${AppConfig
        .apiKey}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Movie> movies = (data['results'] as List)
            .map((movieJson) => Movie.fromJson(movieJson))
            .toList();

        return movies;
      } else {
        throw Exception(
            'Failed to load movies. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch movies: $e');
    }
  }


  Future<List<Movie>> fetchUpcomingMovies() async {
    final String url =
        '${AppConfig.baseUrl}movie/upcoming?api_key=${AppConfig
        .apiKey}&language=en-US&page=1';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Movie> movies = (data['results'] as List)
            .map((movieJson) => Movie.fromJson(movieJson))
            .toList();
        return movies;
      } else {
        throw Exception(
            'Failed to load upcoming movies. Status code: ${response
                .statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch upcoming movies: $e');
    }
  }

  Future<List<Genre>> fetchGenres() async {
    final String url =
        '${AppConfig.baseUrl}genre/movie/list?api_key=${AppConfig
        .apiKey}&language=en-US';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Genre> genres = (data['genres'] as List)
            .map((genreJson) => Genre.fromJson(genreJson))
            .toList();
        return genres;
      } else {
        throw Exception(
            'Failed to load genres. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch genres: $e');
    }
  }
}
