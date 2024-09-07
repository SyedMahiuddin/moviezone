import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:moviezone/Controller/movie_controller.dart';
import 'package:moviezone/Model/movie_model.dart';
import 'package:moviezone/Views/movie_poster.dart';

import '../Helpers/color_helper.dart';
import '../Helpers/space_helper.dart';

class SavedMoviesPage extends StatelessWidget {

  MovieController movieController=Get.put(MovieController());

  SavedMoviesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      appBar: AppBar(
        backgroundColor: ColorHelper.primaryTheme,
        title: Text(
          'Favourite Movies',
          style: TextStyle(
            color: ColorHelper.primaryText,
            fontSize: 20.sp,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Obx(()=>ListView.builder(
          itemCount: movieController.favMovies.length,
          itemBuilder: (context, index) {
            final movie = movieController.favMovies[index];

            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: Slidable(
                key: ValueKey(movie.id),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) => showRemoveDialog(context, movie, index),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Remove',
                    ),
                  ],
                ),
                child: MovieCard(
                  title: movie.title,
                  description: movie.overview,
                  posterUrl: "https://image.tmdb.org/t/p/w500" + movie.posterPath,
                ),
              ),
            );
          },
        )),
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  MovieController movieController=Get.find();
  final String title;
  final String description;
  final String posterUrl;

   MovieCard({super.key,
    required this.title,
    required this.description,
    required this.posterUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: ColorHelper.darkGrey,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.network(
              posterUrl,
              width: 80.w,
              height: 120.h,
              fit: BoxFit.cover,
              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                return Image.asset(
                  'assets/images/noconnection.jpg',  // Ensure the correct asset path
                  width: 80.w,
                  height: 120.h,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          SpaceHelper.horizontalSpace15,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: ColorHelper.primaryText,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SpaceHelper.verticalSpace10,
                Text(
                  description,
                  style: TextStyle(
                    color: ColorHelper.primaryText,
                    fontSize: 14.sp,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SpaceHelper.verticalSpace10,
                Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    onPressed: () {
                      movieController.selectedMovie.clear();
                      movieController.selectedMovie.add(movieController.popMovieList.firstWhere((movie) => movie.title == title));
                      Get.to(DetailsPage());
                    },icon:
                     Icon(Icons.arrow_right_alt,color: ColorHelper.primaryText,size: 25.sp,),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


}
void showRemoveDialog(BuildContext context, Movie movie, int index) {
  MovieController movieController=Get.find();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Remove Movie'),
        content: Text('Do you really want to remove "${movie.title}" from your saved list?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              movieController.removeFromFav(movie);
              Navigator.of(context).pop();
            },
            child: const Text('Remove'),
          ),
        ],
      );
    },
  );
}


