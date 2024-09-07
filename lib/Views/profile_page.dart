import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:moviezone/Controller/movie_controller.dart';
import 'package:moviezone/Helpers/common_components.dart';
import 'package:moviezone/Helpers/space_helper.dart';

import '../Helpers/color_helper.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  MovieController movieController=Get.put(MovieController());
  final TextEditingController categoryController = TextEditingController();
bool editing=false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: ColorHelper.primaryTheme,
      appBar: AppBar(
        backgroundColor: ColorHelper.primaryTheme,
        title: Text(
          'Profile',
          style: TextStyle(
            color: ColorHelper.primaryText,
            fontSize: 20.sp,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: ListView(
          children: [
            _buildProfileHeader(),
            SpaceHelper.verticalSpace20,
            CommonComponents().printText(fontSize: 18,color: ColorHelper.secondaryryText, textData: 'Movie Categories', fontWeight: FontWeight.bold),

            SpaceHelper.verticalSpace10,

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                color: Colors.white.withOpacity(0.1)
              ),
              width: MediaQuery.of(context).size.width-50.w,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Obx(()=>GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of items in each row
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 5.0,
                    childAspectRatio: 6 / 2, // Adjust the aspect ratio as needed
                  ),
                  itemCount:editing? movieController.genreList.length:movieController.myGenreList.length,
                  itemBuilder: (context, index) {
                    final genre = editing?movieController.genreList[index]: movieController.myGenreList[index];
                    return  _buildCategoryItem(genre);
                  },
                )),
              ),
            )
           ,
            SpaceHelper.verticalSpace15
          ],
        ),
      ),
    );
  }

  // Profile header
  Widget _buildProfileHeader() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorHelper.darkGrey,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30.w,
            backgroundImage: NetworkImage(
              'https://img.freepik.com/free-photo/portrait-man-laughing_23-2148859448.jpg?size=338&ext=jpg&ga=GA1.1.2008272138.1725408000&semt=ais_hybrid',
            ),
          ),
          SizedBox(width: 16.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonComponents().printText(fontSize: 18, textData: 'John Doe', fontWeight: FontWeight.bold),
              SpaceHelper.verticalSpace5,
              CommonComponents().printText(fontSize: 18, textData: 'Movie Enthusiast', fontWeight: FontWeight.bold),
              SpaceHelper.verticalSpace5
            ],
          ),
          IconButton(onPressed: (){
            setState(() {
              editing=!editing;
            });
          }, icon:  Icon(editing?Icons.done: Icons.settings,color: ColorHelper.primaryText,))
        ],
      ),
    );
  }

  Widget _buildCategoryItem(var genre) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: ColorHelper.darkGrey,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child:SizedBox(
        child: Center(
          child: Row(
            mainAxisAlignment:editing? MainAxisAlignment.spaceBetween:MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 70.w,
                  child: CommonComponents().printText(fontSize: 15, textData: genre.name, fontWeight: FontWeight.bold)),
           editing?
            Row(
              children: [
                SpaceHelper.horizontalSpace3,
                movieController.myGenreList.any((item) => item.name == genre.name)?
                InkWell(
                  onTap: (){
                    movieController.removeGenre(genre);
                  },
                    child: Icon(Icons.highlight_remove_outlined,color: Colors.redAccent,size: 15.sp,)):
                InkWell(
                  onTap: (){
                    movieController.addGenre(genre);
                  },
                    child: Icon(Icons.add_circle_outline_outlined,color: Colors.green,size: 15.sp,))
              ],
            ):const SizedBox()
            ],
          ),
        ),
      ) ,
    );
  }

}
