import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:moviezone/Helpers/db_helper.dart';
import 'package:moviezone/repository/movie_repo.dart';

class MovieController extends GetxController{

  @override
  void onInit() {
    loadPopularMovies();
    loadUpcomingMovies();
    getFavMovies();
    startAutoScroll();
    super.onInit();
  }

  @override
  void onClose() {
    autoScrollTimer?.cancel();
    scrollController.dispose();
    super.onClose();
  }

  final TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  Timer? autoScrollTimer;
  var popMovieList = [].obs;
  var selectedMovie=[].obs;
  var favMovies=[].obs;
  var filtering=false.obs;

  var upComingMovies=[].obs;

  var filteredMovies = [].obs;


  void startAutoScroll() {
    autoScrollTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (scrollController.hasClients) {
        if (scrollController.position.pixels >= scrollController.position.maxScrollExtent) {
          scrollController.jumpTo(0);
        } else {
          scrollController.animateTo(
            scrollController.position.pixels + 10.0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  Future<void> getFavMovies() async{
    favMovies.clear();
    favMovies.value=await MovieDatabase.instance.getMovies();
    log("fav movies: ${favMovies.length.toString()}");
  }

  Future<void> addToFav(var movie) async
  {
    await MovieDatabase.instance.insertMovie(movie);
    getFavMovies();
  }


  Future<void> removeFromFav(var movie) async{
    await MovieDatabase.instance.removeMovie(id: movie.id,title: movie.title);
    await getFavMovies();
  }

  bool isFav(var movie){
    return favMovies.any((movie) => movie.title == movie.title);
  }

  void searchMovies(String query) {
    if (query.isEmpty) {
      filtering.value=false;
      filteredMovies.assignAll(popMovieList);
    } else {
      filtering.value=true;
      filteredMovies.assignAll(
        popMovieList.where((movie) => movie.title.toLowerCase().contains(query.toLowerCase())).toList(),
      );
    }
  }
var loadingPopMovies=false.obs;
  Future<void> loadPopularMovies() async {
    loadingPopMovies.value=true;
    popMovieList.clear();
    filteredMovies.clear();
    try {
      popMovieList.value = await MovieRepository().fetchPopularMovies();
      filteredMovies.addAll(popMovieList);
      log('Movies loaded successfully: ${popMovieList.length}');
    } catch (e) {
      log('Error loading movies: $e');
    }
    loadingPopMovies.value=false;
  }

  Future<void> loadUpcomingMovies() async {
    upComingMovies.clear();
    try {
      upComingMovies.value = await MovieRepository().fetchUpcomingMovies();
      log('Upcoming movies loaded successfully: ${upComingMovies.length}');
    } catch (e) {
      log('Error loading upcoming movies: $e');
    }
  }
}