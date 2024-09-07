
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:moviezone/Controller/movie_controller.dart';
import 'package:moviezone/Helpers/common_components.dart';
import 'package:moviezone/Helpers/space_helper.dart';

import '../Helpers/color_helper.dart';

class MoviePoster extends StatelessWidget {

   var movie;
   MoviePoster({super.key, required this.movie});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 16.w),
      child: SizedBox(
        height: 300.h,
        width: 200.w,
        child: Stack(
          children: [
            Container(
              height: 300.h,
              width: 200.w,
              decoration: BoxDecoration(
               color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            Align(
            alignment: Alignment.center,
            child:           ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.network(
                "https://image.tmdb.org/t/p/w500"+movie.posterPath,
                height: 299.h,
                width: 199.w,
                fit: BoxFit.fill,
              ),
            ),
          ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 200.h,
                width: 200.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.white.withOpacity(0.6),
                      Colors.white.withOpacity(0.4),
                      Colors.transparent,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
            Positioned(
              bottom: 10.h,
                left: 10.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonComponents().printText(fontSize: 18, textData: movie.title, fontWeight: FontWeight.bold,color: Colors.black)
                    ,Row(
                      children: [
                        Icon(Icons.calendar_month,size: 20.sp,),
                        SpaceHelper.horizontalSpace3,
                        CommonComponents().printText(fontSize: 14, textData: movie.releaseDate, fontWeight: FontWeight.bold,color: Colors.black)
                      ],
                    )
                    ],
                )),
            Positioned(
              top: 10.h,right: 10.w,
                child: movie.adult?
            Container(
              height: 30.h,width: 30.h,
              decoration: BoxDecoration(
                color: ColorHelper.primaryText.withOpacity(0.6),
                borderRadius: BorderRadius.circular(90)
              ),
        child: Center(
          child: CommonComponents().printText(fontSize: 15, textData: "18+", fontWeight: FontWeight.bold,color: Colors.red),
        ),
            ):const SizedBox())
          ],
        ),
      ),
    );
  }
}

class DetailsPage extends StatelessWidget {
  MovieController movieController = Get.put(MovieController());

  @override
  Widget build(BuildContext context) {
    final movie = movieController.selectedMovie[0];

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: ListView(

          children: [

            // Poster Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.network(
                "https://image.tmdb.org/t/p/w500" + movie.posterPath,
                width: double.infinity,
                height: 250.h,
                fit: BoxFit.cover,
              ),
            ),
            SpaceHelper.verticalSpace15,

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 270.w,
                  child: Text(
                    movie.title,
                    style: TextStyle(
                      color: ColorHelper.secondryTheme,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            Obx(()=> movieController.favMovies.any((fav) => fav.title == movie.title)?

            IconButton(onPressed: (){
              movieController.removeFromFav(movie);
            }, icon: const Icon(Icons.favorite)): IconButton(onPressed: (){
              movieController.addToFav(movie);

            }, icon:
            const Icon(Icons.bookmark_add_outlined)
            ))
              ],
            ),
            SpaceHelper.verticalSpace10,

            Text(
              'Release Date: ${movie.releaseDate}',
              style: TextStyle(
                color: ColorHelper.secondaryryText,
                fontSize: 14.sp,
              ),
            ),

            SpaceHelper.verticalSpace15,
            Text(
              movie.overview,
              style: TextStyle(
                color: ColorHelper.secondryTheme,
                fontSize: 14.sp,
                height: 1.5,
              ),
            ),
            SpaceHelper.verticalSpace15,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.yellow, size: 20.sp),
                    SpaceHelper.horizontalSpace5,
                    Text(
                      '${movie.voteAverage}/10',
                      style: TextStyle(
                        color: ColorHelper.secondryTheme,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Icon(Icons.trending_up, color: Colors.green, size: 20.sp),
                    SpaceHelper.horizontalSpace5,
                    Text(
                      'Popularity: ${movie.popularity.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: ColorHelper.primaryText,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const Spacer(),
           SpaceHelper.verticalSpace25,
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorHelper.secondryTheme,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 16.h),
                minimumSize: Size(double.infinity, 50.h),
              ),
              onPressed: () {
                // Handle booking button tap here
              },
              child: Text(
                'Booking Ticket',
                style: TextStyle(
                  color: ColorHelper.primaryText,
                  fontSize: 18.sp,
                ),
              ),
            ),
            SpaceHelper.verticalSpace15,
          ],
        ),
      ),
    );
  }

  // Convert genreId to genreName using a mapping list or dictionary
  String genreIdToName(int id) {
    Map<int, String> genreMap = {
      28: 'Action',
      12: 'Adventure',
      35: 'Comedy',
      878: 'Sci-Fi',
      16: 'Animation',
      // Add more genres as needed
    };
    return genreMap[id] ?? 'Unknown';
  }
}

class GenreTag extends StatelessWidget {
  final String text;
  const GenreTag({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: ColorHelper.darkGrey,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: ColorHelper.primaryText,
          fontSize: 12.sp,
        ),
      ),
    );
  }
}
