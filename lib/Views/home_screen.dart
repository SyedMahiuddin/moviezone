import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:moviezone/Controller/movie_controller.dart';
import 'package:moviezone/Helpers/common_components.dart';
import 'package:moviezone/Helpers/space_helper.dart';

import '../Helpers/color_helper.dart';
import 'movie_poster.dart';

class HomePage extends StatelessWidget {
  MovieController movieController=Get.put(MovieController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SpaceHelper.verticalSpace40,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
          
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://img.freepik.com/free-photo/portrait-man-laughing_23-2148859448.jpg?size=338&ext=jpg&ga=GA1.1.2008272138.1725408000&semt=ais_hybrid'),
                    radius: 20.r,
                  ),
                  SizedBox(
                    height: 60.h,
                    width: 270.w,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Obx(()=>TextField(
                        controller: movieController.searchController,
                        onChanged: (query) {
                          movieController.searchMovies(query);
                          movieController.update(); // To trigger the close icon visibility
                        },
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            size: 15.sp,
                          ),
                          hintText: "Search movies by title",
                          suffixIcon: movieController.filtering.value
                              ? IconButton(
                            icon: Icon(
                              Icons.close,
                              color: Colors.grey,
                              size: 18.sp,
                            ),
                            onPressed: () {
                              movieController.searchController.text="";
                              movieController.searchMovies('');
                              movieController.filtering.value=false;
                            },
                          )
                              : null,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.grey), // Inactive border color
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.white), // Active border color
                          ),
                        ),
                      )) ,
                    ),
                  )
                  ,
                ],
              ),
              CommonComponents().printText(fontSize: 20,color: ColorHelper.primaryText, textData: "Trending now", fontWeight: FontWeight.bold),
             SpaceHelper.verticalSpace10,
              SizedBox(
                height: 300.h,
                child: Obx(()=>
                    ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: movieController.filteredMovies.length,
                  itemBuilder: (context, index) {
                    var movie=movieController.filteredMovies[index];
                    return GestureDetector(
                      onTap: (){
                        movieController.selectedMovie.clear();
                        movieController.selectedMovie.add(movie);
                        Get.to(DetailsPage());
                      },
                      child: SizedBox(
                        height: 300.h,
                        child: MoviePoster(
                          movie: movie,
                        ),
                      ),
                    );
                  },
                )),
              ),
              SizedBox(height: 12.h),
              CommonComponents().printText(fontSize: 20,color: ColorHelper.primaryText, textData: "Upcoming", fontWeight: FontWeight.bold),
              SpaceHelper.verticalSpace10,
              SizedBox(
                height: 150.h,
                child: Obx(()=>
                    ListView.builder(
                      controller: movieController.scrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: movieController.upComingMovies.length,
                      itemBuilder: (context, index) {
                        var movie=movieController.upComingMovies[index];
                        return GestureDetector(
                          onTap: (){
                            movieController.selectedMovie.clear();
                            movieController.selectedMovie.add(movie);
                            Get.to(DetailsPage());
                          },
                          child: SizedBox(
                            height: 300.h,
                            child: MoviePoster(
                              movie: movie,
                            ),
                          ),
                        );
                      },
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

