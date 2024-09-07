import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Helpers/color_helper.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<String> movieCategories = [
    'Action',
    'Drama',
    'Adventure',
    'Comedy',
  ];
  final TextEditingController categoryController = TextEditingController();

  void addCategory() {
    if (categoryController.text.isNotEmpty) {
      setState(() {
        movieCategories.add(categoryController.text);
        categoryController.clear();
      });
    }
  }

  void deleteCategory(int index) {
    setState(() {
      movieCategories.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(),
            SizedBox(height: 20.h),
            Text(
              'Movie Categories',
              style: TextStyle(
                color: ColorHelper.primaryText,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: ListView.builder(
                itemCount: movieCategories.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: _buildCategoryItem(movieCategories[index], index),
                  );
                },
              ),
            ),
            SizedBox(height: 20.h),
            _buildAddCategoryField(),
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
              Text(
                'John Doe',
                style: TextStyle(
                  color: ColorHelper.primaryText,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Movie Enthusiast',
                style: TextStyle(
                  color: ColorHelper.primaryText,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Movie category item
  Widget _buildCategoryItem(String category, int index) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: ColorHelper.darkGrey,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            category,
            style: TextStyle(
              color: ColorHelper.primaryText,
              fontSize: 16.sp,
            ),
          ),
          IconButton(
            onPressed: () {
              deleteCategory(index);
            },
            icon: Icon(
              Icons.delete,
              color: ColorHelper.secondaryryText,
            ),
          ),
        ],
      ),
    );
  }

  // Add new category field
  Widget _buildAddCategoryField() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: categoryController,
            style: TextStyle(
              color: ColorHelper.primaryText,
              fontSize: 14.sp,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: ColorHelper.darkGrey,
              hintText: 'Add a new category...',
              hintStyle: TextStyle(color: ColorHelper.primaryText),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        IconButton(
          onPressed: addCategory,
          icon: Icon(
            Icons.add_circle,
            color: ColorHelper.secondaryryText,
            size: 30.sp,
          ),
        ),
      ],
    );
  }
}
